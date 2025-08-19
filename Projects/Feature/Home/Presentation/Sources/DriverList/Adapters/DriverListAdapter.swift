//
//  DriverListAdapter.swift
//  HomePresentation
//
//  Created by JunHyeok Lee on 8/18/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import UIKit

import BasePresentation

protocol DriverListDataSource: AnyObject {
    func numberOfRows(in section: Int) -> Int
    func cellForRow(at indexPath: IndexPath) -> DriverModel?
}

protocol DriverListDelegate: AnyObject {
    func heightForRow(at indexPath: IndexPath) -> CGFloat
    func didSelectRow(at indexPath: IndexPath)
}

final class DriverListAdapter: NSObject {
    
    private let driversTableView: UITableView
    private weak var dataSource: DriverListDataSource?
    private weak var delegate: DriverListDelegate?
    
    init(
        driversTableView: UITableView,
        dataSource: DriverListDataSource?,
        delegate: DriverListDelegate?
    ) {
        self.driversTableView = driversTableView
        self.dataSource = dataSource
        self.delegate = delegate
        super.init()
        self.registerDriverListTableViewCells()
        self.driversTableView.dataSource = self
        self.driversTableView.delegate = self
    }
    
    private func registerDriverListTableViewCells() {
        driversTableView.register(
            DriverListTableViewCell.self,
            forCellReuseIdentifier: DriverListTableViewCell.identifier
        )
    }
}

// MARK: - UITableViewDataSource
extension DriverListAdapter: UITableViewDataSource {
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
                withIdentifier: DriverListTableViewCell.identifier,
                for: indexPath
            ) as? DriverListTableViewCell else {
            return UITableViewCell()
        }
        guard let driver = dataSource?.cellForRow(at: indexPath) else { return cell }
        cell.configure(with: driver)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension DriverListAdapter: UITableViewDelegate {
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
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.didSelectRow(at: indexPath)
    }
}
