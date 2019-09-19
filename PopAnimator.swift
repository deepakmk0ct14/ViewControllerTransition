/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import Foundation
import UIKit


class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let transition = 1.0
    var originalFrame = CGRect.zero
    var presenting = true
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transition
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let toView = transitionContext.view(forKey: .to) else { return }
        guard let animatingView = presenting ? toView : transitionContext.view(forKey: .from) else { return }
        
        let initalFrame = presenting ? originalFrame : animatingView.frame
        let finalFrame = presenting ? animatingView.frame : originalFrame
        
        let scaleFactorX = presenting ? initalFrame.width / finalFrame.width : finalFrame.width / initalFrame.width
        let scaleFactorY = presenting ? initalFrame.height / finalFrame.height : finalFrame.height / initalFrame.height
        let scaleFactor = CGAffineTransform(scaleX: scaleFactorX, y: scaleFactorY)
        
        if(presenting) {
            animatingView.transform = scaleFactor
            animatingView.center = CGPoint(
                x: initalFrame.midX,
                y: initalFrame.midY
            )
        }
        
        animatingView.layer.cornerRadius = presenting ? 20/scaleFactorX : 0.0
        animatingView.clipsToBounds = true
        containerView.addSubview(toView)
        containerView.bringSubviewToFront(animatingView)
        UIView.animate(
            withDuration: 1,
            delay: 0.0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.0,
            animations: {
                animatingView.layer.cornerRadius = self.presenting ? 0.0: 20/scaleFactorX
                animatingView.transform = self.presenting ? .identity : scaleFactor
                animatingView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
        }) { _ in
            transitionContext.completeTransition(true)
        }
    }
}
