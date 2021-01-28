//
//  ScenarioTableViewCell.swift
//  GermanTimeTravel
//
//  Created by Zachary Thacker on 1/15/21.
//

import UIKit

protocol LabelDelegate: AnyObject {
    func didChangeLabelHeight()
}

class ScenarioTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var totalEventsLabel: UILabel!
    @IBOutlet weak var unitsLabel: UILabel!
    @IBOutlet weak var roundView: UIView!
    
    var scenario: Summary? {
        didSet {
            updateViews()
        }
    }
    var language: Language?
    weak var delegate: LabelDelegate?
    
    override func prepareForReuse() {
        titleLabel.text = ""
        descriptionLabel.text = ""
        totalEventsLabel.text = ""
        unitsLabel.text = ""
        language = nil
        scenario = nil
    }
    
    private func updateViews() {
        
        guard let scenario = scenario else { return }
        if language == .english {
            titleLabel.text = scenario.nameEn
            descriptionLabel.text = scenario.descriptionEn
            totalEventsLabel.text = "Events: \(scenario.totalEvents)"
            unitsLabel.text = "Major Events: \(scenario.majorEvents)"
        } else {
            titleLabel.text = scenario.nameDe
            descriptionLabel.text = scenario.descriptionDe
            totalEventsLabel.text = "Ereignisse: \(scenario.totalEvents)"
            unitsLabel.text = "Zentrale Ereignisse: \(scenario.majorEvents)"
        }
        self.roundView.roundCorners(cornerRadius: 25)
    }
    
    @IBAction func moreInfoTapped(_ sender: UIButton) {
        if descriptionLabel.numberOfLines == 3 {
            descriptionLabel.numberOfLines = 0
        } else {
            descriptionLabel.numberOfLines = 3
        }
        delegate?.didChangeLabelHeight()
    }
    
}
