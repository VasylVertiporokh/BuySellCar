//
//  UserInfoViewModel.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 01.03.2023.
//

import Combine
import Foundation

enum UserInfoViewModelEvents {
    case showUserInfo(UserDomainModel)
}

final class UserInfoViewModel: BaseViewModel {
    // MARK: - Private properties
    private let userService: UserService
    let tempService: AdvertisementNetworkService
    
    let searchDict: [SearchParam] = [
        .init(key: .price, value: .lessOrEqualTo(intValue: 50500)),
        .init(key: .price, value: .greaterOrEqualTo(intValue: 6500))
    ]
    
    
    // MARK: - Subjects
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<UserInfoTransition, Never>()
    
    private(set) lazy var eventsPublisher = eventsSubject.eraseToAnyPublisher()
    private let eventsSubject = PassthroughSubject<UserInfoViewModelEvents, Never>()
    
    init(userService: UserService, tempService: AdvertisementNetworkService) {
        self.userService = userService
        self.tempService = tempService
        super.init()
    }
    
    override func onViewDidLoad() {
        userService.userDomainPublisher
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] model in
                guard let model = model else {
                    return
                }
                eventsSubject.send(.showUserInfo(model))
            }
            .store(in: &cancellables)
        
        
        tempService.searchAdvertisement(searchParams: searchDict)
            .sink { error in
                print(error)
            } receiveValue: { _ in
                
            }
            .store(in: &cancellables)
    }
}
