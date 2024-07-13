//
//  DownloadResponse.swift
//  Kustaurant
//
//  Created by 류연수 on 7/13/24.
//

import Foundation

public final class DownloadResponse: Response {
    let url: URL?
    
    init(url: URL?, error: NetworkError?) {
        self.url = url
        
        super.init(data: nil, error: error)
    }
}
