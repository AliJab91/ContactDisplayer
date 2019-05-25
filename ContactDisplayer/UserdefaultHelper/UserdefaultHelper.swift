//
//  UserdefaultHelper.swift
//  ContactsDisplayer
//
//  Created by Ali Jaber on 5/24/19.
//  Copyright © 2019 OmegaSoftware-AliJaber. All rights reserved.
//

import Foundation
class UserdefaultHelper {
    static private var counter = "counter"
    /// incremet user id after each save
    static func incrementContactId() {
        if let userId = UserDefaults.standard.integer(forKey: counter) as? Int {
            if userId == 0  {
                UserDefaults.standard.set(1, forKey: counter)
            }else {
                UserDefaults.standard.set(userId + 1, forKey: counter)
            }
        }
    }
    
    /// returning a userid
    static func getContactId() ->Int {
        if let userId = UserDefaults.standard.integer(forKey: counter) as? Int {
            if userId == 0 {
                UserDefaults.standard.set(1, forKey: counter)
                return 1
            }else {
                return userId
            }
        }
    }
}
