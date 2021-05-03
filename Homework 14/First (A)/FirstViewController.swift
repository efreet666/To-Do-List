//
//  FirstViewController.swift
//  Homework 14
//
//  Created by Влад Бокин on 30.03.2021.
//

import UIKit

class FirstViewController: UIViewController {

   
    @IBAction func nameTextField(_ sender: Any) {
        nameLabel.text = nameTextFieldOutlet.text
        Persistance.shared.userName = nameTextFieldOutlet.text
    }
    @IBAction func surnameTextField(_ sender: Any) {
        surnameLabel.text = surnameTextFieldOutlet.text
        Persistance.shared.userSurname = surnameTextFieldOutlet.text
    }
    
    @IBOutlet weak var nameTextFieldOutlet: UITextField!
    @IBOutlet weak var surnameTextFieldOutlet: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        if Persistance.shared.userName != nil{
            nameLabel.text = Persistance.shared.userName
        }
        if Persistance.shared.userSurname != nil{
            surnameLabel.text = Persistance.shared.userSurname
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var surnameLabel: UILabel!
    
    
    
}
