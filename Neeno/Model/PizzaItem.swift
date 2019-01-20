import Foundation

public struct PizzaList : Decodable {
   
    public var BasePrice : Double = 0
    public var PizzaInfos : [Pizza] = []
   
    enum CodingKeys : String, CodingKey {
        case BasePrice = "basePrice"
        case PizzaInfos = "pizzas"
    } 
    
    enum PizzaKeys: String, CodingKey {
        case pizza
    }
    
    init(baseprice : Double, pizzaInfos : [Pizza]) {
        BasePrice = baseprice
        PizzaInfos = pizzaInfos
    }
    init() {}
}

public struct Pizza : Codable {
    
    public var Name : String = ""
    public var IngredientsById : [Int64] = []
    public var ImageUrl : String?
    
    enum CodingKeys : String, CodingKey {
        case IngredientsById = "ingredients"
        case Name = "name"
        case ImageUrl = "imageUrl"
    }
    
    init(name: String, ingredientsById: [Int64]) {
        IngredientsById = ingredientsById
        Name = name
    }
}

public struct PizzaItem {
    public var BasePrice : Double = 0
    public var Name : String = ""
    public var IngredientsByName : [String] = []
    public var IngredientsById : [Int64] = []
    public var ImageUrl : String?
    public var Price : Double?
    var PizzaType : PizzaType = .basic
    
    init(basePrice : Double, name : String, ingredientsByName : [String], ingredientsById : [Int64], pizzaType: PizzaType)
    {
        BasePrice = basePrice
        Name = name
        IngredientsByName = ingredientsByName
        IngredientsById = ingredientsById
        PizzaType = pizzaType
    }

    init(){}
}

enum PizzaType {
    case basic
    case basicPlus
    case custom
}


