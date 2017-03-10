//
//  CustomTransition.swift
//  TransitionImageSample
//
//  Created by 田中賢治 on 2017/03/09.
//  Copyright © 2017年 田中賢治. All rights reserved.
//

import UIKit

class CustomTransition: NSObject {
    class var sharedInstance: CustomTransition {
        struct Static {
            static let instance: CustomTransition = CustomTransition()
        }
        return Static.instance
    }
    
    fileprivate var isPresent = false
}

extension CustomTransition: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = false
        return self
    }
}

extension CustomTransition: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.7
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresent {
            presentTransition(transitionContext: transitionContext)
        } else {
            dissmissTransition(transitionContext: transitionContext)
        }
    }
    
    func presentTransition(transitionContext: UIViewControllerContextTransitioning) {
        let firstVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! FirstViewController
        let secondVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! SecondViewController
        let containerView = transitionContext.containerView
        
        let cell = firstVC.tableView.cellForRow(at: firstVC.tableView.indexPathForSelectedRow!) as! CustomCell
        let animationView = UIImageView(image: cell.subImageView.image)
        
        // convertって？ ビュー階層内で離れた位置にあるビュー同士の位置関係を参照するための変換処理。Window座標系の絶対位置を返す？
        animationView.frame = containerView.convert(cell.subImageView.frame, from: cell.subImageView.superview)
//        animationView.frame = cell.subImageView.frame // <- この指定だとView座標系がとれてしまう
//        animationView.frame = cell.subImageView.bounds // <- この指定だとView座標系がとれてしまう
        cell.subImageView.isHidden = true
        
        secondVC.view.frame = transitionContext.finalFrame(for: secondVC)
        secondVC.view.alpha = 0
        secondVC.imageView.isHidden = true
        
        containerView.addSubview(secondVC.view)
        containerView.addSubview(animationView)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            secondVC.view.alpha = 1.0
            animationView.frame = containerView.convert(secondVC.imageView.frame, from: secondVC.view)
        }, completion: { _ in
            secondVC.imageView.isHidden = false
            cell.subImageView.isHidden = false
            animationView.removeFromSuperview()
            transitionContext.completeTransition(true)
        })
    }
    
    func dissmissTransition(transitionContext:UIViewControllerContextTransitioning) {
        let secondVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! SecondViewController
        let firstVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! FirstViewController
        let containerView = transitionContext.containerView
        
        let cell = firstVC.tableView.cellForRow(at: secondVC.indexPath) as! CustomCell
        cell.subImageView.isHidden = true
        
        let animationView = UIImageView(image: secondVC.imageView.image)
        animationView.frame = containerView.convert(secondVC.imageView.frame, from: secondVC.imageView.superview)
        secondVC.imageView.isHidden = true
        
        firstVC.view.frame = transitionContext.finalFrame(for: firstVC)
        
        containerView.insertSubview(firstVC.view, belowSubview: secondVC.view)
        containerView.addSubview(animationView)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            secondVC.view.alpha = 0
            animationView.frame = containerView.convert(cell.subImageView.frame, from: cell.subImageView.superview)
        }, completion: { finished in
            animationView.removeFromSuperview()
            secondVC.imageView.isHidden = false
            cell.subImageView.isHidden = false
            transitionContext.completeTransition(true)
        })
    }

}
