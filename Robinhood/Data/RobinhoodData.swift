

import Foundation

struct RobinhoodDataModel {
  var cards: [RobinhoodCardViewModel] = []
  
  init(jsonContent: [[String: String]]) {
    self.cards = jsonContent.compactMap({ (cardModelJSON) -> RobinhoodCardViewModel? in
      guard let title = cardModelJSON["title"],
        let text = cardModelJSON["text"],
        let link = cardModelJSON["link"] else { return nil }
      
      return RobinhoodCardViewModel(title: title, text: text, link: link)
    })
  }
}

class RobinhoodData {
  static let jsonURL = Bundle.main.url(forResource: "RobinhoodData", withExtension: "json")!
  
  static var data: RobinhoodDataModel {
    do {
      let cardsData = try Data(contentsOf: jsonURL)
      
      if let cardsContent = try JSONSerialization.jsonObject(with: cardsData, options: JSONSerialization.ReadingOptions()) as? [[String: String]] {
        
        return RobinhoodDataModel(jsonContent: cardsContent)
        
      } else {
        return RobinhoodDataModel(jsonContent: [])
      }
    }
      
    catch {
      return RobinhoodDataModel(jsonContent: [])
    }
  }
}

struct RobinhoodChartData {
  let openingPrice: Double
  let data: [(date: Date, price: Double)]
  
  static var portfolioData: RobinhoodChartData {
    var chartData: [(date: Date, price: Double)] = []
    
    var dateComponents = DateComponents()
    dateComponents.year = 2018
    dateComponents.month = 5
    dateComponents.day = 4
    dateComponents.minute = 0
    
    let calendar = Calendar.current
    var startDateComponents = dateComponents
    startDateComponents.hour = 9
    let startDate = calendar.date(from: startDateComponents)
    
    var endDateComponents = dateComponents
    endDateComponents.hour = 16
    let endDate = calendar.date(from: endDateComponents)
    
    var dateInterval = DateInterval(start: startDate!, end: endDate!)
    
    let secondsInMinute = 60
    let timeIntervalIncrement = 5 * secondsInMinute
    let duration = Int(dateInterval.duration)
    
    let startPrice: Double = 240.78
    
    for i in stride(from: 0, to: duration, by: timeIntervalIncrement) {
      let date = startDate!.addingTimeInterval(TimeInterval(i))
      var randomPriceMovement = Double(arc4random_uniform(100))/50
      let upOrDown = arc4random_uniform(2)
      
      if upOrDown == 0 { randomPriceMovement = -randomPriceMovement }
      let chartDataPoint = (date: date, price: startPrice + randomPriceMovement)
      chartData.append(chartDataPoint)
    }

    let portfolioData = RobinhoodChartData(openingPrice: startPrice, data: chartData)
    
    return portfolioData
  }
}
