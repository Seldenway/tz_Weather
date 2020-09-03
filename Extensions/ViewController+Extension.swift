import Foundation
import UIKit

extension ViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        switch scrollView {
        case self.topScrollView:
            if scrollView.contentOffset.y >= self.topView.frame.size.height {
                scrollView.bounces = false
                self.bottomScrollView.isUserInteractionEnabled = true
            } else {
                self.bottomScrollView.isUserInteractionEnabled = false
                scrollView.bounces = true
            }
            var alphaOpacity = scrollView.contentOffset.y / 128
            
            if alphaOpacity > 0 {
                alphaOpacity = 0.5 - alphaOpacity
                
                self.currentTemperatureView.alpha = alphaOpacity
                self.currentMinMaxTempView.alpha = alphaOpacity - 0.3
            } else {
                alphaOpacity = 1
                self.currentTemperatureView.alpha = alphaOpacity
                self.currentMinMaxTempView.alpha = alphaOpacity
                
            }
        case self.bottomScrollView:
            if scrollView.contentOffset.y >= 82.5 {
                scrollView.bounces = true
            } else {
                scrollView.bounces = false
            }
        default:
            break
        }
    }
}


extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let temp = NetworkService.shared.weatherData?.hourly
        
        return temp?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as? CustomCollectionViewCell else { return UICollectionViewCell() }
        
        self.collectionViewConfig(cell, indexPath)
        
        return cell
        
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let currentTemp = NetworkService.shared.weatherData?.daily.removeFirst()
        let temp = NetworkService.shared.weatherData?.daily
        self.minMaxTemperature = currentTemp
        
        return temp?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as? CustomTableViewCell else { return UITableViewCell() }
        
        self.tableViewConfig(cell, indexPath)
        
        return cell
    }
    
    
}
