

import Foundation
import UIKit

// Layout constants
private extension CGFloat {
  static let tickerHeightMultiplier: CGFloat = 0.4
  static let graphHeightMultiplier: CGFloat = 0.6
}

class ViewController: UIViewController {
  
  @IBOutlet weak var topView: UIView!
  @IBOutlet weak var cardCollectionView: UICollectionView!
  
  private var cardsData = RobinhoodData.data.cards
  private var graphData = RobinhoodChartData.portfolioData
  
  lazy private var graphView: GraphView = {
    return GraphView(data: graphData)
  }()
  
  lazy private var tickerControl: TickerControl = {
    return TickerControl(value: graphData.openingPrice)
  }()
  
  override func viewDidLoad() {
    
    cardCollectionView.delegate = self
    cardCollectionView.dataSource = self
    cardCollectionView.register(RobinhoodCardCell.self, forCellWithReuseIdentifier: RobinhoodCardCell.identifier)
    
    if let layout = cardCollectionView.collectionViewLayout as? CardStackLayout {
      layout.delegate = self
    }
    
    addChild(tickerControl)
    topView.addSubview(tickerControl.view)
    tickerControl.view.translatesAutoresizingMaskIntoConstraints = false
    
    view.addConstraints([
      NSLayoutConstraint(item: tickerControl.view, attribute: .top, relatedBy: .equal, toItem: topView, attribute: .top, multiplier: 1.0, constant: 0.0),
      NSLayoutConstraint(item: tickerControl.view, attribute: .leading, relatedBy: .equal, toItem: topView, attribute: .leading, multiplier: 1.0, constant: 0.0),
      NSLayoutConstraint(item: tickerControl.view, attribute: .trailing, relatedBy: .equal, toItem: topView, attribute: .trailing, multiplier: 1.0, constant: 0.0),
      NSLayoutConstraint(item: tickerControl.view, attribute: .height, relatedBy: .equal, toItem: topView, attribute: .height, multiplier: .tickerHeightMultiplier, constant: 0.0)
      ])
    
    tickerControl.didMove(toParent: self)
    
    graphView.backgroundColor = .white
    graphView.translatesAutoresizingMaskIntoConstraints = false
    graphView.delegate = self
    topView.addSubview(graphView)
    
    view.addConstraints([
      NSLayoutConstraint(item: graphView, attribute: .bottom, relatedBy: .equal, toItem: topView, attribute: .bottom, multiplier: 1.0, constant: 0.0),
      NSLayoutConstraint(item: graphView, attribute: .leading, relatedBy: .equal, toItem: topView, attribute: .leading, multiplier: 1.0, constant: 0.0),
      NSLayoutConstraint(item: graphView, attribute: .trailing, relatedBy: .equal, toItem: topView, attribute: .trailing, multiplier: 1.0, constant: 0.0),
      NSLayoutConstraint(item: graphView, attribute: .height, relatedBy: .equal, toItem: topView, attribute: .height, multiplier: .graphHeightMultiplier, constant: 0.0)
      ])
  }
}

// MARK: UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return cardsData.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RobinhoodCardCell.identifier, for: indexPath) as? RobinhoodCardCell else {
      return UICollectionViewCell()
    }
    
    cell.viewModel = cardsData[indexPath.row]
    cell.backgroundType = .light(priceMovement: .up)
    
    return cell
  }
}

// MARK: UICollectionViewDelegate
extension ViewController: UICollectionViewDelegate {  }

// MARK: CardStackLayoutProtocol
extension ViewController: CardStackLayoutProtocol {
  func cardShouldRemove(_ flowLayout: CardStackLayout, indexPath: IndexPath) {
    cardsData.removeLast()
    cardCollectionView.reloadData()
  }
}


extension ViewController: GraphViewDelegate {
    
    func didMoveToPrice(_ graphView: GraphView, price: Double) {
        tickerControl.showNumber(price)
    }
    
}
