//
//  ContactsRequests.swift
//  ContactsDisplayer
//
//  Created by Omega on 5/21/19.
//  Copyright © 2019 OmegaSoftware-AliJaber. All rights reserved.
//

import Foundation
import Contacts
import UIKit
enum Errors: Error {
    case error(Error)
}

/// getting Phone contacts
class pContacts {
    static func getPhoneContacts() -> [CNContact] {
        let contactStore = CNContactStore()
        let keysToFetch = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactPhoneNumbersKey,
            CNContactEmailAddressesKey,
            CNContactThumbnailImageDataKey] as [Any]
        var allContainers: [CNContainer] = []
        do {
            allContainers = try contactStore.containers(matching: nil)
        } catch {
            print( "Error fetching containers")
        }
        var results: [CNContact] = []
        for container in allContainers {
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
            do {
                let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                results.append(contentsOf: containerResults)
            } catch {
            }
        }
        return results
    }
    
    
    /// get saved contacts from local database
    static func getContacts(completion: @escaping ([Contact]) -> Void){
        var contacts = [Contact]()
        let phoneContacts = getPhoneContacts()
        for contact in phoneContacts {
            if let pNumber = (contact.phoneNumbers.first?.value)?.stringValue, let contactName = contact.givenName as? String , let contactId = UserdefaultHelper.getContactId() as? Int  {
                CoreDataRequests.contactExistsByPhone(pNumber) { (success,id) in
                    if success {
                        if let contactId = id {
                            contacts.append(Contact(pNumber: pNumber,name:contactName,id: contactId))
                        }
                    }else  { CoreDataRequests.contactExistsByName(contactName, completion: { (success, id) in
                        if success {
                            if let contactId = id {
                                contacts.append(Contact(pNumber: pNumber,name:contactName,id: contactId))
                            }
                        }else {
                            contacts.append(Contact(pNumber: pNumber,name:contactName,id: contactId))
                            UserdefaultHelper.incrementContactId()
                        }
                    })}
                }
            }
        }
        completion(contacts)
    }
    
    
    
    /// save contacts locally and return the errors
    static func saveContactsLocally(_ contacts:[Contact], completion:@escaping ([contactSaveError])->Void) {
        CoreDataRequests.saveContacts(contacts, completion: { (errors) in
            if errors.isEmpty {
                completion([])
            }else {
                completion(errors)
            }
        })
    }
}



