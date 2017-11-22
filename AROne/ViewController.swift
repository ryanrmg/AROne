//
//  ViewController.swift
//  AROne
//
//  Created by Ryan Gess on 11/13/17.
//  Copyright © 2017 Ryan Gess. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate, SCNPhysicsContactDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var debug = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
        
        debugMode(a: true)
        
        sceneView.scene.physicsWorld.gravity = SCNVector3Make(0, -2.0, 0)
        createTable()
    }
    
    func debugMode(a: Bool){
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        let debug = a
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let results = sceneView.hitTest(touch.location(in: sceneView), types: [ARHitTestResult.ResultType.featurePoint])
        guard let hitFeature = results.last else { return }
        let hitTransform = SCNMatrix4(hitFeature.worldTransform)
        let hitPosition = SCNVector3Make(hitTransform.m41, hitTransform.m42, hitTransform.m43)
        
        if (debug){
            print(hitTransform.m41)
            print(hitTransform.m42)
            print(hitTransform.m43)
        }
        
        createBall(hitPosition: hitPosition)
    }
    
    func createBall(hitPosition : SCNVector3) {
        let ball = SCNSphere(radius: 0.1)
        let newBallNode = SCNNode(geometry: ball)
        newBallNode.position = hitPosition
        let physicsBallShape = SCNPhysicsShape(node: newBallNode)
        let physicsBallBody = SCNPhysicsBody.init(type: SCNPhysicsBodyType.dynamic, shape: physicsBallShape)
        physicsBallBody.isAffectedByGravity = true
        newBallNode.physicsBody = physicsBallBody
        
        ball.firstMaterial?.diffuse.contents = UIColor.blue
        //newBallNode
        self.sceneView.scene.rootNode.addChildNode(newBallNode)
        
    }
    
    func createTable(){
        let net = SCNBox(width: 1, height: 0.1, length: 1, chamferRadius: 0)
        let netNode = SCNNode(geometry: net)
        netNode.position = SCNVector3Make(0, -0.5, -1.0)
        let physicsNetShape = SCNPhysicsShape(node: netNode)
        let physicsNetBody = SCNPhysicsBody.init(type: SCNPhysicsBodyType.dynamic, shape: physicsNetShape)
        netNode.physicsBody = physicsNetBody
        physicsNetBody.isAffectedByGravity = false
        
        net.firstMaterial?.diffuse.contents = UIColor.green
        self.sceneView.scene.rootNode.addChildNode(netNode)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
