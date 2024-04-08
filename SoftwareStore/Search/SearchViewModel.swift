//
//  SearchViewModel.swift
//  SoftwareStore
//
//  Created by 차소민 on 4/5/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchViewModel: CommonViewModel {
    let disposeBag = DisposeBag()
    
    struct Input {
        let searchButtonTap: ControlEvent<Void>
        let searchText: ControlProperty<String?>
        let tableViewItem: ControlEvent<Result>
//        let downloadTap: PublishRelay<ControlEvent<Void>>
        let freeButtonTap: ControlEvent<Void>
        let paidButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let software: PublishSubject<[Result]>
        let selectSofeware: Driver<Result>
//        let downloadTap: Driver<Void>
        let freeButtonTap: Driver<[Result]>
        let paidButtonTap: Driver<[Result]>
        let networkError: Driver<Error>
    }
    
    func transform(input: Input) -> Output {
        let origin = PublishSubject<[Result]>()
        let software = PublishSubject<[Result]>()
        let networkError = PublishSubject<Error>()

        input.searchButtonTap
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .debug()
            .withLatestFrom(input.searchText.orEmpty)
            .flatMap {
                StoreNetwork.fetchStoreSingle(searchText: $0)
                    .catch { error in
                        networkError.onNext(error)
                        return Single<[Result]>.never()
                    }
            }
            .share()
            .subscribe(onNext: { result in
                software.onNext(result)
                origin.onNext(result)
            }, onError: { _ in
                print("==== Transform Error")
            }, onCompleted: {
                print("==== Transform Completed")
            }, onDisposed: {
                print("==== Transform Disposed")
            })
            .disposed(by: disposeBag)
                
        let freeButtonTap = input.freeButtonTap
            .withLatestFrom(origin)
            .map { $0.filter { $0.formattedPrice == "무료" }}
            .asDriver(onErrorJustReturn: [])
        
        freeButtonTap
            .drive(software)
            .disposed(by: disposeBag)
        
        let paidButtonTap = input.paidButtonTap
            .withLatestFrom(origin)
            .map { $0.filter { $0.formattedPrice != "무료" }}
            .asDriver(onErrorJustReturn: [])
        
        paidButtonTap
            .drive(software)
            .disposed(by: disposeBag)

        
        return Output.init(software: software, selectSofeware: input.tableViewItem.asDriver(), freeButtonTap: freeButtonTap, paidButtonTap: paidButtonTap, networkError: networkError.asDriver(onErrorJustReturn: APIError.decodingError))
    }
    
}
