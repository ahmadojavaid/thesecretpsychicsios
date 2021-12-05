//
//  ViewController.swift
//  Psychic
//
//  Created by APPLE on 12/27/18.
//  Copyright © 2018 Jobesk. All rights reserved.
//

import UIKit
import FirebaseInstanceID
class ViewController: UIViewController, UIPageViewControllerDataSource  {
 
    
    var pageViewController = UIPageViewController()
    var window: UIWindow?
    
    @IBOutlet weak var pageCount: UIPageControl!
    lazy var viewContollers : [UIViewController] = {
        
        
        let sb = UIStoryboard(name: "Walkthrogh", bundle: nil)
        let vc1 = sb.instantiateViewController(withIdentifier: "first") as! FirstWalkScreen
        let vc2 = sb.instantiateViewController(withIdentifier: "second")
        let vc3 = sb.instantiateViewController(withIdentifier: "third")
        let vc4 = sb.instantiateViewController(withIdentifier: "fourth")
        return [vc1,vc2,vc3,vc4]
        
    } ()
    override func viewDidLoad() {
        
        
        
        let defaults = UserDefaults.standard
        let logged = defaults.string(forKey: "logged")
        
        
        let walk = defaults.string(forKey: "walk")
        
        if walk == nil
        {
           
            
            
        }
        else
        {
            
            
            
            
            if logged == nil
            {
                let storyboard = UIStoryboard(name: "LoginScreens", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "AfterWalk") as! UINavigationController
                self.window = UIWindow(frame: UIScreen.main.bounds)
                self.window?.rootViewController = vc
                self.window?.makeKeyAndVisible()
            }
            else
            {
                let log = defaults.string(forKey: "logged")!
                if log == "advisorLogin"
                {
                    let storyboard = UIStoryboard(name: "AdvisorScreens", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "AdvisorHome") as! SWRevealViewController
                    self.window = UIWindow(frame: UIScreen.main.bounds)
                    self.window?.rootViewController = vc
                    self.window?.makeKeyAndVisible()
                }
                else if log == "clientLogin"
                {
                    let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "ClientScreens", bundle: nil)
                    let initialViewControlleripad : UIViewController = mainStoryboardIpad.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                    self.window = UIWindow(frame: UIScreen.main.bounds)
                    self.window?.rootViewController = initialViewControlleripad
                    self.window?.makeKeyAndVisible()
                }
                
                
            }
            
            
            
            
            
            
        }
        
        
        

        
        
        super.viewDidLoad()

        
        
        
        
        
        
        
        
        
        pageCount.numberOfPages = viewContollers.count
        
        
        self.pageViewController = self.storyboard?.instantiateViewController(withIdentifier: "MyPageViewController") as! UIPageViewController
        
        self.pageViewController.dataSource = self
        
        
        
        if let firtVC = viewContollers.first{
            pageViewController.setViewControllers([firtVC], direction: UIPageViewController.NavigationDirection.forward, animated: true, completion: nil)
        }

        self.view.addSubview(pageViewController.view)
    }

    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        
        guard let vcIndex = viewContollers.index(of: viewController) else { return nil }
        pageCount.currentPage = vcIndex
        let previeusIndex = vcIndex - 1
        guard previeusIndex >= 0 else {return nil}
        guard viewContollers.count > previeusIndex else {return nil}
        return viewContollers[previeusIndex]
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = viewContollers.index(of: viewController) else { return nil }
        pageCount.currentPage = vcIndex
        let nextIndex = vcIndex + 1
        guard  viewContollers.count != nextIndex else {return nil}
        guard viewContollers.count > nextIndex else {return nil}
        
        if nextIndex > viewContollers.count
        {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc22 = sb.instantiateViewController(withIdentifier: "mmmm")
            self.view.addSubview(vc22.view)
            
        }
        
        return viewContollers[nextIndex]
    }
    

}

