//
//  CoredataRequests.swift
//  ContactsDisplayer
//
//  Created by Omega on 5/21/19.
//  Copyright © 2019 OmegaSoftware-AliJaber. All rights reserved.
//

import Foundation
import CoreData
import UIKit

struct contactSaveError: Error {
    var contact: Contact
}
extension AppDelegate {
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
}


class CoreDataRequests {
    static func getAllContacts() -> [Contact] {
        let context = AppDelegate.shared.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: CoredataKeys.Contacts.rawValue)
        do {
            let fetchedResults = try context.fetch(request)
            if let contacts = fetchedResults as? [NSManagedObject] {
                var array = [Contact]()
                for contact in contacts {
                    if let phoneNumber = contact.value(forKey: CoredataKeys.phoneNumber.rawValue) as? String, let name = contact.value(forKey: CoredataKeys.name.rawValue) as? String , let contactId = contact.value(forKey: CoredataKeys.id.rawValue) as? Int{
                        let contact = Contact(pNumber: phoneNumber, name: name,id: contactId)
                        array.append(contact)
                    }
                }
                return array
            }
        }catch {
            return []
        }
        return []
    }
    
    static func contactExistsById(_ id: Int,completion: @escaping(Bool) ->Void)  {
        let context = AppDelegate.shared.persistentContainer.viewContext
         let request = NSFetchRequest<NSFetchRequestResult>(entityName: CoredataKeys.Contacts.rawValue)
        request.predicate = NSPredicate(format: "\(CoredataKeys.id.rawValue) = %d", id)
        request.returnsObjectsAsFaults = false
        do{
            let fetchedData = try context.fetch(request)
            if let contact  = fetchedData as? [NSManagedObject] {
                if contact.isEmpty {
                    completion(false)
                    return
                }else {
                    completion(true)
                    return
                }
            }
        }catch {
            completion(false)
            return
        }
    }
    
    ///check if contact
    static func contactExistsByPhone(_ phone: String,completion: @escaping(Bool,Int?) ->Void)  {
        let context = AppDelegate.shared.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: CoredataKeys.Contacts.rawValue)
        request.predicate = NSPredicate(format: "\(CoredataKeys.phoneNumber.rawValue) = %@", phone)
        request.returnsObjectsAsFaults = false
        do{
            let fetchedData = try context.fetch(request)
            if let contact  = fetchedData as? [NSManagedObject] {
                if contact.isEmpty {
                    completion(false,nil)
                    return
                }else {
                   if let contct = contact.first {
                    let contId =  contct.value(forKey: CoredataKeys.id.rawValue) as? Int
                    completion(true,contId)
                    return
                    }
                }
            }
        }catch {
            completion(false,nil)
            return
        }
    }
    
    ///check if contact exist in database by name
    static func contactExistsByName(_ name: String,completion: @escaping(Bool,Int?) ->Void)  {
        let context = AppDelegate.shared.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: CoredataKeys.Contacts.rawValue)
        request.predicate = NSPredicate(format: "\(CoredataKeys.name.rawValue) = %@", name)
        request.returnsObjectsAsFaults = false
        do{
            let fetchedData = try context.fetch(request)
            if let contact  = fetchedData as? [NSManagedObject] {
                if contact.isEmpty {
                    completion(false,nil)
                    return
                }else {
                    if let contct = contact.first {
                        let contId =  contct.value(forKey: CoredataKeys.id.rawValue) as? Int
                        completion(true,contId)
                        return
                    }
                }
            }
        }catch {
            completion(false,nil)
            return
        }
    }
    

    static func saveContacts(_ contacts:[Contact],completion: @escaping ([contactSaveError])->Void) {
        var errors = [contactSaveError] ()
        for contact in contacts {
            if let error = saveContact(contact) {
                errors.append(error)
            }
        }
        completion(errors)
    }
    
    ///save contact with returning the contact if not saved
    private static func saveContact(_ contact:Contact) ->contactSaveError? {
        let context = AppDelegate.shared.persistentContainer.viewContext
        let newContact = NSEntityDescription.insertNewObject(forEntityName: CoredataKeys.Contacts.rawValue, into: context)
        newContact.setValue(contact.id, forKey: CoredataKeys.id.rawValue)
        newContact.setValue(contact.phoneNumber, forKey: CoredataKeys.phoneNumber.rawValue)
        newContact.setValue(contact.name, forKey: CoredataKeys.name.rawValue)
        do {
            try context.save()
            return nil
        }catch {
          return contactSaveError(contact: contact)
        }
    }
}
