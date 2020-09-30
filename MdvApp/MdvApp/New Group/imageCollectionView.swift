//
//  imageCollectionView.swift
//  MdvApp
//
//  Created by School on 2020-09-30.
//

import Foundation
import UIKit

class imageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageVIewCell: UIImageView!
    
    @IBOutlet weak var imageTitle: UILabel!
    
    var images = schoolMap.FetchCourse()
    var cellScale : CGFloat = 0.6
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let screenSize = UIScreen.main.bounds.size
        let cellWidth = floor(screenSize.width * cellScale )
        let cellHeight = floor(screenSize.height * cellScale)
        let instX = ( view.bounds.width - cellWidth ) / 2.0
        let instY = ( view.bounds.height - cellHeight ) / 2.0
        let layout = imageCollectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight )
        imageCollectionView.contentInset = UIEdgeInsets(top: instY , left: instX , bottom: instY, right: instX )
        imageCollectionView.dataSource = self
        
        viewBar.layer.cornerRadius = 40
        
    }
    
    
}

extension ViewController : UICollectionViewDataSource  {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return courses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagesCell", for: indexPath) as! imageCollectionView
        let image = images[indexPath.item]
        cell.images = image
        cell.backgroundColor = UIColor.black
        cell.layer.borderWidth = 1
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowRadius = 2.0
        cell.layer.cornerRadius = 10
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width: 2.0, height: 4.0)
        cell.layer.shadowRadius = 2.0
        return cell
        
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
}

