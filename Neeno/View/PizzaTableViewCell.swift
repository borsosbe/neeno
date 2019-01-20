import UIKit
import RxSwift

class PizzaTableViewCell: UITableViewCell {

    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var pizzaLabel: UILabel!
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var orderButton: UIButton!
    
    static let reuseIdentifier = "PizzaTableViewCell"
    private(set) var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag() // because life cicle of every cell ends on prepare for reuse
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        orderButton.layer.cornerRadius = 4
        orderButton.layer.masksToBounds = true
        coverImageView.clipsToBounds = true
        setImageColor(color: UIColor.red)
    }
    
    func initContent(model : PizzaItem)
    {
        pizzaLabel.text = model.Name
        ingredientsLabel.text = ""
        for i in 0...model.IngredientsByName.count - 1 {
            if(i == 0) { ingredientsLabel.text = model.IngredientsByName[i] }
            else { ingredientsLabel.text = ingredientsLabel.text! + ", " + model.IngredientsByName[i] }
        }
        orderButton.setTitle(String(format:"$%.1f", model.Price!), for: .normal)
        if (model.ImageUrl != nil) { coverImageView.imageFromUrl(urlString: model.ImageUrl!) }
    }
    
    func setImageColor(color: UIColor) {
        let templateImage = self.orderButton.currentImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        self.orderButton.setImage(templateImage, for: .normal)
        self.tintColor = UIColor.white
    }
}

extension UIImageView {
    public func imageFromUrl(urlString: String) {
        let url = URL(string: urlString)
        if(urlString.isEmpty) { return }
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard let data = data, error == nil else { return }
            
            DispatchQueue.main.async() {    // execute on main thread
                self.image = UIImage(data: data)
            }
        }
        task.resume()
    }
}
