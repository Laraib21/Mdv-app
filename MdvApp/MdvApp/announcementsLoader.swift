//
//  announcementsLoader.swift
//  MdvApp
//
//  Created by School on 2020-07-02.
//

import Foundation

class AnnouncementLoader {
    var announcements: [Announcement] = [
        Announcement(title: "Welcome Back Meadowvale!", body:"Hello Falcons, welcome back after an unsual time. It's going to be hard but we will get through it together as we always do.Hello Falcons, welcome back after an unsual time. It's going to be hard but we will get through it together as we always do.Hello Falcons, welcome back after an unsual time. It's going to be hard but we will get through it together as we always do.Hello Falcons, welcome back after an unsual time. It's going to be hard but we will get through it together as we always do.", tags: []),
        Announcement(title: "Test 123", body: "Testing 123, this is a sample announcement", tags: []),
        Announcement(title: "Test 123", body: "Testing 123, this is a sample announcement", tags: []),
        Announcement(title: "Test 123", body: "Testing 123, this is a sample announcement", tags: []),
        Announcement(title: "Test 123", body: "Testing 123, this is a sample announcement", tags: []),
    ]
    
    
    func announcmentGetter(completion: @escaping ([Announcement]) -> Void) {
        completion(announcements)
        /*
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
     
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard let data = data else {
               print("Encountered error: \(error?.localizedDescription ?? "Unknown")")
                return
            }
            let announcements = try! JSONDecoder().decode([Announcement].self, from: data)
            DispatchQueue.main.async {
                completion(announcements)
            }
        }
        task.resume()
        
    }
}
*/
}
}
