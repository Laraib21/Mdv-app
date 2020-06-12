//
//  AnnouncementsTableViewController.swift
//  MdvApp
//
//  Created by School on 2020-06-08.
//

import UIKit

class AnnouncementsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 10
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.textLabel?.text = "Cell #\(indexPath.row)"
        return cell
    }
    
    
    
}

