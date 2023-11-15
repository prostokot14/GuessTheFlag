//
//  ViewController.swift
//  Project2
//
//  Created by Антон Кашников on 22.02.2023.
//

import UIKit

final class ViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet private var button1: UIButton!
    @IBOutlet private var button2: UIButton!
    @IBOutlet private var button3: UIButton!

    // MARK: - Private Properties
    private var countries = [String]()
    private var correctAnswer = 0
    private var score = 0
    private var highestScore = 0
    private var countOfAnswers = 0

    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Show Score", style: .done, target: self, action: #selector(showScore)
        )
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1

        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor

        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        highestScore = UserDefaults.standard.integer(forKey: "HighestScore")

        askQuestion(action: nil)
    }

    // MARK: - IBActions
    @IBAction private func buttonTouchedDown(_ sender: UIButton) {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 5) {
            sender.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }
    }
    
    @IBAction private func buttonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 5) {
            sender.transform = .identity
        }
        
        var title: String

        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
        } else {
            title = "Wrong! That’s the flag of \(countries[sender.tag].uppercased())"
            score -= 1
        }
        
        countOfAnswers += 1
        
        if countOfAnswers == 10 {
            if score > highestScore {
                highestScore = score
                UserDefaults.standard.set(highestScore, forKey: "HighestScore")
                showAlert(title: "Congratulations!", message: "Your new score \(score) beat the previous high score!", buttonTitle: "OK") { [weak self] _ in
                    guard let self else {
                        return
                    }
                    
                    self.score = 0
                    self.countOfAnswers = 0
                    self.askQuestion(action: nil)
                }
            } else {
                showAlert(title: "Congratulations!", message: "Your final score is \(score)", buttonTitle: "Continue") { [weak self] _ in
                    guard let self else {
                        return
                    }
                    
                    self.score = 0
                    self.countOfAnswers = 0
                    self.askQuestion(action: nil)
                }
            }
        } else {
            showAlert(title: title, message: "Your score is \(score).", buttonTitle: "Continue", action: askQuestion)
        }
    }

    // MARK: - Private Methods
    private func askQuestion(action: UIAlertAction?) {
        countries.shuffle()
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        correctAnswer = Int.random(in: 0...2)
        title = countries[correctAnswer].uppercased() + " Score: \(score)"
    }

    private func showAlert(
        title: String, message: String?, buttonTitle: String, action: ((UIAlertAction) -> Void)?
    ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: action))
        present(alertController, animated: true)
    }

    @objc
    private func showScore() {
        showAlert(title: "Your score is \(score)", message: nil, buttonTitle: "OK", action: nil)
    }
}
