
import Foundation
import UIKit

private extension CGFloat {
  static let widthMultiplier: CGFloat = 0.8
  static let outerVerticalOffset: CGFloat = 15
  static let horizontalOffset: CGFloat = 25
  static let innerVerticalOffset: CGFloat = 10
}

class RobinhoodCardCell: UICollectionViewCell {
  
  static let identifier = "RobinhoodCell"
  
  private let textLabel = UILabel()
  private let titleLabel = UILabel()
  private let linkLabel = UILabel()
  private let cardView = UIView()
  
  var backgroundType: BackgroundType {
    didSet {
      textLabel.textColor = backgroundType.textTextColor
      titleLabel.textColor = backgroundType.titleTextColor
      linkLabel.textColor = backgroundType.linkTextColor
    }
  }
  
  var viewModel: RobinhoodCardViewModel? {
    didSet {
      guard let model = viewModel else { return }
      textLabel.configureTextLabel(withText: model.text)
      titleLabel.configureTitleLabel(withText: model.title)
      linkLabel.configureLinkLabel(withText: model.link)
    }
  }
  
  override init(frame: CGRect) {
    backgroundType = .light(priceMovement: .up)
    super.init(frame: frame)
    setUpViews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setUpViews() {
    contentView.addSubview(cardView)
    
    cardView.layer.cornerRadius = 4
    cardView.backgroundColor = .white
    cardView.layer.shadowColor = UIColor.black.cgColor
    cardView.layer.shadowOpacity = 0.2
    cardView.layer.shadowRadius = 10
    cardView.layer.shadowOffset = CGSize(width: -1, height: 2)
    cardView.translatesAutoresizingMaskIntoConstraints = false
    
    contentView.addConstraints([
      NSLayoutConstraint(item: cardView, attribute: .height, relatedBy: .equal, toItem: contentView, attribute: .height, multiplier: 0.9, constant: 0.0),
      NSLayoutConstraint(item: cardView, attribute: .width, relatedBy: .equal, toItem: contentView, attribute: .width, multiplier: 0.9, constant: 0.0),
      NSLayoutConstraint(item: cardView, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1.0, constant: 0.0),
      NSLayoutConstraint(item: cardView, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1.0, constant: 0.0)
      ])
    
    cardView.addSubview(titleLabel)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    
    cardView.addSubview(textLabel)
    textLabel.translatesAutoresizingMaskIntoConstraints = false
    
    cardView.addSubview(linkLabel)
    linkLabel.translatesAutoresizingMaskIntoConstraints = false
    
    contentView.addConstraints([
      NSLayoutConstraint(item: titleLabel, attribute: .leading, relatedBy: .equal, toItem: cardView, attribute: .leading, multiplier: 1.0, constant: CGFloat.horizontalOffset),
      NSLayoutConstraint(item: titleLabel, attribute: .trailing, relatedBy: .equal, toItem: cardView, attribute: .trailing, multiplier: 1.0, constant: -CGFloat.horizontalOffset),
      NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: cardView, attribute: .top, multiplier: 1.0, constant: CGFloat.outerVerticalOffset)
      ])
    
    contentView.addConstraints([
      NSLayoutConstraint(item: textLabel, attribute: .leading, relatedBy: .equal, toItem: titleLabel, attribute: .leading, multiplier: 1.0, constant: 0.0),
      NSLayoutConstraint(item: textLabel, attribute: .trailing, relatedBy: .equal, toItem: titleLabel, attribute: .trailing, multiplier: 1.0, constant: 0.0),
      NSLayoutConstraint(item: textLabel, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1.0, constant: CGFloat.innerVerticalOffset),
      ])
    
    contentView.addConstraints([
      NSLayoutConstraint(item: linkLabel, attribute: .leading, relatedBy: .equal, toItem: titleLabel, attribute: .leading, multiplier: 1.0, constant: 0.0),
      NSLayoutConstraint(item: linkLabel, attribute: .trailing, relatedBy: .equal, toItem: titleLabel, attribute: .trailing, multiplier: 1.0, constant: 0.0),
      NSLayoutConstraint(item: linkLabel, attribute: .bottom, relatedBy: .equal, toItem: cardView, attribute: .bottom, multiplier: 1.0, constant: -CGFloat.outerVerticalOffset)
      ])
  }
  
}

