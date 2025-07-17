//
//  DriverUseCase.swift
//  BasePresentation
//
//  Created by JunHyeok Lee on 7/15/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import Foundation
import RxSwift

public protocol DriverUseCase {
    func getDrivers(year: Int) -> Single<[DriverModel]>
}
