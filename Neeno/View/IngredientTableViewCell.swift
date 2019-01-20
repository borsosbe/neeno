import UIKit
import RxSwift

class IngredientTableViewCell: UITableViewCell {

    @IBOutlet weak var tickImageView: UIImageView!
    @IBOutlet weak var ingredientLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    static let reuseIdentifier = "IngredientTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func initContent(model : IngredientCell)
    {
        ingredientLabel.text = model.Name
        priceLabel.text = String(format:"$%.1f", model.Price)
        tickImageView.isHidden = !model.IsActive
    }
}
