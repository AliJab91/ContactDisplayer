//
//  ContactsViewController.swift
//  ContactsDisplayer
//
//  Created by Omega on 5/21/19.
//  Copyright © 2019 OmegaSoftware-AliJaber. All rights reserved.
//

import UIKit
import Contacts
class ContactsViewController: UIViewController {

    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    var phoneContacts = [Contact]()
    var localContacts = [Contact]()
    var deletedContacts = [Contact]()
    var newContacts = [Contact]()
    var displayedContacts = [Contact]()
    var editedContacts = [Contact]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setSegmentController()
        setTableView()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.getContacts),
            name: NSNotification.Name(rawValue: "getContacts"),
            object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
         getContacts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    @objc func getContacts()  {
        emptyAllArrays()
        pContacts.getContacts(completion: { (pContacts) in
            if pContacts.isEmpty && CoreDataRequests.getAllContacts().isEmpty {
                self.showAlert(title: "Error", body: "Could not get contacts")
                return
            }else if !pContacts.isEmpty {
                self.phoneContacts = pContacts
                if CoreDataRequests.getAllContacts().isEmpty {
                    self.saveContacts(pContacts)
                }else {
                    self.localContacts = CoreDataRequests.getAllContacts()
                    for contact in self.phoneContacts {
                        self.checkIfNewContact(contact)
                    }
                    for contact in self.localContacts {
                        self.getDeletedContacts(contact)
                        self.getEditedNumbersById(contact)
                    }
                }
            }
        })
    }
    
    func emptyAllArrays()  {
        self.deletedContacts.removeAll()
        self.newContacts.removeAll()
        self.displayedContacts.removeAll()
        self.editedContacts.removeAll()
    }
    
    @IBAction func segmentChanged(_ sender: Any) {
        switch segmentController.selectedSegmentIndex {
        case 0: displayedContacts = editedContacts
        tableView.reloadData()
            break
        case 1: displayedContacts = newContacts
        tableView.reloadData()
            break
        case 2: displayedContacts = deletedContacts
        tableView.reloadData()
            break
        default:
            displayedContacts = editedContacts
            tableView.reloadData()
        }
    }
    
    
    func checkIfNewContact(_ contact:Contact)   {
        if let id = contact.id {
            CoreDataRequests.contactExistsById(id) { (available) in
                if available {
                }else {
                    self.newContacts.append(contact)
                }
            }
        }
    }
    
    func getDeletedContacts(_ contact:Contact)  {
        if phoneContacts.contains(contact) {
        }else {
            self.deletedContacts.append(contact)
        }
    }
    
    func getEditedNumbersById(_ contact:Contact)  {
        for cont in phoneContacts {
            if Contact.isEdited(lhs: contact, rhs: cont){
                self.editedContacts.append(contact)
            }
        }
        self.displayedContacts = editedContacts
        self.tableView.reloadData()
    }
    
    func saveContacts(_ contacts:[Contact])  {
        if contacts.isEmpty {
            return
        }
        pContacts.saveContactsLocally(contacts) { (erorrs) in
            if erorrs.isEmpty {
                self.localContacts = self.phoneContacts
            }else {
                self.showAlert(title: "Error", body: "\(erorrs.count) contacts werent saved")
            }
        }
    }
    
    @IBAction func refreshTapped(_ sender: Any) {
        getContacts()
        self.segmentController.selectedSegmentIndex = 0
    }
    
    func setTableView()  {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ContactCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    
    func setSegmentController()  {
        segmentController.setTitle("Modified", forSegmentAt: 0)
        segmentController.setTitle("Added", forSegmentAt: 1)
        segmentController.setTitle("Deleted", forSegmentAt: 2)
    }
}

extension ContactsViewController :UITableViewDelegate {}

extension ContactsViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedContacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "cell") as? ContactCell
        if let contact = displayedContacts[indexPath.row] as? Contact {
            cell!.fillCellWithContact(contact)
            return cell!
        }
         return cell!
    }
}

