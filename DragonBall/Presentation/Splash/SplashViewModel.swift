//
//  SplashViewModel.swift
//  DragonBalliOSAvanzado
//
//  Created by Pedro on 19/10/23.
//

import Foundation


class SplashViewModel: SplashViewControllerDelegate {
    private let apiProvider: ApiProviderProtocol
    private let secureDataProvider: SecureDataProviderProtocol

    var viewState: ((SplashViewState) -> Void)?

    lazy var loginViewModel: LoginViewControllerDelegate = {
        LoginViewModel(
            apiProvider: apiProvider,
            secureDataProvider: secureDataProvider
        )
    }()

    lazy var heroesViewModel: HeroesViewControllerDelegate = {
        HeroesViewModel(
            apiProvider: apiProvider,
            secureDataProvider: secureDataProvider
        )
    }()

    private var isLogged: Bool {
        secureDataProvider.getToken()?.isEmpty == false
    }


    init(apiProvider: ApiProviderProtocol, secureDataProvider: SecureDataProviderProtocol) {
        self.apiProvider = apiProvider
        self.secureDataProvider = secureDataProvider
    }

    func onViewAppear() {
        viewState?(.loading(true))

        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(2)) {
            self.isLogged ? self.viewState?(.navigateToHeroes) : self.viewState?(.navigateToLogin)
        }
    }
}
