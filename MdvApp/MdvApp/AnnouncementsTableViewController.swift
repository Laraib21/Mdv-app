//
//  AnnouncementsTableViewController.swift
//  MdvApp
//
//  Created by School on 2020-06-08.
//

import UIKit
import SwiftUI

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
        Announcement(title: "Test 123", body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eu augue metus. Donec ultrices pharetra libero eu ultrices. Aenean posuere convallis nisl, quis varius nunc congue in. Suspendisse consectetur, velit nec pretium bibendum, ligula sapien iaculis enim, sit amet porttitor leo lacus ac nisl. Sed sodales ante sed pretium auctor. Morbi ut vestibulum lorem. Sed lobortis vel ipsum quis rhoncus. Phasellus tempor mollis vestibulum. Nullam vel lacus in velit volutpat sagittis. Donec eu turpis eu ex auctor gravida id vitae nulla. Vestibulum laoreet lorem rutrum tortor congue, eget elementum turpis congue.\nFusce fringilla ante ac tempus rhoncus. Duis sollicitudin massa at leo venenatis sodales. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Duis consectetur bibendum ex sed consectetur. Morbi id ex nisi. Praesent bibendum tortor sed risus tempus consequat sed sit amet est. Proin hendrerit dolor ac lacus auctor malesuada. Sed at justo ultrices, ornare massa id, scelerisque lorem.\nQuisque tincidunt consequat volutpat. Curabitur at metus magna. Nunc hendrerit feugiat urna at euismod. Duis lectus mi, dignissim ac egestas quis, porta eu ipsum. Praesent laoreet aliquet elit, ut venenatis ipsum luctus a. Duis vel accumsan justo, interdum imperdiet tortor. Nulla arcu augue, dapibus id convallis eu, rutrum vitae urna. Nulla pretium pellentesque tellus auctor pharetra.\nAenean tincidunt, nulla tempor pulvinar rhoncus, purus lacus feugiat tortor, sit amet accumsan felis massa in felis. Integer et aliquam eros, a volutpat ex. Integer auctor elementum blandit. Suspendisse eget cursus risus, non fermentum mi. In rutrum erat nec nisi tincidunt, eu imperdiet arcu molestie. Curabitur venenatis fermentum nulla sit amet congue. Praesent id metus tellus. Nullam at convallis quam, non auctor diam.", tags: []),
        Announcement(title: "Test 123", body: "Testing 123, this is a sample announcement", tags: []),
        Announcement(title: "Test 123", body: "Testing 123, this is a sample announcement", tags: []),
        Announcement(title: "Test 123", body: "Testing 123, this is a sample announcement", tags: []),
        Announcement(title: "Test 123", body: "Testing 123, this is a sample announcement", tags: []),
    ]
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let announcementDetailsView = AnnouncementDetailsView(announcement: announcements[indexPath.row])
        let hostingController = UIHostingController(rootView: announcementDetailsView)
        present(hostingController, animated: true, completion: nil)
    }
    
    
    
    
    
}

