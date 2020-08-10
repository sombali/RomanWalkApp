//
//  Coordinator.swift
//  RomanWalk
//
//  Created by Somogyi Balázs on 2020. 05. 03..
//  Copyright © 2020. Somogyi Balázs. All rights reserved.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}
