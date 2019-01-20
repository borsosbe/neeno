import UIKit
import RxSwift
import RxCocoa

class CartFooterView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var priceLabel: UILabel!
     let disposeBag = DisposeBag()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("CartFooterView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
}
