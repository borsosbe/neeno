import Foundation
import RxSwift
import RxCocoa

class IngredientsViewModel : ReactiveCompatible {
    
    fileprivate lazy var _menuService : BehaviorRelay<MenuService> = BehaviorRelay(value: MenuService())
    fileprivate lazy var _cartService : BehaviorRelay<CartService> = BehaviorRelay(value: CartService())
    fileprivate lazy var _pizza : BehaviorRelay<PizzaItem> = BehaviorRelay(value: PizzaItem())
    fileprivate lazy var _ingredientsSource : BehaviorRelay<[IngredientCell]> = BehaviorRelay(value: [])

    var menuService: MenuService {
        get { return _menuService.value }
        set { _menuService.accept(newValue) }
    }
    
    var cartService: CartService {
        get { return _cartService.value }
    }
    
    var pizza: PizzaItem {
        get { return _pizza.value }
        set { _pizza.accept(newValue) }
    }
    
    var ingredientsSource: [IngredientCell] {
        get { return _ingredientsSource.value }
        set { _ingredientsSource.accept(newValue) }
    }
    
    init(menuService: MenuService, pizza: PizzaItem) {
        self.menuService = menuService
        self.pizza = pizza
        for item in menuService.ingredients {
            var value = false
            for item2 in pizza.IngredientsById {
                if (item.Id == item2) { value = true }
            }
            ingredientsSource.append(IngredientCell(id: item.Id, name: item.Name, price: item.Price, isActive: value))
        }
    }
    
    private func manageIngredients()
    {
        pizza.IngredientsById = []
        for item in ingredientsSource {
            if ( item.IsActive ) { pizza.IngredientsById.append(item.Id) }
        }
    }
    
    public func GetCurrentSumPrice() -> Double {
        manageIngredients()
        var sum = pizza.BasePrice
        for item in ingredientsSource {
            if (item.IsActive) { sum += item.Price}
        }
        return sum
    }
    
    public func AddCartItem(cartItem : CartItem)
    {
       cartService.AddCartItem(cartItem: cartItem)
    }
}

extension Reactive where Base: IngredientsViewModel {
    var ingredientsSource : Observable<[IngredientCell]> {
        return base._ingredientsSource.asObservable()
    }
}
