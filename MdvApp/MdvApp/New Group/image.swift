//
//  image.swift
//  MdvApp
//
//  Created by School on 2020-09-30.
//

import UIKit

class schoolMap: UIView {
    
    var title = ""
    var zoneImage: UIImage
    
    
    init(title:String , zoneImage :UIImage) {
        self.title = title
        self.zoneImage = zoneImage
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func FetchCourse () -> [schoolMap]{
        
        return [ schoolMap(title: "Our School", zoneImage: UIImage(named: "WHOLE SCHOOL")!),
                 schoolMap(title: "Yellow Zone", zoneImage: UIImage(named: "YELLOW ZONE")!),
                 schoolMap(title: "Green Zone", zoneImage: UIImage(named: "GREEN ZONE")!),
                 schoolMap(title: "Red Zone", zoneImage: UIImage(named: "RED ZONE")!),
                 schoolMap(title: "Purple Zone", zoneImage: UIImage(named: "PURPLE ZONE")!),
                 schoolMap(title: "Brown Zone", zoneImage: UIImage(named: "BROWN ZONE")!),
                 schoolMap(title: "BLUE Zone", zoneImage: UIImage(named: "BLUE ZONE")!),
        ]
        
    }
}




