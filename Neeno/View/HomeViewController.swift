import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {

    @IBOutlet weak var pizzaTableView: UITableView!

    private var viewModel: HomeViewModel!
    private let disposeBag = DisposeBag()
    
    init() {
        super.init(nibName: "HomeViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
        setupTableView()
        setupBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavbar()
    }
    
    private func setupTableView()
    {
        pizzaTableView.delegate = nil
        pizzaTableView.dataSource = nil
        pizzaTableView.rowHeight = 178
        pizzaTableView.register(UINib(nibName: PizzaTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: PizzaTableViewCell.reuseIdentifier)
        
    }
    
    private func setupBinding()
    {
        self.viewModel.rx.pizzaSource.asObservable()
            .bind(to: pizzaTableView.rx.items(cellIdentifier: PizzaTableViewCell.reuseIdentifier, cellType: PizzaTableViewCell.self))
            {
                (row, element, cell) in
                cell.initContent(model: element)
                cell.orderButton.rx.tap
                    .throttle(0.5, latest: false, scheduler: MainScheduler.instance)
                    .subscribe( { [weak self] _ in
                        let ingVM = IngredientsViewModel(menuService: self!.viewModel.menuService, pizza: element )
                        let ingredientsVC = IngredientsViewController(ingVM: ingVM, pizzaImage: cell.coverImageView.image ?? nil)
                        self!.navigationController?.pushViewController(ingredientsVC, animated:true)
                    })
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        self.viewModel.rx.showConenctionError.asObservable()
            .subscribe({ [weak self] value in
                if(value.element!) {
                    DispatchQueue.main.async {
                        self!.error()
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func error()
    {
        let alert = UIAlertController(title: "Error", message: self.viewModel.errorMessage, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default, handler: {
            (UIAlertAction) in
            self.viewModel.LoadMenu()
        })
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    
    private func configureViewModel() {
        self.viewModel = HomeViewModel()
    }
    
    @objc func rightButtonAction(sender: UIBarButtonItem)
    {
        let ingVM = IngredientsViewModel(menuService: viewModel.menuService, pizza: PizzaItem(basePrice: self.viewModel.basePrice, name: "CREATE A PIZZA", ingredientsByName: [], ingredientsById: [], pizzaType: .custom) )
        let ingredientsVC = IngredientsViewController(ingVM: ingVM, pizzaImage: UIImage.init(named: "custom_pizza"))
        navigationController?.pushViewController(ingredientsVC, animated:true)
    }
    
    @objc func leftButtonAction(sender: UIBarButtonItem)
    {
        let cartVM = CartViewModel(menuService: self.viewModel.menuService)
        let cartVC = CartViewController(cartVM: cartVM)
        self.navigationController?.pushViewController(cartVC, animated:true)
    }
    
    func setupNavbar()
    {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.title = "NENNO'S PIZZA"
        let color = UIColor(displayP3Red: CGFloat(225.0/255.0), green: CGFloat(77.0/255.0), blue: CGFloat(69.0/255.0), alpha: CGFloat(1.0))
        let rightButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(rightButtonAction))
        let leftButtonItem = UIBarButtonItem(image: UIImage(named: "ic_cart_navbar")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(leftButtonAction))
        rightButtonItem.tintColor = color
        leftButtonItem.tintColor = color
        navigationItem.rightBarButtonItem = rightButtonItem
        navigationItem.leftBarButtonItem = leftButtonItem
    }
}


