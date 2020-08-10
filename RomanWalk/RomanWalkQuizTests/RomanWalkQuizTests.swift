//
//  RomanWalkQuizTests.swift
//  RomanWalkQuizTests
//
//  Created by Somogyi Balázs on 2020. 05. 06..
//  Copyright © 2020. Somogyi Balázs. All rights reserved.
//

import XCTest
import CoreData
@testable import RomanWalk

class RomanWalkQuizTests: XCTestCase {
    var sut: QuizHandler!
    var managedObjectContext: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        sut = QuizHandler()
        managedObjectContext = setUpInMemoryManagedObjectContext()
        
        let task1 = Task(context: managedObjectContext)
        task1.question = "Question number 1?"
        task1.answer = "This is the answer for question number 1"
        task1.options = ["This is the answer for question number 1", "This is not the answer", "Another wrong answer", "And another one"]
        
        let task2 = Task(context: managedObjectContext)
        task2.question = "Question number 2?"
        task2.answer = "This is the answer for question number 2"
        task2.options = ["This is the answer for question number 2", "This is not the answer", "Another wrong answer", "And another one"]
        
        sut.quizSet = [task1, task2]
        sut.rightAnswer = 0
        sut.questionNumber = 0
        sut.maxQuestionNumber = 2
    }
    
    func setUpInMemoryManagedObjectContext() -> NSManagedObjectContext {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!

        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)

        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        } catch {
            print("Adding in-memory persistent store failed")
        }

        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator

        return managedObjectContext
    }
    
    func testOneRightAnswer() {
        //given
        let userAnswer = "This is the answer for question number 1"
        
        //when
        sut.checkAnswer(userAnswer: userAnswer)
        
        //then
        XCTAssertEqual(sut.rightAnswer, 1)
    }
    
    func testTwoRightAnswer() {

        for i in 0..<sut.maxQuestionNumber {
            let userAnswer = "This is the answer for question number \(i+1)"
            sut.checkAnswer(userAnswer: userAnswer)
            sut.nextQuestion { (_) -> (Void) in
                
            }
        }
        XCTAssertEqual(sut.rightAnswer, 2)
    }
    
    func testLastQuestion() {
        var testLastQuestion = false
        
        for _ in 0..<sut.maxQuestionNumber {
            let userAnswer = "Random answer"
            sut.checkAnswer(userAnswer: userAnswer)
            sut.nextQuestion { (lastQuestion) -> (Void) in
                testLastQuestion = lastQuestion
            }
        }
        XCTAssertEqual(testLastQuestion, true)
    }
    
    func testNotLastQuestion() {
        var testLastQuestion = false
        let userAnswer = "This is the answer for question number 1"
        sut.checkAnswer(userAnswer: userAnswer)
        sut.nextQuestion { (lastQuestion) -> (Void) in
            testLastQuestion = lastQuestion
        }
        
        XCTAssertEqual(testLastQuestion, false)
    }
    
    func testWrongAnswer() {
        let userAnswer = "This is not the answer"
        
        sut.checkAnswer(userAnswer: userAnswer)
        
        XCTAssertEqual(sut.rightAnswer, 0)
    }

    override func tearDown() {
        sut = nil
        managedObjectContext = nil
        super.tearDown()
    }
}
