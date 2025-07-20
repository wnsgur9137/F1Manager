//
//  MinimapView.swift
//  HomePresentation
//
//  Created by JUNHYEOK LEE on 7/20/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import UIKit
import SnapKit

public final class MinimapView: UIView {
    
    // MARK: - UI Components
    
    private let trackImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .systemGray6
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let carsContainerView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        return view
    }()
    
    // MARK: - Properties
    
    private var carViews: [Int: CarDotView] = [:]
    private var trackBounds: CGRect = .zero
    private var coordinateTransform: CGAffineTransform = .identity
    
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
        addSubview(trackImageView)
        addSubview(carsContainerView)
    }
    
    private func setupLayoutConstraints() {
        trackImageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(8)
        }
        
        carsContainerView.snp.makeConstraints {
            $0.edges.equalTo(trackImageView)
        }
    }
    
    // MARK: - Public Methods
    
    public func setTrackImage(_ image: UIImage?) {
        trackImageView.image = image
        setupCoordinateTransform()
    }
    
    public func updateCarPosition(driverNumber: Int, position: CGPoint, carData: CarData?) {
        let transformedPosition = position.applying(coordinateTransform)
        
        if let carView = carViews[driverNumber] {
            UIView.animate(withDuration: 0.1, delay: .zero, options: .curveLinear) {
                carView.center = transformedPosition
                if let data = carData {
                    carView.updateData(data)
                }
            }
        } else {
            let carView = CarDotView(driverNumber: driverNumber)
            carView.center = transformedPosition
            if let data = carData {
                carView.updateData(data)
            }
            carsContainerView.addSubview(carView)
            carViews[driverNumber] = carView
        }
    }
    
    public func removeCarView(driverNumber: Int) {
        carViews[driverNumber]?.removeFromSuperview()
        carViews.removeValue(forKey: driverNumber)
    }
    
    public func clearAllCars() {
        carViews.values.forEach { $0.removeFromSuperview() }
        carViews.removeAll()
    }
    
    // MARK: - Private Methods
    
    private func setupCoordinateTransform() {
        // 실제 트랙 좌표를 뷰 좌표로 변환하는 변환 행렬 설정
        // 이 부분은 실제 트랙 데이터에 따라 조정 필요
        let viewBounds = trackImageView.bounds
        coordinateTransform = CGAffineTransform(
            scaleX: viewBounds.width / 1000.0,  // 가정: 트랙 좌표 범위가 -500~500
            y: viewBounds.height / 1000.0
        ).translatedBy(x: 500, y: 500)  // 중심점 조정
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        setupCoordinateTransform()
    }
}

// MARK: - CarData Structure
public struct CarData {
    public let speed: Int
    public let gear: Int
    public let isDrsActive: Bool
    public let brakePercentage: Double
    public let throttlePercentage: Double
    
    public init(speed: Int, gear: Int, isDrsActive: Bool, brakePercentage: Double, throttlePercentage: Double) {
        self.speed = speed
        self.gear = gear
        self.isDrsActive = isDrsActive
        self.brakePercentage = brakePercentage
        self.throttlePercentage = throttlePercentage
    }
}

// MARK: - CarDotView
private final class CarDotView: UIView {
    
    private let dotView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6
        view.backgroundColor = .systemBlue
        return view
    }()
    
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 8, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let drsIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGreen
        view.layer.cornerRadius = 2
        view.isHidden = true
        return view
    }()
    
    private let driverNumber: Int
    
    init(driverNumber: Int) {
        self.driverNumber = driverNumber
        super.init(frame: CGRect(x: 0, y: 0, width: 12, height: 12))
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(dotView)
        addSubview(numberLabel)
        addSubview(drsIndicator)
        
        dotView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(12)
        }
        
        numberLabel.snp.makeConstraints {
            $0.center.equalTo(dotView)
        }
        
        drsIndicator.snp.makeConstraints {
            $0.top.equalTo(dotView.snp.top).offset(-2)
            $0.centerX.equalTo(dotView)
            $0.size.equalTo(4)
        }
        
        numberLabel.text = "\(driverNumber)"
    }
    
    func updateData(_ data: CarData) {
        // DRS 표시
        drsIndicator.isHidden = !data.isDrsActive
        
        // 속도에 따른 색상 변경
        let speedRatio = min(Double(data.speed) / 350.0, 1.0)  // 최대 350km/h 기준
        let color = UIColor(
            red: CGFloat(speedRatio),
            green: CGFloat(1.0 - speedRatio),
            blue: 0.3,
            alpha: 1.0
        )
        dotView.backgroundColor = color
        
        // 브레이크 사용 시 빨간색
        if data.brakePercentage > 0.1 {
            dotView.backgroundColor = .systemRed
        }
    }
}
