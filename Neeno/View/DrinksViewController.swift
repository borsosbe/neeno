import UIKit
import RxSwift
import RxCocoa

class DrinksViewController: UIViewController {

    @IBOutlet weak var drinksTableView: UITableView!
  
    private var viewModel: DrinksViewModel!
    private let disposeBag = DisposeBag()
    
    init(drinksVM : DrinksViewModel)
    {
        viewModel = drinksVM
        super.init(nibName: "DrinksViewController", bundle: nil)
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
    
    func setupBinding()
    {
        self.viewModel.rx.drinkSource.asObservable()
            .bind(to: drinksTableView.rx.items(cellIdentifier: CartItemTableViewCell.reuseIdentifier, cellType: CartItemTableViewCell.self))
            {
                (row, element, cell) in
                cell.initContent(model: element, isDrinkView: true)
                cell.actionButton.rx.tap
                    .subscribe(){ event in
                        self.viewModel.AddCartItem(cartItem: element)
                        let addedView = AddedToCartView()
                        addedView.frame = CGRect(x: 0, y: self.drinksTableView.frame.minY - 8, width: self.view.frame.width, height: 20)
                        self.view.addSubview(addedView)
                        addedView.Aniamte()
                    }.disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
    }
    
    func setupTableView()
    {
        drinksTableView.delegate = nil
        drinksTableView.dataSource = nil
        drinksTableView.register(UINib(nibName: CartItemTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: CartItemTableViewCell.reuseIdentifier)
    }
    
    func setupNavbar()
    {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.title = "DRINKS"
    }
}
