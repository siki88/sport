//
//  Section.swift
//  omega
//
//  Created by Lukas Spurny on 20.08.18.
//  Copyright © 2018 LEKSYS s.r.o. All rights reserved.
//

import Foundation

struct Section {
    var genre: String!
    var clen: [String]!
    var neclen: [String]!
    var movies: [String]!
    var expanded: Bool!
    
    init(genre: String, movies: [String], expanded: Bool, clen: [String], neclen: [String]){
        self.genre = genre
        self.movies = movies
        self.expanded = expanded
        self.clen = clen
        self.neclen = neclen
    }
    
}
