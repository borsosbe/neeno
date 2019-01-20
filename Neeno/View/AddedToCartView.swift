import UIKit

class AddedToCartView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
          commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("AddedToCartView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    public func Aniamte()
    {
        contentView.frame = CGRect(x: -contentView.frame.width, y: 0, width: contentView.frame.width, height: contentView.frame.height)
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.contentView.frame = CGRect(x:0, y: 0, width: self.contentView.frame.width, height: self.contentView.frame.height)
        }, completion: {_ in self.dismiss()})
    }
    
    private func dismiss()
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.contentView.frame = CGRect(x: self.contentView.frame.width, y: 0, width: self.contentView.frame.width, height: self.contentView.frame.height)
            }, completion: {_ in self.removeFromSuperview()})
        }
    }
}
