//
//  Task+CoreDataClass.swift
//  
//
//  Created by Somogyi Balázs on 2020. 03. 19..
//
//

import Foundation
import CoreData
import Firebase

public class Task: NSManagedObject {
    func create(_ document: QueryDocumentSnapshot) {
        guard let answer = document.get("Answer") as? String,
                let options = document.get("Options") as? NSArray,
                let question = document.get("Question") as? String
            else { return }
        
        self.answer = answer
        self.options = options.filter { $0 is String } as? [String]
        self.question = question
        self.id = document.documentID
    }
}
