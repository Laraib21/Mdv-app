//
//  AnnouncementsTableViewController.swift
//  MdvApp
//
//  Created by School on 2020-06-08.
//

import UIKit
import SwiftUI

    // MARK: - Helpers
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
    
        // MARK: - Helpers
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return announcements.count
    }
    
        // MARK: - Helpers
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let announcement = announcements[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! announcementTableViewCell
        cell.announcementTitleLabel?.text = announcement.title
        cell.announcementBodyLabel?.text = announcement.body
        return cell
    }
        // MARK: - Helpers
    var announcements: [Announcement] = []
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
    
        // MARK: - Helpers
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let announcementDetailsView = AnnouncementDetailsView(announcement: announcements[indexPath.row])
        let hostingController = UIHostingController(rootView: announcementDetailsView)
        present(hostingController, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    @IBAction func addFakeAnnouncement(_ sender: Any) {
        let announcement = Announcement(title: "Welcome Back", body: "hello")
        announcementLoader.save(announcement) {error in
            print(String(describing:error))
        }
    }
    
    
    
}

