//
//  RaceListTableViewCell.swift
//  HomePresentation
//
//  Created by JunHyeok Lee on 8/12/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import UIKit
import SnapKit

import BasePresentation

final class RaceListTableViewCell: UITableViewCell {
    
    // MARK: - UI Components
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 12
        view.layer.shadowOpacity = 0.08
        return view
    }()
    
    private let gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.systemRed.withAlphaComponent(0.1).cgColor,
            UIColor.clear.cgColor
        ]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        gradient.cornerRadius = 20
        return gradient
    }()
    
    private let roundBadge: UIView = {
        let view = UIView()
        view.backgroundColor = .systemRed
        view.layer.cornerRadius = 16
        return view
    }()
    
    private let roundLabel: UILabel = {
        let label = UILabel()
        label.font = .f1(.bold, size: 14)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let statusIndicator: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 4
        view.backgroundColor = .systemGray4
        return view
    }()
    
    private let raceNameLabel: UILabel = {
        let label = UILabel()
        label.font = .f1(.bold, size: 20)
        label.textColor = .label
        label.numberOfLines = 2
        return label
    }()
    
    private let circuitNameLabel: UILabel = {
        let label = UILabel()
        label.font = .f1(.regular, size: 16)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        return label
    }()
    
    private let locationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        return stackView
    }()
    
    private let countryFlagLabel: UILabel = {
        let label = UILabel()
        label.font = .f1(.regular, size: 20)
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = .f1(.regular, size: 14)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let dateTimeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .trailing
        return stackView
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .f1(.bold, size: 16)
        label.textColor = .label
        label.textAlignment = .right
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .f1(.regular, size: 14)
        label.textColor = .systemRed
        label.textAlignment = .right
        return label
    }()
    
    private let chevronImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        imageView.tintColor = .systemGray3
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        addSubviews()
        setupLayoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = containerView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        roundLabel.text = nil
        raceNameLabel.text = nil
        circuitNameLabel.text = nil
        countryFlagLabel.text = nil
        locationLabel.text = nil
        dateLabel.text = nil
        timeLabel.text = nil
        statusIndicator.backgroundColor = .systemGray4
    }
    
    // MARK: - Setup
    
    private func setupCell() {
        backgroundColor = .clear
        selectionStyle = .none
        containerView.layer.insertSublayer(gradientLayer, at: 0)
        
        // Content priority 설정 - dateTimeStackView가 우선순위를 가지도록
        raceNameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        circuitNameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        dateLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        timeLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        // Hugging priority 설정
        dateLabel.setContentHuggingPriority(.required, for: .horizontal)
        timeLabel.setContentHuggingPriority(.required, for: .horizontal)
        raceNameLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        circuitNameLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
    
    // MARK: - Configuration
    
    func configure(with race: RaceModel) {
        roundLabel.text = "R\(race.round)"
        raceNameLabel.text = race.raceName
        circuitNameLabel.text = race.circuit.circuitName
        
        // Location info
        if let location = race.circuit.location {
            countryFlagLabel.text = location.country.flag
            locationLabel.text = "\(location.locality), \(location.country)"
        }
        
        // Date and time
        dateLabel.text = formatDate(race.date)
        timeLabel.text = race.time?.prefix(5).description ?? "TBA"
        
        // Race status based on current date
        updateRaceStatus(for: race.date)
    }
    
    private func formatDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US")
        
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "MMM dd"
            return dateFormatter.string(from: date).uppercased()
        }
        
        return dateString.uppercased()
    }
    
    private func updateRaceStatus(for dateString: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let raceDate = dateFormatter.date(from: dateString) else {
            statusIndicator.backgroundColor = .systemGray4
            return
        }
        
        let currentDate = Date()
        let comparison = Calendar.current.compare(raceDate, to: currentDate, toGranularity: .day)
        
        switch comparison {
        case .orderedAscending:
            // Past race
            statusIndicator.backgroundColor = .systemGray4
            timeLabel.textColor = .secondaryLabel
        case .orderedSame:
            // Today's race
            statusIndicator.backgroundColor = .systemRed
            timeLabel.textColor = .systemRed
        case .orderedDescending:
            // Future race
            statusIndicator.backgroundColor = .systemGreen
            timeLabel.textColor = .systemRed
        }
    }
}

// MARK: - Layout
extension RaceListTableViewCell {
    private func addSubviews() {
        contentView.addSubview(containerView)
        
        containerView.addSubview(roundBadge)
        roundBadge.addSubview(roundLabel)
        containerView.addSubview(statusIndicator)
        containerView.addSubview(raceNameLabel)
        containerView.addSubview(circuitNameLabel)
        containerView.addSubview(locationStackView)
        containerView.addSubview(dateTimeStackView)
        containerView.addSubview(chevronImageView)
        
        locationStackView.addArrangedSubview(countryFlagLabel)
        locationStackView.addArrangedSubview(locationLabel)
        
        dateTimeStackView.addArrangedSubview(dateLabel)
        dateTimeStackView.addArrangedSubview(timeLabel)
    }
    
    private func setupLayoutConstraints() {
        containerView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        roundBadge.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(20)
            $0.width.equalTo(40)
            $0.height.equalTo(32)
        }
        
        roundLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        statusIndicator.snp.makeConstraints {
            $0.leading.equalTo(roundBadge.snp.trailing).offset(12)
            $0.centerY.equalTo(roundBadge)
            $0.width.height.equalTo(8)
        }
        
        raceNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalTo(statusIndicator.snp.trailing).offset(12)
            $0.trailing.lessThanOrEqualTo(dateTimeStackView.snp.leading).offset(-16)
        }
        
        circuitNameLabel.snp.makeConstraints {
            $0.top.equalTo(raceNameLabel.snp.bottom).offset(4)
            $0.leading.equalTo(raceNameLabel)
            $0.trailing.lessThanOrEqualTo(dateTimeStackView.snp.leading).offset(-16)
        }
        
        locationStackView.snp.makeConstraints {
            $0.top.equalTo(circuitNameLabel.snp.bottom).offset(12)
            $0.leading.equalTo(raceNameLabel)
            $0.bottom.equalToSuperview().inset(20)
        }
        
        dateTimeStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(chevronImageView.snp.leading).offset(-12)
            $0.width.greaterThanOrEqualTo(80)
        }
        
        chevronImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
            $0.width.height.equalTo(16)
        }
    }
}
