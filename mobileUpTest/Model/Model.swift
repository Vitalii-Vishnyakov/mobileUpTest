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
    func getRequest(completion : @escaping (Result<URLRequest,Error>) -> Void)
    func encodeData ( with token : String , completion : @escaping (PhotosResponse) -> Void)
    func saveToken(url: String, completion : @escaping (Result<String,Errors>) -> Void)
    func getToken( ) -> (token: String , isValid : Bool)
    func loadImagesWithCach ( urlStr : String , completion : @escaping (UIImage?) -> Void)
}

class NetworkManager : NetworkManagerProtocol{
    var imageCash = NSCache<NSString, UIImage> ( )
    
    var cleanToken = ""
    
    init( ){
        do {
            try Locksmith.saveData(data: ["token" : "" , "expireDate" : 0 , "dateWhenRecive" : 0], forUserAccount: "userCreds")
        }
        catch {
         
        }
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
        if Int(Date().timeIntervalSince1970) - dateWhenRecive >= expireDate{
            isValid = false
        }
        if (!isValid){
            imageCash.removeAllObjects()
        }
        return (token : token, isValid : isValid)
        
        
        
    }
    
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
                DispatchQueue.main.async {
                    completion(photosResponse)
                }
                
            }
            else{
                print("PHoto error")
            }
        }
        task.resume()
        
    }
    func loadImagesWithCach ( urlStr : String , completion : @escaping (UIImage?) -> Void){
        
        if let cashedImage = imageCash.object(forKey: urlStr as NSString){
            completion(cashedImage)
            
        }else {
            guard let url = URL(string: urlStr) else {
                return
            }
            
            let request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 10)
            URLSession.shared.dataTask(with: request) { data, response , error in
                guard let data = data else {
                    
                    return
                }
                guard let image = UIImage(data: data) else {
                    
                    return
                }
                self.imageCash.setObject(image, forKey: urlStr as NSString)
                
                DispatchQueue.main.async {
                    completion(image)
                }
            }.resume()
        }
        
        
    }
    
}
