//
//  StoreNetwork.swift
//  SoftwareStore
//
//  Created by 차소민 on 4/5/24.
//

import Foundation


final class StoreNetwork {
    static func fetchStore(searchText: String) {
        guard let url = URL(string: "https://itunes.apple.com/search?term=\(searchText)&country=KR&media=software") else {
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                return
            }
            
            guard let data else { return }
            
            do {
                let appData = try JSONDecoder().decode(Store.self, from: data)
                print(appData)
            }
            catch {
                print("디코딩 실패")
            }
        }
        .resume()
    }
}
