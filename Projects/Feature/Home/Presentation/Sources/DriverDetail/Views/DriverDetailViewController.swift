//
//  DriverDetailViewController.swift
//  HomePresentation
//
//  Created by JUNHYEOK LEE on 7/17/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import SnapKit

import BasePresentation

public final class DriverDetailViewController: UIViewController, View {
    
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
        view.backgroundColor = .clear
        return view
    }()
    
    private let headshotImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = .systemGray5
        return imageView
    }()
    
    private let teamColorBannerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let driverNumberLabel: UILabel = {
        let label = UILabel()
        label.font = .f1(.bold, size: 72)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        return label
    }()
    
    private let nameStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .leading
        return stackView
    }()
    
    private let firstNameLabel: UILabel = {
        let label = UILabel()
        label.font = .f1(.regular, size: 18)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let lastNameLabel: UILabel = {
        let label = UILabel()
        label.font = .f1(.bold, size: 32)
        label.textColor = .label
        return label
    }()
    
    private let teamNameLabel: UILabel = {
        let label = UILabel()
        label.font = .f1(.bold, size: 16)
        label.textColor = .label
        return label
    }()
    
    private let countryInfoView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let countryFlagLabel: UILabel = {
        let label = UILabel()
        label.font = .f1(.regular, size: 24)
        return label
    }()
    
    private let countryNameLabel: UILabel = {
        let label = UILabel()
        label.font = .f1(.regular, size: 16)
        label.textColor = .label
        return label
    }()
    
    // Info Cards Section
    private let infoCardsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        return stackView
    }()
    
    private let personalInfoCard: DriverInfoCardView = {
        let card = DriverInfoCardView()
        card.configure(title: "Personal Information")
        return card
    }()
    
    private let careerInfoCard: DriverInfoCardView = {
        let card = DriverInfoCardView()
        card.configure(title: "Career Information")
        return card
    }()
    
    private let standingInfoCard: DriverInfoCardView = {
        let card = DriverInfoCardView()
        card.configure(title: "2025 Championship Standing")
        return card
    }()
    
    // Championship Stats Section
    private let statsSection: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        return view
    }()
    
    private let statsSectionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Championship Stats"
        label.font = .f1(.bold, size: 20)
        label.textColor = .label
        return label
    }()
    
    private let statsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 1
        return stackView
    }()
    
    private let positionStatView: StatCardView = {
        let view = StatCardView()
        view.configure(title: "Position", value: "-", style: .position)
        return view
    }()
    
    private let pointsStatView: StatCardView = {
        let view = StatCardView()
        view.configure(title: "Points", value: "-", style: .points)
        return view
    }()
    
    private let winsStatView: StatCardView = {
        let view = StatCardView()
        view.configure(title: "Wins", value: "-", style: .wins)
        return view
    }()
    
    // MARK: - Properties
    
    public var disposeBag = DisposeBag()
    
    // MARK: - Life cycle
    
    public static func create(with reactor: DriverDetailReactor) -> DriverDetailViewController {
        let viewController = DriverDetailViewController()
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
        navigationBar.setTitle("Driver Details")
    }
    
    public func bind(reactor: DriverDetailReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
}

