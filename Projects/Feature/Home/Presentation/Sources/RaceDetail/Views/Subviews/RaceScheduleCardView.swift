//
//  RaceScheduleCardView.swift
//  HomePresentation
//
//  Created by JunHyeok Lee on 8/12/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import UIKit
import SnapKit

import BasePresentation

final class RaceScheduleCardView: UIView {
    
    // MARK: - UI Components
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .cellBackground
        view.layer.cornerRadius = 16
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Schedule"
        label.font = .f1(.bold, size: 20)
        label.textColor = .label
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupLayoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    
    func configure(with race: RaceModel) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Race Date
        let raceEventView = createEventView(
            title: "Race",
            date: race.date,
            time: race.time
        )
        stackView.addArrangedSubview(raceEventView)
        
        // Qualifying
        if let qualifying = race.qualifying {
            let qualifyingView = createEventView(
                title: "Qualifying",
                date: qualifying.date,
                time: qualifying.time
            )
            stackView.addArrangedSubview(qualifyingView)
        }
        
        // Sprint (if exists)
        if let sprint = race.sprint {
            let sprintView = createEventView(
                title: "Sprint",
                date: sprint.date,
                time: sprint.time
            )
            stackView.addArrangedSubview(sprintView)
        }
        
        // Practice Sessions
        if let fp1 = race.firstPractice {
            let fp1View = createEventView(
                title: "Practice 1",
                date: fp1.date,
                time: fp1.time
            )
            stackView.addArrangedSubview(fp1View)
        }
        
        if let fp2 = race.secondPractice {
            let fp2View = createEventView(
                title: "Practice 2",
                date: fp2.date,
                time: fp2.time
            )
            stackView.addArrangedSubview(fp2View)
        }
        
        if let fp3 = race.thirdPractice {
            let fp3View = createEventView(
                title: "Practice 3",
                date: fp3.date,
                time: fp3.time
            )
            stackView.addArrangedSubview(fp3View)
        }
    }
    
    private func createEventView(title: String, date: String?, time: String?) -> UIView {
        let eventView = UIView()
        eventView.backgroundColor = .systemGray6
        eventView.layer.cornerRadius = 12
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .f1(.bold, size: 16)
        titleLabel.textColor = .label
        
        let dateTimeLabel = UILabel()
        let dateText = formatDate(date) ?? "TBA"
        let timeText = time?.prefix(5).description ?? "TBA"
        dateTimeLabel.text = "\(dateText) • \(timeText)"
        dateTimeLabel.font = .f1(.regular, size: 14)
        dateTimeLabel.textColor = .secondaryLabel
        
        eventView.addSubview(titleLabel)
        eventView.addSubview(dateTimeLabel)
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(16)
        }
        
        dateTimeLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.trailing.bottom.equalToSuperview().inset(16)
        }
        
        eventView.snp.makeConstraints {
            $0.height.equalTo(60)
        }
        
        return eventView
    }
    
    private func formatDate(_ dateString: String?) -> String? {
        guard let dateString = dateString else { return nil }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "MMM dd, yyyy"
            return dateFormatter.string(from: date)
        }
        
        return dateString
    }
}

// MARK: - Layout
extension RaceScheduleCardView {
    private func addSubviews() {
        addSubview(containerView)
        
        [
            titleLabel,
            stackView
        ].forEach {
            containerView.addSubview($0)
        }
    }
    
    private func setupLayoutConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(20)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(20)
        }
    }
}