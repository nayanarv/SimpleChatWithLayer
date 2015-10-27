//
//  ConversationListViewController.swift
//  SimpleChat
//
//  Created by Nayana on 27/10/15.
//  Copyright © 2015 Nayana. All rights reserved.
//

import UIKit
import Atlas

class ConversationListViewController: ATLConversationViewController, ATLConversationListViewControllerDataSource, ATLConversationListViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

//        self.dataSource = self
//        self.delegate = self
        self.navigationController!.navigationBar.tintColor = ATLBlueColor()
        
        let composeItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Compose, target: self, action: Selector("composeButtonTapped:"))
        self.navigationItem.setRightBarButtonItem(composeItem, animated: false)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK - ATLConversationListViewControllerDelegate Methods
    
    
    
    func conversationListViewController(conversationListViewController: ATLConversationListViewController, didSelectConversation conversation:LYRConversation) {
        self.presentConversationControllerForConversation(conversation)
        
    }
    
    
    // MARK - ATLConversationListViewControllerDataSource Methods
    
    func conversationListViewController(conversationListViewController: ATLConversationListViewController, titleForConversation conversation: LYRConversation) -> String {
        if conversation.metadata["title"] != nil {
            return conversation.metadata["title"] as! String
        } else {
            let listOfParticipant = Array(conversation.participants)
            if listOfParticipant.count == 0
            {
                return "personal conversation"
            }
        }
        return ""
    }

    //MARK: - Participate Delegate

    
    //MARK: - Helpers
    
    func presentConversationControllerForConversation (conversation : LYRConversation!)
    {
        let conversationViewController = ATLConversationViewController()
        conversationViewController.conversation = conversation
        self.navigationController?.pushViewController(conversationViewController, animated: true)
        
    }
    
    func participantsForIdentifiers(identifiers: NSSet) ->NSSet
    {
        let participants:NSMutableSet = NSMutableSet(capacity: identifiers.count)
        let identifier = NSString()

        let userobj = User()
         participants.addObject(userobj.userWithParticipateIdentifier(identifier))
        return participants
    }
    
    //MARK: - User Interaction
    
    //MARK: - Helpers

}
