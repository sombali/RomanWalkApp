//
//  Saver.swift
//  RomanWalk
//
//  Created by Somogyi Balázs on 2020. 04. 08..
//  Copyright © 2020. Somogyi Balázs. All rights reserved.
//

import Foundation
import Firebase
import CoreData
import CoreFoundation
import SwiftEventBus

class Saver {
    
    var firebase: FirebaseService
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let managedObjectContext = AppDelegate.managedContext
    private let fileDownloader: FileDownloader
    
    var errorThrown = false
    let defaults = UserDefaults.standard
    
    init() {
        self.firebase = FirebaseService()
        self.fileDownloader = FileDownloader()
    }
    
    //MARK: Save a project
    func saveProject(organisationId: String, projectId: String) {
        deleteExistingProject()
        
        let projectRef = self.firebase.organisationRef.document(organisationId)
         .collection(FirebaseCollections.Project.rawValue)
                 .document(projectId)
        
        firebase.getSelectedProject(projectRef: projectRef) { (project) -> (Void) in
            self.saveCoin(for: project, with: projectRef)
            self.saveLocation(for: project, with: projectRef)
            self.saveOrganisation(organisationId, for: project)
        }
    }
    
    func saveOrganisationImage(for organisation: Organisation?) {
        if let organisation = organisation {
            fileDownloader.save(url: organisation.image, name: organisation.name) { (result) -> (Void) in
                switch result {
                case .success(let fileName):
                    organisation.fileName = fileName
                case .failure(let downloadError):
                    self.postError(downloadError)
                    return
                }
            }
        }
    }
    
    fileprivate func saveImage(_ location: Location) {
        fileDownloader.save(url: location.image, name: location.name) { (result) -> (Void) in
            switch result {
            case .success(let fileName):
                location.fileName = fileName
                self.appDelegate.saveContext()
            case .failure(let downloadError):
                self.postError(downloadError)
                return
            }
        }
    }
    
    fileprivate func saveLocationReconstructionImage(_ location: Location) {
        let saveReconstructionImageAs = "\(String(describing: location.name)) Reconstruction"
        fileDownloader.save(url: location.reconstructionImage, name:  saveReconstructionImageAs) { (result) -> (Void) in
            switch result {
            case .success(let fileName):
                location.reconstructionImageName = fileName
                self.appDelegate.saveContext()
            case .failure(let downloadError):
                self.postError(downloadError)
                return
            }
        }
    }
    
    fileprivate func saveLocationReconstructionBackgroundImage(_ location: Location) {
        let saveReconstructionBackgroundImageAs = "\(String(describing: location.name)) Reconstruction Background"
        fileDownloader.save(url: location.reconstructionBackgroundImage, name: saveReconstructionBackgroundImageAs) { (result) -> (Void) in
            switch result {
            case .success(let fileName):
                location.reconstructionBackgroundImageName = fileName
                self.appDelegate.saveContext()
            case .failure(let downloadError):
                self.postError(downloadError)
                return
            }
        }
    }
    
    fileprivate func saveLocationImages(_ location: Location) {
        saveImage(location)
        saveLocationReconstructionImage(location)
        saveLocationReconstructionBackgroundImage(location)
    }
    
    func saveLocation(for project: Project, with projectRef: DocumentReference) {
        if !errorThrown {
            firebase.getLocations(with: projectRef) { (result) -> (Void) in
                switch result {
                case .success(let locations):
                    for location in locations {
                        if self.errorThrown {
                            return
                        }
                        
                        project.addToLocations(location)
                        location.project = project
                        let locationRef = projectRef.collection(FirebaseCollections.Location.rawValue).document(location.id!)
                        self.saveQuiz(for: location, with: locationRef)
                        
                        self.saveLocationImages(location)
                    }
                    self.appDelegate.saveContext()
                case .failure(let downloadError):
                    self.postError(downloadError)
                    return
                }
            }
        }
    }
    
    func saveQuiz(for location: Location, with locationRef: DocumentReference) {
        if !errorThrown {
            firebase.getQuiz(with: locationRef) { (result) -> (Void) in
                switch result {
                case .success(let tasks):
                    for task in tasks {
                        task.location = location
                        location.addToQuiz(task)
                    }
                    self.appDelegate.saveContext()
                case .failure(let downloadError):
                    self.postError(downloadError)
                    return
                }
            }
        }
    }
    
    fileprivate func saveImage(_ coin: Coin) {
        self.fileDownloader.save(url: coin.image, name: coin.name) { (result) -> (Void) in
            switch result {
            case .success(let fileName):
                coin.fileName = fileName
                self.appDelegate.saveContext()
            case .failure(let downloadError):
                self.postError(downloadError)
                return
            }
        }
    }
    
    fileprivate func postError(_ downloadError: (DownloadError)) {
        if !self.errorThrown {
            self.errorThrown = true
            SwiftEventBus.post(downloadError.rawValue)
        }
    }
    
    func saveCoin(for project: Project, with projectRef: DocumentReference) {
        firebase.getCoins(with: projectRef) { (result) -> (Void) in
            switch result {
            case .success(let coins):
                for coin in coins {
                    if self.errorThrown {
                        return
                    }
                    
                    project.addToCoins(coin)
                    coin.project = project
                    
                    self.saveImage(coin)
                }
                
                self.appDelegate.saveContext()
            case .failure(let downloadError):
                self.postError(downloadError)
                return
            }
            
        }
    }
    
    func saveOrganisation(_ organisation: String, for project: Project) {
        firebase.getSelectedOrganisation(organisationId: organisation) { (organisation) -> (Void) in
            organisation.addToProjects(project)
            project.organisation = organisation
            self.appDelegate.saveContext()
            
            self.saveOrganisationImage(for: organisation)
        }
    }
    
    //MARK: Delete project from Core data
    func deleteExistingProject() {
        let persistentStoreCoordinator = appDelegate.persistentContainer.persistentStoreCoordinator

        do {
            for entity in persistentStoreCoordinator.managedObjectModel.entitiesByName {
                let fethRequest: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity.key)
                let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fethRequest)
                try managedObjectContext.executeAndMergeChanges(using: batchDeleteRequest)
            }
            
            appDelegate.saveContext()
        } catch let error as NSError {
            print("Error while deleting Project objects: \(error.localizedDescription)")
        }
    }
    
    //MARK: Delete images from directory
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
