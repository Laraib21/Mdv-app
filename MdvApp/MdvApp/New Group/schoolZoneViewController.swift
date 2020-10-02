//
//  scrollViewPhoto.swift
//  MdvApp
//
//  Created by School on 2020-09-29.
//

import Foundation
import UIKit

class SchoolZoneViewController: UICollectionViewController {
    
    var zones = 
        
        [zoneMap(title: "Our School", zoneImage: UIImage(named: "WHOLE SCHOOL")!),
         zoneMap(title: "Yellow Zone", zoneImage: UIImage(named: "YELLOW ZONE")!),
         zoneMap(title: "Green Zone", zoneImage: UIImage(named: "GREEN ZONE")!),
         zoneMap(title: "Red Zone", zoneImage: UIImage(named: "RED ZONE")!),
         zoneMap(title: "Purple Zone", zoneImage: UIImage(named: "PURPLE ZONE")!),
         zoneMap(title: "Brown Zone", zoneImage: UIImage(named: "BROWN ZONE")!),
         zoneMap(title: "BLUE Zone", zoneImage: UIImage(named: "BLUE ZONE")!),
        ]
    
}

extension SchoolZoneViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return zones.count
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let zone = zones[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "zoneIdentifier", for: indexPath) as! ZoneMapCollectionViewCell
        cell.zoneTitle.text = zone.title
        cell.zoneImage.image = zone.zoneImage
        return cell
    }
}

class ZoneMapCollectionViewCell: UICollectionViewCell {
    @IBOutlet var zoneTitle: UILabel!
    
    @IBOutlet var zoneImage : UIImageView!
}
