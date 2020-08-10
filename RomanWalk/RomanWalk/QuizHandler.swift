//
//  QuizHandler.swift
//  RomanWalk
//
//  Created by Somogyi Balázs on 2020. 04. 09..
//  Copyright © 2020. Somogyi Balázs. All rights reserved.
//

import Foundation

struct QuizHandler {
    
    var questionNumber = 0
    var rightAnswer = 0
    var maxQuestionNumber = 0
    
    var quizSet = [Task]()
    
    mutating func shuffleQuizSet() {
        quizSet.shuffle()
    }
    
    mutating func setMaxNumber(_ maxNumber: Int) {
        if quizSet.count > maxNumber {
            maxQuestionNumber = maxNumber
        } else {
            maxQuestionNumber = quizSet.count
        }
    }
    
    func getQuestionText() -> String? {
        return quizSet[questionNumber].question
    }
    
    func getOptions() -> [String]? {
        return quizSet[questionNumber].options?.shuffled()
    }
    
    func getRightAnswer() -> String? {
        return quizSet[questionNumber].answer
    }
    
    func getProgress() -> Float {
        return Float(questionNumber) / Float(maxQuestionNumber)
    }
    
    mutating func nextQuestion(completion: @escaping (Bool) -> (Void)) {
        var lastQuestion: Bool = false
        
        if questionNumber + 1 < maxQuestionNumber {
            questionNumber += 1
        } else {
            lastQuestion = true
        }
        completion(lastQuestion)
    }
    
    mutating func checkAnswer(userAnswer: String) -> Bool {
        if userAnswer == quizSet[questionNumber].answer {
            rightAnswer += 1
            return true
        } else {
            return false
        }
    }
}
