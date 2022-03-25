//
//  model.swift
//  mobileUpTest
//
//  Created by Виталий on 25.03.2022.
//

import Foundation
// https://oauth.vk.com/authorize?client_id=8115470&redirect_uri=http://localhost&scope=12&display=mobile

class NetworkManager {
    
   static func getRequest(completion : @escaping (Result<URLRequest,Error>) -> Void){
        guard let url = URL(string: "https://oauth.vk.com/oauth/authorize?client_id=8115470&redirect_uri=https://oauth.vk.com/blank.html&scope=12&display=mobile&response_type=token") else {
            completion(.failure(Errors.faildToCreateUrl))
            return
        }
        completion(.success(URLRequest(url: url)))
    }
    static func encodeData ( url : URL , completion : @escaping (PhotosResponse) -> Void){
        var token = ""
        if("\(url)".contains("#access_token=") ){
            let garb = "\(url)"
            token = garb.components(separatedBy: CharacterSet(charactersIn: "=/&")).filter {item in
                return item.count > 30}.first!
            
        }
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
}
