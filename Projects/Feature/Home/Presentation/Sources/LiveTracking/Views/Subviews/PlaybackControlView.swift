//
//  PlaybackControlView.swift
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

public final class PlaybackControlView: UIView {
    
    // MARK: - UI Components
    
    private let playButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        button.setImage(UIImage(systemName: "pause.circle.fill"), for: .selected)
        button.tintColor = .systemBlue
        return button
    }()
    
    private let speedLabel: UILabel = {
        let label = UILabel()
        label.text = "Speed: 1x"
        label.font = .f1(.regular, size: 12)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let speedSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0.5
        slider.maximumValue = 4.0
        slider.value = 1.0
        slider.tintColor = .systemBlue
        return slider
    }()
    
    private let progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progressTintColor = .systemBlue
        progressView.trackTintColor = .systemGray5
        return progressView
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00 / 00:00"
        label.font = .f1(.regular, size: 10)
        label.textColor = .tertiaryLabel
        return label
    }()
    
    // MARK: - Properties
    
    private let playButtonTappedSubject = PublishSubject<Void>()
    private let speedChangedSubject = PublishSubject<Double>()
    
    public var playButtonTapped: Observable<Void> {
        return playButtonTappedSubject.asObservable()
    }
    
    public var speedChanged: Observable<Double> {
        return speedChangedSubject.asObservable()
    }
    
    // MARK: - Initialization
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        addSubviews()
        setupLayoutConstraints()
        setupActions()
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
        addSubview(playButton)
        addSubview(speedLabel)
        addSubview(speedSlider)
        addSubview(progressView)
        addSubview(timeLabel)
    }
    
    private func setupLayoutConstraints() {
        playButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(40)
        }
        
        speedLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.leading.equalTo(playButton.snp.trailing).offset(16)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        speedSlider.snp.makeConstraints {
            $0.top.equalTo(speedLabel.snp.bottom).offset(4)
            $0.leading.equalTo(playButton.snp.trailing).offset(16)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        progressView.snp.makeConstraints {
            $0.top.equalTo(speedSlider.snp.bottom).offset(8)
            $0.leading.equalTo(playButton.snp.trailing).offset(16)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        timeLabel.snp.makeConstraints {
            $0.top.equalTo(progressView.snp.bottom).offset(4)
            $0.leading.equalTo(playButton.snp.trailing).offset(16)
            $0.bottom.equalToSuperview().inset(8)
        }
    }
    
    private func setupActions() {
        playButton.addTarget(self, action: #selector(playButtonTapped(_:)), for: .touchUpInside)
        speedSlider.addTarget(self, action: #selector(speedSliderChanged(_:)), for: .valueChanged)
    }
    
    @objc private func playButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        playButtonTappedSubject.onNext(())
    }
    
    @objc private func speedSliderChanged(_ sender: UISlider) {
        let speed = Double(sender.value)
        speedLabel.text = String(format: "Speed: %.1fx", speed)
        speedChangedSubject.onNext(speed)
    }
    
    // MARK: - Public Methods
    
    public func updateProgress(_ progress: Float) {
        progressView.progress = progress
    }
    
    public func updateTime(current: TimeInterval, total: TimeInterval) {
        let currentFormatted = formatTime(current)
        let totalFormatted = formatTime(total)
        timeLabel.text = "\\(currentFormatted) / \\(totalFormatted)"
    }
    
    public func setPlaying(_ isPlaying: Bool) {
        playButton.isSelected = isPlaying
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}