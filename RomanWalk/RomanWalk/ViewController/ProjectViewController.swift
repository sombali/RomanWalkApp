//
//  ProjectViewController.swift
//  RomanWalk
//
//  Created by Somogyi Balázs on 2020. 04. 03..
//  Copyright © 2020. Somogyi Balázs. All rights reserved.
//

import UIKit
import Reachability
import SwiftEventBus

class ProjectViewController: UIViewController, Storyboarded {
    
    weak var coordinator: ProjectCoordinator?
    let reachability = try! Reachability()
    var enableProjectStart = true
    
    enum Section {
        case main
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Project>!
    private var projectDataSource: ProjectDataSource?
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
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        projectDataSource = ProjectDataSource()
        
        SwiftEventBus.onMainThread(self, name: DownloadError.imageDownloadError.rawValue) { result in
            self.errorHandling()
        }
        
        
        SwiftEventBus.onMainThread(self, name: DownloadError.firebaseDownloadError.rawValue) { (result) in
            self.errorHandling()
        }
        
        reachability.whenUnreachable = { reachability in
            self.enableProjectStart = false
            self.showNetworkNotReachableStatusBar()
            self.errorHandling()
        }
        
        reachability.whenReachable = { reachability in
            self.hideMessage()
            self.enableProjectStart = true
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        projectDataSource?.delegate = self

        collectionView.delegate = self
        
        collectionView.register(ProjectCollectionViewCell.self, forCellWithReuseIdentifier: ProjectCollectionViewCell.reuseIdentifier)
        collectionView.collectionViewLayout = createLayout()
        
        configureDataSource()
        if let projectDataSource = projectDataSource {
            configureSnapshot(with: projectDataSource.projects)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        reachability.stopNotifier()
    }
    
    //MARK: Error handling
    @objc func errorHandling() {
        let downloadErrorHandler = DownloadErrorHandler()
        self.removeSpinner()
        downloadErrorHandler.showProjectLoadError(for: self) { (result) -> (Void) in
            switch result {
            case .success():
                self.createSpinnerView()
            case .failure(_):
                abort()
            }
        }
    }
}

//MARK: DataSource and Layout Configuration
extension ProjectViewController {
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
        dataSource = UICollectionViewDiffableDataSource<Section, Project>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, project: Project) -> UICollectionViewCell? in

            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ProjectCollectionViewCell.reuseIdentifier,
                for: indexPath) as? ProjectCollectionViewCell else { fatalError("Cannot create new cell") }
            
            if let name = project.name, let image = project.image {
                cell.imageView.kf.indicatorType = .activity
                cell.imageView.kf.setImage(with: image)
                cell.nameLabel.text = name
            }
            
            return cell
        }
    }
    
    func configureSnapshot(with projects: [Project]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Project>()
        snapshot.appendSections([.main])
        snapshot.appendItems(projects)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

//MARK: UICollectionViewDelegate
extension ProjectViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectedProject = dataSource.itemIdentifier(for: indexPath),
            let organisation = selectedProject.organisation,
            let organisationId = organisation.id,
            let projectId = selectedProject.id {
            
            if enableProjectStart {
                createPopup(organisationId, projectId)
            }
        }
    }
    
    func createPopup(_ organisationId: String, _ projectId: String) {
        let buttonTapped: ((UIButton) -> Void)? = { _ in
            self.hideMessage()
            self.reachability.stopNotifier()

            let defaults = UserDefaults.standard
            if defaults.object(forKey: "ProjectID") as? String != projectId {
                self.saveProjectIdToUserDefaults(projectId: projectId)
                self.saveOrganisationIdToUserDefaults(organisationId: organisationId)
                self.generateGameID()
                self.setDownloadNeededProperty(to: true)
            } else {
                self.setDownloadNeededProperty(to: false)
            }
            self.coordinator?.openProject(with: self, organisationId: organisationId, projectId: projectId)
            
        }
        
        showMessageWithOneButton(title: "Kezdhetjük a játékot?", body: nil, iconImage: nil, iconText: "🎮", buttonImage: nil, buttonTitle: "Igen", with: buttonTapped)
    }
    
    func setDownloadNeededProperty(to value: Bool) {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: "DownloadNeeded")
    }
    
    func saveProjectIdToUserDefaults(projectId: String) {
        let defaults = UserDefaults.standard
        defaults.set(projectId, forKey: "ProjectID")
    }
    
    func saveOrganisationIdToUserDefaults(organisationId: String) {
        let defaults = UserDefaults.standard
        defaults.set(organisationId, forKey: "OrganisationID")
    }
    
    func generateGameID() {
        let defaults = UserDefaults.standard
        let gameID = UUID()
        defaults.set(gameID.uuidString, forKey: "GameID")
    }
}

//MARK: ProjectDataSourceDelegate
extension ProjectViewController: ProjectDataSourceDelegate {
    func dataSource(_ dataSource: ProjectDataSource, didFinishFetching projects: [Project]) {
        configureSnapshot(with: projects)
        removeSpinner()
    }
}

