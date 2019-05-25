//
//  ContactCell.swift
//  ContactsDisplayer
//
//  Created by Omega on 5/21/19.
//  Copyright © 2019 OmegaSoftware-AliJaber. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {
    @IBOutlet weak var contactName: UILabel!
    @IBOutlet weak var contactPnumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    func fillCellWithContact(_ contact:Contact) {
        contactName.text = contact.name
        contactPnumber.text = contact.phoneNumber
    }
    
}
