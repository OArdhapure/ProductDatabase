//
//  ViewController.swift
//  ProductDatabase
//
//  Created by Omkar Ardhapure on 22/03/18.
//  Copyright © 2018 Omkar Ardhapure. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var productName: UITextField!
    
    @IBOutlet weak var productPrice: UITextField!
    @IBOutlet weak var productQuantity: UITextField!
    @IBAction func saveClicked(_ sender: Any) {
        insertDB()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func insertDB()
    {
        //dir
        let dir = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        
        //dbPath
        let dbPath = dir.appendingPathComponent("product.sqlite")
        
        print(dbPath)
        //file exists
        let manager = FileManager()
        
        if manager.fileExists(atPath: dbPath.path)
        {
            print("file Exits")
        }
        else
        {
            manager.createFile(atPath: dbPath.path, contents: nil, attributes: nil)
        }
        
        var op : OpaquePointer? = nil
        //open
        let status = sqlite3_open(dbPath.path, &op)
        if status == SQLITE_OK
        {
            print("Database is opened")
            //insert operation
            let tempProductName = productName.text
            let tempProductPrice = productPrice.text
            let tempProductQuantity = productQuantity.text
            
            let query = String(format : "insert into product values('%@','%d','%d')", tempProductName!, tempProductPrice!, tempProductQuantity!)
            let queryStatus = sqlite3_exec(op, query, nil, nil, nil)
            if queryStatus == SQLITE_OK
            {
                print("record inserted")
            }
            else
            {
                print("record not inserted")
            }
            
        }
        else
        {
            print("Database not opened")
        }
        //close db
        sqlite3_close(op)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

