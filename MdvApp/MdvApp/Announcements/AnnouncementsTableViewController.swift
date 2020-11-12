//
//  AnnouncementsTableViewController.swift
//  MdvApp
//
//  Created by School on 2020-06-08.
//

import UIKit
import SwiftUI
import os.log
import Combine

// MARK: - Helpers
class AnnouncementsTableViewController: UITableViewController {
    var cancellable: AnyCancellable?
    var announcements: [Announcement] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshControlInvoked), for: .valueChanged)
        AnnouncementLoader.shared.updateSubscriptions()
        cancellable = AnnouncementLoader.shared.$announcements
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newAnnouncements in
                self?.announcements.append(contentsOf: newAnnouncements)
                self?.tableView.reloadData()
            }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshControlInvoked()
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
    
    
    @IBAction func addAnnouncement(_ sender: Any) {
        let announcement = NewAnnouncementView(dismiss:dismissHostingController)
        present(announcement)
    }
    
    
    
    
    
    func dismissHostingController(newAnnouncement: Announcement) -> Void {
        AnnouncementLoader.shared.save(newAnnouncement) {[weak self]error in
            print(String(describing:error))
            self?.presentedViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    
    @objc func refreshControlInvoked() {
        refreshControl?.beginRefreshing()
        AnnouncementLoader.shared.fetchAnnouncements { [weak self] (possibleError) in
            defer { DispatchQueue.main.async { self?.refreshControl?.endRefreshing() } }
            if let possibleError = possibleError{
                print(possibleError)
                os_log("User encountered error: %{public}@", log: .default, type: .error, possibleError.localizedDescription)
                return
            }
            os_log("Announcements loaded!", log: .default, type: .error)
            self?.tableView.reloadData()
        }
    }
}
