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
    
    static let identifier = "DriverCollectionViewCell"
    
    // MARK: - UI Components
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.1
        return view
    }()
    
    private let headshotImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
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
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = .black
        label.layer.cornerRadius = 12
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
    
    private let firstNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let lastNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private let teamNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let countryFlagLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
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
        teamColorView.backgroundColor = .clear
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        contentView.addSubview(containerView)
        
        [headshotImageView, teamColorView, driverNumberLabel, nameStackView, teamNameLabel, countryFlagLabel].forEach {
            containerView.addSubview($0)
        }
        
        [firstNameLabel, lastNameLabel].forEach {
            nameStackView.addArrangedSubview($0)
        }
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(4)
        }
        
        headshotImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(12)
            $0.height.equalTo(80)
        }
        
        teamColorView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(8)
            $0.width.equalTo(4)
            $0.height.equalTo(32)
        }
        
        driverNumberLabel.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(8)
            $0.width.height.equalTo(24)
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
    }
    
    // MARK: - Configuration
    
    func configure(with driver: DriverModel) {
        driverNumberLabel.text = "\(driver.driverNumber)"
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
}

// MARK: - Extensions

extension UIColor {
    convenience init?(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        
        guard Scanner(string: hex).scanHexInt64(&int) else { return nil }
        
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return nil
        }
        
        self.init(
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            alpha: Double(a) / 255
        )
    }
}

extension String {
    var flag: String {
        let base: UInt32 = 127397
        var s = ""
        for v in self.unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return String(s)
    }
}
