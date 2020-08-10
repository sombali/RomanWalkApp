//
//  ProjectDataSource.swift
//  RomanWalk
//
//  Created by Somogyi Balázs on 2020. 04. 03..
//  Copyright © 2020. Somogyi Balázs. All rights reserved.
//

import Foundation

protocol ProjectDataSourceDelegate: class {
    func dataSource(_ dataSource: ProjectDataSource, didFinishFetching projects: [Project])
}

class ProjectDataSource {
    weak var delegate: ProjectDataSourceDelegate?
    
    var projects: [Project] = []
    
    init() {
        let firebaseService = FirebaseService()
        
        firebaseService.getAllProject { (projects) -> (Void) in
            self.projects = projects
            self.delegate?.dataSource(self, didFinishFetching: projects)
        }
    }
}
