import Foundation
import RxSwift
import RxCocoa

class CartViewModel : ReactiveCompatible {
    
    fileprivate lazy var _menuService : BehaviorRelay<MenuService> = BehaviorRelay(value: MenuService())
    fileprivate lazy var _cartService : BehaviorRelay<CartService> = BehaviorRelay(value: CartService())
    fileprivate lazy var _cartSource : BehaviorRelay<[CartItem]> = BehaviorRelay(value: [])
    fileprivate lazy var _totalPrice : BehaviorRelay<Double> = BehaviorRelay(value: Double())
    fileprivate lazy var _errorMessage : BehaviorRelay<String> = BehaviorRelay(value:"Check your internet connection, or try again later")
    let backendService : BackendService
    
    var menuService : MenuService {
        get { return _menuService.value }
        set { _menuService.accept(newValue) }
    }
    
    var cartService: CartService {
        get { return _cartService.value }
        set { _cartService.accept(newValue) }
    }
    
    var cartSource: [CartItem] {
        get { return _cartSource.value }
        set { _cartSource.accept(newValue) }
    }
    
    var totalPrice: Double {
        get { return _totalPrice.value }
        set { _totalPrice.accept(newValue) }
    }
    
    var errorMessage: String {
        get { return _errorMessage.value }
        set { _errorMessage.accept(newValue) }
    }
    
    init(backendService: BackendService = BackendService(), menuService: MenuService ) {
        self.backendService = backendService
        self.menuService = menuService
    }
    
    public func RemoveItem(index: Int)
    {
        cartSource.remove(at: index)
        cartService.SaveCartDictionary(cartItems: cartSource)
        CountTotal()
    }
    
    public func CountTotal()
    {
        var temp = 0.0
        for item in cartSource {
            temp += item.Price
        }
        totalPrice = temp
    }
    
    public func RefreshCart()
    {
        cartService.LoadCartitems()
        cartSource.removeAll()
        if(cartService.cartDictionary.count != 0)
        {
            for index in 0...cartService.cartDictionary.count - 1
            {
                self.cartSource.append(cartService.cartDictionary[index]!)
            }
        }
        CountTotal()
    }
    
    public func Checkout(completion:@escaping (Int) -> Void)
    {
       backendService.SendOrder(cartList: cartSource) {(result: Int) in
            if (result == 0) { completion(0) }
            if (result == 1)
            {
                self.cartSource.removeAll()
                self.CountTotal()
                self.cartService.RemoveAllItems()
                completion(1)
            }
        }
    }

}
extension Reactive where Base: CartViewModel {
    var cartSource : Observable<[CartItem]> {
        return base._cartSource.asObservable()
    }
    var totalprice : Observable<Double> {
        return base._totalPrice.asObservable()
    }
}

