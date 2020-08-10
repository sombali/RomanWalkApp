//
//  MapCoordinator.swift
//  RomanWalk
//
//  Created by Somogyi Balázs on 2020. 03. 24..
//  Copyright © 2020. Somogyi Balázs. All rights reserved.
//

import UIKit

class MapCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = MapViewController.instantiate()
        vc.tabBarItem = UITabBarItem(title: "Térkép", image: UIImage(named: "map"), tag: 2)
        navigationController.pushViewController(vc, animated: false)
    }
}
