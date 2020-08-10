//
//  ProjectCoordinator.swift
//  RomanWalk
//
//  Created by Somogyi Balázs on 2020. 04. 03..
//  Copyright © 2020. Somogyi Balázs. All rights reserved.
//

import UIKit

class ProjectCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = ProjectViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func openProject(with oldViewController: UIViewController, organisationId: String, projectId: String) {
        let vc = MainTabBarController()
        
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        sceneDelegate?.window?.rootViewController = vc
    }
}
