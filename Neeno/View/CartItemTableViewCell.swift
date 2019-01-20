import UIKit
import RxSwift
import RxCocoa

class CartItemTableViewCell: UITableViewCell {

    @IBOutlet weak var removeItemImageView: UIImageView!
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var plusImageView: UIImageView!
    
    static let reuseIdentifier = "CartItemTableViewCell"
    private(set) var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag() // because life cicle of every cell ends on prepare for reuse
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func initContent(model: CartItem, isDrinkView: Bool) {
        itemLabel.text = model.Name
        priceLabel.text = String(format:"$%.1f", model.Price)
        if (isDrinkView) {
            removeItemImageView.isHidden = true
            plusImageView.isHidden = false
        }
    }
}

