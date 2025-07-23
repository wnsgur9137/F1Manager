//
//  Lottie+init.swift
//  BasePresentation
//
//  Created by JunHyeok Lee on 7/22/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import UIKit
import Lottie

extension LottieAnimationView {
    public enum LottieAnimationResourceName: String {
        case splash
    }
    
    private static var basePresentationBundle: Bundle {
        return Bundle.module
    }
    
    public convenience init(
        name: LottieAnimationResourceName,
        bundle: Bundle? = nil,
        subdirectory: String? = nil,
        imageProvider: AnimationImageProvider? = nil,
        animationCache: AnimationCacheProvider? = LottieAnimationCache.shared,
        configuration: LottieConfiguration = .shared
    ) {
        let targetBundle = bundle ?? Self.basePresentationBundle
        let animation = LottieAnimation.named(name.rawValue, bundle: targetBundle, subdirectory: subdirectory, animationCache: animationCache)
        let provider = imageProvider ?? BundleImageProvider(bundle: targetBundle, searchPath: nil)
        self.init(animation: animation, imageProvider: provider, configuration: configuration)
    }
}
