
import Foundation
import UIKit

final class TickerCell: UITableViewCell {
  static let identifier = "TickerCell"
  
  var digit: String = "0" {
    didSet { setText() }
  }
  
  var fontSize: CGFloat = .largeFontSize {
    didSet { setFont() }
  }
  
  private let numberLabel = UILabel()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setUpViews()
  }
  
  private func setUpViews() {
    setText()
    setFont()
    
    numberLabel.textAlignment = .center
    numberLabel.textColor = .black
    
    contentView.addSubview(numberLabel)
    numberLabel.translatesAutoresizingMaskIntoConstraints = false
    
    contentView.addConstraints([
      NSLayoutConstraint(item: numberLabel, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1.0, constant: 0.0),
      NSLayoutConstraint(item: numberLabel, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1.0, constant: 0.0),
      NSLayoutConstraint(item: numberLabel, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1.0, constant: 0.0),
      NSLayoutConstraint(item: numberLabel, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1.0, constant: 0.0),
      ])
    
    backgroundColor = .clear
    contentView.backgroundColor = .clear
  }
  
  private func setText() {
    numberLabel.text = digit
  }
  
  private func setFont() {
    numberLabel.font = UIFont(name: "Roboto-Regular", size: fontSize)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
