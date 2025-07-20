//
//  SessionInfoView.swift
//  HomePresentation
//
//  Created by JUNHYEOK LEE on 7/20/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import UIKit
import SnapKit

import BasePresentation

public final class SessionInfoView: UIView {
    
    // MARK: - UI Components
    
    private let circuitLabel: UILabel = {
        let label = UILabel()
        label.font = .f1(.bold, size: 18)
        label.textColor = .label
        return label
    }()
    
    private let sessionLabel: UILabel = {
        let label = UILabel()
        label.font = .f1(.regular, size: 14)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let yearLabel: UILabel = {
        let label = UILabel()
        label.font = .f1(.regular, size: 12)
        label.textColor = .tertiaryLabel
        return label
    }()
    
    // MARK: - Initialization
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        addSubviews()
        setupLayoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        backgroundColor = .systemGray6
        layer.cornerRadius = 12
    }
    
    private func addSubviews() {
        addSubview(circuitLabel)
        addSubview(sessionLabel)
        addSubview(yearLabel)
    }
    
    private func setupLayoutConstraints() {
        circuitLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(16)
        }
        
        sessionLabel.snp.makeConstraints {
            $0.bottom.leading.equalToSuperview().inset(16)
        }
        
        yearLabel.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(16)
        }
    }
    
    // MARK: - Public Methods
    
    public func configure(with session: SessionModel) {
        circuitLabel.text = session.circuitShortName
        sessionLabel.text = "\(session.sessionName) - \(session.sessionType)"
        yearLabel.text = "\(session.year)"
    }
}

//// Temporary model
//public struct GrandprizeSessionModel {
//    let circuitShortName: String
//    let sessionName: String
//    let sessionType: String
//    let year: Int
//}
