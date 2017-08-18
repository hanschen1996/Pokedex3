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
            print(response.result.value!)
            if let jsonDict = response.result.value as? Dictionary<String, Any> {
                if let currWeight = jsonDict["weight"] as? String {
                    self._weight = currWeight
                }
                
                if let currHeight = jsonDict["height"] as? String {
                    self._height = currHeight
                }
                
                if let currAttack = jsonDict["attack"] as? Int {
                    self._attack = "\(currAttack)"
                }
                
                if let currDefense = jsonDict["defense"] as? Int {
                    self._defense = "\(currDefense)"
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
