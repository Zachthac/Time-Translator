//
//  EnterRunTimeViewController.swift
//  GermanTimeTravel
//
//  Created by Zachary Thacker on 1/2/21.
//

import UIKit

class RunTimeViewController: UIViewController {
    
    // MARK: - Outlets

    @IBOutlet private var scenarioTitleLabel: UILabel!
    @IBOutlet private var scenarioImage: UIImageView!
    @IBOutlet private var pickerView: UIPickerView!
    @IBOutlet private var roundView: UIView!
    @IBOutlet private var startButton: UIButton!
    @IBOutlet private var stackView: UIStackView!
    @IBOutlet private var suggestedRTLabel: UILabel!
    
    // MARK: - Properties
    
    weak var controller: ModelController?
    var scenario: Summary?
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        setUpView()
    }
    
    override func viewDidLayoutSubviews() {
        setUpSubViews()
    }
    
    // MARK: - Actions
    
    @IBAction func startScenario(_ sender: UIButton) {
        guard let scenario = scenario else { return }
        startButton.isEnabled = false
        controller?.startScenario(nameId: scenario.nameId, totalTime: runTime(), completion: { result in
            switch result {
            case true:
                DispatchQueue.main.async {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            case false:
                DispatchQueue.main.async {
                    self.startButton.isEnabled = true
                    if self.controller?.language == .english {
                        let alert = UIAlertController(title: "Error", message: "Something went wrong - please try again.", preferredStyle: .alert)
                        let button = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alert.addAction(button)
                        self.present(alert, animated: true)
                    } else {
                        let alert = UIAlertController(title: "Fehler", message: "Es ist etwas schief gegangen - Bitte versuche es erneut.", preferredStyle: .alert)
                        let button = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alert.addAction(button)
                        self.present(alert, animated: true)
                    }
                }
            }
        })
    }
    
    // MARK: - Private Functions
    
    private func setUpSubViews() {
        scenarioTitleLabel.layer.shadowOffset = CGSize(width: 1, height: 1)
        scenarioTitleLabel.layer.shadowOpacity = 1
        scenarioTitleLabel.layer.shadowRadius = 2.4
        scenarioTitleLabel.layer.shadowColor = UIColor.black.cgColor
        gradient.frame = roundView.bounds
        gradient2.frame = scenarioImage.bounds
        roundView.layer.addSublayer(gradient)
        scenarioImage.layer.addSublayer(gradient2)
        roundView.roundCorners(cornerRadius: 25)
        roundView.bringSubviewToFront(stackView)
        roundView.bringSubviewToFront(startButton)
    }
    
    private func setUpView() {
        startButton.isEnabled = true
        pickerView.setValue(UIColor.white, forKeyPath: "textColor")
        if let runtime = scenario?.runtime {
            setSuggestionOnPicker(runtime: runtime)
            if controller?.language == .english {
                suggestedRTLabel.text = scenario?.suggestionEn
            } else {
                suggestedRTLabel.text = scenario?.suggestionDe
            }
        } else {
            if controller?.language == .english {
                suggestedRTLabel.text = "No suggested run-time for this scenario."
            } else {
                suggestedRTLabel.text = "Keine empfohlene Laufzeit für dieses Szenario."
            }
        }
        
        guard let scenario = scenario else { return }
        if controller?.language == .english {
            scenarioTitleLabel.text = scenario.nameEn
        } else {
            scenarioTitleLabel.text = scenario.nameDe
        }
        controller?.loadImage(summary: scenario, scenario: nil, event: nil, completion: { image in
            DispatchQueue.main.async {
                self.scenarioImage.image = image
            }
        })
    }
    
    private func setSuggestionOnPicker(runtime: Double) {
        let days = Int(floor(runtime / 86400))
        var timeLeft = runtime - (Double(days) * 86400)
        let hours = Int(floor(timeLeft / 3600))
        timeLeft = timeLeft - (Double(hours) * 3600)
        let minutes = Int(floor(timeLeft / 60))
        timeLeft = timeLeft - (Double(minutes) * 60)
        let seconds = Int(floor(timeLeft))
        pickerView.selectRow(days, inComponent: 0, animated: false)
        pickerView.selectRow(hours, inComponent: 1, animated: false)
        pickerView.selectRow(minutes, inComponent: 2, animated: false)
        pickerView.selectRow(seconds, inComponent: 3, animated: false)
    }
    
    private func runTime() -> Double {
        let daySeconds = Double(pickerView.selectedRow(inComponent: 0)) * 60 * 60 * 24
        let hourSeconds = Double(pickerView.selectedRow(inComponent: 1)) * 60 * 60
        let minuteSeconds = Double(pickerView.selectedRow(inComponent: 2)) * 60
        return daySeconds + hourSeconds + minuteSeconds + Double(pickerView.selectedRow(inComponent: 3))
    }
    
    lazy var gradient: CAGradientLayer = {
        let gradient1 = CAGradientLayer()
        gradient1.type = .axial
        gradient1.colors = [
            UIColor.lightBlue.cgColor,
            UIColor.darkBlue.cgColor
        ]
        gradient1.locations = [0, 1]
        return gradient1
    }()
    
    lazy var gradient2: CAGradientLayer = {
        let gradient2 = CAGradientLayer()
        gradient2.type = .radial
        gradient2.colors = [
            UIColor.clear.cgColor,
            UIColor.black.cgColor
        ]
        gradient2.startPoint = CGPoint(x: 0.5, y: 0.5)
        let endY = 1 + view.frame.size.width / view.frame.size.height
        gradient2.endPoint = CGPoint(x: 1.25, y: endY)
            return gradient2
    }()
}

extension RunTimeViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return 11
        case 1:
            return 24
        case 2:
            return 60
        case 3:
            return 60
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return pickerView.frame.size.width/4 - 10
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return "\(row)"
        case 1:
            return "\(row)"
        case 2:
            return "\(row)"
        case 3:
            return "\(row)"
        default:
            return ""
        }
    }

}

extension UIView {
    func roundCorners(cornerRadius: Double) {
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.clipsToBounds = true
    }
}
