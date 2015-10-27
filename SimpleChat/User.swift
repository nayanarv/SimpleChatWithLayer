//
//  User.swift
//  SimpleChat
//
//  Created by Nayana on 27/10/15.
//  Copyright © 2015 Nayana. All rights reserved.
//

import UIKit
import Atlas

class User: NSObject {

    var firstName:NSString!
    var lastName:NSString!
    var fullName:NSString!
    var participantIdentifiers:NSString!
    var avatarInitials:NSString!
    
    func initWithParticipateIdentifier(participantIdentifier:NSString) -> NSObject
    {

        participantIdentifiers = participantIdentifier
        firstName = participantIdentifier
        lastName = participantIdentifier
        fullName = participantIdentifier
        avatarInitials = participantIdentifier.substringFromIndex(1)
        
        return self
    }
    
    func userWithParticipateIdentifier (participantIdentifier:NSString) -> NSObject
    {
        return self.initWithParticipateIdentifier(participantIdentifier)
    }
    
}
