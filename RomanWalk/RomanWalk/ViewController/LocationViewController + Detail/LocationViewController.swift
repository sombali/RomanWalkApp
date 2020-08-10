//
//  LocationViewController.swift
//  RomanWalk
//
//  Created by Somogyi Balázs on 2020. 03. 18..
//  Copyright © 2020. Somogyi Balázs. All rights reserved.
//

import UIKit
import CoreData
import Kingfisher
import SwiftEventBus

class LocationViewController: UIViewController, Storyboarded {
    enum Section {
        case main
    }
    
    weak var coordinator: LocationCoordinator?
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let managedObjectContext = AppDelegate.managedContext

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Location.Diffable>!
    
    private var locationDataSource: LocationDataSource?
    var errorPresented = false
    let child = SpinnerViewController()
    
    func createSpinnerView() {
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func removeSpinner() {
        child.willMove(toParent: nil)
        child.view.removeFromSuperview()
        child.removeFromParent()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let bgImage = UIImageView();
        bgImage.image = UIImage(named: "background");
        bgImage.contentMode = .scaleToFill
        self.collectionView.backgroundView = bgImage
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Projektek", style: .plain, target: self, action: #selector(projectSelected))
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        SwiftEventBus.onMainThread(self, name: DownloadError.imageDownloadError.rawValue) { result in
            self.errorHandling()
        }
        
        SwiftEventBus.onMainThread(self, name: DownloadError.firebaseDownloadError.rawValue) { (result) in
            self.errorHandling()
        }
        
        locationDataSource = LocationDataSource()
        locationDataSource?.delegate = self
        
        collectionView.delegate = self
        
        collectionView.register(LocationCollectionViewCell.self, forCellWithReuseIdentifier: LocationCollectionViewCell.reuseIdentifier)
        collectionView.collectionViewLayout = createLayout()
        
        configureDataSource()
        if let locationDataSource = locationDataSource {
            configureSnapshot(with: locationDataSource.locations)
        }
    }
    
    @objc func projectSelected() {
        coordinator?.openProjectList(from: self)
    }

    //MARK: Error handling
    func errorHandling() {
        if !errorPresented {
            let downloadErrorHandler = DownloadErrorHandler()
            errorPresented = true
            
            removeSpinner()
            
            downloadErrorHandler.showError(for: self) { (result) -> (Void) in
                switch result {
                case .success():
                    self.errorPresented = false
                    self.createSpinnerView()
                    self.locationDataSource?.fetchLocations()
                case .failure(_):
                    abort()
                }
            }
        }
    }
}

//MARK: DataSource and Layout configuration
extension LocationViewController {
    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
       
        let layout = UICollectionViewCompositionalLayout(section: section)
       
        return layout
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Location.Diffable>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, location: Location.Diffable) -> UICollectionViewCell? in

            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: LocationCollectionViewCell.reuseIdentifier,
                for: indexPath) as? LocationCollectionViewCell else { fatalError("Cannot create new cell") }
            
            cell.imageView.loadImage(for: location)
            cell.nameLabel.text =  location.name
            cell.locationLabel.text = location.address

            return cell
        }
    }
    
    func configureSnapshot(with locations: [Location]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Location.Diffable>()
        snapshot.appendSections([.main])
        if let locations = locationDataSource?.locations {
            let locations = locations.map(Location.Diffable.init)
            snapshot.appendItems(locations)
            dataSource.apply(snapshot, animatingDifferences: true)

            removeSpinner()
        }
    }
}

//MARK: UICollectionViewDelegate
extension LocationViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let location = locationDataSource?.fetchedResultsController.object(at: indexPath) else { return }
        
        coordinator?.show(location)
    }
}

//MARK: LocationDataSourceDelegate
extension LocationViewController: LocationDataSourceDelegate {
    func dataSource(_ dataSource: LocationDataSource, didFinishFetching locations: [Location]) {
        configureSnapshot(with: locations)
    }
}

