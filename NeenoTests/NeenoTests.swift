import Foundation
import XCTest

@testable import Neeno

class NeenoTests : XCTestCase {
    
    //JsonTests
    func testGetIngredientsFromJson()
    {
        // escaped current json from Ingredients API
        let data = Data("[{\"price\":1,\"name\":\"Mozzarella\",\"id\":1},{\"price\":0.5,\"name\":\"Tomato Sauce\",\"id\":2},{\"price\":1.5,\"name\":\"Salami\",\"id\":3},{\"price\":2,\"name\":\"Mushrooms\",\"id\":4},{\"price\":4,\"name\":\"Ricci\",\"id\":5},{\"price\":2,\"name\":\"Asparagus\",\"id\":6},{\"price\":1,\"name\":\"Pineapple\",\"id\":7},{\"price\":3,\"name\":\"Speck\",\"id\":8},{\"price\":2.5,\"name\":\"Bottarga\",\"id\":9},{\"price\":2.2,\"name\":\"Tuna\",\"id\":10}]".utf8)
        
        let jsonService = JsonService()
        let ingFirst = Ingredient(Id: 1, Name: "Mozzarella", Price: 1)
        let ingLast = Ingredient(Id: 10, Name: "Tuna", Price: 2.2)
        
        let result = jsonService.GetIngredientsFromJson(jsonData: data)
        // Test the first and the last element, they are should be a match
        XCTAssertEqual(ingFirst.Name, result[0].Name)
        XCTAssertEqual(ingFirst.Id, result[0].Id)
        XCTAssertEqual(ingFirst.Price, result[0].Price)
        XCTAssertEqual(ingLast.Name, result[result.count - 1].Name)
        XCTAssertEqual(ingLast.Id, result[result.count - 1].Id)
        XCTAssertEqual(ingLast.Price, result[result.count - 1].Price)
    }
    
    func testGetDrinksFromJson()
    {
        // escaped current json from drinks API
        let data = Data("[{\"price\":1,\"name\":\"Still Water\",\"id\":1},{\"price\":1.5,\"name\":\"Sparkling Water\",\"id\":2},{\"price\":2.5,\"name\":\"Coke\",\"id\":3},{\"price\":3,\"name\":\"Beer\",\"id\":4},{\"price\":4,\"name\":\"Red Wine\",\"id\":5}]".utf8)
        
        let jsonService = JsonService()
        let drinkFirst = Drink(Id: 1, Name: "Still Water", Price: 1)
        let drinkLast = Drink(Id: 5, Name: "Red Wine", Price: 4)
        
        let result = jsonService.GetDrinksFromJson(jsonData: data)
        // Test the first and the last element, they are should be a match
        XCTAssertEqual(drinkFirst.Name, result[0].Name)
        XCTAssertEqual(drinkFirst.Id, result[0].Id)
        XCTAssertEqual(drinkFirst.Price, result[0].Price)
        XCTAssertEqual(drinkLast.Name, result[result.count - 1].Name)
        XCTAssertEqual(drinkLast.Id, result[result.count - 1].Id)
        XCTAssertEqual(drinkLast.Price, result[result.count - 1].Price)
    }
    
