//
//  File.swift
//  newARProject
//
//  Created by Дмитрий Бакчеев on 7/27/22.
//

import SpriteKit

class ARJoystickSKScene: SKScene {
  
  enum NodesZPosition: CGFloat {
    case joystick
  }
  
  lazy var analogJoystick: AnalogJoystick = {
    let js = AnalogJoystick(diameter: 100, colors: nil, images: (substrate: #imageLiteral(resourceName: "jSubstrate"), stick: #imageLiteral(resourceName: "jStick")))
      js.position = CGPoint(x: js.radius + 45, y: js.radius + 45)
    js.zPosition = NodesZPosition.joystick.rawValue
    return js
  }()
  
  override func didMove(to view: SKView) {
    self.backgroundColor = .clear
    setupNodes()
    setupJoystick()
  }
  
  func setupNodes() {
    anchorPoint = CGPoint(x: 0.0, y: 0.0)
  }
  
  func setupJoystick() {
    addChild(analogJoystick)
    
    analogJoystick.trackingHandler = { [unowned self] data in
      NotificationCenter.default.post(name: joystickNotificationName, object: nil, userInfo: ["data": data])
    }
    
  }
  
}


















