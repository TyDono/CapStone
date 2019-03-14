//
//  MessageViewController.swift
//  PartyUp
//
//  Created by Tyler Donohue on 3/13/19.
//  Copyright © 2019 Tyler Donohue. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import MessageKit
import MessageInputBar

class MessageViewController: MessagesViewController {
    
    var messages: [Message] = []
    var member: Member!
    var chatService: ChatService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        member = Member(name: .randomName, color: .randomColor)
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messageInputBar.delegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        chatService = ChatService(member: member, onRecievedMessage: {
            [weak self] message in
            self?.messages.append(message)
            self?.messagesCollectionView.reloadData()
            self?.messagesCollectionView.scrollToBottom(animated: true)
        })
        
        chatService.connect()
    }
    
}

//extensions
//1
extension MessageViewController: MessagesDataSource {
    func numberOfSections(
        in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }

    func currentSender() -> Sender {
        return Sender(id: member.name, displayName: member.name)
    }

    func messageForItem(
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView) -> MessageType {

        return messages[indexPath.section]
    }

    func messageTopLabelHeight(
        for message: MessageType,
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView) -> CGFloat {

        return 12
    }

    func messageTopLabelAttributedText(
        for message: MessageType,
        at indexPath: IndexPath) -> NSAttributedString? {

        return NSAttributedString(
            string: message.sender.displayName,
            attributes: [.font: UIFont.systemFont(ofSize: 12)])
    }
}

//2
extension MessageViewController: MessagesLayoutDelegate {
    func heightForLocation(message: MessageType,
                           at indexPath: IndexPath,
                           with maxWidth: CGFloat,
                           in messagesCollectionView: MessagesCollectionView) -> CGFloat {

        return 0
    }
}

//3
extension MessageViewController: MessagesDisplayDelegate {
    func configureAvatarView(
        _ avatarView: AvatarView,
        for message: MessageType,
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView) {

        let message = messages[indexPath.section]
        let color = message.member.color
        avatarView.backgroundColor = color
    }
}

//4
extension MessageViewController: MessageInputBarDelegate {
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        chatService.sendMessage(text)
        inputBar.inputTextView.text = ""
    }
}

//propertie sont eh nav or view controller. or hidue the nav bar when you do stuff.  a prepare for segue posibley? override the defualt behavior.
