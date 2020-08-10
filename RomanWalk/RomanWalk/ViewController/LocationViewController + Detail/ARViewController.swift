//
//  ARViewController.swift
//  RomanWalk
//
//  Created by Somogyi Balázs on 2020. 04. 28..
//  Copyright © 2020. Somogyi Balázs. All rights reserved.
//
import UIKit
import SceneKit
import ARKit

class ARViewController: UIViewController, ARSCNViewDelegate, Storyboarded {

    @IBOutlet weak var sceneView: ARSCNView!
    var location: Location?
    
    var currentNode: SCNNode?
    var currentAngleY: Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.showsStatistics = false
        
        setupSceneView()
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.scaleObject(gesture:)))
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.rotateObject(_:)))
        self.view.addGestureRecognizer(pinchGesture)
        self.view.addGestureRecognizer(panGesture)
        
    }
    
    @objc func scaleObject(gesture: UIPinchGestureRecognizer) {

        guard let currentNode = currentNode else { return }
        if gesture.state == .changed {

            let scaleX: CGFloat = gesture.scale * CGFloat((currentNode.scale.x))
            let scaleY: CGFloat = gesture.scale * CGFloat((currentNode.scale.y))
            let scaleZ: CGFloat = gesture.scale * CGFloat((currentNode.scale.z))
            currentNode.scale = SCNVector3Make(Float(scaleX), Float(scaleY), Float(scaleZ))
            gesture.scale = 1

        }
        if gesture.state == .ended { }
    }
    
    @objc func rotateObject(_ gesture: UIPanGestureRecognizer) {

        guard let nodeToRotate = currentNode else { return }

        let translation = gesture.translation(in: gesture.view!)
        var newAngleY = (Float)(translation.x)*(Float)(Double.pi)/180.0
        newAngleY += currentAngleY

        nodeToRotate.eulerAngles.y = newAngleY

        if(gesture.state == .ended) {
            currentAngleY = newAngleY
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()

        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        presentError()
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        presentError()
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        resetARSession()
    }
    
    func presentError() {
        let alertController = UIAlertController(title: "Hiba", message: "Kérlek próbáld újra később", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (_) in
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
    func resetARSession() {
        sceneView.session.pause()
        sceneView.scene.rootNode.enumerateChildNodes { (node, stop) in
            node.removeFromParentNode() }
        setupARSession()
        setupSceneView()
    }

    func setupARSession() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.worldAlignment = .gravityAndHeading
        sceneView.session.run(configuration, options: [ARSession.RunOptions.resetTracking, ARSession.RunOptions.removeExistingAnchors])
    }
    
    func setupSceneView() {
        let scene = SCNScene()
        
        let shipScene = SCNScene(named: "ar.scnassets/ship.scn")
        scene.lightingEnvironment.contents = shipScene?.lightingEnvironment.contents
        
        guard let shipNode = shipScene?.rootNode.childNode(withName: "shipMesh", recursively: true) else { fatalError() }
//        guard let arNode = kapuScene?.rootNode else { return }
        currentNode = shipNode
        
        shipNode.position = SCNVector3(0, 0, -1)
        
        if let currentNode = currentNode {
            scene.rootNode.addChildNode(currentNode)
        }
        
        sceneView.scene = scene
    }
}
