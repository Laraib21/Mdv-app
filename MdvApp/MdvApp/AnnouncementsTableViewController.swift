//
//  AnnouncementsTableViewController.swift
//  MdvApp
//
//  Created by School on 2020-06-08.
//

import UIKit
import SwiftUI

class AnnouncementsTableViewController: UITableViewController {
    let announcementLoader = AnnouncementLoader()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        announcementLoader.announcmentGetter { (announcements) in
            self.announcements = announcements
            self.tableView.reloadData()
        }
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
    
    var announcements: [Announcement] = []
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let announcementDetailsView = AnnouncementDetailsView(announcement: announcements[indexPath.row])
        let hostingController = UIHostingController(rootView: announcementDetailsView)
        present(hostingController, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    
    
}

