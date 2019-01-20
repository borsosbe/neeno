import Foundation

class CartService {
    static var ud_dicKey = "cartDic"
    var cartDictionary: [Int: CartItem] = [:]
    
    public func LoadCartitems()
    {
        if let dic = UserDefaults.standard.value(forKey: CartService.ud_dicKey) as? Data {
            cartDictionary = try! PropertyListDecoder().decode(Dictionary<Int,CartItem>.self, from: dic)
            print("cartDictionary LOADED with \(String(describing: cartDictionary.count)) cart items")
        }
        else
        {
            print("cartDictionary is empty --> No cart items")
        }
    }
    
    public func SaveCartDictionary(cartItems : [CartItem])
    {
        cartDictionary.removeAll()
        if(cartItems.count != 0)
        {
            for i in 0...cartItems.count - 1 {
                cartDictionary[i] = cartItems[i]
            }
        }
        UserDefaults.standard.set(try? PropertyListEncoder().encode(cartDictionary), forKey: CartService.ud_dicKey)
        print("cartDictionary is saved with \(String(describing: cartDictionary.count)) cart items")
    }
    
    public func AddCartItem(cartItem : CartItem)
    {
        var cartList = [cartItem]
        LoadCartitems()
        if(cartDictionary.count != 0)
        {
            for i in  0...cartDictionary.count - 1 {
                if (i == 0) { cartList[i] = cartDictionary[i]! }
                else {cartList.append(cartDictionary[i]!) }
            }
            cartList.append(cartItem)
            SaveCartDictionary(cartItems: cartList)
        }
        else
        {
            SaveCartDictionary(cartItems: cartList)
        }
    }
    
    public func RemoveAllItems()
    {
        SaveCartDictionary(cartItems: [])
    }

}

