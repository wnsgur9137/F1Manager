//
//  HomeViewController.swift
//  HomePresentation
//
//  Created by JUNHYEOK LEE on 7/13/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import RxGesture

import BasePresentation

public final class HomeViewController: UIViewController, View {
    
    // MARK: - UI Instances
    
    private let navigationBar = NavigationBar(.nonButton)
    
    private lazy var driversCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(DriverCollectionViewCell.self, forCellWithReuseIdentifier: DriverCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    private let sectionHeaderView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let driversLabel: UILabel = {
        let label = UILabel()
        label.text = "Drivers"
        label.font = .f1(.bold, size: 24)
        label.textColor = .label
        return label
    }()
    
    private let seeAllButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("See All", for: .normal)
        button.titleLabel?.font = .f1(.regular, size: 16)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    // MARK: - Properties
    
    private var drivers: [DriverModel] = []
    
    public var disposeBag = DisposeBag()
    
    // MARK: - Life cycle
    
    public static func create(with reactor: HomeReactor) -> HomeViewController {
        let viewController = HomeViewController()
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
        setupNavigationBar()
        setupSeeAllButton()
        addSubviews()
        setupLayoutConstraints()
        
        navigationBar.rx
            .tapGesture()
            .when(.recognized)
            .bind(onNext: { _ in
                let reactor = LiveTrackingReactor()
                let viewController = LiveTrackingViewController.create(with: reactor)
                self.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupNavigationBar() {
        navigationBar.setTitle("F1 Manager")
    }
    
    private func setupSeeAllButton() {
        seeAllButton.addTarget(self, action: #selector(seeAllButtonTapped), for: .touchUpInside)
    }
    
    @objc private func seeAllButtonTapped() {
        reactor?.action.onNext(.navigateToDriverList)
    }
    
    public func bind(reactor: HomeReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
}

// MARK: - Bind
extension HomeViewController {
    private func bindAction(_ reactor: HomeReactor) {
        rx.viewDidLoad
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: HomeReactor) {
        reactor.pulse(\.$drivers)
            .compactMap { $0 }
            .map { drivers in
                return Array(drivers
                    .sorted { (first, second) in
                        guard let firstPosition = first.standingPosition,
                              let secondPosition = second.standingPosition else {
                            return false
                        }
                        return firstPosition < secondPosition
                    }
                    .prefix(5))
            }
            .bind(onNext: { [weak self] drivers in
                self?.drivers = drivers
                self?.driversCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$error)
            .compactMap { $0 }
            .bind(onNext: { error in
                
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Layout
extension HomeViewController {
    private func addSubviews() {
        view.addSubview(navigationBar)
        view.addSubview(sectionHeaderView)
        view.addSubview(driversCollectionView)
        
        [
            driversLabel,
            seeAllButton
        ].forEach {
            sectionHeaderView.addSubview($0)
        }
    }
    
    private func setupLayoutConstraints() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        sectionHeaderView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(20)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }
        
        driversLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        
        seeAllButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        
        driversCollectionView.snp.makeConstraints {
            $0.top.equalTo(sectionHeaderView.snp.bottom).offset(16)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(200)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return drivers.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DriverCollectionViewCell.identifier, for: indexPath) as? DriverCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let driver = drivers[indexPath.item]
        cell.configure(with: driver)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 140, height: 200)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.item < drivers.count else { return }
        let selectedDriver = drivers[indexPath.item]
        reactor?.action.onNext(.driverSelected(selectedDriver))
    }
}
