//
//  ViewModel.swift
//  mobileUpTest
//
//  Created by Виталий on 26.03.2022.
//

import Foundation
import WebKit
protocol ViewModelProtocol {
    var isTokenValid : Bool {get set}
    var images : [Item] {get set }
    var token : String {get set}
    var networkManager : NetworkManagerProtocol {get set}
    func  setToken ( from url : String , completion : @escaping (Result<String,Errors>) -> Void )
    func logout ( completion: @escaping (Result<String,Errors>) -> Void)
}

class ViewModel : ViewModelProtocol {
    
    var token = ""
    var isTokenValid: Bool
    var networkManager: NetworkManagerProtocol
    var images = [Item]()
    
    
    
    init( networkManager: NetworkManagerProtocol ){
        self.networkManager = networkManager
        isTokenValid = self.networkManager.getToken().isValid
        token = self.networkManager.getToken().token
    }
    
    
    
    func setToken(from url: String, completion: @escaping (Result<String,Errors>) -> Void) {
        networkManager.saveToken(url: url) { result in
            switch result {
            case .success(let token):
                self.token = token
                self.isTokenValid = true
                
                completion(.success("done"))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
    }
    func logout(completion: @escaping (Result<String,Errors>) -> Void) {
        
        networkManager.saveToken(url: networkManager.cleanToken) { [weak self] result in
            switch result {
            case .success(let token):
                self?.token = token
                self?.isTokenValid = false
                print("succes logout")
                self?.cleanWebViewCash()
                completion( .success(token))
            case .failure(let error):
                completion(.failure(error))
                print("error in logout")
            }
        }
        
    }
    func cleanWebViewCash() {
            HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
            print("[WebCacheCleaner] All cookies deleted")
            
            WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
                records.forEach { record in
                    WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
                    print("[WebCacheCleaner] Record \(record) deleted")
                }
            }
        }
    
    

}

