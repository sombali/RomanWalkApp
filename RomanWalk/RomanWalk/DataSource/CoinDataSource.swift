//
//  CoinDataSource.swift
//  RomanWalk
//
//  Created by Somogyi Balázs on 2020. 04. 18..
//  Copyright © 2020. Somogyi Balázs. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import SwiftEventBus

protocol CoinDataSourceDelegate: class {
    func dataSource(_ dataSource: CoinDataSource, didChangeContent coins: [Coin])
}

class CoinDataSource: NSObject {
    var coins: [Coin]
    
    private let managedObjectContext = AppDelegate.managedContext
    var fetchedResultsController: NSFetchedResultsController<Coin>!
    weak var delegate: CoinDataSourceDelegate?
    
    override init() {
        coins = [Coin]()
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.coinEarned(_:)),
                                            name: NSNotification.Name(rawValue: "CoinEarned"), object: nil)
        
        fetchCoins()
    }
    
    private func fetchCoins() {
        let fetchRequest: NSFetchRequest<Coin> = Coin.fetchRequest()
               
        let nameSortDescriptor: NSSortDescriptor = NSSortDescriptor(key: #keyPath(Coin.name), ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
        let collectedSortDescriptor = NSSortDescriptor(key: #keyPath(Coin.collected), ascending: false)
        fetchRequest.sortDescriptors = [collectedSortDescriptor, nameSortDescriptor]
   
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: #keyPath(Coin.collected), cacheName: nil)
        fetchedResultsController.delegate = self
        
        fetchRequest.fetchBatchSize = 20
       
        do {
            try fetchedResultsController.performFetch()
           
            if let coins = fetchedResultsController.fetchedObjects {
                self.coins = coins
            }

        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    @objc func coinEarned(_ notification: Notification) {
        if let dict = notification.userInfo as NSDictionary? {
            if let locationName = dict["locationName"] as? String {
                let coin = self.coins.filter { $0.location == locationName }.first
                if let coin = coin {
                    coin.collected = true
                    (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
                }
            }
        }
    }
    
    func getCoin(for indexPath: IndexPath) -> Coin {
        return fetchedResultsController.object(at: indexPath)
    }
}

//MARK: NSFetchedREsultsControllerDelegate
extension CoinDataSource: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let coins = fetchedResultsController.fetchedObjects {
            self.coins = coins
            self.delegate?.dataSource(self, didChangeContent: coins)
        }
    }
}
