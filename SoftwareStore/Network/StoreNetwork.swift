//
//  StoreNetwork.swift
//  SoftwareStore
//
//  Created by 차소민 on 4/5/24.
//

import Foundation
import RxSwift
import RxCocoa

enum APIError: String, Error {
    case invalidURL = "잘못된 URL"
    case unknownResponse = "알 수 없는 응답"
    case statusError = "상태코드 오류"
    case decodingError = "응답은 왔으나 디코딩 실패"
}


final class StoreNetwork {
    static func fetchStore(searchText: String) -> Observable<[Result]> {
        
        return Observable<[Result]>.create { observer in
            guard let url = URL(string: "https://itunes.apple.com/search?term=\(searchText)&country=KR&media=software") else {
                observer.onError(APIError.invalidURL)
                return Disposables.create()
            }
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let _ = error {
                    observer.onError(APIError.unknownResponse)
                    return
                }
                
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    observer.onError(APIError.statusError)
                    return
                }
                
                guard let data else { return }
                
                do {
                    let appData = try JSONDecoder().decode(Store.self, from: data)
                    observer.onNext(appData.results)
                    observer.onCompleted() //✅
                }
                catch {
                    observer.onError(APIError.decodingError)
                }
            }
            .resume()
            return Disposables.create()
        }
    }
    
    
    static func fetchStoreSingle(searchText: String) -> Single<[Result]> {
        
        return Single<[Result]>.create { single in
            guard let url = URL(string: "https://itunes.apple.com/search?term=\(searchText)&country=KR&media=software") else {
                single(.failure(APIError.invalidURL))
                return Disposables.create()
            }
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let _ = error {
                    single(.failure(APIError.unknownResponse))
                    return
                }
                
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    single(.failure(APIError.statusError))
                    return
                }
                
                guard let data else { return }
                
                do {
                    let appData = try JSONDecoder().decode(Store.self, from: data)
                    single(.success(appData.results))
                }
                catch {
                    single(.failure(APIError.decodingError))
                }
            }
            .resume()
            return Disposables.create()
        }
        .debug("FetchSingle❗️")
    }
}
