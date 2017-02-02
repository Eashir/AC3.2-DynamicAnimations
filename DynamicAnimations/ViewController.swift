//
//  ViewController.swift
//  DynamicAnimations
//
//  Created by Louis Tur on 1/26/17.
//  Copyright © 2017 AccessCode. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    var dynamicAnimator: UIDynamicAnimator? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        setupViewHierarchy()
        configureConstraints()
        
        self.dynamicAnimator = UIDynamicAnimator(referenceView: view)
    }
    
    private func configureConstraints() {
        self.edgesForExtendedLayout = []
        
        spartanImageView.snp.makeConstraints { (imageView) in
            imageView.leading.bottom.equalToSuperview()
            imageView.size.equalTo(CGSize(width: 100, height: 300))
        }
        
        blueView.snp.makeConstraints { (view) in
            view.top.centerX.equalToSuperview()
            view.size.equalTo(CGSize(width: 100, height: 100))
        }
        
        yellowView.snp.makeConstraints { (view) in
            view.leading.equalTo(spartanImageView.snp.leading)
            view.size.equalTo(CGSize(width: 10, height: 10))
        }
        
        bangbangButton.snp.makeConstraints { (view) in
            view.centerX.equalToSuperview()
            view.bottom.equalToSuperview().inset(50.0)
        }
        
        deSnapButton.snp.makeConstraints { (view) in
            view.centerX.equalToSuperview()
            view.top.equalTo(bangbangButton.snp.bottom).offset(8.0)
        }
        
        greenView.snp.makeConstraints { (view) in
            view.leading.trailing.centerY.equalToSuperview()
            view.height.equalTo(20.0)
        }
    }
    
    private func setupViewHierarchy() {
        self.view.addSubview(spartanImageView)
        
        self.view.addSubview(blueView)
        self.view.addSubview(yellowView)
        self.view.addSubview(greenView)
        
        self.view.addSubview(bangbangButton)
        self.view.addSubview(deSnapButton)
        
        self.bangbangButton.addTarget(self, action: #selector(Bangbang), for: .touchUpInside)
        self.deSnapButton.addTarget(self, action: #selector(deSnapFromCenter), for: .touchUpInside)
    }
    
    
    internal func Bangbang() {
        //                let snappingBehavior = UISnapBehavior(item: yellowView, snapTo: self.view.center)
        //                snappingBehavior.damping = 1.0
        //                self.dynamicAnimator?.addBehavior(snappingBehavior)
        //
        //        let gravityBehavior = UIGravityBehavior(items: [yellowView])
        //        //    gravityBehavior.angle = CGFloat.pi / 6.0
        //        gravityBehavior.magnitude = 0.2
        //        gravityBehavior.angle = 0
        //        self.dynamicAnimator?.addBehavior(gravityBehavior)
        //
        
        generateBullet()
        
    }
    
    internal func deSnapFromCenter() {
        
        // what to do... what. to. do?
        
        let _ = dynamicAnimator?.behaviors.map {
            if $0 is UIGravityBehavior {
                self.dynamicAnimator?.removeBehavior($0)
            }
        }
        
    }
    
    func generateBullet() {
        //View
        var bulletView: UIView?
        if let validBullet = bulletView {
            validBullet.backgroundColor = .yellow
            view.addSubview(validBullet)
            
            //Constraint
            validBullet.snp.makeConstraints { (view) in
                view.bottom.equalTo(spartanImageView.snp.bottom)
                view.size.equalTo(CGSize(width: 10, height: 10))
            }
            
            //Behavior
            let gravityBehavior = UIGravityBehavior(items: [validBullet])
            //    gravityBehavior.angle = CGFloat.pi / 6.0
            gravityBehavior.magnitude = 0.2
            gravityBehavior.angle = 0
            self.dynamicAnimator?.addBehavior(gravityBehavior)
        }
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - Views
    internal lazy var spartanImageView: UIImageView = {
        let image = #imageLiteral(resourceName: "Honor Guard")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    internal lazy var blueView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .blue
        return view
    }()
    
    internal lazy var yellowView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .yellow
        return view
    }()
    
    internal lazy var greenView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .green
        return view
    }()
    
    internal lazy var bangbangButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle("SHOOT!", for: .normal)
        return button
    }()
    
    internal lazy var deSnapButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle("(de)SNAP!", for: .normal)
        return button
    }()
    
}

class BouncyViewBehavior: UIDynamicBehavior {
    
    override init() {
    }
    
    convenience init(items: [UIDynamicItem]) {
        self.init()
        
        let gravityBehavior = UIGravityBehavior(items: items)
        //    gravityBehavior.angle = CGFloat.pi / 6.0
        gravityBehavior.magnitude = 0.2
        gravityBehavior.angle = 0
        self.addChildBehavior(gravityBehavior)
        
        let collisionBehavior = UICollisionBehavior(items: items)
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        self.addChildBehavior(collisionBehavior)
        
        let elasticBehavior = UIDynamicItemBehavior(items: items)
        elasticBehavior.elasticity = 0.5
        elasticBehavior.addAngularVelocity(CGFloat.pi / 6.0, for: items.first!)
        self.addChildBehavior(elasticBehavior)
    }
}
