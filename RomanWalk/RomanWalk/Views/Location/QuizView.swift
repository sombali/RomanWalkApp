//
//  QuizView.swift
//  RomanWalk
//
//  Created by Somogyi Balázs on 2020. 04. 09..
//  Copyright © 2020. Somogyi Balázs. All rights reserved.
//

import UIKit
import PureLayout

protocol QuizViewDelegate: UIViewController {
    func quizView(_ view: UIView, didSelect answer: String, with button: UIButton)
}

class QuizView: UIView {
    
    let stackView = UIStackView()
    let questionLabel = UILabel()
    let progressBar = UIProgressView()
    var optionButtons = [UIButton]()
    
    weak var delegate: QuizViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure() {
        self.layer.cornerRadius = 30
        self.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.spacing = 5
        
        questionLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        questionLabel.adjustsFontForContentSizeCategory = true
        questionLabel.textColor = .black
        questionLabel.numberOfLines = 0

        self.addSubview(stackView)
        self.addSubview(progressBar)
        stackView.addArrangedSubview(questionLabel)
        
        stackView.autoPinEdgesToSuperviewSafeArea(with: .init(top: 5, left: 10, bottom: 0, right: 10), excludingEdge: .bottom)
        stackView.autoPinEdge(.bottom, to: .top, of: progressBar, withOffset: -20)
        
        progressBar.autoPinEdge(toSuperviewSafeArea: .bottom)
        progressBar.autoPinEdge(toSuperviewEdge: .leading)
        progressBar.autoPinEdge(toSuperviewEdge: .trailing)
        progressBar.autoSetDimension(.height, toSize: 5)
    }
    
    func setup(_ options : [String]) {
        clearButtons()
        
        for option in options {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            
            button.setTitle(option, for: .normal)
            button.titleLabel?.lineBreakMode = .byWordWrapping
            button.setTitleColor(.black, for: .normal)
            button.setBackgroundImage(UIImage(named: "Rectangle"), for: .normal)
            button.backgroundColor = .clear
            button.layer.cornerRadius = 20
            button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            
            NSLayoutConstraint.activate([
                button.heightAnchor.constraint(lessThanOrEqualToConstant: 80)
            ])

            self.optionButtons.append(button)
            stackView.addArrangedSubview(button)
        }
    }
    
    func clearButtons() {
        while !optionButtons.isEmpty {
            for (i, button) in optionButtons.enumerated().reversed() {
                stackView.removeArrangedSubview(button)
                button.removeFromSuperview()
                optionButtons.remove(at: i)
            }
        }
    }
    
    @objc func buttonAction(sender: UIButton!) {
        if let answer = sender.titleLabel?.text {
            delegate?.quizView(self, didSelect: answer, with: sender)
        }
    }
}
