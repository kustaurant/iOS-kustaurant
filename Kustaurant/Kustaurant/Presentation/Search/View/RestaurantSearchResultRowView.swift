//
//  RestaurantSearchResultRowView.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/22/24.
//

import SwiftUI

struct RestaurantSearchResultRowView: View {
    
    private let restaurant: Restaurant
    
    init(restaurant: Restaurant) {
        self.restaurant = restaurant
    }
    
    var body: some View {
        HStack(spacing: 0) {
            restaurantThumbnail
            VStack {
                HStack {
                    restaurantTitles
                    Spacer()
                    favoritesAndEvaluated
                }
                Divider()
            }
        }
    }
}

extension RestaurantSearchResultRowView {
    
    var restaurantThumbnail: some View {
        ZStack(alignment: .topLeading) {
            if let restaurantImgUrl = restaurant.restaurantImgUrl {
                AsyncImage(url: URL(string: restaurantImgUrl)) { image in
                    image.resizable()
                        .scaledToFill()
                        .cornerRadius(10)
                        .frame(width: 55, height: 55)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                } placeholder: {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(Color(uiColor: .Sementic.gray100 ?? .lightGray))
                        .cornerRadius(10)
                        .frame(width: 55, height: 55)
                }
            }
            
            TierBadgeView(tier: restaurant.mainTier)
        }
        .padding(.trailing, 20)
    }
    
    var restaurantTitles: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(restaurant.restaurantName ?? "")
                .foregroundStyle(Color(uiColor: .Sementic.gray800 ?? .darkGray))
                .font(Font(UIFont.Pretendard.medium16))
            HStack {
                Text("\(restaurant.restaurantCuisine ?? "") ㅣ \(restaurant.restaurantPosition ?? "")")
                    .foregroundStyle(Color(uiColor: .Sementic.gray400 ?? .darkGray))
                    .font(Font(UIFont.Pretendard.regular12))
            }
        }
    }
    
    var favoritesAndEvaluated: some View {
        VStack {
            HStack(alignment: .top, spacing: 4) {
                if let isFavorite = restaurant.isFavorite {
                    if isFavorite {
                        Image("icon_favorite")
                    }
                }
                if let isEvaluated = restaurant.isEvaluated {
                    if isEvaluated {
                        Image("icon_check")
                    }
                }
            }
            Spacer()
        }
    }
}

#Preview {
    RestaurantSearchResultRowView(
        restaurant: JsonSupport.loadRestaurantsFromJSON(fileName: "Restaurants")![5]
    )
    .frame(width: 300, height: 55)
}
