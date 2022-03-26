//
//  Model.swift
//  mobileUpTest
//
//  Created by Виталий on 25.03.2022.
//

import Foundation
import Locksmith
protocol NetworkManagerProtocol {
    var token : String {get set}
    func getRequest(completion : @escaping (Result<URLRequest,Error>) -> Void)
    func encodeData ( with token : String , completion : @escaping (PhotosResponse) -> Void)
    func getToken( url : String)
    func saveToken(token : String , expireDate : Int? , dateWhenRecive : Int, completion : @escaping (Result<String,Errors>) -> Void)
    func getToken( ) -> (token: String , isValid : Bool)
}

class NetworkManager : NetworkManagerProtocol{
    func saveToken(token: String, expireDate: Int?, dateWhenRecive: Int , completion : @escaping (Result<String,Errors>) -> Void) {
        guard let expireDate = expireDate else {
            completion(.failure(.faildToSaveToken))
            return
        }
        do {
            try Locksmith.saveData(data: ["token" : token , "expireDate" : expireDate , "dateWhenRecive" : dateWhenRecive], forUserAccount: "userCreds")
            completion(.success("Token Saved"))
            
        }
        catch {
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
        print(dict)
        
        
        return (token : token, isValid : true)
    }
    
    public var token = ""
    
    func getRequest(completion : @escaping (Result<URLRequest,Error>) -> Void){
        guard let url = URL(string: "https://oauth.vk.com/oauth/authorize?client_id=8115470&redirect_uri=https://oauth.vk.com/blank.html&scope=12&display=mobile&response_type=token") else {
            completion(.failure(Errors.faildToCreateUrl))
            return
        }
        completion(.success(URLRequest(url: url)))
    }
    
     func encodeData ( with token : String , completion : @escaping (PhotosResponse) -> Void){
            let url  = URL(string:  "https://api.vk.com/method/photos.get?owner_id=-128666765&album_id=266276915&rev=false&extended=false&photo_sizes=true&access_token=\(token)&v=5.131")
            let task = URLSession.shared.dataTask(with: url!) { data, resp, error in
                if let data = data {
                    let photosResponse = try? JSONDecoder().decode(PhotosResponse.self, from: data)
                    guard let photosResponse = photosResponse else {
                        return
                    }
                    completion(photosResponse)
                }
                else{
                    print("PHoto error")
                }
            }
            task.resume()
        
    }
    func getToken ( url : String){
        
        if(url.contains("#access_token=")){
            let arr = url.components(separatedBy: "&")
            print(arr)
            
        }
    }
}
