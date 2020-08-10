//
//  MuseumCoordinator.swift
//  RomanWalk
//
//  Created by Somogyi Balázs on 2020. 03. 20..
//  Copyright © 2020. Somogyi Balázs. All rights reserved.
//

import UIKit

class MuseumCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = MuseumViewController.instantiate()
        vc.coordinator = self
        vc.tabBarItem = UITabBarItem(title: "Múzeum", image: UIImage(named: "museum"), tag: 4)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func openWeb(url: URL) {
        let vc = WebViewController()
        vc.url = url
        navigationController.pushViewController(vc, animated: true)
    }
}
