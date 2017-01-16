import Foundation
import Alamofire

class Pokemon
{
    private var _name:String!
    private var _pokedexID:Int!
    
    
    
    private var _description:String!
    private var _type:String!
    private var _defense:String!
    private var _height:String!
    private var _weight:String!
    private var _attack:String!
    private var _nextEvolutionTxt:String!
    private var _nextEvolutionName:String!
    private var _nextEvolutionId:String!
    private var _nextEvolutionLevel:String!
    private var _pokemonURL:String!
    
    var nextEvolutionName:String
    {
        if _nextEvolutionName == nil
        {
            _nextEvolutionName = ""
        }
        return _nextEvolutionName
    }
    
    var nextEvolutionId:String
    {
        if _nextEvolutionId == nil
        {
            _nextEvolutionId = ""
        }
        return _nextEvolutionId
    }
    
    var nextEvolutionLevel:String
    {
        if _nextEvolutionLevel == nil
        {
            _nextEvolutionLevel = ""
        }
        return _nextEvolutionLevel
    }
    
    var nextEvolutionTxt:String
    {
        if _nextEvolutionTxt == nil
        {
            _nextEvolutionTxt = ""
        }
        return _nextEvolutionTxt
    }
    
    var attack:String
    {
        if _attack == nil
        {
            _attack = ""
        }
        return _attack
    }
    
    var weight:String
    {
        if _weight == nil
        {
            _weight = ""
        }
        return _weight
    }
    
    var height:String
    {
        if _height == nil
        {
            _height = ""
        }
        return _height
    }
    
    var defense:String
    {
        if _defense == nil
        {
            _defense = ""
        }
        return _defense
    }
    
    var type:String
    {
        if _type == nil
        {
            _type = ""
        }
        return _type
    }
    
    var description:String
    {
        if _description == nil
        {
            _description = ""
        }
        return _description
    }
    
    
    var name:String
    {
        return _name
    }
    
    var pokedexID:Int
    {
        return _pokedexID
    }
    
    init(name:String, pokeDexID:Int)
    {
        self._name = name
        self._pokedexID = pokeDexID
        
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexID)"
    }
    
    func downloadPokemonDetails(donwloadCompleted: @escaping DownloadComplete)
    {
        Alamofire.request(_pokemonURL).responseJSON
        { (response) in
            if let dict = response.result.value as? Dictionary<String,AnyObject>
            {
                if let weight = dict["weight"] as? String
                {
                    self._weight = weight
                }
                
                if let height = dict["height"] as? String
                {
                    self._height = height
                }
                
                if let attack = dict["attack"] as? Int
                {
                    self._attack = "\(attack)"
                }
                
                if let defense = dict["defense"] as? Int
                {
                    self._defense = "\(defense)"
                }
            
                if let types = dict["types"] as? [Dictionary<String,AnyObject>] , types.count > 0
                {
                    /*
                     This is working perfectly fine but i was forcing it to have two types even if it had just one.....*/
                    
                    if let name1 = types[0]["name"] as? String
                    {
                        self._type = name1.capitalized
                    }
                    if types.count > 1
                    {
                        if let name2 = types[1]["name"] as? String
                        {
                            self._type = "\(self._type!)/\(name2)"
                        }
                    }
                    /*
                    if let name = types[0]["name"]
                    {
                        self._type = name.capitalized
                    }
                    
                    if types.count > 1
                    {
                        for x in 1..<types.count
                        {
                            if let name = types[x]["name"]
                            {
                                self._type! += "/\(name.capitalized!)"
                            }
                        }
                    }
                    */
                    
                }
                else
                {
                    self._type = "NOT FOUND"
                }
                
                if let descArray = dict["descriptions"] as? [Dictionary<String,String>] , descArray.count > 0
                {
                    if let url = descArray[0]["resource_uri"]
                    {
                        let descURL = "\(URL_BASE)\(url)"
                        Alamofire.request(descURL).responseJSON(completionHandler:
                            { (response) in
                                if let descDictionary = response.result.value as? Dictionary<String,AnyObject>
                                {
                                    if let description = descDictionary["description"] as? String
                                    {
                                        let desc = description.replacingOccurrences(of: "POKMON", with: "Pokemon")
                                        self._description = desc

                                    }
                                }
                                donwloadCompleted()
                        })
                    }
                }
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String,AnyObject>] , evolutions.count > 0
                {
                    if let nextEvolution = evolutions[0]["to"] as? String
                    {
                        if nextEvolution.range(of: "mega") == nil
                        {
                            self._nextEvolutionName = nextEvolution
                            if let uri = evolutions[0]["resource_uri"] as? String
                            {
                                let newStr = uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                                let nextEvoId = newStr.replacingOccurrences(of: "/", with: "")
                                
                                self._nextEvolutionId = nextEvoId
                                
                                if let lvlExist = evolutions[0]["level"]
                                {
                                    if let lvl = lvlExist as? Int
                                    {
                                        self._nextEvolutionLevel = "\(lvl)"
                                    }
                                }
                                else
                                {
                                    self._nextEvolutionLevel = ""
                                }
                            }
                        }
                    }
                    print(self._nextEvolutionId!)
                    print(self._nextEvolutionLevel!)
                    print(self._nextEvolutionTxt!)
                    print(self._nextEvolutionName!)
                }
            }
            donwloadCompleted()
        }
    }
}
