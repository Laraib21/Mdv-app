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
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshControlInvoked), for: .valueChanged)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshControlInvoked()
    }
    // MARK: - Helpers
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return announcementLoader.announcements.count
    }
    
    // MARK: - Helpers
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let announcement = announcementLoader.announcements[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! announcementTableViewCell
        cell.announcementTitleLabel?.text = announcement.title
        cell.announcementBodyLabel?.text = announcement.body
        return cell
    }
    // MARK: - Helpers
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
    
    // MARK: - Helpers
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let announcementDetailsView = AnnouncementDetailsView(announcement: announcementLoader.announcements[indexPath.row])
        let hostingController = UIHostingController(rootView: announcementDetailsView)
        present(hostingController, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    @IBAction func addAnnouncement(_ sender: Any) {
        let announcement = NewAnnouncementView(dismiss:dismissHostingController)
        present(announcement)
    }
    
    
    
    
    
    func dismissHostingController(newAnnouncement: Announcement) -> Void {
        announcementLoader.save(newAnnouncement) {[weak self]error in
            print(String(describing:error))
            self?.presentedViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    
    @objc func refreshControlInvoked() {
        refreshControl?.beginRefreshing()
        announcementLoader.fetchAnnouncements { [weak self] (possibleError) in
            if let possibleError = possibleError{
                print(possibleError)
                return
            }
            self?.tableView.reloadData()
            DispatchQueue.main.async { self?.refreshControl?.endRefreshing() }
        }
    }
    
    
    
    
    
    
}
