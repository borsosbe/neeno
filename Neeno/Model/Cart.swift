import Foundation

struct CartItem : Codable {
    public var Name : String
    public var Price : Double
    public var DrinkId : Int64?
    public var IngredientsById : [Int64]?
    
    init(name: String, price: Double) {
        Name = name
        Price = price
    }
    
    init(name: String, price: Double, drinkId: Int64?, ingredientsById: [Int64]?) {
        Name = name
        Price = price
        DrinkId = drinkId
        IngredientsById = ingredientsById
    }
}
