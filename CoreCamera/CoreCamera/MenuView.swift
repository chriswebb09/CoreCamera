import UIKit

struct MenuViewConstants {
    static let sharedHeightMultiplier: CGFloat = 0.2
    static let backgroundColor = UIColor(red:0.09, green:0.14, blue:0.31, alpha:1.0)
    static let alpha: CGFloat = 0.98
    static let optionBorderWidth: CGFloat =  1
}

struct MenuOptionViewConstants {
    static let optionLabelCenterXOffset: CGFloat = UIScreen.main.bounds.width * 0.025
    static let optionLabelHeightMultiplier: CGFloat = 0.9
    static let optionLabelWidthMultiplier: CGFloat = 0.8
    static let iconViewCenterXOffset: CGFloat = UIScreen.main.bounds.width * 0.23
    static let iconViewHeightAnchor: CGFloat = 0.35
    static let iconViewWidthAnchor: CGFloat = 0.5
}

final class MenuView: UIView {
    
    weak var delegate: MenuDelegate?
    
    private var optionOneView: MenuOptionView = {
        let optionOne = MenuOptionView()
        optionOne.setupConstraints()
        optionOne.isUserInteractionEnabled = true
        optionOne.layer.borderWidth = MenuViewConstants.optionBorderWidth
        return optionOne
    }()
    
    private var optionTwoView: MenuOptionView = {
        let optionTwo = MenuOptionView()
        optionTwo.setupConstraints()
        optionTwo.isUserInteractionEnabled = true
        optionTwo.layer.borderWidth = MenuViewConstants.optionBorderWidth
        return optionTwo
    }()
    
    private var optionThreeView: MenuOptionView = {
        let optionThree = MenuOptionView()
        optionThree.setupConstraints()
        optionThree.layer.borderWidth = MenuViewConstants.optionBorderWidth
        return optionThree
    }()
    
    private var optionFourView: MenuOptionView = {
        let optionFour = MenuOptionView()
        optionFour.setupConstraints()
        optionFour.layer.borderWidth = MenuViewConstants.optionBorderWidth
        return optionFour
    }()
    
    private var optionCancelView: MenuOptionView = {
        let optionCancel = MenuOptionView()
        optionCancel.setupConstraints()
        optionCancel.isUserInteractionEnabled = true
        optionCancel.layer.borderWidth = MenuViewConstants.optionBorderWidth
        return optionCancel
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        isUserInteractionEnabled = true
        // layer.cornerRadius = 6
    }
    
