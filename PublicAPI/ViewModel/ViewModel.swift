//
//  ViewModel.swift
//  PublicAPI
//
//  Created by Unsal Oner on 7.02.2023.
//

import Foundation

class ViewModel{
    
    
    func fetchAPI(completion: @escaping (API?) -> Void) {
        
        let url = URL(string:"https://api.publicapis.org/entries")!
        
         URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                print(error?.localizedDescription ?? "Error")
            }
             if let data = data {
                do{
                    let apiList = try JSONDecoder().decode(API.self, from: data)
                        completion(apiList)
                }catch let error{
                    print(error)
                    completion(nil)
                }
            }
        }.resume()
    }
}

struct ViewListModel {
    
    let apis : Entry
    
    init(apis: Entry) {
        self.apis = apis
    }
    
    var api : String {
        return self.apis.api
    }
    var link : String {
        return self.apis.link
    }
    var description :String {
        return self.apis.description
    }
    var isHttps : Bool {
        return self.apis.https
    }
    
}
