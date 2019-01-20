import Foundation

public struct Drink : Decodable {
   
    public var Id : Int64 // Long in documentation
    public var Name : String
    public var Price : Double
    
    enum CodingKeys : String, CodingKey {
        case Id = "id"
        case Name = "name"
        case Price = "price"
    }
}
