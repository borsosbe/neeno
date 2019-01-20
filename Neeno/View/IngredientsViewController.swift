import UIKit
import RxSwift
import RxCocoa

class IngredientsViewController: UIViewController {

    @IBOutlet weak var ingredientsTableView: UITableView!
    
    private var viewModel: IngredientsViewModel!
    private var pizzaImage: UIImage
    private var hasImage : Bool
    private var ingIDs : [Int64]
    private let disposeBag = DisposeBag()
    private var footerView = AddToCartFooterView()

    init(ingVM : IngredientsViewModel, pizzaImage: UIImage?)
    {
        viewModel = ingVM
        ingIDs = viewModel.pizza.IngredientsById
        if ( pizzaImage != nil ) { self.pizzaImage = pizzaImage!; hasImage = true }
        else { self.pizzaImage = UIImage(); hasImage = false }
        super.init(nibName: "IngredientsViewController", bundle: nil)
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
        setupNavbar()
    }
    
    func setupTableView()
    {
        ingredientsTableView.delegate = nil
        ingredientsTableView.dataSource = nil
        addHeaderFooter()
        ingredientsTableView.register(UINib(nibName: IngredientTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: IngredientTableViewCell.reuseIdentifier)
        
    }
    
    func setupBinding()
    {
        self.viewModel.rx.ingredientsSource.asObservable()
            .bind(to: ingredientsTableView.rx.items(cellIdentifier: IngredientTableViewCell.reuseIdentifier, cellType: IngredientTableViewCell.self))
            {
                (row, element, cell) in
                cell.initContent(model: element)
            }
            .disposed(by: disposeBag)
        
        ingredientsTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.viewModel.ingredientsSource[indexPath.row].IsActive = !(self?.viewModel.ingredientsSource[indexPath.row].IsActive)!
                (self?.ingredientsTableView.tableFooterView as! AddToCartFooterView).cartButton.setTitle(String(format: "ADD TO CART ($%.1f)", self?.viewModel.GetCurrentSumPrice() ?? 0.0), for: .normal)
                self?.viewModel.pizza.PizzaType = (self?.viewModel.menuService.GetPizzaType(pizza: (self?.viewModel.pizza)!))!
            }).disposed(by: disposeBag)
        
        footerView.cartButton.rx.tap
            .subscribe(){ event in
                var pizzaName = ""
                switch self.viewModel.pizza.PizzaType {
                case .basic:
                    pizzaName = self.viewModel.pizza.Name
                case .basicPlus:
                    pizzaName = "Custom " + self.viewModel.pizza.Name
                case .custom:
                    pizzaName = "Custom Pizza"
                }
                self.viewModel.AddCartItem(cartItem: CartItem(name: pizzaName, price: self.viewModel.GetCurrentSumPrice(), drinkId: nil, ingredientsById: self.viewModel.pizza.IngredientsById))
                let addedView = AddedToCartView()
                addedView.frame = CGRect(x: 0, y: self.ingredientsTableView.frame.minY, width: self.view.frame.width, height: 20)
                self.view.addSubview(addedView)
                addedView.Aniamte()
            }.disposed(by: footerView.disposeBag)
    }
    
    func setupNavbar()
    {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.title = viewModel.pizza.Name.uppercased()
    }
    
    func addHeaderFooter()
    {
        let headerView = IngredientsTableViewHeaderView()
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width * 0.9)
        if(hasImage) { headerView.coverImageView.image = pizzaImage }
        else
        {   if (self.viewModel.pizza.ImageUrl != nil)
            {
            headerView.coverImageView .imageFromUrl(urlString: self.viewModel.pizza.ImageUrl!)
            }
        }
        
        ingredientsTableView.tableHeaderView = headerView
        footerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 112)
        ingredientsTableView.tableFooterView = footerView
        footerView.cartButton.setTitle(String(format: "ADD TO CART ($%.1f)", self.viewModel.GetCurrentSumPrice()), for: .normal)
    }
}
