import Foundation

public struct Ingredient : Decodable {
    
    public var Id : Int64 // Long in documentation
    public var Name : String
    public var Price : Double
    
    enum CodingKeys : String, CodingKey {
        case Id = "id"
        case Name = "name"
        case Price = "price"
    }
}

public struct IngredientCell {
    public var Id : Int64
    public var Name : String
    public var Price : Double
    public var IsActive : Bool
    init(id : Int64, name : String, price : Double, isActive : Bool)
    {
        self.Id = id
        self.Name = name
        self.Price = price
        self.IsActive = isActive
    }
}
