//
//  Pokemon.swift
//  pokedex3
//
//  Created by Apple on 2017/8/17.
//  Copyright © 2017年 Hans. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionText: String!
    private var _nextEvolutionName: String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionLevel: String!
    private var _pokemonURL: String!
    
    var name: String {
        if _name == nil {
            _name = ""
        }
        return _name
    }
    
    var pokedexId: Int {
        if _pokedexId == nil {
            _pokedexId = 0
        }
        return _pokedexId
    }
    
    var description: String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    
    var nextEvolutionText: String {
        if _nextEvolutionText == nil {
            _nextEvolutionText = ""
        }
        return _nextEvolutionText
    }
    
    var nextEvolutionName: String {
        if _nextEvolutionName == nil {
            _nextEvolutionName = ""
        }
        return _nextEvolutionName
    }
    
    var nextEvolutionId: String {
        if _nextEvolutionId == nil {
            _nextEvolutionId = ""
        }
        return _nextEvolutionId
    }
    
    var nextEvolutionLevel: String {
        if _nextEvolutionLevel == nil {
            _nextEvolutionLevel = ""
        }
        return _nextEvolutionLevel
    }
    
    var pokemonURL: String {
        if _pokemonURL == nil {
            _pokemonURL = ""
        }
        return _pokemonURL
    }
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        self._pokemonURL = "\(BASE_URL)\(URL_POKEMON)\(pokedexId)/"
    }
    
    func downloadPokemonDetails(completed: @escaping DownloadComplete) {
        print(pokemonURL)
        Alamofire.request(pokemonURL).responseJSON { response in
            print("about to print json result")
            if let jsonDict = response.result.value as? Dictionary<String, Any> {
                
                // weight
                if let currWeight = jsonDict["weight"] as? String {
                    self._weight = currWeight
                }
                
                // height
                if let currHeight = jsonDict["height"] as? String {
                    self._height = currHeight
                }
                
                // attack
                if let currAttack = jsonDict["attack"] as? Int {
                    self._attack = "\(currAttack)"
                }
                
                // defense
                if let currDefense = jsonDict["defense"] as? Int {
                    self._defense = "\(currDefense)"
                }
                
                // types
                if let currTypes = jsonDict["types"] as? [Dictionary<String, String>], currTypes.count > 0 {
                    if let currType = currTypes[0]["name"] {
                        self._type = currType.capitalized
                        for i in 1..<currTypes.count {
                            self._type = self._type! + "/\(currTypes[i]["name"])"
                        }
                    }
                }
                
                // description
                if let currDescription = jsonDict["description"] as? [Dictionary<String, String>], currDescription.count > 0 {
                    if let url = currDescription[0]["resource_uri"] {
                        Alamofire.request("\(BASE_URL)\(url)").responseJSON { response in
                            
                            if let descriptionDict = response.result.value as? Dictionary<String, Any> {
                                if let desc = descriptionDict["description"] as? String {
                                    let newDesc = desc.replacingOccurrences(of: "POKMON", with: "Pokemon")
                                    self._description = newDesc
                                }
                            }
                        }
                    }
                }
                
                if let evolutions = jsonDict["evolutions"] as? [Dictionary<String, Any>], evolutions.count > 0 {
                    if let nextEvolution = evolutions[0]["to"] as? String {
                        if nextEvolution.range(of: "mega") == nil { // dont support mega
                            self._nextEvolutionName = nextEvolution
                            
                            if let uri = evolutions[0]["resource_uri"] as? String { // id is in the redirection uri
                                let newStr = uri.replacingOccurrences(of: URL_POKEMON, with: "")
                                self._nextEvolutionId = newStr.replacingOccurrences(of: "/", with: "")
                                
                                if let level = evolutions[0]["level"] as? Int {
                                    self._nextEvolutionLevel = "\(level)"
                                } else {
                                    self._nextEvolutionLevel = ""
                                }
                            }
                        }
                    }
                }
                print("weight is \(self.weight)")
                print("height is \(self.height)")
                print("attack is \(self.attack)")
                print("defense is \(self.defense)")
            }
            completed()
            
        }
    }
}
