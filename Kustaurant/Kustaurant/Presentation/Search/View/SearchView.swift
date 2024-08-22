//
//  SearchView.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/22/24.
//

import SwiftUI

struct SearchView: View {
    
    @ObservedObject var viewModel: SearchViewModel
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        Text("123")
    }
}

#Preview {
    SearchView(viewModel: SearchViewModel(searchUseCases: MockSearchUseCases()))
}

struct MockSearchUseCases: SearchUseCases {
    func search(term: String) async -> Result<[Restaurant], NetworkError> {
        let restaurants = JsonSupport.loadRestaurantsFromJSON(fileName: "Restaurants")
        return .success(restaurants ?? [])
    }
}
