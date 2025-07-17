//
//  DriverListTableViewCell.swift
//  HomePresentation
//
//  Created by JUNHYEOK LEE on 7/17/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import UIKit
import SnapKit

import BasePresentation

final class DriverListTableViewCell: UITableViewCell {
    
    // MARK: - UI Components
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
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
    
    private let countryInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.alignment = .center
        return stackView
    }()
    
    private let countryFlagLabel: UILabel = {
        let label = UILabel()
        label.font = .f1(.regular, size: 18)
        return label
    }()
    
    private let countryLabel: UILabel = {
        let label = UILabel()
        label.font = .f1(.regular, size: 12)
        label.textColor = .tertiaryLabel
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
        headshotImageView.image = nil
        driverNumberLabel.text = nil
        fullNameLabel.text = nil
        teamNameLabel.text = nil
        countryFlagLabel.text = nil
        countryLabel.text = nil
        teamColorView.backgroundColor = .clear
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
        
        // 이름
        fullNameLabel.text = driver.fullName
        teamNameLabel.text = driver.teamName
        
        // 팀 컬러
        if let teamColor = driver.teamColour,
           let color = UIColor(hex: teamColor) {
            teamColorView.backgroundColor = color
        }
        
        // 국가 정보
        if let countryCode = driver.countryCode {
            countryFlagLabel.text = countryCode.flag
        }
        countryLabel.text = driver.country
        
        // 헤드샷 이미지
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
            countryInfoStackView,
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
        
        [
            countryFlagLabel,
            countryLabel
        ].forEach {
            countryInfoStackView.addArrangedSubview($0)
        }
    }
    
    private func setupLayoutConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16))
        }
        
        headshotImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(50)
        }
        
        teamColorView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(8)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(4)
            $0.height.equalTo(32)
        }
        
        driverNumberLabel.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(12)
            $0.width.height.equalTo(20)
        }
        
        nameStackView.snp.makeConstraints {
            $0.leading.equalTo(headshotImageView.snp.trailing).offset(12)
            $0.top.equalToSuperview().inset(12)
            $0.trailing.lessThanOrEqualTo(driverNumberLabel.snp.leading).offset(-8)
        }
        
        countryInfoStackView.snp.makeConstraints {
            $0.leading.equalTo(headshotImageView.snp.trailing).offset(12)
            $0.bottom.equalToSuperview().inset(12)
            $0.trailing.lessThanOrEqualTo(chevronImageView.snp.leading).offset(-8)
        }
        
        chevronImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(12)
        }
    }
}
