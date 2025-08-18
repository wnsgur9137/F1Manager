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
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 8)
        view.layer.shadowRadius = 16
        view.layer.shadowOpacity = 0.1
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "WEEKEND SCHEDULE"
        label.font = .f1(.bold, size: 18)
        label.textColor = .systemRed
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
    
    private func createEventView(
        title: String,
        date: String?,
        time: String?
    ) -> UIView {
        let eventView = UIView()
        eventView.backgroundColor = title == "Race" ? UIColor.systemRed.withAlphaComponent(0.1) : UIColor.systemGray6
        eventView.layer.cornerRadius = 16
        eventView.layer.borderWidth = title == "Race" ? 2 : 0
        eventView.layer.borderColor = title == "Race" ? UIColor.systemRed.cgColor : UIColor.clear.cgColor
        
        let titleLabel = UILabel()
        titleLabel.text = title.uppercased()
        titleLabel.font = .f1(.bold, size: 16)
        titleLabel.textColor = title == "Race" ? .systemRed : .label
        
        let dateTimeLabel = UILabel()
        let dateText = formatDate(date) ?? "TBA"
        let timeText = time?.prefix(5).description ?? "TBA"
        dateTimeLabel.text = "\(dateText) • \(timeText)"
        dateTimeLabel.font = .f1(.regular, size: 14)
        dateTimeLabel.textColor = .secondaryLabel
        
        // F1 스타일 시간 표시를 위한 별도 라벨
        let timeHighlightLabel = UILabel()
        timeHighlightLabel.text = timeText
        timeHighlightLabel.font = .f1(.bold, size: 16)
        timeHighlightLabel.textColor = title == "Race" ? .systemRed : .label
        
        eventView.addSubview(titleLabel)
        eventView.addSubview(timeHighlightLabel)
        eventView.addSubview(dateTimeLabel)
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(20)
        }
        
        timeHighlightLabel.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(20)
        }
        
        dateTimeLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview().inset(20)
        }
        
        eventView.snp.makeConstraints {
            $0.height.equalTo(80)
        }
        
        return eventView
    }
    
    private func formatDate(_ dateString: String?) -> String? {
        guard let dateString = dateString else { return nil }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US")
        
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
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(stackView)
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
