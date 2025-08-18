//
//  RaceRepository.swift
//  BaseDomain
//
//  Created by JunHyeok Lee on 8/12/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import Foundation
import RxSwift

public protocol RaceRepository {
    func getRaces(year: Int) -> Single<[Race]>
    func getRound(year: Int, round: Int) -> Single<[Race]>
    func getRaceDriver(driverName: String) -> Single<[Race]>
    func getRaceConstructor(constructorName: String) -> Single<[Race]>
    func getRaceGrid(gridPosition: Int) -> Single<[Race]>
    func getRaceStatus(statusId: Int) -> Single<[Race]>
}
