//
//  CoinCollectionViewDataSource.swift
//  RomanWalk
//
//  Created by Somogyi Balázs on 2020. 04. 21..
//  Copyright © 2020. Somogyi Balázs. All rights reserved.
//

import UIKit
import Kingfisher
import SwiftMessages

protocol CoinCollectionViewChangeDelegate: class {
    func dataSourceShouldReload()
}

class CoinCollectionViewDataHandler: NSObject, UICollectionViewDataSource {
    
    private var coinDataSource: CoinDataSource?
    weak var delegate: CoinCollectionViewChangeDelegate?
    var percentage: Int = 0
    
    let numberOfItemsPerRow: CGFloat
    let interItemSpacing: CGFloat
    let sideSpacing = CGFloat(20.0)
    
    override init() {
        self.numberOfItemsPerRow = 3
        self.interItemSpacing = 10
        super.init()

        coinDataSource = CoinDataSource()
        coinDataSource?.delegate = self
    }
    
    func getCoin(for indexPath: IndexPath) -> Coin? {
        let newIndexPath = IndexPath(row: indexPath.row, section: indexPath.section - 1)
        if newIndexPath.section < 0  || newIndexPath.row < 0 {
            return nil
        }
        
        let coin = coinDataSource?.getCoin(for: newIndexPath)
        return coin
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if let sectionCount = coinDataSource?.fetchedResultsController.sections?.count {
            return sectionCount + 1
        } else {
            return  0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            guard let sections = coinDataSource?.fetchedResultsController.sections, let coins = sections[section - 1].objects else {
                return 0
            }
            return coins.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CoinTitleSupplementaryView.reuseIdentifier, for: indexPath) as? CoinTitleSupplementaryView else { fatalError("Cannot create supplementary view")
        }
        
        if indexPath.section == 0 {
            view.label.text = "Szerezz kedvezményt!"
        } else {
            if let coins = coinDataSource?.fetchedResultsController.sections?[indexPath.section - 1].objects as? [Coin],
                let coin = coins.first {
                view.label.text = coin.collected ? "Megszerzett érmék" : "Még fel nem fedezett érmék"
            }
        }
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CoinStaticCollectionViewCell.reuseIdentifier, for: indexPath) as? CoinStaticCollectionViewCell else { fatalError("Cannot create new cell") }
            
            cell.descriptionLabel.text = """
                                        Minden pénzérme megszerzésével 2% kedvezményt kapsz a múzeumi shop
                                        vásárlásodból! Eddigi kedvezményed:
                                        """
            if let coins = coinDataSource?.coins {
                percentage = (coins.filter { $0.collected}.count) * 2
            }
            
            cell.percentageLabel.text = "\(percentage) %"
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CoinCollectionViewCell.reuseIdentifier, for: indexPath) as? CoinCollectionViewCell else { fatalError("Cannot create new cell") }
            
            if let coin = coinDataSource?.fetchedResultsController.object(at: IndexPath(row: indexPath.row, section: indexPath.section - 1)) {
                
                if coin.collected {
                    cell.imageView.loadImage(for: coin)
                } else {
                    let p = BlackWhiteProcessor() |> BlurImageProcessor(blurRadius: 60)
                    cell.imageView.loadImage(for: coin, with: p)
                }
            } else {
                fatalError("Cannot create new cell")
            }
            return cell
        }
    }
}

extension CoinCollectionViewDataHandler: CoinDataSourceDelegate {
    func dataSource(_ dataSource: CoinDataSource, didChangeContent coins: [Coin]) {
        delegate?.dataSourceShouldReload()
    }
}

extension CoinCollectionViewDataHandler: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxWidth = UIScreen.main.bounds.width
    
        if indexPath.section == 0 {
            return CGSize(width: maxWidth - (2 * sideSpacing), height: (maxWidth - (2 * sideSpacing)) / 2)
        } else {
            let totalSpacing = interItemSpacing * numberOfItemsPerRow + (sideSpacing * 2)
            let itemWidth = (maxWidth - totalSpacing)/numberOfItemsPerRow
            return CGSize(width: itemWidth, height: itemWidth)
        }
    }
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return interItemSpacing
    }
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return interItemSpacing
    }
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 0, left: sideSpacing, bottom: interItemSpacing/2, right: sideSpacing)
        } else {
            return UIEdgeInsets(top: interItemSpacing/2, left: sideSpacing, bottom: interItemSpacing/2, right: sideSpacing)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 44)
    }
}

extension CoinCollectionViewDataHandler: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let coin = getCoin(for: indexPath) else { return }
        
        let backButton: (() -> Void)? = {
            SwiftMessages.hide()
        }
        
        showCoin(coin: coin, backButton: backButton)
    }
    
    func showCoin(coin: Coin, backButton: (() -> Void)?) {
        let view: CoinDetailView = try! SwiftMessages.viewFromNib()
        view.configureDropShadow()
        view.configureBackgroundView(width: 300)
        view.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
        if coin.collected {
            view.coinCollected.text = "Megszerzett érme"
            view.coinImageView.loadImage(for: coin)
        } else {
            view.coinCollected.text = "Még fel nem fedezett érme"
            let processor = BlackWhiteProcessor() |> BlurImageProcessor(blurRadius: 60)
            view.coinImageView.loadImage(for: coin, with: processor)
        }
        
        view.titleLabel?.text = coin.location
        view.backButton = backButton
        var config = SwiftMessages.defaultConfig
        config.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        config.duration = .forever
        config.presentationStyle = .center
        config.dimMode = .blur(style: .dark, alpha: 0.7, interactive: true)
        SwiftMessages.show(config: config, view: view)
    }
}
