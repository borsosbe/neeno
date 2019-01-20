import Foundation

class BackendService {
    let backendURL = URL(string: "https://api.myjson.com/bins")
    let postURL = URL(string: "http://ptsv2.com/t/nennos_pizza/post")
    let ingredientsURL = "ozt3z"
    let drinksUrl = "150da7"
    let pizzaListUrl = "dokm7"
    let jsonService : JsonService
    
    init(jsonService: JsonService = JsonService())
    {
        self.jsonService = jsonService
    }
    
    private func getIngredients(str: String, completion:@escaping ([Ingredient]) -> Void) {
        let url = URL(string: (backendURL?.absoluteString)! + "/" + str)
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return completion([Ingredient]()) }
            completion(self.jsonService.GetIngredientsFromJson(jsonData: dataResponse))
        }
        task.resume()
    }
    
    private func getDrinks(str: String, completion:@escaping ([Drink]) -> Void) {
         let url = URL(string: (backendURL?.absoluteString)! + "/" + str)
         let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return completion([Drink]())}
             completion(self.jsonService.GetDrinksFromJson(jsonData: dataResponse))
        }
        task.resume()
    }
    
    private func getPizzas(str: String, completion:@escaping (PizzaList) -> Void) {
        let url = URL(string: (backendURL?.absoluteString)! + "/" + str)
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return completion(PizzaList()) }
            completion(self.jsonService.GetPizzasFromJson(jsonData: dataResponse))
        }
        task.resume()
    }

    //Method just to execute request, assuming the response type is string (and not file)
    private func HTTPsendRequest(request: URLRequest, callback: @escaping (Error?, String?) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { (data, res, err) in
            if (err != nil) {
                callback(err,nil)
            } else {
                callback(nil, String(data: data!, encoding: String.Encoding.utf8))
            }
        }
        task.resume()
    }
    
    // post JSON
    private func HTTPPostJSON(url: URL,  data: Data,
                              callback: @escaping (Error?, String?) -> Void) {
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.addValue("application/json",forHTTPHeaderField: "Content-Type")
        request.addValue("application/json",forHTTPHeaderField: "Accept")
        request.httpBody = data
        HTTPsendRequest(request: request, callback: callback)
    }
    
    //Checking the APIs
    private func checkIsDone(counter: Int) -> Bool
    {
        if(counter == 3) { return true }
        else { return false }
    }
    
    public func GetMenu(completion:@escaping (Any) -> Void) {
        let menu = MenuService()
        var counter = 0
        var errorCode = 0
        getIngredients(str: ingredientsURL) {(result: [Ingredient]) in
            if (result.isEmpty) { errorCode = 1 }
            menu.ingredients = result
            counter = counter + 1
            if (self.checkIsDone(counter: counter) && errorCode == 0) { completion(menu) }
             else if(self.checkIsDone(counter: counter)) { completion(errorCode) }
        }
        getDrinks(str: drinksUrl) {(result: [Drink]) in
            if (result.isEmpty) { errorCode = 2 }
            menu.drinks = result
            counter = counter + 1
            if(self.checkIsDone(counter: counter) && errorCode == 0) { completion(menu) }
             else if(self.checkIsDone(counter: counter)) { completion(errorCode) }
        }
        getPizzas(str: pizzaListUrl) {(result: PizzaList) in
            if (result.BasePrice != result.BasePrice) { errorCode = 3 }
            menu.pizzaList = result
            counter = counter + 1
            if(self.checkIsDone(counter: counter) && errorCode == 0) { completion(menu) }
            else if(self.checkIsDone(counter: counter)) { completion(errorCode) }
        }
    }
    
    public func SendOrder(cartList: [CartItem], completion:@escaping (Int) -> Void)
    {
        let data = jsonService.GetCartJson(cartList: cartList)
        print("Result -> \(String(describing: data))")
        
        HTTPPostJSON(url: postURL!, data: data) { (err, result) in
            if(err != nil){
                print(err!.localizedDescription)
                return completion(0)
            }
            completion(1)
            print("postResponse:")
            print(result as Any)
        }
    }
}
