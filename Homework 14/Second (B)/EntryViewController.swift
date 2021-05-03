//
//  EntryViewController.swift
//  Homework 14
//
//  Created by Влад Бокин on 31.03.2021.
//

import UIKit
import RealmSwift

class EntryViewController:  UIViewController, UITextFieldDelegate {
    
    private let realm = try! Realm()
    public var completionHandler: (() -> Void)?
    @IBOutlet var textField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.becomeFirstResponder()
        textField.delegate = self
        datePicker.setDate(Date() , animated: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "save", style: .done, target: self, action:  #selector(didTapSaveButton))
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @objc @IBAction func didTapSaveButton() {
        if let text = textField.text, !text.isEmpty{
            let date = datePicker.date
            realm.beginWrite()
            
            let newItem = ToDoList()
            newItem.date = date
            newItem.item = text
            realm.add(newItem )
            try! realm.commitWrite()
            completionHandler?()
            navigationController?.popToRootViewController(animated: true)
        }
        else {
            print("add something")
        }
    }
}

