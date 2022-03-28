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
    var indexPath : Int {get set}
    var currenImage : UIImage? {get set }
    var images : [Item] {get set }
    var token : String {get set}
    var model : ModelProtocol {get set}
    func  setToken ( from url : String , completion : @escaping (Bool) -> Void )
    func logout ( completion: @escaping (Bool) -> Void)
    func setUpTitle ( completion : (String) -> Void )
    func getRequest(completion : @escaping (Result<URLRequest,Errors>) -> Void)
    func encodeData ( completion : @escaping (Result<PhotosResponse,Errors>) -> Void)
    func loadImagesWithCach ( at index : Int,  completion : @escaping (UIImage?) -> Void)
}

final class ViewModel : ViewModelProtocol {
    var currenImage: UIImage?
    var indexPath: Int = 0
    var token = ""
    var isTokenValid: Bool
    var model: ModelProtocol
    var images = [Item]()
    
    init( model: ModelProtocol ){
        self.model = model
        isTokenValid = self.model.getToken().isValid
        token = self.model.getToken().token
    }
    
    func getRequest(completion : @escaping (Result<URLRequest,Errors>) -> Void){
        guard let url = URL(string: "https://oauth.vk.com/oauth/authorize?client_id=8115470&redirect_uri=https://oauth.vk.com/blank.html&scope=12&display=mobile&response_type=token") else {
            completion(.failure(.faildToCreateUrl))
            return
        }
        completion(.success(URLRequest(url: url)))
    }
    
    func setToken(from url: String, completion: @escaping (Bool) -> Void) {
        model.saveToken(url: url) { result in
            switch result {
            case .success(let token):
                self.token = token
                self.isTokenValid = true
                completion(true)
            case .failure( _):
                completion(false)
            }
        }
    }
    
    func logout(completion: @escaping (Bool) -> Void) {
        model.saveToken(url: model.cleanToken) { [weak self] result in
            switch result {
            case .success(let token):
                self?.token = token
                self?.isTokenValid = false
                print("succes logout")
                self?.cleanWebViewCash()
                self?.model.imageCash.removeAllObjects()
                completion( true)
            case .failure(_):
                completion(false)
                print("error in logout")
            }
        }
        
    }
    func cleanWebViewCash() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    
    func setUpTitle (completion : (String) -> Void ){
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.locale = Locale.current
        dateFormatterPrint.dateFormat = "d MMMM yyyy"
        let date = Date(timeIntervalSince1970: TimeInterval( images[indexPath].date))
        completion( "\(dateFormatterPrint.string(from: date))")
    }
    
    func encodeData (  completion : @escaping (Result<PhotosResponse,Errors>) -> Void){
        guard let url  = URL(string:  "https://api.vk.com/method/photos.get?owner_id=-128666765&album_id=266276915&rev=false&extended=false&photo_sizes=true&access_token=\(self.token)&v=5.131") else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, resp, error in
            guard let resp = resp else {
                return
            }
            guard  let httpRsponse = resp as? HTTPURLResponse else {
                return
            }
            if httpRsponse.statusCode >= 200 && httpRsponse.statusCode < 300{
                if let data = data {
                    let photosResponse = try? JSONDecoder().decode(PhotosResponse.self, from: data)
                    guard let photosResponse = photosResponse else {
                        DispatchQueue.main.async {
                            completion(.failure(.faildToDecodeData))
                        }
                        return
                    }
                    self.images = photosResponse.response.items
                    DispatchQueue.main.async {
                        completion(.success(photosResponse))
                    }
                }
            }else{
                DispatchQueue.main.async {
                    completion(.failure(.faildToLoadImageData))
                }
            }
        }
        task.resume()
    }
    
    func loadImagesWithCach (at index : Int, completion : @escaping (UIImage?) -> Void){
        guard let urlStr = self.images[index].sizes.last?.url else {
            completion(nil)
            return
        }
        if let cashedImage = model.imageCash.object(forKey: urlStr as NSString){
            completion(cashedImage)
        }else {
            guard let url = URL(string: urlStr) else {
                return
            }
            let request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 10)
            URLSession.shared.dataTask(with: request) {[weak self] data, response , error in
                guard let data = data else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                    return
                }
                guard let image = UIImage(data: data) else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                    return
                }
                self?.model.imageCash.setObject(image, forKey: urlStr as NSString)
                DispatchQueue.main.async {
                    completion(image)
                }
            }.resume()
        }
    }
}

