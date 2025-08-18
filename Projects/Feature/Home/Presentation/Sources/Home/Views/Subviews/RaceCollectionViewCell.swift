//
//  RaceCollectionViewCell.swift
//  HomePresentation
//
//  Created by JunHyeok Lee on 8/12/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import UIKit
import SnapKit

import BasePresentation

final class RaceCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .cellBackground
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.1
        return view
    }()
    
    private let roundBadge: UIView = {
        let view = UIView()
        view.backgroundColor = .systemRed
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let roundLabel: UILabel = {
        let label = UILabel()
        label.font = .f1(.bold, size: 12)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let raceNameLabel: UILabel = {
        let label = UILabel()
        label.font = .f1(.bold, size: 16)
        label.textColor = .label
        label.numberOfLines = 2
        return label
    }()
    
    private let circuitNameLabel: UILabel = {
        let label = UILabel()
        label.font = .f1(.regular, size: 14)
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        return label
    }()
    
    private let locationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .center
        return stackView
    }()
    
    private let countryFlagLabel: UILabel = {
        let label = UILabel()
        label.font = .f1(.regular, size: 16)
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = .f1(.regular, size: 12)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let dateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.alignment = .leading
        return stackView
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .f1(.bold, size: 14)
        label.textColor = .label
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .f1(.regular, size: 12)
        label.textColor = .secondaryLabel
        return label
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        roundLabel.text = nil
        raceNameLabel.text = nil
        circuitNameLabel.text = nil
        countryFlagLabel.text = nil
        locationLabel.text = nil
        dateLabel.text = nil
        timeLabel.text = nil
    }
    
    // MARK: - Configuration
    
    func configure(with race: RaceModel) {
        roundLabel.text = "R\(race.round)"
        raceNameLabel.text = race.raceName
        circuitNameLabel.text = race.circuit.circuitName
        
        // 위치 정보 설정
        if let location = race.circuit.location {
            countryFlagLabel.text = location.country.flag
            locationLabel.text = "\(location.locality), \(location.country)"
        }
        
        // 날짜 정보 설정
        dateLabel.text = formatDate(race.date)
        timeLabel.text = race.time?.prefix(5).description ?? "TBA"
    }
    
    private func formatDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US")
        
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "MMM dd"
            return dateFormatter.string(from: date).uppercased()
        }
        
        return dateString
    }
}

// MARK: - Layout
extension RaceCollectionViewCell {
    private func addSubviews() {
        contentView.addSubview(containerView)
        
        containerView.addSubview(roundBadge)
        containerView.addSubview(raceNameLabel)
        containerView.addSubview(circuitNameLabel)
        containerView.addSubview(locationStackView)
        containerView.addSubview(dateStackView)
        
        roundBadge.addSubview(roundLabel)
        
        locationStackView.addArrangedSubview(countryFlagLabel)
        locationStackView.addArrangedSubview(locationLabel)
        
        dateStackView.addArrangedSubview(dateLabel)
        dateStackView.addArrangedSubview(timeLabel)
    }
    
    private func setupLayoutConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(4)
        }
        
        roundBadge.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(12)
            $0.width.height.equalTo(24)
        }
        
        roundLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        raceNameLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(12)
            $0.trailing.equalTo(roundBadge.snp.leading).offset(-8)
        }
        
        circuitNameLabel.snp.makeConstraints {
            $0.top.equalTo(raceNameLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(12)
        }
        
        locationStackView.snp.makeConstraints {
            $0.top.equalTo(circuitNameLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().inset(12)
            $0.trailing.lessThanOrEqualToSuperview().inset(12)
        }
        
        dateStackView.snp.makeConstraints {
            $0.top.equalTo(locationStackView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().inset(12)
        }
    }
}