import UIKit
import RxSwift
import RxCocoa

class CartViewController: UIViewController {

    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var checkoutButton: UIButton!
    private var viewModel: CartViewModel!
    private var footerView = CartFooterView()
    private let disposeBag = DisposeBag()
    
    init(cartVM : CartViewModel)
    {
        viewModel = cartVM
        super.init(nibName: "CartViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.RefreshCart()
        setupNavbar()
    }
    
    func setupTableView()
    {
        cartTableView.delegate = nil
        cartTableView.dataSource = nil
        cartTableView.register(UINib(nibName: CartItemTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: CartItemTableViewCell.reuseIdentifier)
        addFooter()
    }
    
    func setupBinding()
    {
        self.viewModel.rx.cartSource.asObservable()
            .bind(to: cartTableView.rx.items(cellIdentifier: CartItemTableViewCell.reuseIdentifier, cellType: CartItemTableViewCell.self))
            {
                (row, element, cell) in
                cell.initContent(model: element, isDrinkView: false)
                cell.actionButton.rx.tap
                    .subscribe(){ event in
                        self.viewModel.RemoveItem(index: row)
                    }.disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        checkoutButton.rx.tap
            .subscribe(){ event in
                if (self.viewModel.cartSource.isEmpty) {
                    self.emptyCartAlert()
                }
                else {
                    self.viewModel.Checkout() {(result: Int) in
                        if (result == 1)
                        {
                            DispatchQueue.main.async {
                                let thanksView = ThanksOrderView()
                                thanksView.frame = self.view.frame
                                self.view.addSubview(thanksView)
                                thanksView.Aniamte()
                            }
                        }
                        else {
                            DispatchQueue.main.async{ self.error() }
                        }
                    }
                }
            }.disposed(by: disposeBag)
        
        viewModel.rx.totalprice
            .subscribe(){ event in
                DispatchQueue.main.async{ self.footerView.priceLabel.text = String(format:"$%.1f", self.viewModel.totalPrice) }
            }.disposed(by: disposeBag)

    }
    
    private func error()
    {
        let alert = UIAlertController(title: "Error", message: self.viewModel.errorMessage, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    
    func addFooter()
    {
        footerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 68)
        cartTableView.tableFooterView = footerView
    }
    
    func emptyCartAlert()
    {
        let alert = UIAlertController(title: "Your cart is empty!", message: "Add something to it!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    @objc func leftButtonAction(sender: UIBarButtonItem)
    {
        let drinksVM = DrinksViewModel(menuService: self.viewModel.menuService)
        let drinksVC = DrinksViewController(drinksVM: drinksVM)
        self.navigationController?.pushViewController(drinksVC, animated:true)
    }
    
    func setupNavbar()
    {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.title = "CART"
        let color = UIColor(displayP3Red: CGFloat(225.0/255.0), green: CGFloat(77.0/255.0), blue: CGFloat(69.0/255.0), alpha: CGFloat(1.0))
        let rightButtonItem = UIBarButtonItem(image: UIImage(named: "ic_drinks")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(leftButtonAction))
        rightButtonItem.tintColor = color
        navigationItem.rightBarButtonItem = rightButtonItem
    }
}
