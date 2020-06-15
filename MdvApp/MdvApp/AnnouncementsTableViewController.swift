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
        return announcements.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let announcement = announcements[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! announcementTableViewCell
        cell.announcementTitleLabel?.text = announcement.title
        cell.announcementBodyLabel?.text = announcement.body
        return cell
    }
    
    var announcements: [Announcement] = [
        Announcement(title: "Test 123", body: "Testing 123, this is a sample announcement", tags: []),
        Announcement(title: "Test 123", body: "Testing 123, this is a sample announcement", tags: []),
        Announcement(title: "Test 123", body: "Testing 123, this is a sample announcement", tags: []),
        Announcement(title: "Test 123", body: "Testing 123, this is a sample announcement", tags: []),
        Announcement(title: "Test 123", body: "Testing 123, this is a sample announcement", tags: []),
    ]
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
    
    
    
    
    
    
    
}

