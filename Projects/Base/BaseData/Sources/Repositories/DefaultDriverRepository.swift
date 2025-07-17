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
    
    private func getLatestDriverDetails() -> Single<[DriverDetailResponseDTO]> {
        let driverDetailDTOs = networkManager.getLatestDriverDetails()
        return driverDetailDTOs
    }
}

extension DefaultDriverRepository {
    public func getDrivers(year: Int) -> Single<[Driver]> {
        return Single.zip(
            networkManager.getDrivers(year: year),
            getLatestDriverDetails()
        )
        .map { (driverDTOs, driverDetailDTOs) -> [Driver] in
            guard !driverDTOs.isEmpty else {
                return []
            }
            
            let drivers: [Driver] = driverDTOs.compactMap { driverDTO in
                guard let driverNumberString = driverDTO.driverNumber,
                      let driverNumber = Int(driverNumberString) else {
                    return driverDTO.toDomain(driverDetail: nil)
                }
                
                // 드라이버 번호가 일치하는 첫 번째 DetailDTO 찾기
                let matchingDetail = driverDetailDTOs.first { detailDTO in
                    if driverNumber == 33 { // api에서는 1번을 사용하지 않음 (예시 2025 Max verstappen -> 33)
                        return detailDTO.driverNumber == 1
                        || driverNumber == detailDTO.driverNumber
                    }
                    return driverNumber == detailDTO.driverNumber
                }
                
                if let matchingDetail = matchingDetail {
                    return driverDTO.toDomain(driverDetail: matchingDetail)
                } else {
                    return driverDTO.toDomain(driverDetail: nil)
                }
            }
            
            return drivers
        }
        .catch { error in
            return Single.error(self.handle(error))
        }
    }
}
