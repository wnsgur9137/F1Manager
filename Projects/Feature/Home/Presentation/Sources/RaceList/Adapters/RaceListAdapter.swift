//
//  RaceListAdapter.swift
//  HomePresentation
//
//  Created by JunHyeok Lee on 8/18/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

import BasePresentation

protocol RaceListDataSource: AnyObject {
    func numberOfRows(in section: Int) -> Int
    func cellForRow(at indexPath: IndexPath) -> RaceModel?
}

protocol RaceListDelegate: AnyObject {
    func heightForRow(at indexPath: IndexPath) -> CGFloat
    func didSelectRow(at indexPath: IndexPath)
}

final class RaceListAdapter: NSObject {
    
    private let raceListTableView: UITableView
    private weak var dataSource: RaceListDataSource?
    private weak var delegate: RaceListDelegate?
    
    init(
        raceListTableView: UITableView,
        dataSource: RaceListDataSource?,
        delegate: RaceListDelegate?
    ) {
        self.raceListTableView = raceListTableView
        self.dataSource = dataSource
        self.delegate = delegate
        super.init()
        self.registerRaceListTableViewCells()
        self.raceListTableView.dataSource = self
        self.raceListTableView.delegate = self
    }
    
    private func registerRaceListTableViewCells() {
        raceListTableView.register(
            RaceListTableViewCell.self,
            forCellReuseIdentifier: RaceListTableViewCell.identifier
        )
    }
}

// MARK: - UITableViewDataSource
extension RaceListAdapter: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return dataSource?.numberOfRows(in: section) ?? 0
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView
            .dequeueReusableCell(
                withIdentifier: RaceListTableViewCell.identifier,
                for: indexPath
            ) as? RaceListTableViewCell else {
            return UITableViewCell()
        }
        guard let race = dataSource?.cellForRow(at: indexPath) else { return cell }
        cell.configure(with: race)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension RaceListAdapter: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return delegate?.heightForRow(at: indexPath) ?? 0
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        delegate?.didSelectRow(at: indexPath)
    }
}
