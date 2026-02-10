//
//  HomeViewState.swift
//  AISmartDirector
//
//  Created by Ece Akcay on 9.02.2026.
//

import Foundation

///🎯 Amaç
///ViewController “ne göstereceğim?” diye düşünmesin
///Sadece state’e göre hareket etsin

enum HomeViewState {
    case idle
    case loading
    case loaded([Movie])
    case error(String)
}