// MARK: - Bind
extension DriverDetailViewController {
    private func bindAction(_ reactor: DriverDetailReactor) {
        rx.viewDidLoad
            .map { DriverDetailReactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        navigationBar.didTapBackButton
            .map { DriverDetailReactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: DriverDetailReactor) {
        reactor.pulse(\.$driver)
            .compactMap { $0 }
            .bind(onNext: { [weak self] driver in
                self?.configureUI(with: driver)
            })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$error)
            .compactMap { $0 }
            .bind(onNext: { [weak self] error in
                self?.showErrorAlert(error: error)
            })
            .disposed(by: disposeBag)
    }
    
    private func showErrorAlert(error: Error) {
        let alert = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - Configuration
extension DriverDetailViewController {
    private func configureUI(with driver: DriverModel) {
        // Driver Number
        if let driverNumber = driver.driverNumber {
            driverNumberLabel.text = driverNumber
        }
        
        // Names
        firstNameLabel.text = driver.givenName
        lastNameLabel.text = driver.familyName
        teamNameLabel.text = driver.teamName
        
        // Country
        if let countryCode = driver.countryCode {
            countryFlagLabel.text = countryCode.flag
        }
        countryNameLabel.text = driver.country
        
        // Team Color
        if let teamColor = driver.teamColour,
           let color = UIColor(hex: teamColor) {
            teamColorBannerView.backgroundColor = color
        } else {
            teamColorBannerView.backgroundColor = .systemGray
        }
        
        // Headshot Image
        headshotImageView.setImage(
            driver.headshotImageURL,
            placeholder: UIImage(systemName: "person.circle.fill")
        )
        
        // Configure Info Cards
        configureStandingInfoCard(with: driver)
        configurePersonalInfoCard(with: driver)
        configureCareerInfoCard(with: driver)
        
        // Configure Stats
        configureStatsSection(with: driver)
    }
    
    private func configureStandingInfoCard(with driver: DriverModel) {
        var infoItems: [DriverInfoCardView.InfoItem] = []
        
        if let standingPosition = driver.standingPosition {
            let positionText = standingPosition == 1 ? "1st" : standingPosition == 2 ? "2nd" : standingPosition == 3 ? "3rd" : "\(standingPosition)th"
            infoItems.append(DriverInfoCardView.InfoItem(
                title: "Championship Position",
                value: positionText
            ))
        }
        
        if let standingPoints = driver.standingPoints {
            infoItems.append(DriverInfoCardView.InfoItem(
                title: "Total Points",
                value: "\(standingPoints) pts"
            ))
        }
        
        if let wins = driver.wins {
            let winsText = wins == 1 ? "1 win" : "\(wins) wins"
            infoItems.append(DriverInfoCardView.InfoItem(
                title: "Race Wins",
                value: winsText
            ))
        }
        
        standingInfoCard.configure(items: infoItems)
    }
    
    private func configureStatsSection(with driver: DriverModel) {
        // Position
        if let standingPosition = driver.standingPosition {
            let positionText = standingPosition == 1 ? "1st" : standingPosition == 2 ? "2nd" : standingPosition == 3 ? "3rd" : "\(standingPosition)th"
            positionStatView.configure(title: "Position", value: positionText, style: .position)
        }
        
        // Points
        if let standingPoints = driver.standingPoints {
            pointsStatView.configure(title: "Points", value: "\(standingPoints)", style: .points)
        }
        
        // Wins
        if let wins = driver.wins {
            winsStatView.configure(title: "Wins", value: "\(wins)", style: .wins)
        }
    }
    
    private func configurePersonalInfoCard(with driver: DriverModel) {
        var infoItems: [DriverInfoCardView.InfoItem] = []
        
        if let dateOfBirth = driver.dateOfBirth {
            infoItems.append(DriverInfoCardView.InfoItem(
                title: "Date of Birth",
                value: formatDateOfBirth(dateOfBirth)
            ))
        }
        
        if let country = driver.country {
            infoItems.append(DriverInfoCardView.InfoItem(
                title: "Nationality",
                value: country
            ))
        }
        
        if let driverCode = driver.driverCode {
            infoItems.append(DriverInfoCardView.InfoItem(
                title: "Driver Code",
                value: driverCode
            ))
        }
        
        personalInfoCard.configure(items: infoItems)
    }
    
    private func configureCareerInfoCard(with driver: DriverModel) {
        var infoItems: [DriverInfoCardView.InfoItem] = []
        
        if let teamName = driver.teamName {
            infoItems.append(DriverInfoCardView.InfoItem(
                title: "Current Team",
                value: teamName
            ))
        }
        
        if let driverNumber = driver.driverNumber {
            infoItems.append(DriverInfoCardView.InfoItem(
                title: "Racing Number",
                value: driverNumber
            ))
        }
        
        // Wikipedia Link
        if let wikipediaURL = driver.wikipediaURL {
            infoItems.append(DriverInfoCardView.InfoItem(
                title: "Wikipedia",
                value: "View Profile",
                action: { [weak self] in
                    self?.openWebsite(url: wikipediaURL)
                }
            ))
        }
        
        careerInfoCard.configure(items: infoItems)
    }
    
    private func formatDateOfBirth(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MMMM d, yyyy"
        
        if let date = inputFormatter.date(from: dateString) {
            return outputFormatter.string(from: date)
        }
        return dateString
    }
    
    private func openWebsite(url: String) {
        guard let url = URL(string: url) else { return }
        UIApplication.shared.open(url)
    }
}

// MARK: - Layout
extension DriverDetailViewController {
    private func addSubviews() {
        view.addSubview(navigationBar)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Hero Section
        contentView.addSubview(heroSectionView)
        heroSectionView.addSubview(teamColorBannerView)
        heroSectionView.addSubview(headshotImageView)
        heroSectionView.addSubview(driverNumberLabel)
        heroSectionView.addSubview(nameStackView)
        heroSectionView.addSubview(teamNameLabel)
        heroSectionView.addSubview(countryInfoView)
        
        nameStackView.addArrangedSubview(firstNameLabel)
        nameStackView.addArrangedSubview(lastNameLabel)
        
        countryInfoView.addSubview(countryFlagLabel)
        countryInfoView.addSubview(countryNameLabel)
        
        // Stats Section
        contentView.addSubview(statsSection)
        statsSection.addSubview(statsSectionTitleLabel)
        statsSection.addSubview(statsStackView)
        
        statsStackView.addArrangedSubview(positionStatView)
        statsStackView.addArrangedSubview(pointsStatView)
        statsStackView.addArrangedSubview(winsStatView)
        
        // Info Cards
        contentView.addSubview(infoCardsStackView)
        infoCardsStackView.addArrangedSubview(standingInfoCard)
        infoCardsStackView.addArrangedSubview(personalInfoCard)
        infoCardsStackView.addArrangedSubview(careerInfoCard)
    }
    
    private func setupLayoutConstraints() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.horizontalEdges.bottom.equalTo(view)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        // Hero Section
        heroSectionView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(320)
        }
        
        teamColorBannerView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }
        
        headshotImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(32)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(120)
        }
        
        driverNumberLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.trailing.equalTo(headshotImageView.snp.leading).offset(-16)
            $0.width.equalTo(100)
        }
        
        nameStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(32)
            $0.top.equalTo(driverNumberLabel.snp.bottom).offset(8)
            $0.trailing.lessThanOrEqualTo(headshotImageView.snp.leading).offset(-16)
        }
        
        teamNameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(32)
            $0.top.equalTo(nameStackView.snp.bottom).offset(8)
        }
        
        countryInfoView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(32)
            $0.bottom.equalToSuperview().inset(24)
            $0.height.equalTo(30)
        }
        
        countryFlagLabel.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
        }
        
        countryNameLabel.snp.makeConstraints {
            $0.leading.equalTo(countryFlagLabel.snp.trailing).offset(8)
            $0.centerY.equalToSuperview()
            $0.trailing.lessThanOrEqualToSuperview()
        }
        
        // Stats Section
        statsSection.snp.makeConstraints {
            $0.top.equalTo(heroSectionView.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(120)
        }
        
        statsSectionTitleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(16)
        }
        
        statsStackView.snp.makeConstraints {
            $0.top.equalTo(statsSectionTitleLabel.snp.bottom).offset(12)
            $0.horizontalEdges.bottom.equalToSuperview().inset(16)
        }
        
        // Info Cards
        infoCardsStackView.snp.makeConstraints {
            $0.top.equalTo(statsSection.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(24)
        }
    }
}