    private func addSelectors() {
        let optionOneTapped = UITapGestureRecognizer(target: self, action: #selector(optionOneViewTapped))
        optionOneView.addGestureRecognizer(optionOneTapped)
        let optionTwoTapped = UITapGestureRecognizer(target: self, action: #selector(optionTwoViewTapped))
        optionTwoView.addGestureRecognizer(optionTwoTapped)
        let optionThreeTapped = UITapGestureRecognizer(target: self, action: #selector(optionThreeViewTapped))
        optionThreeView.addGestureRecognizer(optionThreeTapped)
        let optionFourTapped = UITapGestureRecognizer(target: self, action: #selector(optionFourViewTapped))
        optionFourView.addGestureRecognizer(optionFourTapped)
        let cancelTapped = UITapGestureRecognizer(target: self, action: #selector(cancelViewTapped))
        optionCancelView.addGestureRecognizer(cancelTapped)
    }
    
    @objc private func optionOneViewTapped() {
        animateTap(view: optionOneView)
        optionOneView.layer.borderWidth = 6
        delegate?.optionOne(tapped: true)
        optionOneView.layer.borderWidth = MenuViewConstants.optionBorderWidth
    }
    
    @objc private func optionTwoViewTapped() {
        animateTap(view: optionTwoView)
        optionTwoView.layer.borderWidth = 6
        delegate?.optionTwo(tapped: true)
        optionTwoView.layer.borderWidth = MenuViewConstants.optionBorderWidth
    }
    
    @objc private func optionThreeViewTapped() {
        animateTap(view: optionThreeView)
        optionThreeView.layer.borderWidth = 6
        delegate?.optionThree(tapped: true)
        optionThreeView.layer.borderWidth = MenuViewConstants.optionBorderWidth
    }
    
    @objc private func optionFourViewTapped() {
        print("cancelViewTapped() ")
        animateTap(view: optionFourView)
        optionCancelView.layer.borderWidth = 6
        delegate?.optionFour(tapped: true)
        optionFourView.layer.borderWidth = MenuViewConstants.optionBorderWidth
    }
    
    @objc private func cancelViewTapped() {
        print("cancelViewTapped() ")
        animateTap(view: optionCancelView)
        optionCancelView.layer.borderWidth = 6
        delegate?.cancel(tapped: true)
        optionCancelView.layer.borderWidth = MenuViewConstants.optionBorderWidth
    }
    
    func animateTap(view: UIView) {
        let colorAnimation = CABasicAnimation(keyPath: "backgroundColor")
        colorAnimation.fromValue = view.backgroundColor
        colorAnimation.toValue = UIColor.lightGray.cgColor
        colorAnimation.duration = 0.5
        view.layer.add(colorAnimation, forKey: "colorAnimation")
        colorAnimation.autoreverses = true
        CATransaction.begin()
        colorAnimation.isRemovedOnCompletion = true
        colorAnimation.fillMode = kCAFillModeForwards
        view.layer.backgroundColor = UIColor.lightGray.cgColor
        CATransaction.commit()
    }
    
    func configureView() {
        layoutSubviews()
        setupConstraints()
        optionOneView.set(with: "ComicEffect", and: #imageLiteral(resourceName: "brain"))
        optionTwoView.set(with: "Crystalize", and: #imageLiteral(resourceName: "brain"))
        optionThreeView.set(with:"Invert Color", and: #imageLiteral(resourceName: "brain"))
        optionFourView.set(with: "Halftone", and: #imageLiteral(resourceName: "brain"))
        optionCancelView.set(with: "Cancel", and: #imageLiteral(resourceName: "brain"))
        addSelectors()
    }
    
    
    func setOptionOneTitle(string: String) {
        optionOneView.set(with: string, and: #imageLiteral(resourceName: "cloud-circle-white"))
    }
    
    func setupOptionTwoTitle(title: String) {
        optionTwoView.set(with: title, and: #imageLiteral(resourceName: "circle-x-white"))
    }
    
    func setMenuColor(backgroundColor: UIColor, borderColor: UIColor, labelTextColor: UIColor) {
        let optionViews = [optionOneView, optionTwoView, optionThreeView, optionFourView, optionCancelView]
        optionViews.forEach {
            $0.backgroundColor = backgroundColor
            $0.layer.borderColor = borderColor.cgColor
            $0.set(textColor: labelTextColor)
        }
    }
    
    private func sharedLayout(view: UIView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        view.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.94).isActive = true
        view.heightAnchor.constraint(equalTo: heightAnchor, multiplier: MenuViewConstants.sharedHeightMultiplier).isActive = true
    }
    
    private func setupConstraints() {
        sharedLayout(view: optionOneView)
        optionOneView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        sharedLayout(view: optionTwoView)
        optionTwoView.topAnchor.constraint(equalTo: optionOneView.bottomAnchor, constant: UIScreen.main.bounds.height * 0.006).isActive = true
        sharedLayout(view: optionThreeView)
        optionThreeView.topAnchor.constraint(equalTo: optionTwoView.bottomAnchor, constant: UIScreen.main.bounds.height * 0.006).isActive = true
        sharedLayout(view: optionFourView)
        optionFourView.topAnchor.constraint(equalTo: optionThreeView.bottomAnchor, constant: UIScreen.main.bounds.height * 0.006).isActive = true
        sharedLayout(view: optionCancelView)
        optionCancelView.topAnchor.constraint(equalTo: optionFourView.bottomAnchor, constant: UIScreen.main.bounds.height * 0.006).isActive = true
    }
}
