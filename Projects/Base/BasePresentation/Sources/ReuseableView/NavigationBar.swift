//
//  NavigationBar.swift
//  BasePresentation
//
//  Created by JUNHYEOK LEE on 7/13/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

public final class NavigationBar: UIView {
    
    // MARK: - UI Instances
    
    private let backButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "1235"
        return label
    }()
    
    private let rightStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    // MARK: - Properties
    
    // MARK: - Live cycle
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupLayoutConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Layout
extension NavigationBar {
    private func addSubviews() {
        addSubview(backButton)
        addSubview(titleLabel)
        addSubview(rightStackView)
    }
    
    private func setupLayoutConstraints() {
        snp.makeConstraints {
            $0.height.equalTo(80)
        }
        
        backButton.snp.makeConstraints {
            $0.width.height.equalTo(32)
            $0.centerY.equalTo(self)
            $0.leading.equalTo(self).offset(16)
        }
        
        titleLabel.snp.makeConstraints {
            $0.center.equalTo(self)
        }
        
        rightStackView.snp.makeConstraints {
            $0.centerY.equalTo(self)
            $0.trailing.equalTo(self).offset(-16)
        }
    }
}
