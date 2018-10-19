

import UIKit

// Ticker UI Constants
extension CGFloat {
  static let miniWidth: CGFloat = 8.0
  static let smallWidth: CGFloat = 20.0
  static let largeWidth: CGFloat = 32.0
  static let smallFontSize: CGFloat = 35.0
  static let largeFontSize: CGFloat = 60.0
  static let cellHeight: CGFloat = 48
  static let columnHeight: CGFloat = 50
}

final class TickerControl: UIViewController {
  
  private let numericAlphabet = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
  private var stringValue: String
  private var numberValue: Double {
    didSet {
      stringValue = String(format: "$%.2f", numberValue)
    }
  }
  
  private let columnsCollectionView: UICollectionView = {
    let flowLayout                     = UICollectionViewFlowLayout()
    flowLayout.scrollDirection         = .horizontal
    flowLayout.minimumInteritemSpacing = 0
    flowLayout.minimumLineSpacing      = 0
    return UICollectionView(frame: .zero, collectionViewLayout:flowLayout)
  }()
  
  init(value: Double) {
    self.stringValue = String(format: "$%.2f", value)
    self.numberValue = value
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    columnsCollectionView.backgroundColor = .white
    columnsCollectionView.delegate = self
    columnsCollectionView.dataSource = self
    columnsCollectionView.register(TickerColumnCell.self, forCellWithReuseIdentifier: TickerColumnCell.identifier)
    
    view.addSubview(columnsCollectionView)
    columnsCollectionView.translatesAutoresizingMaskIntoConstraints = false
    
    view.addConstraints([
      NSLayoutConstraint(item: columnsCollectionView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0.0),
      NSLayoutConstraint(item: columnsCollectionView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 0.0),
      NSLayoutConstraint(item: columnsCollectionView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: CGFloat(CGFloat.columnHeight)),
      NSLayoutConstraint(item: columnsCollectionView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1.0, constant:0.0)
      ])
    
    view.backgroundColor = .white
  }
  
  override func viewDidAppear(_ animated: Bool) {
    showNumber(numberValue)
  }
  
  func showNumber(_ number: Double) {
    numberValue = number
    
    for (index, char) in stringValue.enumerated() {
        let indexPath = IndexPath(item: index, section: 0)
        
        guard let cell = columnsCollectionView.cellForItem(at: indexPath) as? TickerColumnCell, let characterIndex = cell.characters.index(of: "\(char)") else { return }
        
        let charIndexPath = IndexPath(item: characterIndex, section: 0)
        
        if !cell.isScrolling {
            cell.tableView.scrollToRow(at: charIndexPath, at: .middle, animated: true)
        }
        
    }
  }
}

// MARK: UICollectionViewDelegateFlowLayout
extension TickerControl: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    let count = stringValue.count
    var size: TickerColumnCell.Size
    
    switch indexPath.row {
    case 0, count - 1, count - 2:
      size = .small
    case count - 3:
      size = .mini
    default:
      size = .large
    }
    
    return size.rectSize
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    
    let count = stringValue.count
    let largeCharsCount = count - 4 // "$", ".", 2 decimal places at the end
    
    let totalCellWidth = 1 * CGFloat.miniWidth + 3 * CGFloat.smallWidth + CGFloat(largeCharsCount) * CGFloat.largeWidth
    
    let leftInset = (collectionView.layer.frame.size.width - CGFloat(totalCellWidth)) / 2
    let rightInset = leftInset
    
    return UIEdgeInsets.init(top: 0, left: leftInset, bottom: 0, right: rightInset)
  }
}

// MARK: UICollectionViewDataSource
extension TickerControl: UICollectionViewDataSource {

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return stringValue.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TickerColumnCell.identifier, for: indexPath) as! TickerColumnCell
    
    let character = "\(stringValue[indexPath.row])"
    let characters: [String]
    
    if numericAlphabet.contains(character) {
      characters = numericAlphabet
      // If it's not the last OR second to last index, then make it big
      cell.size = ![stringValue.count - 1, stringValue.count - 2].contains(indexPath.row) ? .large : .small
    } else {
      characters = [character]
      cell.size = character == "." ? .mini : .small
    }
    
    cell.characters = characters
    
    return cell
  }
}

// MARK: UICollectionViewDelegate
extension TickerControl: UICollectionViewDelegate { }

