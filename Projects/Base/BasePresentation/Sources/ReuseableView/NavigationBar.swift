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
    
    public enum NavigationType {
        case nonButton
        case dismissButton
        case popButton
    }
    
    // MARK: - UI Instances
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.isHidden = true
        button.tintColor = .label
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .f1(.bold, size: 18)
        return label
    }()
    
    private let rightStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    // MARK: - Properties
    
    public var didTapBackButton: ControlEvent<Void> {
        return backButton.rx.tap
    }
    
    // MARK: - Live cycle
    
    public init(_ type: NavigationType) {
        super.init(frame: .zero)
        setupBackButtonImage(type)
        
        addSubviews()
        setupLayoutConstraints()
    }
      
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBackButtonImage(_ type: NavigationType) {
        switch type {
        case .nonButton:
            backButton.isHidden = true
        case .dismissButton:
            backButton.isHidden = false
            backButton.setImage(
                UIImage(systemName: "xmark"),
                for: .normal
            )
        case .popButton:
            backButton.isHidden = false
            backButton.setImage(
                UIImage(systemName: "chevron.left"),
                for: .normal
            )
        }
    }
    
}

extension NavigationBar {
    public func setTitle(_ title: String) {
        titleLabel.text = title
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
            $0.height.equalTo(44)
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