    func testGetPizzasFromJson()
    {
        // escaped current json from drinks API
        let data = Data("{\"basePrice\":4,\"pizzas\":[{\"ingredients\":[1,2],\"name\":\"Margherita\",\"imageUrl\":\"https://cdn.pbrd.co/images/M57yElqQo.png\"},{\"ingredients\":[1,5],\"name\":\"Ricci\",\"imageUrl\":\"https://cdn.pbrd.co/images/M58jWCFVC.png\"},{\"ingredients\":[1,2,3,4],\"name\":\"Boscaiola\",\"imageUrl\":\"https://cdn.pbrd.co/images/tOhJQ5N3.png\"},{\"ingredients\":[1,5,6],\"name\":\"Primavera\",\"imageUrl\":\"https://cdn.pbrd.co/images/M57VcfLGQ.png\"},{\"ingredients\":[1,2,7,8],\"name\":\"Hawaii\",\"imageUrl\":\"https://cdn.pbrd.co/images/M57lNSLnC.png\"},{\"ingredients\":[1,9,10],\"name\":\"Mare Bianco\"},{\"ingredients\":[1,2,4,8,9,10],\"name\":\"Mari e monti\",\"imageUrl\":\"https://cdn.pbrd.co/images/M57K6OFiU.png\"},{\"ingredients\":[1,9],\"name\":\"Bottarga\",\"imageUrl\":\"https://cdn.pbrd.co/images/M57aGTmgA.png\"},{\"ingredients\":[1,2,9,6],\"name\":\"Boottarga e Asparagi\",\"imageUrl\":\"https://cdn.pbrd.co/images/4O6T9RQLX.png\"},{\"ingredients\":[1,5,6],\"name\":\"Ricci e Asparagi\",\"imageUrl\":\"https://cdn.pbrd.co/images/4O70NDkMl.png\"}]}".utf8)
        
        let jsonService = JsonService()
        let pizzaSixth = Pizza(name: "Mare Bianco", ingredientsById: [1,9,10])
        let pizzaFirst = Pizza(name: "Margherita", ingredientsById: [1,2])
        let basePrice = 4.0
        let result = jsonService.GetPizzasFromJson(jsonData: data)
        // Test the 6th pizza and the first in the 2th place and aslo test the basPrice
        
        XCTAssertEqual(basePrice, result.BasePrice)
        XCTAssertEqual(pizzaSixth.Name, result.PizzaInfos[5].Name)
        XCTAssertEqual(pizzaSixth.IngredientsById, result.PizzaInfos[5].IngredientsById)
        XCTAssertNotEqual(pizzaFirst.Name, result.PizzaInfos[1].Name)
        XCTAssertNotEqual(pizzaFirst.IngredientsById, result.PizzaInfos[1].IngredientsById)
    }

    // Testing backend GetMenu method
    // TODO -- should test each api call seperatly
    func testGetMenu ()
    {
        let backendService = BackendService()
        var menu = MenuService()
        // should be empty
        XCTAssertEqual(menu.drinks.isEmpty, true)
        XCTAssertEqual(menu.ingredients.isEmpty, true)
        XCTAssertEqual(menu.pizzaList.PizzaInfos.isEmpty, true)
        
        backendService.GetMenu() {(result: Any) in
            menu = result as! MenuService
            // Test if get any drinks from backend
            XCTAssertNotEqual(menu.drinks.isEmpty, false)
            // Test if get any ingredients from backend
            XCTAssertNotEqual(menu.ingredients.isEmpty, false)
            // Test if get any pizzas from backend
            XCTAssertNotEqual(menu.pizzaList.PizzaInfos.isEmpty, false)
        }
    }
    
    func testGetPizzaType()
    {
        let menuService = MenuService()
        // setup just the part that the method is using
        menuService.pizzaList.PizzaInfos = [Pizza(name: "Margherita", ingredientsById: [1,2]),
                                            Pizza(name: "Hawaii", ingredientsById: [1,2,7,8])]
        
        let basicMargherita = PizzaItem(basePrice: 4, name: "Margherita", ingredientsByName: [""],                               ingredientsById: [1,2,], pizzaType: .basic)
        let basicPlusMargherita = PizzaItem(basePrice: 4, name: "Margherita", ingredientsByName: [""], ingredientsById: [1,2,3], pizzaType: .basicPlus)
        let basicHawaii = PizzaItem(basePrice: 4, name: "Hawaii", ingredientsByName: [""],                               ingredientsById: [1,2,7,8], pizzaType: .basic)
        // Custom pizza with the Hawaii's ingredients
        let customPizza = PizzaItem(basePrice: 4, name: "Custom", ingredientsByName: [""],                               ingredientsById: [1,2,7,8], pizzaType: .custom)
        
        let basicMargheritaResult = menuService.GetPizzaType(pizza: basicMargherita)
        let basicPlusMargheritaResult = menuService.GetPizzaType(pizza: basicPlusMargherita)
        let basicHawaiiResult = menuService.GetPizzaType(pizza: basicHawaii)
        let customPizzaResult = menuService.GetPizzaType(pizza: customPizza)
        
        XCTAssertEqual(basicMargheritaResult, PizzaType.basic)
        XCTAssertEqual(basicPlusMargheritaResult, PizzaType.basicPlus)
        XCTAssertEqual(basicHawaiiResult, PizzaType.basic)
        XCTAssertEqual(customPizzaResult, PizzaType.custom)
    }
}
