//
//  SoftwareDetailViewModel.swift
//  SoftwareStore
//
//  Created by 차소민 on 4/7/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SoftwareDetailViewModel: CommonViewModel {
    
    struct Input {
        let data: BehaviorSubject<Result>
        let downloadButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let data: Driver<Result>
        let downloadButtonTap: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        
        return Output.init(data: input.data.asDriver(onErrorJustReturn: Result(artworkUrl512: "", screenshotUrls: [], trackName: "", trackViewUrl: "", contentAdvisoryRating: "", formattedPrice: "", artistName: "", genres: [], price: 0, description: "", version: "")), downloadButtonTap: input.downloadButtonTap.asDriver(onErrorJustReturn: ()))
    }

}
