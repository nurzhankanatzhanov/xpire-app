//
//  Confetti.swift
//  XPIRE
//
//  Created by Nurzhan Kanatzhanov on 3/8/21.
//

import UIKit
import Foundation
import SAConfettiView

// pass in a UIView where we need to run the confetti animation, after which the timer would go off and after 6 seconds the confetti animation will stop.
public func createConfetti(view: UIView) {
    let confetti = SAConfettiView(frame: view.bounds)
    confetti.type = .Confetti
    
    view.addSubview(confetti)
    confetti.startConfetti()
    
    confetti.isUserInteractionEnabled = false
    
    // after 6 seconds after the view has loaded, stop the confetti animation
    _ = Timer.scheduledTimer(withTimeInterval: 4, repeats: false) { timer in
        confetti.stopConfetti()
    }
}

