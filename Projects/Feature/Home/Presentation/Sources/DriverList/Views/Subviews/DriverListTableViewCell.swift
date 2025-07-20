//
//  DriverListTableViewCell.swift
//  HomePresentation
//
//  Created by JUNHYEOK LEE on 7/17/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

import BasePresentation

final class DriverListTableViewCell: UITableViewCell {
    
    // MARK: - UI Components
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .cellBackground
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.1
        return view
    }()
    
    private let headshotImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 25
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
        label.layer.cornerRadius = 10
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
    
    private let fullNameLabel: UILabel = {
        let label = UILabel()
        label.font = .f1(.bold, size: 18)
        label.textColor = .label
        return label
    }()
    
    private let teamNameLabel: UILabel = {
        let label = UILabel()
        label.font = .f1(.regular, size: 14)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let standingInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        return stackView
    }()
    
    private let positionBadge: UIView = {
        let view = UIView()
        view.backgroundColor = .systemRed
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let positionLabel: UILabel = {
        let label = UILabel()
        label.font = .f1(.bold, size: 12)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let pointsLabel: UILabel = {
        let label = UILabel()
        label.font = .f1(.bold, size: 14)
        label.textColor = .label
        return label
    }()
    
    private let pointsUnitLabel: UILabel = {
        let label = UILabel()
        label.text = "PTS"
        label.font = .f1(.regular, size: 10)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .tertiaryLabel
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        
        addSubviews()
        setupLayoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        headshotImageView.kf.cancelDownloadTask()
        headshotImageView.image = nil
        driverNumberLabel.text = nil
        fullNameLabel.text = nil
        teamNameLabel.text = nil
        positionLabel.text = nil
        pointsLabel.text = nil
        teamColorView.backgroundColor = .clear
        positionBadge.backgroundColor = .systemGray
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    // MARK: - Configuration
    
    func configure(with driver: DriverModel) {
        // 드라이버 번호
        if let driverNumber = driver.driverNumber {
            driverNumberLabel.text = driverNumber
        }
        
        // 텍스트 설정 후 padding 추가
        updateDriverNumberLabelPadding()
        
        // 이름
        fullNameLabel.text = driver.fullName
        teamNameLabel.text = driver.teamName
        
        // 팀 컬러
        if let teamColor = driver.teamColour,
           let color = UIColor(hex: teamColor) {
            teamColorView.backgroundColor = color
        }
        
        // Standing 정보
        if let standingPosition = driver.standingPosition {
            positionLabel.text = "\(standingPosition)"
            positionLabel.textColor = .white
            
            // 포지션에 따른 배지 색상
            switch standingPosition {
            case 1:
                positionBadge.backgroundColor = .systemYellow // Gold
            case 2:
                positionBadge.backgroundColor = .systemGray // Silver
            case 3:
                positionBadge.backgroundColor = .systemOrange // Bronze
            default:
                positionBadge.backgroundColor = .clear // Default clear
                positionLabel.textColor = .label
            }
        }
        
        if let standingPoints = driver.standingPoints {
            pointsLabel.text = "\(standingPoints)"
        }
        
        // 헤드샷 이미지
        headshotImageView.setImage(
            driver.headshotImageURL,
            placeholder: UIImage(systemName: "person.circle.fill")
        )
    }
    
    private func updateDriverNumberLabelPadding() {
        driverNumberLabel.setNeedsLayout()
        driverNumberLabel.layoutIfNeeded()
        
        // 텍스트 너비에 따라 패딩 추가
        let textSize = driverNumberLabel.intrinsicContentSize
        let paddingHorizontal: CGFloat = 6
        
        driverNumberLabel.snp.updateConstraints {
            $0.width.greaterThanOrEqualTo(max(20, textSize.width + paddingHorizontal))
        }
    }
}

// MARK: - Layout
extension DriverListTableViewCell {
    private func addSubviews() {
        contentView.addSubview(containerView)
        
        [
            headshotImageView,
            teamColorView,
            driverNumberLabel,
            nameStackView,
            standingInfoStackView,
            chevronImageView
        ].forEach {
            containerView.addSubview($0)
        }
        
        [
            fullNameLabel,
            teamNameLabel
        ].forEach {
            nameStackView.addArrangedSubview($0)
        }
        
        positionBadge.addSubview(positionLabel)
        
        [
            positionBadge,
            pointsLabel,
            pointsUnitLabel
        ].forEach {
            standingInfoStackView.addArrangedSubview($0)
        }
    }
    
    private func setupLayoutConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 6, left: 16, bottom: 6, right: 16))
        }
        
        headshotImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(60)
        }
        
        teamColorView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(8)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(4)
            $0.height.equalTo(32)
        }
        
        driverNumberLabel.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(20)
            $0.width.greaterThanOrEqualTo(20)
        }
        
        nameStackView.snp.makeConstraints {
            $0.leading.equalTo(headshotImageView.snp.trailing).offset(12)
            $0.top.equalToSuperview().inset(16)
            $0.trailing.lessThanOrEqualTo(driverNumberLabel.snp.leading).offset(-8)
        }
        
        standingInfoStackView.snp.makeConstraints {
            $0.leading.equalTo(headshotImageView.snp.trailing).offset(12)
            $0.bottom.equalToSuperview().inset(16)
            $0.trailing.lessThanOrEqualTo(chevronImageView.snp.leading).offset(-8)
        }
        
        positionBadge.snp.makeConstraints {
            $0.width.height.equalTo(20)
        }
        
        positionLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        chevronImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(12)
        }
    }
}
