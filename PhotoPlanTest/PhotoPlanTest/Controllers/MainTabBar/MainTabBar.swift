//
//  MainTabBar.swift
//  PhotoPlanTest
//
//  Created by Дмитрий Осипенко on 20.10.21.
//

import UIKit

class MainTabBar: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let group = GroupViewController()
        let settings = SettingsViewController()
        let mood = MoodViewController()
        let location = LocationViewController()
        let account = AccountingViewController()
        
        viewControllers = [generateVC(rootVC: settings, image: "Settings"),
                           generateVC(rootVC: account, image: "account"),
                           generateVC(rootVC: group, image: "Group 169"),
                           generateVC(rootVC: mood, image: "moodboard"),
                             generateVC(rootVC: location, image: "Location")
        ]
                
        for tabBarItem in tabBar.items! {
            tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: 0, right: 0)
        }
        
    }
    
    
    
    private func generateVC(rootVC: UIViewController, image: String) -> UIViewController {
        let navVC = UINavigationController(rootViewController: rootVC)
        navVC.tabBarItem.image = UIImage(named: image)?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        return navVC
        
    }
}


