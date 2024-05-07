//
//  Service.swift
//  day7-CoreData2
//
//  Created by Mina on 01/05/2024.
//

import Foundation
import CoreData
class Service {
    static let shared = Service()
    private init(){}
    func fetchData(completionHandler: @escaping ([Movie]?) -> Void){
        let url = URL(string: "https://api.themoviedb.org/3/movie/top_rated?api_key=abe7089daa19c4b98bff89bb7fe1acac")
        let request = URLRequest(url: url!)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { data, response, error in
            do {
                let json = try JSONDecoder().decode(Movies.self, from: data!)
                
                completionHandler(json.results)
            }catch {
                print(error.localizedDescription)
                completionHandler(nil)
            }
        }
        task.resume()
    }
}
