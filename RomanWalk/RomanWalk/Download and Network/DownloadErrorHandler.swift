//
//  DownloadErrorHandler.swift
//  RomanWalk
//
//  Created by Somogyi Balázs on 2020. 04. 22..
//  Copyright © 2020. Somogyi Balázs. All rights reserved.
//

import UIKit

enum DownloadError: String, Error {
    case imageDownloadError
    case firebaseDownloadError
}

class DownloadErrorHandler {
    var errorPresented = false
    
    func showError(for viewController: UIViewController, completion: @escaping (Result<Void, DownloadError>) -> (Void)) {
        let saver = Saver()
        
        let alertController = UIAlertController(title: "Hiba", message: "Hiba történt a letöltés során", preferredStyle: .alert)
        let action = UIAlertAction(title: "Újrapróbálkozás", style: .destructive) { (action) in
            
            DispatchQueue.main.async {
                saver.deleteImagesFromDocumentDirectory()
                saver.deleteExistingProject()
            }
            
            let userDefaults = UserDefaults.standard
            let projectId = userDefaults.object(forKey: "ProjectID") as? String
            let organisationId = userDefaults.object(forKey: "OrganisationID") as? String
            
            if let projectId = projectId, let organisationId = organisationId {
                saver.saveProject(organisationId: organisationId, projectId: projectId)
                self.errorPresented = false
                completion(.success(()))
            } else {
                completion(.failure(.imageDownloadError))
            }
        }
        
        alertController.addAction(action)
        viewController.present(alertController, animated: true)
    }
    
    func showProjectLoadError(for viewController: UIViewController, completion: @escaping (Result<Void, DownloadError>) -> (Void)) {
        
        let projectId = UserDefaults.standard.object(forKey: "ProjectID") as? String ?? nil
        if projectId == nil {
            let alertController = UIAlertController(title: "Hiba történt a letöltés során", message: "Kérlek ellenőrizd az internetkapcsolatod!", preferredStyle: .alert)
            let action = UIAlertAction(title: "Újrapróbálkozás", style: .destructive) { (action) in
            }
            
            alertController.addAction(action)
            viewController.present(alertController, animated: true)
        }
    }
    
    func deleteImagesFromDocumentDirectory() {
        let fileManager = FileManager.default
        guard let documentURL = fileManager.urls(for: .documentDirectory,
                                                         in: .userDomainMask).first else { return }
        
        do {
            let filePaths = try fileManager.contentsOfDirectory(atPath: documentURL.path)
            for filePath in filePaths {
                try fileManager.removeItem(atPath: documentURL.path + "/" + filePath)
            }
        } catch {
            print("Could not clear temp folder: \(error)")
        }
    }
}
