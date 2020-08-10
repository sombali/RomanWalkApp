//
//  LocationCoordinator.swift
//  RomanWalk
//
//  Created by Somogyi Balázs on 2020. 03. 20..
//  Copyright © 2020. Somogyi Balázs. All rights reserved.
//

import UIKit

class LocationCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = LocationViewController.instantiate()
        vc.coordinator = self
        vc.tabBarItem = UITabBarItem(title: "Helyszínek", image: UIImage(named: "colosseum"), tag: 0)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func show(_ location: Location) {
        let vc = LocationDetailViewController.instantiate()
        vc.coordinator = self
        vc.location = location
        navigationController.pushViewController(vc, animated: true)
    }
    
    func show(_ quiz: [Task], for locationName: String?, _ maxQuestionNumber: Int) {
        let vc = QuizViewController.instantiate()
        vc.tasks = quiz
        vc.locationName = locationName
        vc.maxQuestionNumber = maxQuestionNumber
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showReconstruction(for location: Location) {
        let vc = ReconstructionViewController.instantiate()
        vc.location = location
        navigationController.pushViewController(vc, animated: true)
    }
    
    func openProjectList(from vc: UIViewController) {
        weak var viewController = vc
        let sceneDelegate = viewController!.view.window!.windowScene!.delegate as? SceneDelegate
        let projectVC = ProjectViewController.instantiate()
        let navController = UINavigationController()
        sceneDelegate?.coordinator = ProjectCoordinator(navigationController: navController)
        projectVC.coordinator = sceneDelegate?.coordinator as? ProjectCoordinator
        sceneDelegate?.coordinator?.start()
        
        navigationController.pushViewController(projectVC, animated: true)
    }
    
    func openQRScanner(for location: Location) {
        let vc = ScannerViewController.instantiate()
        vc.navigationItem.title = "QR kód olvasó"
        vc.coordinator = self
        vc.location = location
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showAR(for location: Location) {
        let vc = ARViewController.instantiate()
        vc.location = location
        navigationController.pushViewController(vc, animated: true)
    }
}
