//
//  TierBadgeView.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/22/24.
//

import SwiftUI

struct TierBadgeView: View {
    
    private let tier: Tier?
    
    init(tier: Tier?) {
        self.tier = tier
    }
    
    var body: some View {
        if let tier = tier, tier != .unowned {
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .foregroundStyle(Color(uiColor: tier.backgroundColor()))
                Image(tier.iconImageName)
                    .resizable()
                    .frame(width: 20, height: 20)
            }
            .frame(width: 20, height: 20)
        }
    }
}

#Preview {
    Group {
        VStack(spacing: 10) {
            TierBadgeView(tier: Tier.first)
            TierBadgeView(tier: Tier.second)
            TierBadgeView(tier: Tier.third)
            TierBadgeView(tier: Tier.fourth)
            TierBadgeView(tier: Tier.unowned)
        }
    }
}
