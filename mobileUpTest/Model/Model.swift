//
//  Model.swift
//  mobileUpTest
//
//  Created by Виталий on 25.03.2022.
//

import Foundation
import Locksmith
protocol NetworkManagerProtocol {
    var cleanToken : String {get set}
    var  imageCash : NSCache<NSString,UIImage>{get set}
    func saveToken(url: String, completion : @escaping (Result<String,Errors>) -> Void)
    func getToken( ) -> (token: String , isValid : Bool)    
}

class NetworkManager : NetworkManagerProtocol{
    var imageCash = NSCache<NSString, UIImage> ( )
    
    var cleanToken = ""
    
    init( ){
        saveFieldForKeyChain ( )
    }
    private func saveFieldForKeyChain ( ){
        do {
            try Locksmith.saveData(data: ["token" : "" , "expireDate" : 0 , "dateWhenRecive" : 0], forUserAccount: "userCreds")
        }
        catch {}
    }
    func saveToken(url: String, completion : @escaping (Result<String,Errors>) -> Void) {
        if url !=  cleanToken {
            let sepStr = url.components(separatedBy: CharacterSet(charactersIn: "#&"))
            var token = ""
            var expirDate = 0
            let dateWhenRecive = Date().timeIntervalSince1970
            for item in sepStr{
                if item.contains("access_token"){
                    token = item.components(separatedBy: "=")[1]
                }
                if item.contains("expires_in"){
                    guard let expirValue = Int(item.components(separatedBy: "=")[1])  else {
                        completion(.failure(.faildToSaveToken))
                        return
                    }
                    expirDate = expirValue
                }
            }
            writeKeyChain(token: token, expirDate: expirDate, dateWhenRecive: Int(dateWhenRecive)) { result in
                switch result {
                case .success(let token):
                    completion(.success(token))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }else {
            writeKeyChain(token: cleanToken , expirDate: 0 , dateWhenRecive: 0) { result in
                switch result {
                case .success(let token):
                    completion(.success(token))
                case .failure(let error):
                    completion(.failure(error))
                    print("error in model logout")
                }
            }
            imageCash.removeAllObjects()
        }
    }
    private func writeKeyChain(token : String , expirDate: Int  ,dateWhenRecive : Int ,  completion : @escaping (Result<String,Errors>) -> Void){
        do {
            try Locksmith.updateData(data: ["token" : token , "expireDate" : expirDate , "dateWhenRecive" : dateWhenRecive], forUserAccount: "userCreds")
            
            completion(.success(token))
        }
        catch {
            print("cant save empty")
            completion(.failure(.faildToSaveToken))
        }
    }
    func getToken() -> (token: String , isValid : Bool){
        guard let dict = Locksmith.loadDataForUserAccount(userAccount: "userCreds") else {
            return ("", false)
        }
        guard let token = dict["token"] as? String else {
            return  ("", false)
        }
        guard let expireDate = dict["expireDate"] as? Int else {
            return  ("", false)
        }
        guard let dateWhenRecive = dict["dateWhenRecive"] as? Int else {
            return  ("", false)
        }
        var isValid = true
        if Int(Date().timeIntervalSince1970) - dateWhenRecive > expireDate{
            isValid = false
        }
        if (!isValid){
            imageCash.removeAllObjects()
        }
        return (token : token, isValid : isValid)
    }
}
