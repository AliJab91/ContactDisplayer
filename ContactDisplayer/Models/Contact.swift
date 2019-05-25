//
//  Contact.swift
//  ContactsDisplayer
//
//  Created by Omega on 5/21/19.
//  Copyright © 2019 OmegaSoftware-AliJaber. All rights reserved.
//

import Foundation
struct Contact {
    let phoneNumber: String?
    let name:String?
    let id:Int?
    init(pNumber:String,name:String,id:Int) {
        self.phoneNumber = pNumber
        self.name = name
        self.id = id 
    }
}


