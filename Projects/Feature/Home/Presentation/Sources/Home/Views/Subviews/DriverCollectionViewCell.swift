//
//  DriverCollectionViewCell.swift
//  HomePresentation
//
//  Created by JUNHYEOK LEE on 7/16/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import UIKit
import SnapKit

import BasePresentation

final class DriverCollectionViewCell: UICollectionViewCell {
    
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
    
    private let headshotImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = .systemGray5
        return imageView
    }()
    
    private let teamColorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 2
        return view
    }()
    
    private let driverNumberLabel: UILabel = {
        let label = UILabel()
        label.font = .f1(.bold, size: 16)
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = .black
        label.layer.cornerRadius = 12
        label.clipsToBounds = true
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    
    private let nameStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.alignment = .leading
        return stackView
    }()
    
    private let firstNameLabel: UILabel = {
        let label = UILabel()
        label.font = .f1(.regular, size: 14)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let lastNameLabel: UILabel = {
        let label = UILabel()
        label.font = .f1(.bold, size: 16)
        label.textColor = .label
        return label
    }()
    
    private let teamNameLabel: UILabel = {
        let label = UILabel()
        label.font = .f1(.regular, size: 12)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let countryFlagLabel: UILabel = {
        let label = UILabel()
        label.font = .f1(.regular, size: 20)
        return label
    }()
    
    private let positionBadge: UIView = {
        let view = UIView()
        view.backgroundColor = .systemRed
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let positionLabel: UILabel = {
        let label = UILabel()
        label.font = .f1(.bold, size: 14)
        label.textColor = .white
        label.textAlignment = .center
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
        headshotImageView.image = nil
        driverNumberLabel.text = nil
        firstNameLabel.text = nil
        lastNameLabel.text = nil
        teamNameLabel.text = nil
        countryFlagLabel.text = nil
        positionLabel.text = nil
        teamColorView.backgroundColor = .clear
        positionBadge.backgroundColor = .systemGray
        positionBadge.isHidden = true
    }
    
    // MARK: - Configuration
    
    func configure(with driver: DriverModel) {
        if let driverNumber = driver.driverNumber {
            driverNumberLabel.text = driverNumber
        }
        
        // 텍스트 설정 후 padding 추가
        updateDriverNumberLabelPadding()
        firstNameLabel.text = driver.givenName
        lastNameLabel.text = driver.familyName
        teamNameLabel.text = driver.teamName
        
        // 팀 컬러 설정
        if let teamColor = driver.teamColour,
           let teamColor = UIColor(hex: teamColor) {
            teamColorView.backgroundColor = teamColor
        }
        
        // 국가 코드를 플래그 이모지로 변환
        if let countryCode = driver.countryCode {
            countryFlagLabel.text = countryCode.flag
        }
        
        // Standing Position 표시
        if let standingPosition = driver.standingPosition {
            positionLabel.text = "\(standingPosition)"
            positionLabel.textColor = .white
            positionBadge.isHidden = false
            
            // 포지션에 따른 배지 색상
            switch standingPosition {
            case 1:
                positionBadge.backgroundColor = .systemYellow // Gold
            case 2:
                positionBadge.backgroundColor = .systemGray2 // Silver
            case 3:
                positionBadge.backgroundColor = .systemOrange // Bronze
            default:
                positionBadge.backgroundColor = .white // Default white
                positionLabel.textColor = .black
            }
        } else {
            positionBadge.isHidden = true
        }
        
        // 헤드샷 이미지 로딩 (나중에 Kingfisher 등으로 대체)
        if let headshotImageURL = driver.headshotImageURL {
            loadHeadshotImage(from: headshotImageURL)
        }
    }
    
    private func loadHeadshotImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data = data, let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                self?.headshotImageView.image = image
            }
        }.resume()
    }
    
    private func updateDriverNumberLabelPadding() {
        driverNumberLabel.setNeedsLayout()
        driverNumberLabel.layoutIfNeeded()
        
        // 텍스트 너비에 따라 패딩 추가
        let textSize = driverNumberLabel.intrinsicContentSize
        let paddingHorizontal: CGFloat = 8
        
        driverNumberLabel.snp.updateConstraints {
            $0.width.greaterThanOrEqualTo(max(24, textSize.width + paddingHorizontal))
        }
    }
}

// MARK: - Layout
extension DriverCollectionViewCell {
    private func addSubviews() {
        contentView.addSubview(containerView)
        
        [
            headshotImageView,
            teamColorView,
            driverNumberLabel,
            nameStackView,
            teamNameLabel,
            countryFlagLabel,
            positionBadge
        ].forEach {
            containerView.addSubview($0)
        }
        
        positionBadge.addSubview(positionLabel)
        
        [
            firstNameLabel,
            lastNameLabel
        ].forEach {
            nameStackView.addArrangedSubview($0)
        }
    }
    
    private func setupLayoutConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(4)
        }
        
        headshotImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(12)
            $0.height.equalTo(100)
        }
        
        teamColorView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(8)
            $0.width.equalTo(4)
            $0.height.equalTo(32)
        }
        
        driverNumberLabel.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(8)
            $0.height.equalTo(24)
            $0.width.greaterThanOrEqualTo(24)
        }
        
        countryFlagLabel.snp.makeConstraints {
            $0.top.equalTo(headshotImageView.snp.bottom).offset(8)
            $0.leading.equalToSuperview().inset(12)
        }
        
        nameStackView.snp.makeConstraints {
            $0.top.equalTo(headshotImageView.snp.bottom).offset(8)
            $0.leading.equalTo(countryFlagLabel.snp.trailing).offset(6)
            $0.trailing.equalToSuperview().inset(12)
        }
        
        teamNameLabel.snp.makeConstraints {
            $0.top.equalTo(nameStackView.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().inset(12)
        }
        
        positionBadge.snp.makeConstraints {
            $0.bottom.equalTo(headshotImageView.snp.bottom).inset(8)
            $0.trailing.equalToSuperview().inset(8)
            $0.width.height.equalTo(24)
        }
        
        positionLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
