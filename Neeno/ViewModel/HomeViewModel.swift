import RxSwift
import RxCocoa

class HomeViewModel : ReactiveCompatible {

    fileprivate lazy var _menuService : BehaviorRelay<MenuService> = BehaviorRelay(value: MenuService())
    fileprivate lazy var _pizzaSource : BehaviorRelay<[PizzaItem]> = BehaviorRelay(value: [])
    fileprivate lazy var _basePrice : BehaviorRelay<Double> = BehaviorRelay(value: Double())
    fileprivate lazy var _errorMessage : BehaviorRelay<String> = BehaviorRelay(value:"Check your internet connection, or try again later")
    fileprivate lazy var _showConenctionError : BehaviorRelay<Bool> = BehaviorRelay(value:false)
    var backendService : BackendService = BackendService()
    
    var menuService: MenuService {
        get { return _menuService.value }
        set { _menuService.accept(newValue) }
    }
    
    var pizzaSource: [PizzaItem] {
        get { return _pizzaSource.value }
        set { _pizzaSource.accept(newValue) }
    }
    
    var basePrice: Double {
        get { return _basePrice.value }
        set { _basePrice.accept(newValue) }
    }
    
    var errorMessage: String {
        get { return _errorMessage.value }
        set { _errorMessage.accept(newValue) }
    }
    
    var showConenctionError: Bool {
        get { return _showConenctionError.value }
        set { _showConenctionError.accept(newValue) }
    }
    
    init(backendService: BackendService = BackendService()) {
        self.backendService = backendService
        LoadMenu()
    }
    
    private func handleError(errorCode: Int)
    {
        switch errorCode {
        case 1:
            print("Error while loading drinks")
        case 2:
            print("Error while loading drinks")
        case 3:
            print("Error while loading drinks")
        default:
            print("Error while loading content")
        }
        showConenctionError = true
    }
    
    public func LoadMenu()
    {
        backendService.GetMenu() {(result: Any) in
            if (result is Int)
            {
                self.handleError(errorCode: result as! Int)
            }
            if (result is MenuService)
            {
                self.menuService = result as! MenuService
                self.pizzaSource.append(contentsOf: self.menuService.GetGeneralPizzaOffers())
                self.basePrice = self.pizzaSource[0].BasePrice
            }
        }
    }
}

extension Reactive where Base: HomeViewModel {
    var pizzaSource : Observable<[PizzaItem]> {
        return base._pizzaSource.asObservable()
    }
    var showConenctionError : Observable<Bool> {
        return base._showConenctionError.asObservable()
    }
}


