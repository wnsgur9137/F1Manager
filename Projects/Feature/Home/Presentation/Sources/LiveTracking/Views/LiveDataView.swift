//
//  LiveDataView.swift
//  HomePresentation
//
//  Created by JUNHYEOK LEE on 7/20/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import UIKit
import SnapKit

import BasePresentation

public final class LiveDataView: UIView {
    
    // MARK: - UI Components
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let speedContainer = DataContainerView(title: "SPEED", unit: "km/h")
    private let gearContainer = DataContainerView(title: "GEAR", unit: "")
    private let rpmContainer = DataContainerView(title: "RPM", unit: "")
    private let drsContainer = DataContainerView(title: "DRS", unit: "")
    
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
        backgroundColor = .systemBackground
        layer.cornerRadius = 12
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.1
    }
    
    private func addSubviews() {
        addSubview(stackView)
        
        [speedContainer, gearContainer, rpmContainer, drsContainer].forEach {
            stackView.addArrangedSubview($0)
        }
    }
    
    private func setupLayoutConstraints() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }
    }
    
    // MARK: - Public Methods
    
    public func updateData(_ carData: CarData) {
        speedContainer.setValue("\(carData.speed)")
        gearContainer.setValue(carData.gear == 0 ? "N" : "\(carData.gear)")
        rpmContainer.setValue("\(carData.speed * 50)") // RPM 계산 (임시)
        drsContainer.setValue(carData.isDrsActive ? "ON" : "OFF")
        drsContainer.setStatus(carData.isDrsActive ? .active : .inactive)
    }
    
    public func updateThrottle(_ percentage: Double) {
        speedContainer.setProgress(percentage)
    }
    
    public func updateBrake(_ percentage: Double) {
        speedContainer.setBrakeActive(percentage > 0.1)
    }
}

// MARK: - DataContainerView
private final class DataContainerView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .f1(.regular, size: 10)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = .f1(.bold, size: 18)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private let unitLabel: UILabel = {
        let label = UILabel()
        label.font = .f1(.regular, size: 8)
        label.textColor = .tertiaryLabel
        label.textAlignment = .center
        return label
    }()
    
    private let progressView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = 2
        view.isHidden = true
        return view
    }()
    
    private let progressFillView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGreen
        view.layer.cornerRadius = 2
        return view
    }()
    
    private let statusIndicator: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 3
        view.isHidden = true
        return view
    }()
    
    private let title: String
    private let unit: String
    
    init(title: String, unit: String) {
        self.title = title
        self.unit = unit
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .systemGray6
        layer.cornerRadius = 8
        
        addSubview(titleLabel)
        addSubview(valueLabel)
        addSubview(unitLabel)
        addSubview(progressView)
        addSubview(statusIndicator)
        progressView.addSubview(progressFillView)
        
        titleLabel.text = title
        unitLabel.text = unit
        valueLabel.text = "--"
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.centerX.equalToSuperview()
        }
        
        valueLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        unitLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(8)
            $0.centerX.equalToSuperview()
        }
        
        progressView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.bottom.equalToSuperview().inset(4)
            $0.height.equalTo(4)
        }
        
        progressFillView.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0)
        }
        
        statusIndicator.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(4)
            $0.size.equalTo(6)
        }
        
        // 특정 컨테이너에만 진행률 표시
        progressView.isHidden = title != "SPEED"
    }
    
    func setValue(_ value: String) {
        valueLabel.text = value
    }
    
    func setProgress(_ percentage: Double) {
        guard !progressView.isHidden else { return }
        
        progressFillView.snp.updateConstraints {
            $0.width.equalToSuperview().multipliedBy(min(max(percentage, 0), 1))
        }
        
        UIView.animate(withDuration: 0.1) {
            self.layoutIfNeeded()
        }
    }
    
    func setBrakeActive(_ isActive: Bool) {
        backgroundColor = isActive ? .systemRed.withAlphaComponent(0.3) : .systemGray6
        
        UIView.animate(withDuration: 0.1) {
            self.backgroundColor = isActive ? .systemRed.withAlphaComponent(0.3) : .systemGray6
        }
    }
    
    func setStatus(_ status: Status) {
        statusIndicator.isHidden = false
        statusIndicator.backgroundColor = status.color
    }
    
    enum Status {
        case active
        case inactive
        
        var color: UIColor {
            switch self {
            case .active:
                return .systemGreen
            case .inactive:
                return .systemGray
            }
        }
    }
}
