import Foundation
import RxCocoa
import RxSwift

class DrinksViewModel : ReactiveCompatible {
    
    fileprivate lazy var _menuService : BehaviorRelay<MenuService> = BehaviorRelay(value: MenuService())
    fileprivate lazy var _drinkSource : BehaviorRelay<[CartItem]> = BehaviorRelay(value: [])
    fileprivate lazy var _cartService : BehaviorRelay<CartService> = BehaviorRelay(value: CartService())
    
    var menuService : MenuService {
        get { return _menuService.value }
        set { _menuService.accept(newValue) }
    }
    
    var drinkSource: [CartItem] {
        get { return _drinkSource.value }
        set { _drinkSource.accept(newValue) }
    }
    
    var cartService: CartService {
        get { return _cartService.value }
        set { _cartService.accept(newValue) }
    }
    
    init(menuService: MenuService) {
        self.menuService = menuService;
        var drinks = [CartItem]()
        for item in menuService.drinks {
            drinks.append(CartItem(name: item.Name, price: item.Price, drinkId: item.Id, ingredientsById: nil))
        }
        drinkSource.append(contentsOf: drinks)
    }
    
    public func AddCartItem(cartItem : CartItem)
    {
        cartService.AddCartItem(cartItem: cartItem)
    }
}

extension Reactive where Base: DrinksViewModel {
    var drinkSource : Observable<[CartItem]> {
        return base._drinkSource.asObservable()
    }
}
