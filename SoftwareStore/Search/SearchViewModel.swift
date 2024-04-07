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
    }
    
    struct Output {
        let software: PublishSubject<[Result]>
        let selectSofeware: Driver<Result>
    }
    
    func transform(input: Input) -> Output {
        let software = PublishSubject<[Result]>()

        input.searchButtonTap
            .withLatestFrom(input.searchText.orEmpty)
            .flatMap {
                StoreNetwork.fetchStore(searchText: $0)
            }
            .subscribe(onNext: { result in
                software.onNext(result)
            }, onError: { _ in
                print("==== Transform Error")
            }, onCompleted: {
                print("==== Transform Completed")
            }, onDisposed: {
                print("==== Transform Disposed")
            })
            .disposed(by: disposeBag)
                
        return Output.init(software: software, selectSofeware: input.tableViewItem.asDriver())
    }
    
}
