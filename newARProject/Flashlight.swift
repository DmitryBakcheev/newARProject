//
//  Flashlight.swift
//  newARProject
//
//  Created by Дмитрий Бакчеев on 8/6/22.
//

import Foundation
import AVKit


struct Flashlight {
    

    func toggleTorch(on: Bool) {
        
        guard
            let device = AVCaptureDevice.default(for: AVMediaType.video),
            device.hasTorch
        else { return }
        
        
        do {
            try device.lockForConfiguration()
            
            device.torchMode = on ? .on : .off
            
            device.unlockForConfiguration()
        } catch {
            print("Torch could not be used")
        }

    }
    
}
