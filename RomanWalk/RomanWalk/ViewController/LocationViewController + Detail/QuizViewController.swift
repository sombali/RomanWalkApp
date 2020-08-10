//
//  QuizViewController.swift
//  RomanWalk
//
//  Created by Somogyi Balázs on 2020. 04. 09..
//  Copyright © 2020. Somogyi Balázs. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController, Storyboarded {
    
    var tasks: [Task]?
    var maxQuestionNumber: Int?
    var quizView: QuizView!
    var quizHandler = QuizHandler()
    var locationName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
        if let tasks = tasks, let maxQuestionNumber = maxQuestionNumber {
            quizHandler.quizSet = tasks
            
            quizHandler.shuffleQuizSet()
            quizHandler.setMaxNumber(maxQuestionNumber)
        }
        
        quizView = QuizView(frame: .zero)
        quizView.delegate = self
        
        self.view.addSubview(quizView)
        quizView.autoPinEdgesToSuperviewEdges(with: .zero)
        
        updateUI()
    }
    
    @objc func updateUI() {
        quizView.questionLabel.text = quizHandler.getQuestionText()
        if let options = quizHandler.getOptions() {
            quizView.setup(options)
            quizView.progressBar.progress = quizHandler.getProgress()
        }
    }
}

extension QuizViewController: QuizViewDelegate {
    func quizView(_ view: UIView, didSelect answer: String, with sender: UIButton) {
        let rightAnswer = quizHandler.checkAnswer(userAnswer: answer)
        
        if rightAnswer {
            sender.backgroundColor = .green
        } else {
            sender.backgroundColor = .red
        }
        
        let rightAnswerCount = quizHandler.rightAnswer
        let numberOfQuestions = quizHandler.maxQuestionNumber
        
        quizHandler.nextQuestion { (lastQuestion) -> (Void) in
            if lastQuestion {
                if rightAnswerCount == numberOfQuestions {
                    let buttonTapped: ((UIButton) -> Void)? = { _ in
                        self.hideMessage()
                                               
                        if let locationName = self.locationName {
                            let locationDict: [String: String] = ["locationName": locationName]
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CoinEarned"), object: nil, userInfo: locationDict)
                        }
                       
                        let locationDetailVC = self.navigationController?.viewControllers.filter { $0 is LocationDetailViewController }.first!
                        if let vc = locationDetailVC {
                            self.navigationController?.popToViewController(vc, animated: true)
                        } else {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                    
                    self.showMessageWithOneButton(title: "Hurrá!", body: "Megszerezted az érmét", iconImage: nil, iconText: "🏅", buttonImage: nil, buttonTitle: "Tovább", with: buttonTapped, interactive: false, interactiveHide: false)
                    
                } else {
                    let buttonTapped: ((UIButton) -> Void)? = { _ in
                        self.hideMessage()
                        let locationDetailVC = self.navigationController?.viewControllers.filter { $0 is LocationDetailViewController }.first!
                        if let vc = locationDetailVC {
                            self.navigationController?.popToViewController(vc, animated: true)
                        } else {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                    
                    self.showMessageWithOneButton(title: "Próbáld újra!", body: "Az elért pontszámod: \(rightAnswerCount)/\(numberOfQuestions)", iconImage: nil, iconText: "❌", buttonImage: nil, buttonTitle: "Tovább", with: buttonTapped, interactive: false, interactiveHide: false)
                }
            } else {
                Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.updateUI), userInfo: nil, repeats: false)
            }
        }
    }
}
