//
//  MovieAPIManager.swift
//  MovieRank
//
//  Created by 박연배 on 2021/11/02.
//

import Foundation
import SwiftyJSON
import Alamofire

class MovieAPIManager {
    static let shared = MovieAPIManager()
    
    private init() {}
    
    func fetchMoviesRank(date: String, result: @escaping (JSON)->() ) {
        
        let url = "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=\(API.API_KEY)&targetDt=\(date)"
        
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                result(json)
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
