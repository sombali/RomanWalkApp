//
//  MainTabBarController.swift
//  RomanWalk
//
//  Created by Somogyi Balázs on 2020. 03. 20..
//  Copyright © 2020. Somogyi Balázs. All rights reserved.
//

import UIKit
import CoreData

class MainTabBarController: UITabBarController {
    
    let locationCoordinator = LocationCoordinator(navigationController: UINavigationController())
    let museumCoordinator = MuseumCoordinator(navigationController: UINavigationController())
    let mapCoordinator = MapCoordinator(navigationController: UINavigationController())
    let coinCoordinator = CoinCoordinator(navigationController: UINavigationController())
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let managedObjectContext = AppDelegate.managedContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkIfDownloadNeeded()
        
        self.tabBar.tintColor = .red
        
        locationCoordinator.start()
        mapCoordinator.start()
        coinCoordinator.start()
        museumCoordinator.start()
        viewControllers = [locationCoordinator.navigationController, mapCoordinator.navigationController, coinCoordinator.navigationController, museumCoordinator.navigationController]
    }
    
    func checkIfDownloadNeeded() {
        let defaults = UserDefaults.standard
        
        let downloadNeeded = defaults.object(forKey: "DownloadNeeded") as? Bool
        
        if let downloadNeeded = downloadNeeded {
            if downloadNeeded {
                let organisationId = defaults.object(forKey: "OrganisationID") as? String
                let projectId = defaults.object(forKey: "ProjectID") as? String
                
                if let organisationId = organisationId, let projectId = projectId {
                    let saver = Saver()
                    saver.deleteExistingProject()
                    saver.deleteImagesFromDocumentDirectory()
                    saver.saveProject(organisationId: organisationId, projectId: projectId)
                    
                    defaults.set(false, forKey: "DownloadNeeded")
                }
            }
        }
    }
}
