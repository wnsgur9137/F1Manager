//
//  RaceDetailViewController.swift
//  HomePresentation
//
//  Created by JunHyeok Lee on 8/12/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import SnapKit

import BasePresentation

public final class RaceDetailViewController: UIViewController, View {
    
    // MARK: - UI Components
    
    private let navigationBar = NavigationBar(.popButton)
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .systemBackground
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    // Hero Section with gradient background
    private let heroSectionView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let heroGradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.systemRed.cgColor,
            UIColor.systemRed.withAlphaComponent(0.8).cgColor,
            UIColor.clear.cgColor
        ]
        gradient.locations = [0.0, 0.6, 1.0]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        return gradient
    }()
    
    private let heroBackgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.alpha = 0.3
        // F1 트랙 패턴 이미지 또는 기본 패턴
        imageView.backgroundColor = .systemGray6
        return imageView
    }()
    
    private let roundBadge: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 8
        view.layer.shadowOpacity = 0.2
        return view
    }()
    
    private let roundLabel: UILabel = {
        let label = UILabel()
        label.font = .f1(.bold, size: 16)
        label.textColor = .systemRed
        label.textAlignment = .center
        return label
    }()
    
    private let raceNameLabel: UILabel = {
        let label = UILabel()
        label.font = .f1(.bold, size: 32)
        label.textColor = .white
        label.numberOfLines = 0
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 2)
        label.layer.shadowRadius = 4
        label.layer.shadowOpacity = 0.5
        return label
    }()
    
    private let circuitNameLabel: UILabel = {
        let label = UILabel()
        label.font = .f1(.regular, size: 20)
        label.textColor = UIColor.white.withAlphaComponent(0.9)
        label.numberOfLines = 0
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 1)
        label.layer.shadowRadius = 2
        label.layer.shadowOpacity = 0.5
        return label
    }()
    
    private let locationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .center
        return stackView
    }()
    
    private let countryFlagLabel: UILabel = {
        let label = UILabel()
        label.font = .f1(.regular, size: 28)
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 1)
        label.layer.shadowRadius = 2
        label.layer.shadowOpacity = 0.3
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = .f1(.bold, size: 18)
        label.textColor = .white
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 1)
        label.layer.shadowRadius = 2
        label.layer.shadowOpacity = 0.5
        return label
    }()
    
    // Race Date Section
    private let raceDateCardView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 12
        view.layer.shadowOpacity = 0.1
        return view
    }()
    
    private let raceDateLabel: UILabel = {
        let label = UILabel()
        label.font = .f1(.bold, size: 24)
        label.textColor = .systemRed
        label.textAlignment = .center
        return label
    }()
    
    private let raceTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .f1(.regular, size: 16)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
    }()
    
    // Race Schedule Section
    private let scheduleCardView = RaceScheduleCardView()
    
    // Properties
    public var disposeBag = DisposeBag()
    
    // MARK: - Life cycle
    
    public static func create(with reactor: RaceDetailReactor) -> RaceDetailViewController {
        let viewController = RaceDetailViewController()
        viewController.reactor = reactor
        return viewController
    }
    
    private init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        addSubviews()
        setupLayoutConstraints()
        setupGradient()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        heroGradientLayer.frame = heroSectionView.bounds
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupNavigationBar() {
        navigationBar.setTitle("Race Details")
        navigationBar.backgroundColor = .clear
    }
    
    private func setupGradient() {
        heroSectionView.layer.insertSublayer(heroGradientLayer, at: 1)
    }
    
    public func bind(reactor: RaceDetailReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
}

// MARK: - Bind
extension RaceDetailViewController {
    private func bindAction(_ reactor: RaceDetailReactor) {
        rx.viewDidLoad
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        navigationBar.didTapBackButton
            .map { Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: RaceDetailReactor) {
        reactor.pulse(\.$race)
            .compactMap { $0 }
            .bind(onNext: { [weak self] race in
                self?.configure(with: race)
            })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$error)
            .compactMap { $0 }
            .bind(onNext: { error in
                
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Configuration
extension RaceDetailViewController {
    private func configure(with race: RaceModel) {
        roundLabel.text = "ROUND \(race.round)"
        raceNameLabel.text = race.raceName.uppercased()
        circuitNameLabel.text = race.circuit.circuitName
        
        // Location info
        if let location = race.circuit.location {
            countryFlagLabel.text = location.country.flag
            locationLabel.text = "\(location.locality), \(location.country)".uppercased()
        }
        
        // Race date and time
        raceDateLabel.text = formatRaceDate(race.date)
        raceTimeLabel.text = race.time?.prefix(5).description ?? "TBA"
        
        // Configure schedule
        scheduleCardView.configure(with: race)
    }
    
    private func formatRaceDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US")
        
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "MMM dd"
            return dateFormatter.string(from: date).uppercased()
        }
        
        return dateString.uppercased()
    }
}

// MARK: - Layout
extension RaceDetailViewController {
    private func addSubviews() {
        view.addSubview(navigationBar)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(heroSectionView)
        contentView.addSubview(raceDateCardView)
        contentView.addSubview(scheduleCardView)
        
        heroSectionView.addSubview(heroBackgroundImageView)
        heroSectionView.addSubview(roundBadge)
        heroSectionView.addSubview(raceNameLabel)
        heroSectionView.addSubview(circuitNameLabel)
        heroSectionView.addSubview(locationStackView)
        
        roundBadge.addSubview(roundLabel)
        
        locationStackView.addArrangedSubview(countryFlagLabel)
        locationStackView.addArrangedSubview(locationLabel)
        
        raceDateCardView.addSubview(raceDateLabel)
        raceDateCardView.addSubview(raceTimeLabel)
    }
    
    private func setupLayoutConstraints() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        // Hero Section - 더 큰 크기로 변경
        heroSectionView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(300)
        }
        
        heroBackgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        roundBadge.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(24)
            $0.width.equalTo(120)
            $0.height.equalTo(40)
        }
        
        roundLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        raceNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(60)
            $0.leading.equalToSuperview().inset(24)
            $0.trailing.equalTo(roundBadge.snp.leading).offset(-16)
        }
        
        circuitNameLabel.snp.makeConstraints {
            $0.top.equalTo(raceNameLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        locationStackView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(24)
            $0.leading.equalToSuperview().inset(24)
            $0.trailing.lessThanOrEqualToSuperview().inset(24)
        }
        
        // Race Date Card
        raceDateCardView.snp.makeConstraints {
            $0.top.equalTo(heroSectionView.snp.bottom).offset(-30) // 오버랩 효과
            $0.centerX.equalToSuperview()
            $0.width.equalTo(200)
            $0.height.equalTo(80)
        }
        
        raceDateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.centerX.equalToSuperview()
        }
        
        raceTimeLabel.snp.makeConstraints {
            $0.top.equalTo(raceDateLabel.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(16)
        }
        
        // Schedule Card
        scheduleCardView.snp.makeConstraints {
            $0.top.equalTo(raceDateCardView.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(24)
        }
    }
}
