//
//  ViewModel.swift
//  mobileUpTest
//
//  Created by Виталий on 26.03.2022.
//

import Foundation
protocol ViewModelProtocol {
    var isTokenValid : Bool {get set}
    var networkManager : NetworkManagerProtocol {get set}
    func  setToken ( from url : String , completion : @escaping (Errors) -> Void )
}

class ViewModel : ViewModelProtocol {
    var isTokenValid: Bool
    var networkManager: NetworkManagerProtocol
    init( networkManager: NetworkManagerProtocol ){
        self.networkManager = networkManager
        isTokenValid = true //networkManager.getToken().isValid
    }
    
    func setToken(from url: String, completion: @escaping (Errors) -> Void) {
        let sepStr = url.components(separatedBy: CharacterSet(charactersIn: "#&"))
        var token = ""
        var expirDate = ""
        let dateWhenRecive = Date()
        for item in sepStr{
            if item.contains("access_token"){
                token = item.components(separatedBy: "=")[1]
            }
            if item.contains("expires_in"){
                expirDate = item.components(separatedBy: "=")[1]
            }
        }
        
        networkManager.saveToken(token: token, expireDate: Int(expirDate), dateWhenRecive: Int(dateWhenRecive.timeIntervalSince1970)) { result in
            
        }
        completion(.faildToGetToken)
    }
    
    

}

