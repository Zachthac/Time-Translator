//
//  EventTableViewCell.swift
//  GermanTimeTravel
//
//  Created by Zachary Thacker on 1/15/21.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var currentUnitLabel: UILabel!
    @IBOutlet weak var eventDetailsLabel: UILabel!
    @IBOutlet weak var roundView: UIView!
    @IBOutlet weak var cameraImageView: UIImageView!
    
    // MARK: - Properties
    
    var event: Event? {
        didSet {
            updateViews()
        }
    }
    var language: Language?
    var unit: Unit?
    
    // MARK: - Private Functions
    
    private func updateViews() {
        
        guard let event = event else { return }
        if event.image != nil {
            cameraImageView.tintColor = UIColor.darkYellow
        } else {
            cameraImageView.tintColor = UIColor.clear
        }
        
        if language == .english {
            eventDetailsLabel.text = event.textEn
        } else {
            eventDetailsLabel.text = event.textDe
        }
        if let time = event.startDate {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            if event.scenario?.unit == "datetime" {
                formatter.timeZone = TimeZone(abbreviation: "UTC")
                formatter.timeStyle = .medium
            }
            currentUnitLabel.text = formatter.string(from: time)
        } else {
            if unit == .imperial {
                if language == .english {
                    currentUnitLabel.text = String("\(Int(event.startDouble * 92.955807)) Million Miles")
                } else {
                    currentUnitLabel.text = String("\(Int(event.startDouble * 92.955807)) Millionen Meilen")
                }
            } else {
                if language == .english {
                    currentUnitLabel.text = String("\(Int(event.startDouble * 149.597871)) Million Kilometers")
                } else {
                    currentUnitLabel.text = String("\(Int(event.startDouble * 149.597871)) Millionen Kilometer")
                }
            }
        }
    }
    
}
