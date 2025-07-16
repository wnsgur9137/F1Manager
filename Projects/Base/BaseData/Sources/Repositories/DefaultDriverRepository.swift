//
//  DefaultDriverRepository.swift
//  BaseData
//
//  Created by JunHyeok Lee on 7/15/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import Foundation
import RxSwift

import NetworkInfra
import BaseDomain

enum DriverNetworkError: Error {
    case driverNotFound
}

public final class DefaultDriverRepository: DriverRepository {
    
    private let networkManager: NetworkManager
    
    public init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    private func handle(_ error: Error) -> Error {
        if let driverNetworkError = error as? DriverNetworkError {
            switch driverNetworkError {
            case .driverNotFound: return DriverError.driverNotFound
            }
        }
        return error
    }
    
    private func getDriverDetail(driverNumber: Int) -> Single<DriverDetailResponseDTO> {
        let driverDetailDTO = networkManager.getDriverDetail(driverNumber: driverNumber)
        return driverDetailDTO
    }
}

extension DefaultDriverRepository {
    public func getDrivers(year: Int) -> Single<[Driver]> {
        return networkManager
            .getDrivers(year: year)
            .flatMap { driverDTOs in
                guard !driverDTOs.isEmpty else {
                    return Single.just([])
                }
                
                let driverSingles: [Single<Driver>] = driverDTOs.map { driverDTO in
                    guard let driverNumberString = driverDTO.driverNumber,
                          let driverNumber = Int(driverNumberString) else {
                        return Single.just(driverDTO.toDomain(driverDetail: nil))
                    }
                    
                    return self.getDriverDetail(driverNumber: driverNumber)
                        .map { detailDTO in
                            return driverDTO.toDomain(driverDetail: detailDTO)
                        }
                        .catch { error in
                            // 개별 드라이버 실패 시 기본 정보만 반환
                            return Single.just(driverDTO.toDomain(driverDetail: nil))
                        }
                }
                
                // Single.zip 사용 시 모든 Single이 성공해야 함
                return Single.zip(driverSingles)
            }
            .catch { error in
                return Single.error(self.handle(error))
            }
    }
}
