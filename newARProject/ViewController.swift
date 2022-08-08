//
//  ViewController.swift
//  newARProject
//
//  Created by Дмитрий Бакчеев on 7/27/22.
//

import UIKit
import SceneKit
import ARKit


class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    var hero: SCNNode!
    var heroTemplateNode: SCNNode!
    var gameWorldCenterTransform: SCNMatrix4 = SCNMatrix4Identity
    var statusMessage: String = ""
    var trackingStatus: String = ""
    var player: AVAudioPlayer?
    var flashlight = Flashlight()
    
    
    
    let arscnView: ARSCNView = {
        let view = ARSCNView()
        
        return view
    }()
    
    lazy var skView: SKView = {
        let view = SKView()
        view.isMultipleTouchEnabled = true
        view.backgroundColor = .clear
        view.isHidden = true
        return view
    }()
    
    lazy var startButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5)
        button.setTitle("Start", for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(startGame), for: .touchUpInside)
        button.isHidden = false
        return button
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        setupARSCNView()
        setupSKView()
        initSceneView()
        initScene()
        initARSession()
        loadModels()
        setupSKViewScene()
        setupARSCNViewSubviews()
       
        
        NotificationCenter.default.addObserver(forName: joystickNotificationName, object: nil, queue: OperationQueue.main) { (notification) in
            guard let userInfo = notification.userInfo else { return }
            let data = userInfo["data"] as! AnalogJoystickData
            
            //      print(data.description)
            
            self.hero.position = SCNVector3(self.hero.position.x + Float(data.velocity.x * joystickVelocityMultiplier), self.hero.position.y, self.hero.position.z - Float(data.velocity.y * joystickVelocityMultiplier))
            
            self.hero.eulerAngles.y = Float(data.angular) + Float(180.0.degreesToRadians)
            
        }
    }
    
    func setupSKView() {
        view.addSubview(skView)
        
        skView.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 180)
    }
    
    func setupSKViewScene() {
        let scene = ARJoystickSKScene(size: CGSize(width: view.bounds.size.width, height: 180))
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
        skView.ignoresSiblingOrder = true
        //    skView.showsFPS = true
        //    skView.showsNodeCount = true
        skView.showsPhysics = true
    }
    
    
    func initSceneView() {
        arscnView.delegate = self
//        arscnView.autoenablesDefaultLighting = true
        
        
    }
    
    func initScene() {
        let scene = SCNScene()
        scene.isPaused = false
        arscnView.scene = scene
    }
    
    func initARSession() {
        guard ARWorldTrackingConfiguration.isSupported else {
            
            return
        }
        
        let config = ARWorldTrackingConfiguration()
        config.worldAlignment = .gravity
        config.providesAudioData = false
        config.planeDetection = .horizontal
        arscnView.session.run(config, options: [.resetTracking, .removeExistingAnchors])
    }
    
    
    
    
    
    
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
 
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    
    func setupARSCNView() {
        view.addSubview(arscnView)
        arscnView.fillSuperview()
    }
    
    
    func setupARSCNViewSubviews() {
        arscnView.addSubview(startButton)
        
        startButton.anchor(arscnView.safeAreaLayoutGuide.topAnchor, left: arscnView.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: arscnView.safeAreaLayoutGuide.rightAnchor, topConstant: 6, leftConstant: 6, bottomConstant: 0, rightConstant: 6, widthConstant: 0, heightConstant: 44)
        
    }
    
    
    
    func loadModels() {
        
        let heroScene = SCNScene(named: Constants.heroScenePath)!
        heroTemplateNode = heroScene.rootNode.childNode(withName: Constants.heroNodeName, recursively: false)!
        
        
    }
    
    
    
    @objc func startGame() {
        DispatchQueue.main.async {
            self.startButton.isHidden = true
            self.createGameWorld()
            self.flashlight.toggleTorch(on: false)
            
           
        }
    }
    func createGameWorld() {
        
        
        skView.isHidden = false
        addHero(to: arscnView.scene.rootNode)
        addLightNode(to: arscnView.scene.rootNode)
        playBackgroundMusic(to: arscnView.scene.rootNode)
    }
    
    
    
    func addHero(to rootNode: SCNNode) {
        hero = heroTemplateNode.clone()
        hero.name = Constants.heroNodeName
        hero.position = SCNVector3(0, -0.5, -2)
        hero.eulerAngles = SCNVector3(0,90.0.degreesToRadians,0)
        hero.scale = SCNVector3(0.02, 0.02, 0.02)
        
        rootNode.addChildNode(hero)
    }
    
    func addLightNode(to rootNode: SCNNode) {
        // Create ambient light
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor(white: 0.70, alpha: 1.0)


        // Add ambient light to scene
        rootNode.addChildNode(ambientLightNode)
        
        
        // Create directional light
        let directionalLight = SCNNode()
        directionalLight.light = SCNLight()
        directionalLight.light!.type = .directional
        directionalLight.light!.color = UIColor(white: 1.0, alpha: 1.0)
        directionalLight.eulerAngles = SCNVector3(x: 5, y: 5, z: 5)
//        directionalLight.position = SCNVector3Zero
        directionalLight.light?.intensity = 5000
        
        // Add directional light to scene
        rootNode.addChildNode(directionalLight)

    }
    
    
    
    
    

    
    
    // MARK: - ARSCNViewDelegate
    
    /*
     // Override to create and configure nodes for anchors added to the view's session.
     func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
     let node = SCNNode()
     
     return node
     }
     */
    //
    //    func session(_ session: ARSession, didFailWithError error: Error) {
    //        // Present an error message to the user
    //
    //    }
    //
    //    func sessionWasInterrupted(_ session: ARSession) {
    //        // Inform the user that the session has been interrupted, for example, by presenting an overlay
    //
    //    }
    //
    //    func sessionInterruptionEnded(_ session: ARSession) {
    //        // Reset tracking and/or remove existing anchors if consistent tracking is required
    //
    //    }
    
    
}
