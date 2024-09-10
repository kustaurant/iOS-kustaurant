//
//  SearchView.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/22/24.
//

import SwiftUI

struct SearchView: View {
    
    @ObservedObject var viewModel: SearchViewModel
    @FocusState var isSearchBarFocused: Bool
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            VStack {
                HStack {
                    backButton
                    Spacer()
                    searchBar
                }
                .padding(.bottom, 20)
                
                if viewModel.isSearching {
                    ProgressView()
                } else if !viewModel.isSearching && viewModel.restaurants.isEmpty {
                    VStack {
                        noRestaurantsView
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.restaurants) { restaurant in
                                RestaurantSearchResultRowView(restaurant: restaurant)
                                    .onTapGesture {
                                        viewModel.didTapRestaurant(restaurantId: restaurant.restaurantId ?? 0)
                                    }
                            }
                        }
                    }
                    .scrollIndicators(.hidden)
                }
                Spacer()
            }
            .padding(.horizontal, 20)
            .toolbar(.hidden, for: .navigationBar)
            .background(
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        isSearchBarFocused = false
                    }
            )
        }
    }
}

extension SearchView {
    var backButton: some View {
        Button(action: {
            viewModel.didTapBackButton()
        }, label: {
            Image("icon_back")
        })
    }
    
    var searchButton: some View {
        Button(action: {
            viewModel.searchRestaurants()
            isSearchBarFocused = false
        }, label: {
            Image("icon_search_gray")
                .padding(.horizontal, 14)
        })
    }
    
    var searchBar: some View {
        HStack {
            ZStack(alignment: .leading) {
                if viewModel.searchText.isEmpty {
                    Text("검색어를 입력하세요...")
                        .foregroundColor(Color(uiColor: .Sementic.gray300 ?? .gray))
                        .font(Font(UIFont.Pretendard.regular14))
                        .padding(.leading, 16)
                }
                TextField(
                    "",
                    text: $viewModel.searchText
                )
                .focused($isSearchBarFocused)
                .padding(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 10))
                .foregroundColor(Color(uiColor: .Sementic.gray800 ?? .black))
                .font(Font(UIFont.Pretendard.regular14))
                .onSubmit {
                    viewModel.searchRestaurants()
                    isSearchBarFocused = false
                }
            }
            Spacer()
            searchButton
        }
        .frame(height: 48)
        .background(Color(uiColor: .Sementic.gray100 ?? .lightGray))
        .cornerRadius(30)
    }
    
    var noRestaurantsView: some View {
        VStack {
            Image("img_search_empty")
            Text("해당 검색어에 맞는 식당이 없어요.")
                .foregroundStyle(Color(uiColor: .Sementic.gray300 ?? .lightGray))
                .font(Font(UIFont.Pretendard.semiBold17))
        }
        .padding(.top, 200)
    }
}

#Preview {
    SearchView(
        viewModel: SearchViewModel(
            actions: SearchViewModelActions(didTapBackButton: {}, didTapRestaurant: { _ in }),
            searchUseCases: MockSearchUseCases()))
}

struct MockSearchUseCases: SearchUseCases {
    func search(term: String) async -> Result<[Restaurant], NetworkError> {
        let restaurants = JsonSupport.loadRestaurantsFromJSON(fileName: "Restaurants")
        return .success(restaurants ?? [])
    }
}
