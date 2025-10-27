//
//  Predators.swift
//  JPApexPredators
//
//  Created by Rajan Marathe on 08/09/25.
//

import Foundation

class Predators {
    var allApexPredators: [ApexPredator] = []
    var apexPredators: [ApexPredator] = []
    
    var allMovies: [String] = []
    
    init () {
        decodeApexPredatorData()
    }
    
    func decodeApexPredatorData() {
        if let url = Bundle.main.url(forResource: "jpapexpredators", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                allApexPredators = try decoder.decode([ApexPredator].self, from: data)
                apexPredators = allApexPredators
                
                // All Movies
                let allMoviesSet : Set<String> = allApexPredators
                    .flatMap { $0.movies }
                    .reduce(into: Set<String>()) { $0.insert($1) }
                allMovies = Array(allMoviesSet).sorted()
                allMovies.insert(contentsOf: ["All"], at: 0)
            } catch {
                print("Error decoding JSON data: \(error)")
            }
        }
    }
    
    func search(for searchTerm: String)-> [ApexPredator] {
        if searchTerm.isEmpty {
            return apexPredators
        } else {
            return apexPredators.filter { predator in
                predator.name.localizedCaseInsensitiveContains(searchTerm)
            }
        }
    }
    
    func sort(by alphabetical: Bool) {
        apexPredators.sort {predator1, predator2 in
            if alphabetical {
                predator1.name < predator2.name
            } else {
                predator1.id < predator2.id
            }
        }
    }
    
    func filter(by type: APType) {
        if type == .all {
            apexPredators = allApexPredators
        } else {
            apexPredators = allApexPredators.filter { predator in
                predator.type == type
            }
        }
//        let arr = SortAndFilterExercise().sortAndFilter(["lion", "tiger", "bear", "eagle", "Big Bird", "raccoon", "skunk", "Toothless", "aardvark", "baboon", "Old Yeller"])
//        print(arr)
    }
    
    func filter(by movie:String) {
        if movie == "All" {
            apexPredators = allApexPredators
        } else {
            apexPredators = allApexPredators.filter { predator in
                predator.movies.contains(movie)
            }
        }
    }
    
    func removePredators(at offsets: IndexSet, from filtered: [ApexPredator]) {
        // map displayed offsets -> actual predator IDs
        let idsToDelete = offsets.map { filtered[$0].id }
        
        // remove from master array by matching IDs
        apexPredators.removeAll { predator in
            idsToDelete.contains(predator.id)
        }
        allApexPredators.removeAll { predator in
            idsToDelete.contains(predator.id)
        }
    }
}
/*
class SortAndFilterExercise {
    func sortAndFilter(_ stringArray: [String]) -> [String] {
        let vowels: Set<Character> = ["a", "e", "i", "o", "u"]
        
        return stringArray
        // Filter: keep strings not starting with vowel
            .filter { str in
                guard let first = str.first?.lowercased().first else { return false }
                return !vowels.contains(first)
            }
        // Sort: case-insensitive (pre-computed lowercased version for efficiency)
            .sorted { $0.lowercased() > $1.lowercased() }
    }
}
*/
