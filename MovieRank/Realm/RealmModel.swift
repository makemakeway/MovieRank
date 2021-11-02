//
//  RealmModel.swift
//  MovieRank
//
//  Created by 박연배 on 2021/11/02.
//

import Foundation
import RealmSwift

class Movie: Object {
    @Persisted var openDt: String
    @Persisted var rank: String
    @Persisted var movieNm: String
    
    convenience init(openDt: String, rank: String, movieNm: String) {
        self.init()
        
        self.openDt = openDt
        self.movieNm = movieNm
        self.rank = rank
    }
}
