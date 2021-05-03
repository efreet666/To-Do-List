//
//  Persistance.swift
//  Homework 14
//
//  Created by Влад Бокин on 30.03.2021.
//

import Foundation

class Persistance{
    static let shared = Persistance()
    
    private let kUserNameKey = "Persistance.kUserNameKey"
    private let kUserSurnameKey = "Persistance.kUserSurnameKey"
    
    var userName: String?{
        set{ UserDefaults.standard.setValue(newValue, forKey: kUserNameKey)}
        get{ return UserDefaults.standard.string(forKey: kUserNameKey)}
    }
    var userSurname: String?{
        set{ UserDefaults.standard.setValue(newValue, forKey: kUserSurnameKey)}
        get{ return UserDefaults.standard.string(forKey: kUserSurnameKey)}
    }
}
