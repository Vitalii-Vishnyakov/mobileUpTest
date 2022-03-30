//
//  Model.swift
//  mobileUpTest
//
//  Created by Виталий on 25.03.2022.
//

import Foundation
import KeychainSwift
protocol ModelProtocol {
    var cleanToken : String {get set}
    var isTest : Bool {get set}
    var keyChain : KeychainSwift {get set}
    var  imageCash : NSCache<NSString,UIImage>{get set}
    func saveToken(url: String, completion : @escaping (Result<String,Errors>) -> Void)
    func getToken( ) -> (token: String , isValid : Bool)
}

final class Model : ModelProtocol{
    var keyChain = KeychainSwift()
    var isTest: Bool = false
    
    var imageCash = NSCache<NSString, UIImage> ( )
    
    var cleanToken = ""
    
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
        let isTokenSuccess =  keyChain.set(token, forKey: "token\(isTest)", withAccess: nil)
        let isExpirDateSuccess =  keyChain.set(String(expirDate), forKey: "expireDate\(isTest)", withAccess: nil)
        let isDateWhenReciveSuccess = keyChain.set(String(dateWhenRecive), forKey: "dateWhenRecive\(isTest)", withAccess: nil)
        if isTokenSuccess && isExpirDateSuccess && isDateWhenReciveSuccess{
            completion(.success(token))
        }
        else {
            completion(.failure(.faildToSaveToken))
        }
    }
    func getToken() -> (token: String , isValid : Bool){
        let token = keyChain.get("token\(isTest)")
        let expireDate = keyChain.get("expireDate\(isTest)")
        let dateWhenRecive = keyChain.get("dateWhenRecive\(isTest)")
        guard expireDate != nil ,
              dateWhenRecive != nil ,
              let token = token,
              let expireDateInt = Int(expireDate!) ,
              let dateWhenReciveInt = Int(dateWhenRecive!) else {
                  imageCash.removeAllObjects()
                  return ("", false)
              }
        var isValid = true
        if Int(Date().timeIntervalSince1970) - dateWhenReciveInt > expireDateInt{
            isValid = false
        }
        if (!isValid){
            imageCash.removeAllObjects()
        }
        return (token : token, isValid : isValid)
    }
}
