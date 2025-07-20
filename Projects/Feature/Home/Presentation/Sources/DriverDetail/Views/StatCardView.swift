//
//  StatCardView.swift
//  HomePresentation
//
//  Created by JUNHYEOK LEE on 7/18/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import UIKit
import SnapKit

import BasePresentation

public final class StatCardView: UIView {
    
    public enum StatStyle {
        case position
        case points
        case wins
        
        var backgroundColor: UIColor {
            switch self {
            case .position:
                return UIColor.systemRed.withAlphaComponent(0.1)
            case .points:
                return UIColor.systemBlue.withAlphaComponent(0.1)
            case .wins:
                return UIColor.systemGreen.withAlphaComponent(0.1)
            }
        }
        
        var accentColor: UIColor {
            switch self {
            case .position:
                return .systemRed
            case .points:
                return .systemBlue
            case .wins:
                return .systemGreen
            }
        }
    }
    
    // MARK: - UI Components
    
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = .f1(.bold, size: 28)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .f1(.regular, size: 12)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .center
        return stackView
    }()
    
    // MARK: - Initialization
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        addSubviews()
        setupLayoutConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        backgroundColor = .clear
    }
    
    private func addSubviews() {
        addSubview(containerView)
        containerView.addSubview(stackView)
        
        stackView.addArrangedSubview(valueLabel)
        stackView.addArrangedSubview(titleLabel)
    }
    
    private func setupLayoutConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(8)
        }
    }
    
    // MARK: - Configuration
    
    public func configure(title: String, value: String, style: StatStyle) {
        titleLabel.text = title.uppercased()
        valueLabel.text = value
        valueLabel.textColor = style.accentColor
        containerView.backgroundColor = style.backgroundColor
    }
}