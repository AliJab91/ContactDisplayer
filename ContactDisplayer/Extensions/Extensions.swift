//
//  Extensions.swift
//  ContactsDisplayer
//
//  Created by Ali Jaber on 5/22/19.
//  Copyright © 2019 OmegaSoftware-AliJaber. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(title:String, body:String)  {
        let alertVC = UIAlertController(title: title, message: body, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertVC.addAction(okAction)
        self.present(alertVC, animated: true, completion: nil)
    }
}

extension Dictionary where Key:
ExpressibleByStringLiteral {
    subscript(key:CoredataKeys) ->Value? {
        get {
            return self[key.rawValue as! Key]
        }
        set {
            self[key.rawValue as! Key] = newValue
        }
    }
}

/// comparing object properties
extension Contact:Equatable {
    static func == (lhs:Contact , rhs:Contact) ->Bool {
        if (lhs.id == rhs.id){
            return true
        }
        return false
    }
    
/// check if object is edited
    static func isEdited (lhs:Contact,rhs:Contact) ->Bool {
        if (lhs.id == rhs.id && (lhs.name != rhs.name || lhs.phoneNumber != rhs.phoneNumber)) {
            return true
        }else {
            return false
        }
    }
}
