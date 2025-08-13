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
    
    // Hero Section
    private let heroSectionView: UIView = {
        let view = UIView()
        view.backgroundColor = .cellBackground
        view.layer.cornerRadius = 16
        return view
    }()
    
    private let roundBadge: UIView = {
        let view = UIView()
        view.backgroundColor = .systemRed
        view.layer.cornerRadius = 16
        return view
    }()
    
    private let roundLabel: UILabel = {
        let label = UILabel()
        label.font = .f1(.bold, size: 14)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let raceNameLabel: UILabel = {
        let label = UILabel()
        label.font = .f1(.bold, size: 28)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    private let circuitNameLabel: UILabel = {
        let label = UILabel()
        label.font = .f1(.regular, size: 18)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    private let locationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        return stackView
    }()
    
    private let countryFlagLabel: UILabel = {
        let label = UILabel()
        label.font = .f1(.regular, size: 24)
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = .f1(.regular, size: 16)
        label.textColor = .secondaryLabel
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
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupNavigationBar() {
        navigationBar.setTitle("Race Details")
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
        raceNameLabel.text = race.raceName
        circuitNameLabel.text = race.circuit.circuitName
        
        // Location info
        if let location = race.circuit.location {
            countryFlagLabel.text = location.country.flag
            locationLabel.text = "\(location.locality), \(location.country)"
        }
        
        // Configure schedule
        scheduleCardView.configure(with: race)
    }
}

// MARK: - Layout
extension RaceDetailViewController {
    private func addSubviews() {
        view.addSubview(navigationBar)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [
            heroSectionView,
            scheduleCardView
        ].forEach {
            contentView.addSubview($0)
        }
        
        [
            roundBadge,
            raceNameLabel,
            circuitNameLabel,
            locationStackView
        ].forEach {
            heroSectionView.addSubview($0)
        }
        
        roundBadge.addSubview(roundLabel)
        
        [
            countryFlagLabel,
            locationLabel
        ].forEach {
            locationStackView.addArrangedSubview($0)
        }
    }
    
    private func setupLayoutConstraints() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        heroSectionView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        roundBadge.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(16)
            $0.width.height.equalTo(32)
        }
        
        roundLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        raceNameLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(16)
            $0.trailing.equalTo(roundBadge.snp.leading).offset(-12)
        }
        
        circuitNameLabel.snp.makeConstraints {
            $0.top.equalTo(raceNameLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        locationStackView.snp.makeConstraints {
            $0.top.equalTo(circuitNameLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(16)
        }
        
        scheduleCardView.snp.makeConstraints {
            $0.top.equalTo(heroSectionView.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(20)
        }
    }
}
