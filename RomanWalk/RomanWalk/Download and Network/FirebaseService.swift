//
//  FirebaseService.swift
//  RomanWalk
//
//  Created by Somogyi Balázs on 2020. 03. 18..
//  Copyright © 2020. Somogyi Balázs. All rights reserved.
//

import Firebase
import SwiftEventBus

enum FirebaseCollections: String {
    case Organisation, Project, Code, Coins, Location, Games, Quiz
}

class FirebaseService {
    let db = Firestore.firestore()
    let organisationRef: CollectionReference
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let managedObjectContext = AppDelegate.managedContext
    
    init() {
        organisationRef = db.collection(FirebaseCollections.Organisation.rawValue)
    }
    
    //MARK: Get documents from firebase
    func getOrganisations(completion: @escaping ([Organisation]) -> (Void)) {
        organisationRef.getDocuments { (querySnapshot, error) in
            if let _ = error {
                SwiftEventBus.post(DownloadError.firebaseDownloadError.rawValue)
            } else {
                var organisations: [Organisation] = []
                for document in querySnapshot!.documents {
                    let organisation = Organisation(context: self.managedObjectContext)
                    organisation.create(document: document)
                    organisations.append(organisation)
                }
                completion(organisations)
            }
        }
    }
    
    func getProjects(for organisation: String, completion: @escaping ([Project]) -> (Void)) {
        let projectRef = organisationRef.document(organisation).collection(FirebaseCollections.Project.rawValue)
        projectRef.getDocuments { (querySnapshot, error) in
            if let _ = error {
                SwiftEventBus.post(DownloadError.firebaseDownloadError.rawValue)
            } else {
                var projects: [Project] = []
                for document in querySnapshot!.documents {
                    let project = Project(context: self.managedObjectContext)
                    project.create(document: document)
                    projects.append(project)
                }
                completion(projects)
            }
        }
    }
    
    //TODO
    func getSelectedProject(projectRef: DocumentReference, completion: @escaping (Project) -> (Void)) {
        projectRef.getDocument { (documentSnapshot, error) in
            if error != nil {
                SwiftEventBus.post(DownloadError.firebaseDownloadError.rawValue)
            } else {
                if let documentSnapshot = documentSnapshot {
                    let project = Project(context: self.managedObjectContext)
                    project.create(document: documentSnapshot)
                    completion(project)
                }
            }
        }
    }
    
    func getSelectedOrganisation(organisationId: String, completion: @escaping (Organisation) -> (Void)) {
        organisationRef.whereField("id", isEqualTo: organisationId).getDocuments { (querySnapshot, error) in
           if let _ = error {
                SwiftEventBus.post(DownloadError.firebaseDownloadError.rawValue)
           } else {
               for document in querySnapshot!.documents {
                    let organisation = Organisation(context: self.managedObjectContext)
                    organisation.create(document: document)
                    completion(organisation)
                }
           }
        }
    }
    
    func getAllProject(completion: @escaping ([Project]) -> (Void)) {
        getOrganisations { (organisations) -> (Void) in
            for organisation in organisations {
                if let id = organisation.id {
                    self.getProjects(for: id) { (projects) -> (Void) in
                        for project in projects {
                            organisation.addToProjects(project)
                            project.organisation = organisation
                        }
                        completion(projects)
                    }
                }
            }
        }
    }
    
    func getLocations(with reference: DocumentReference, completion: @escaping (Result<[Location], DownloadError>) -> (Void)) {
        let locationRef = reference.collection(FirebaseCollections.Location.rawValue)
        locationRef.getDocuments { (querySnapshot, error) in
            if let _ = error {
                completion(.failure(DownloadError.firebaseDownloadError))
                return
            } else {
                var locations = [Location]()
                for document in querySnapshot!.documents {
                    let location = Location(context: self.managedObjectContext)
                    location.create(document: document)
                    locations.append(location)
                }
                completion(.success(locations))
            }
        }
    }
    
    func getQuiz(with reference: DocumentReference, completion: @escaping (Result<[Task], DownloadError>) -> (Void)) {
        let quizRef = reference.collection(FirebaseCollections.Quiz.rawValue)
        quizRef.getDocuments { (querySnapshot, error) in
            if let _ = error {
                completion(.failure(DownloadError.firebaseDownloadError))
            } else {
                var tasks = [Task]()
                for document in querySnapshot!.documents {
                    let task = Task(context: self.managedObjectContext)
                    task.create(document)
                    tasks.append(task)
                }
                completion(.success(tasks))
            }
        }
    }
    
    func getCoins(with reference: DocumentReference, completion: @escaping (Result<[Coin], DownloadError>) -> (Void)) {
        let coinsRef = reference.collection(FirebaseCollections.Coins.rawValue)
        coinsRef.getDocuments { (querySnapshot, error) in
            if let _ = error {
                completion(.failure(DownloadError.firebaseDownloadError))
            } else {
                var coins = [Coin]()
                for document in querySnapshot!.documents {
                    let coin = Coin(context: self.managedObjectContext)
                    coin.create(document: document)
                    coins.append(coin)
                }
                completion(.success(coins))
            }
        }
    }
    
    //MARK: Post QR Code
    func post(percentage: Int, gameID: String, organisationID: String, projectID: String, completion: @escaping (Result<Void, Error>) -> (Void)) {
        let codeRef = organisationRef.document(organisationID).collection(FirebaseCollections.Project.rawValue)
            .document(projectID).collection(FirebaseCollections.Code.rawValue)
        
        codeRef.document(gameID).setData([
            "Percentage": percentage,
            "GameID": gameID
        ], merge: true) { err in
            if let err = err {
                completion(.failure(err))
            } else {
                completion(.success(()))
            }
        }
    }
    
    
}
