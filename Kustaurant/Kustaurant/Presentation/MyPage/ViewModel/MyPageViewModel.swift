//
//  MyPageViewModel.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/19/24.
//

import Foundation

struct MyPageViewModelActions {
}

protocol MyPageViewModelInput {}
protocol MyPageViewModelOutput {}

typealias MyPageViewModel = MyPageViewModelInput & MyPageViewModelOutput

final class DefaultMyPageViewModel: MyPageViewModel {
}
