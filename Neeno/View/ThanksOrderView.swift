import UIKit

class ThanksOrderView: UIView {
    
    @IBOutlet var contentView: UIView!
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("ThanksOrderView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    public func Aniamte()
    {
        contentView.frame = CGRect(x: 0, y: -contentView.frame.height, width: contentView.frame.width, height: contentView.frame.height)
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.contentView.frame = CGRect(x:0, y: 0, width: self.contentView.frame.width, height: self.contentView.frame.height)
        }, completion: {_ in self.dismiss()})
    }
    
    private func dismiss()
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.contentView.frame = CGRect(x: 0, y: -self.contentView.frame.height, width: self.contentView.frame.width, height: self.contentView.frame.height)
            }, completion: {_ in self.removeFromSuperview()})
        }
    }
}
