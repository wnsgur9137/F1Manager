//
//  DriverSelectionView.swift
//  HomePresentation
//
//  Created by JUNHYEOK LEE on 7/20/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

import BasePresentation

public final class DriverSelectionView: UIView {
    
    // MARK: - UI Components
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Select Driver"
        label.font = .f1(.regular, size: 12)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        return stackView
    }()
    
    // MARK: - Properties
    
    private var driverButtons: [UIButton] = []
    private let driverSelectedSubject = PublishSubject<Int>()
    private var selectedDriverNumber: Int?
    
    public var driverSelected: Observable<Int> {
        return driverSelectedSubject.asObservable()
    }
    
    // MARK: - Initialization
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        addSubviews()
        setupLayoutConstraints()
        setupDriverButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        backgroundColor = .systemBackground
    }
    
    private func addSubviews() {
        addSubview(titleLabel)
        addSubview(scrollView)
        scrollView.addSubview(stackView)
    }
    
    private func setupLayoutConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalToSuperview()
        }
    }
    
    private func setupDriverButtons() {
        // F1 2024 driver numbers
        let driverNumbers = [1, 2, 3, 4, 10, 11, 14, 16, 18, 20, 22, 23, 24, 27, 31, 40, 44, 55, 63, 77, 81]
        
        for driverNumber in driverNumbers {
            let button = createDriverButton(driverNumber: driverNumber)
            driverButtons.append(button)
            stackView.addArrangedSubview(button)
        }
    }
    
    private func createDriverButton(driverNumber: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("\\(driverNumber)", for: .normal)
        button.titleLabel?.font = .f1(.bold, size: 14)
        button.backgroundColor = .systemGray5
        button.setTitleColor(.label, for: .normal)
        button.layer.cornerRadius = 16
        button.tag = driverNumber
        
        button.snp.makeConstraints {
            $0.width.height.equalTo(32)
        }
        
        button.addTarget(self, action: #selector(driverButtonTapped(_:)), for: .touchUpInside)
        
        return button
    }
    
    @objc private func driverButtonTapped(_ sender: UIButton) {
        let driverNumber = sender.tag
        selectDriver(driverNumber)
        driverSelectedSubject.onNext(driverNumber)
    }
    
    // MARK: - Public Methods
    
    public func selectDriver(_ driverNumber: Int) {
        // 이전 선택 해제
        if let previousNumber = selectedDriverNumber,
           let previousButton = driverButtons.first(where: { $0.tag == previousNumber }) {
            previousButton.backgroundColor = .systemGray5
            previousButton.setTitleColor(.label, for: .normal)
        }
        
        // 새로운 선택
        if let newButton = driverButtons.first(where: { $0.tag == driverNumber }) {
            newButton.backgroundColor = .systemBlue
            newButton.setTitleColor(.white, for: .normal)
            selectedDriverNumber = driverNumber
        }
    }
}