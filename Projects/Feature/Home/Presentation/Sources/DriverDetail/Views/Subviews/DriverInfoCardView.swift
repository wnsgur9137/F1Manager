//
//  DriverInfoCardView.swift
//  HomePresentation
//
//  Created by JUNHYEOK LEE on 7/17/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit

import BasePresentation

final class DriverInfoCardView: UIView {
    
    struct InfoItem {
        let title: String
        let value: String
        let action: (() -> Void)?
        
        init(title: String, value: String, action: (() -> Void)? = nil) {
            self.title = title
            self.value = value
            self.action = action
        }
    }
    
    // MARK: - UI Components
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .cellBackground
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 8
        view.layer.shadowOpacity = 0.1
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .f1(.bold, size: 20)
        label.textColor = .label
        return label
    }()
    
    private let itemsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        return stackView
    }()
    
    // MARK: - Properties
    
    private var infoItems: [InfoItem] = []
    private var disposeBag = DisposeBag()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
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
        backgroundColor = .clear
    }
    
    // MARK: - Configuration
    
    func configure(title: String) {
        titleLabel.text = title
    }
    
    func configure(items: [InfoItem]) {
        self.infoItems = items
        
        itemsStackView.arrangedSubviews.forEach { view in
            itemsStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        for (index, item) in items.enumerated() {
            let itemView = createInfoItemView(for: item, at: index)
            itemsStackView.addArrangedSubview(itemView)
            
            if index < items.count - 1 {
                let separator = createSeparator()
                itemsStackView.addArrangedSubview(separator)
            }
        }
    }
    
    private func createInfoItemView(for item: InfoItem, at index: Int) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = .clear
        
        let titleLabel = UILabel()
        titleLabel.font = .f1(.regular, size: 14)
        titleLabel.textColor = .secondaryLabel
        titleLabel.text = item.title
        
        let valueLabel = UILabel()
        valueLabel.font = .f1(.regular, size: 16)
        valueLabel.textColor = item.action != nil ? .systemBlue : .label
        valueLabel.text = item.value
        valueLabel.numberOfLines = 0
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(valueLabel)
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        valueLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        if let action = item.action {
            let tapGesture = UITapGestureRecognizer()
            containerView.addGestureRecognizer(tapGesture)
            containerView.isUserInteractionEnabled = true
            
            tapGesture.rx.event
                .subscribe(onNext: { _ in
                    action()
                })
                .disposed(by: disposeBag)
            
            let chevronImageView = UIImageView()
            chevronImageView.image = UIImage(systemName: "chevron.right")
            chevronImageView.tintColor = .tertiaryLabel
            chevronImageView.contentMode = .scaleAspectFit
            
            containerView.addSubview(chevronImageView)
            
            chevronImageView.snp.makeConstraints {
                $0.trailing.equalTo(chevronImageView)
                $0.centerY.equalTo(valueLabel)
                $0.width.height.equalTo(12)
            }
        }
        
        containerView.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(44)
        }
        
        return containerView
    }
    
    private func createSeparator() -> UIView {
        let separator = UIView()
        separator.backgroundColor = .separator
        
        separator.snp.makeConstraints {
            $0.height.equalTo(0.5)
        }
        
        return separator
    }
}

// MARK: - Layout
extension DriverInfoCardView {
    private func addSubviews() {
        addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(itemsStackView)
    }
    
    private func setupLayoutConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview().inset(20)
        }
        
        itemsStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(20)
        }
    }
}
