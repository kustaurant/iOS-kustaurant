//
//  JsonSupport.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/22/24.
//

import Foundation

final class JsonSupport {
    
    static func loadRestaurantsFromJSON(fileName: String) -> [Restaurant]? {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            Logger.error("JSON 파일을 찾을 수 없습니다.", category: .file)
            return nil
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let restaurants = try decoder.decode([Restaurant].self, from: data)
            return restaurants
        } catch {
            Logger.error("JSON 디코딩 중 에러 발생: \(error)", category: .file)
            return nil
        }
    }
}

