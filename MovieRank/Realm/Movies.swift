//
//  Movies.swift
//  MovieRank
//
//  Created by 박연배 on 2021/11/02.
//

import Foundation
import RealmSwift

class Movies: Object {
    @Persisted var movies: List<Movie>
    @Persisted(primaryKey: true) var id: String
    
    convenience init(movies: List<Movie>, id: String) {
        self.init()
        
        self.movies = movies
        self.id = id
    }
}
