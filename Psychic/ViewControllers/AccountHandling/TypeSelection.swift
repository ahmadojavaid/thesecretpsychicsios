//
//  TypeSelection.swift
//  Psychic
//
//  Created by APPLE on 12/31/18.
//  Copyright © 2018 Jobesk. All rights reserved.
//

import UIKit

class TypeSelection: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let bar:UINavigationBar! =  self.navigationController?.navigationBar
        bar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        bar.shadowImage = UIImage()
        bar.alpha = 0.0
        
        
        DEFAULTS.set("1", forKey: "walk")
        
      
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        let animation = CABasicAnimation(keyPath: "position.x")
        animation.fromValue = 1000
        animation.toValue = 1
        animation.duration = 100
        animation.repeatCount = 100000
//        collectionView.layer.add(animation, forKey: "basicAnimation")
        
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "advisors", for: indexPath) as! AdvisorsList
        
        cell.backgroundColor = .random
        cell.advisorImage.clipsToBounds = true
        cell.advisorImage.layer.cornerRadius = 50.0
        
        cell.advisorImage.image = UIImage(named: "face\(indexPath.row+1)")
        
        return cell
    }
    
    
    
    
    
    
    
    
    
    
    
    

}

extension UIColor {
    static var random: UIColor {
        return UIColor(red: .random(in: 0...1),
                       green: .random(in: 0...1),
                       blue: .random(in: 0...1),
                       alpha: 1.0)
    }
}
