import Foundation

class JsonService {
    
    let ingredientsURL = URL(string: "https://api.myjson.com/bins/ozt3z")
    let drinksUrl = URL(string: "https://api.myjson.com/bins/150da7")
    let pizzaListUrl = URL(string: "https://api.myjson.com/bins/dokm7")
    let postURL = URL(string: "http://ptsv2.com/t/nennos_pizza/post")
    let decoder = JSONDecoder()
    
    public func GetIngredientsFromJson(jsonData: Data) -> [Ingredient] {
        do {
            let model = try decoder.decode([Ingredient].self, from:
                jsonData)
            return model
        } catch let parsingError {
            print("Error", parsingError)
        }
        return [Ingredient]()
    }

    public func GetDrinksFromJson(jsonData: Data) -> [Drink] {
        do {
            let model = try decoder.decode([Drink].self, from:
                jsonData)
            return model
        } catch let parsingError {
            print("Error", parsingError)
        }
         return [Drink]()
    }
    
    public func GetPizzasFromJson(jsonData: Data) ->  PizzaList {
        do {
            let model = try decoder.decode(PizzaList.self, from:
                jsonData)
            return model
        } catch let parsingError {
            print("Error", parsingError)
        }
        return PizzaList()
    }
    
    public func GetCartJson(cartList : [CartItem]) -> Data
    {
        var drinks = [Int64]()
        var pizzas = [Dictionary<String, Any>]()
        var dictInfos = Dictionary<String, Any>() // Pizza Object
        
        for item in cartList {
            if (item.DrinkId != nil) { drinks.append(item.DrinkId!) }
            else {
                do
                {
                    dictInfos["name"] = item.Name
                    dictInfos["ingredients"] = item.IngredientsById!
                    pizzas.append(dictInfos)
                }
            }
        }
        drinks.sort{$0 < $1} // order drinkIds from 1 ... 5
        var dictOrder = Dictionary<String, Any>()
        
        dictOrder["drinks"] = drinks
        dictOrder["pizzas"] = pizzas
        
        do {
            let data = try JSONSerialization.data(withJSONObject: dictOrder, options: [])
            return data
        } catch {
            print("Error -> \(error)")
        }
        return Data()
    }
}

