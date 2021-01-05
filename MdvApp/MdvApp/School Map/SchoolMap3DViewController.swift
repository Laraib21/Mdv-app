//
//  SchoolMap3DViewController.swift
//  MdvApp
//
//  Created by Laraib Iqbal on 2021-01-02.
//

import Foundation
import UIKit

class SchoolMap3DViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var imgPhoto: UIImageView!
    
    @IBOutlet weak var firstFloorButton: UIButton!
    
    @IBOutlet weak var secondFloorButton: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        scrollView.minimumZoomScale = 0.80
        scrollView.maximumZoomScale = 6.0
        scrollView.zoomScale = 0.80
        scrollView.contentOffset = CGPoint(x: 0, y: 50)
        // scrollView.delegate = self - it is set on the storyboard.
        var temporaryImg = #imageLiteral(resourceName: "first floor")
        temporaryImg = temporaryImg.rotateDegrees(90)!
        imgPhoto.image = temporaryImg
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return imgPhoto
    }
    
    
    func imageSwitch(image: UIImage) {
        var temporaryImg = image
        temporaryImg = temporaryImg.rotateDegrees(90)!
        UIView.animate(withDuration: 0.3) {
            self.scrollView.zoomScale = 0.80
        } completion: { (_) in
            UIView.transition(with: self.imgPhoto, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.imgPhoto.image = temporaryImg
            }, completion: nil)
        }



    }
    
    @IBAction func firstFloorTapped(_ sender: Any) {
       imageSwitch(image: #imageLiteral(resourceName: "first floor"))
    }
    
    
    @IBAction func secondFloorTapped(_ sender: Any) {
        imageSwitch(image: #imageLiteral(resourceName: "second floor"))
    }
    
    
    
}

