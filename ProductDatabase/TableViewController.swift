//
//  TableViewController.swift
//  ProductDatabase
//
//  Created by Omkar Ardhapure on 22/03/18.
//  Copyright © 2018 Omkar Ardhapure. All rights reserved.
//

import UIKit

class CellClass : UITableViewCell{
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblQuantity: UILabel!
}

class TableViewController: UITableViewController {
    
    var productArray = [ProductClass]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        selectDB()
    }
    
    func selectDB()
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
            //select operation
            
            let query = String(format : "select * from product")
            
            var statement : OpaquePointer? = nil
            
            let queryStatus = sqlite3_prepare(op, query, -1, &statement, nil)
            if queryStatus == SQLITE_OK
            {
                while sqlite3_step(statement) == SQLITE_ROW{
                    let product = ProductClass()
                    let name = String.init(format : "%s", sqlite3_column_text(statement, 0))
                    let price = Int(sqlite3_column_int(statement, 1))
                    let quantity = Int(sqlite3_column_int(statement, 2))
                    
                    product.productName = name
                    product.productPrice = price
                    product.productQuantity = quantity
                    
                    productArray.append(product)
                }
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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return productArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as! CellClass

        // Configure the cell...
       // cell.textLabel?.text = productArray[indexPath.row].productName
        cell.lblName.text = productArray[indexPath.row].productName
        cell.lblPrice.text = String(productArray[indexPath.row].productPrice)
        cell.lblQuantity.text = String(productArray[indexPath.row].productQuantity)
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
