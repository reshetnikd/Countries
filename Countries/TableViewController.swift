//
//  TableViewController.swift
//  Countries
//
//  Created by Dmitry Reshetnik on 26.04.2020.
//  Copyright © 2020 Dmitry Reshetnik. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    var countries = [Country]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        title = "Countries"
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let namesURL = URL(string: "http://country.io/names.json"),
                let capitalsURL = URL(string: "http://country.io/capital.json"),
                let phonesURL = URL(string: "http://country.io/phone.json"),
                let currenciesURL = URL(string: "http://country.io/currency.json") {
                
                let names = self.fetchData(from: namesURL)
                let capitals = self.fetchData(from: capitalsURL)
                let phones = self.fetchData(from: phonesURL)
                let currencies = self.fetchData(from: currenciesURL)
                
                if (names.count == capitals.count) == (phones.count == currencies.count) {
                    for index in 0..<names.count {
                        self.countries.append(Country(name: names[index], capital: capitals[index], phone: phones[index], currency: currencies[index]))
                    }
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
                return
            }
            
            self.showError()
        }
    }
    
    @objc func showError() {
        DispatchQueue.main.async {
            let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
        }
    }
    
    func fetchData(from url: URL) -> [String] {
        var result = [String]()
        
        if let data = try? Data(contentsOf: url) {
            var str = String(data: data, encoding: .utf8)!
            str.removeFirst()
            str.removeLast()
            
            let fetchedData = str.components(separatedBy: "\", \"")
            
            for dataRow in fetchedData {
                result.append(dataRow.components(separatedBy: ":")[1].replacingOccurrences(of: "\"", with: ""))
            }
        }
        
        return result
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return countries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = countries[indexPath.row].name

        return cell
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let identifier = segue.identifier {
            switch identifier {
            case "CountrySelected":
                if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell), let vc = segue.destination as? ViewController {
                    vc.country = countries[indexPath.row]
                }
            default:
                break
            }
        }
    }

}
