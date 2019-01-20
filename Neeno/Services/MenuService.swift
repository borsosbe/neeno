import Foundation

class MenuService {
    private var generalPizzaOffers : [PizzaItem] = []
    public var pizzaList : PizzaList = PizzaList()
    public var ingredients : [Ingredient] = []
    public var drinks : [Drink] = []
    
    init(){}
    
    public func GetGeneralPizzaOffers() -> [PizzaItem]
    {
        for i in 0...pizzaList.PizzaInfos.count - 1 {
            generalPizzaOffers.append(PizzaItem())
            generalPizzaOffers[i].BasePrice = pizzaList.BasePrice
            generalPizzaOffers[i].Price = pizzaList.BasePrice
            generalPizzaOffers[i].ImageUrl = pizzaList.PizzaInfos[i].ImageUrl
            generalPizzaOffers[i].Name = pizzaList.PizzaInfos[i].Name
            generalPizzaOffers[i].IngredientsById = pizzaList.PizzaInfos[i].IngredientsById
            for j in 0...pizzaList.PizzaInfos[i].IngredientsById.count - 1 {
                generalPizzaOffers[i].IngredientsByName.append(String())
                generalPizzaOffers[i].IngredientsByName[j] = getIngredientFromIngredientId(id: pizzaList.PizzaInfos[i].IngredientsById[j])
                generalPizzaOffers[i].Price! += managePrice(id: pizzaList.PizzaInfos[i].IngredientsById[j])
            }
        }
        return generalPizzaOffers
    }
    
    public func GetPizzaType(pizza : PizzaItem ) -> PizzaType
    {
        for item in pizzaList.PizzaInfos {
            if (pizza.Name == item.Name) {
                if (pizza.IngredientsById.elementsEqual(item.IngredientsById)) { return .basic }
                else { return .basicPlus}
            }
        }
        return .custom
    }
    
    private func getIngredientFromIngredientId(id : Int64) -> String
    {
        for index in 0...ingredients.count {
            if(ingredients[index].Id == id ) { return ingredients[index].Name }
        }
        return "Ingredient not found"
    }
    
    private func managePrice(id : Int64) -> Double
    {
        for index in 0...ingredients.count {
            if(ingredients[index].Id == id ) { return ingredients[index].Price }
        }
        return 0
    }
}
