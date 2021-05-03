//
//  ViewViewController.swift
//  Homework 14
//
//  Created by Влад Бокин on 31.03.2021.
//

import UIKit
import RealmSwift

class ViewViewController: UIViewController {

    public var item: ToDoList?
    public var deletionHandler: (() -> Void)?
    
    @IBOutlet var itemLalbel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    private let realm = try! Realm()
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemLalbel.text = item?.item
        dateLabel.text = Self.dateFormatter.string(from: item!.date)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(didTapDelete))
    }
    @objc private func didTapDelete(){
        guard let myItem = self.item else{
            return
        }
        realm.beginWrite()
        realm.delete(myItem)
        try! realm.commitWrite()
        
        deletionHandler?()
        navigationController?.popToRootViewController(animated: true)
    }
}
