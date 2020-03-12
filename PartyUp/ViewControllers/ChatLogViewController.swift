//
//  ChatLogViewController.swift
//  PartyUp
//
//  Created by Tyler Donohue on 2/26/20.
//  Copyright © 2020 Tyler Donohue. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase

class ChatLogViewController: JSQMessagesViewController {
    
    // MARK: - Outlets
    
    @IBOutlet var reportChatPopOver: UIView!
    @IBOutlet weak var reportChatButton: UIBarButtonItem!
    @IBOutlet weak var reportCommentsTextView: UITextView!
    
    // MARK: - Propeties
    
    var currentAuthID = Auth.auth().currentUser?.uid
    var currentUserName: String? = ""
    var messages = [JSQMessage]()
    var db: Firestore!
    var dbRef = Database.database().reference()
    var chatDatabaseName: String?
    var chatId: String = ""
    var currentDate: String?
    
    lazy var outgoingBubble: JSQMessagesBubbleImage = {
        return JSQMessagesBubbleImageFactory()!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }()
    lazy var incomingBubble: JSQMessagesBubbleImage = {
        return JSQMessagesBubbleImageFactory()!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }()

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reportChatPopOver.layer.cornerRadius = 10
        dbRef = Database.database().reference()
        db = Firestore.firestore()
        
        senderId = self.currentAuthID
        senderDisplayName = self.currentUserName
        title = "Chat: \(senderDisplayName!)"
        
        inputToolbar.contentView.leftBarButtonItem = nil
        collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
        let newQuery = dbRef.child("Messages").child(self.chatId).queryLimited(toLast: 53)
        _ = newQuery.observe(.childAdded, with: { [weak self] snapshot in
            if  let data = snapshot.value as? [String: String],
                let id = data["sender_id"],
                let name = data["name"],
                let text = data["text"],
                !text.isEmpty {
                if let message = JSQMessage(senderId: id, displayName: name, text: text) {
                    self?.messages.append(message)
                    self?.finishReceivingMessage()
                }
            }
        })
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        return messages[indexPath.item].senderId == senderId ? outgoingBubble : incomingBubble
    } // chesk to see who is sending message.
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        return messages[indexPath.item].senderId == senderId ? nil : NSAttributedString(string: messages[indexPath.item].senderDisplayName)
    }

    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat {
        return messages[indexPath.item].senderId == senderId ? 0 : 15
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        let newRef = dbRef.child("Messages").child(self.chatId).childByAutoId()
        let message = ["sender_id": senderId, "name": senderDisplayName, "text": text]
        newRef.setValue(message)
        finishSendingMessage()
    }
    
    // MARK: - Functions
    
    func getCurrentDate() {
        let formatter : DateFormatter = DateFormatter()
        formatter.dateFormat = "d/M/yy"
        let myDate : String = formatter.string(from:   NSDate.init(timeIntervalSinceNow: 0) as Date)
        self.currentDate = myDate
    }
    
    func showPopOverAnimate() {
        self.reportChatPopOver.center = self.view.center
        self.reportChatPopOver.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.reportChatPopOver.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.reportChatPopOver.alpha = 1.0
            self.reportChatPopOver.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removePopOverAnimate() {
        UIView.animate(withDuration: 0.25, animations: {
            self.reportChatPopOver.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.reportChatPopOver.alpha = 0.0;
            }, completion:{(finished : Bool)  in
                if (finished) {
                    self.reportChatPopOver.removeFromSuperview()
                }
        });
    }
    
    func createReportData() {
        getCurrentDate()
        let chatId = self.chatId
        guard let creatorId = self.currentAuthID,
            let reason = reportCommentsTextView.text,
            let dateSent = self.currentDate else { return }
        let userReportUID: String = UUID().uuidString
        let userReport = UserReport(reason: reason,
                                    creatorId: creatorId,
                                    chatId: chatId,
                                    dateSent: dateSent,
                                    reportId: userReportUID)
        let userReportRef = self.db.collection("userReports")
        userReportRef.document(userReportUID).setData(userReport.dictionary) { err in
            if let err = err {
                let reportChatFailAlert = UIAlertController(title: "Failed to report", message: "Your device failed to correctly send the report. Please make sure you have a stable internet connection.", preferredStyle: .alert)
                let dismiss = UIAlertAction(title: "OK", style: .default, handler: nil)
                reportChatFailAlert.addAction(dismiss)
                self.present(reportChatFailAlert, animated: true, completion: nil)
                print(err)
            } else {
                let reportChatAlertSucceed = UIAlertController(title: "Thank you!", message: "Your report has been received, thank you for your report", preferredStyle: .alert)
                let dismiss = UIAlertAction(title: "OK", style: .default, handler: nil)
                reportChatAlertSucceed.addAction(dismiss)
                self.removePopOverAnimate()
                self.present(reportChatAlertSucceed, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func reportChatButtonTapped(_ sender: Any) {
        self.view.addSubview(reportChatPopOver)
        showPopOverAnimate()
    }
    
    @IBAction func cancelReportButtonTapped(_ sender: Any) {
        removePopOverAnimate()
    }
    
    @IBAction func submitReportButtonTapped(_ sender: UIButton) {
        createReportData()
    }
    
}
