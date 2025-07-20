//
//  UIImageView+Kingfisher.swift
//  BasePresentation
//
//  Created by JUNHYEOK LEE on 7/20/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    @discardableResult
    public func setImage(
        _ imageURLString: String?,
        placeholder: Kingfisher.Placeholder? = nil,
        options: KingfisherOptionsInfo? = nil,
        completionHandler: ((Result<RetrieveImageResult, KingfisherError>) -> Void)? = nil
    ) -> DownloadTask? {
        guard let imageURLString = imageURLString,
              let imageURL = URL(string: imageURLString) else { return nil }
        return setImage(
            imageURL,
            placeholder: placeholder,
            options: options,
            completionHandler: completionHandler
        )
    }
    
    @discardableResult
    public func setImage(
        _ imageURL: URL,
        placeholder: Kingfisher.Placeholder? = nil,
        options: KingfisherOptionsInfo? = nil,
        completionHandler: ((Result<RetrieveImageResult, KingfisherError>) -> Void)? = nil
    ) -> DownloadTask? {
        let options = options != nil ? options : [
            .transition(.fade(0.2)),
            .cacheOriginalImage,
            .scaleFactor(UIScreen.main.scale)
        ]
        return kf.setImage(
            with: imageURL,
            placeholder: placeholder,
            options: options
        )
    }
}
