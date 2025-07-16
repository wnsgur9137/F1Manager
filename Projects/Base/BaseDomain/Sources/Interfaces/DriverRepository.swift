//
//  DriverRepository.swift
//  BaseDomain
//
//  Created by JunHyeok Lee on 7/15/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import Foundation
import RxSwift

public protocol DriverRepository {
    func getDrivers(year: Int) -> Single<[Driver]>
}
