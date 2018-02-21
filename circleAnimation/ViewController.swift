//
//  ViewController.swift
//  circleAnimation
//
//  Created by Siddharth Kumar on 21/02/18.
//  Copyright © 2018 Siddharth Kumar. All rights reserved.
//

import UIKit
import YouTubePlayer


class ViewController: UIViewController, YouTubePlayerDelegate {
    
    var playerView: YouTubePlayerView!
    var playerViewContainer: UIView!
    var questionViewContainer: UIView!
    var QuestionView: UIView!
    var questionViewMask: CALayer?
    var playerViewMask: CALayer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = UIColor.UIColorFromHex(0x2f2344)
        questionViewContainer = UIView(frame: self.view.frame)
        view.addSubview(questionViewContainer)
        questionViewContainer.backgroundColor = UIColor.UIColorFromHex(0x2f2344)
        
        let circleView = UIView(frame: CGRect(x: 0, y: view.frame.width*0.5, width: view.frame.width*0.33, height: view.frame.width*0.33  ))
        circleView.center.x = view.center.x
        circleView.center.y = view.frame.width*0.5
        circleView.layer.cornerRadius = circleView.frame.width/2
        circleView.backgroundColor = UIColor.UIColorFromHex(0x50295b)
        questionViewContainer.addSubview(circleView)
        
        QuestionView = UIView(frame: CGRect(x: 0, y: view.frame.width*0.5, width: view.frame.width*0.9, height:view.frame.height*0.65))
        QuestionView.center.x = view.center.x
        QuestionView.layer.cornerRadius = QuestionView.frame.width/15
        QuestionView.backgroundColor = UIColor.UIColorFromHex(0x50295b)
        questionViewContainer.addSubview(QuestionView)
        
        self.questionViewMask = CALayer()
        self.questionViewMask!.contents = UIImage(named:"circle_mask")!.cgImage
        self.questionViewMask!.contentsGravity = kCAGravityResizeAspect
        self.questionViewMask!.bounds = CGRect(x:0, y:0, width: 0, height:0)
        self.questionViewMask!.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.questionViewMask!.position = CGPoint(x: view.frame.size.width/2, y: view.frame.size.height/2)
        
        playerViewContainer = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width))
        view.addSubview(playerViewContainer)
        
        self.playerViewMask = CALayer()
        self.playerViewMask!.contents = UIImage(named:"circle_mask")!.cgImage
        self.playerViewMask!.contentsGravity = kCAGravityResizeAspect
        self.playerViewMask!.bounds = CGRect(x:0, y:0, width: 0, height:0)
        self.playerViewMask!.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.playerViewMask!.position = CGPoint(x: view.frame.size.width/2, y: view.frame.size.width/2)
        
        playerView = YouTubePlayerView(frame: self.view.frame)
        playerView.isUserInteractionEnabled = false
        
        playerViewContainer.addSubview(playerView)
        playerView.delegate = self
        
        if (Reachable.isConnectedToNetwork() == true){
            
            loadVideo(videoId: "lYVEQ-ksNec")
            
        }
        else{
            UIAlertView.init(title: "No Internet!", message:"Please check your internet connection.", delegate: self, cancelButtonTitle: "OK").show()
        }
    }
    
    func animate(){
        
        Timer.scheduledTimer(withTimeInterval: 10, repeats: true) {_ in
            
            let random = arc4random_uniform(5)
            let yValue = 0.8 + (0.05 * Double(random))
            
            self.QuestionView.transform = CGAffineTransform(scaleX: 1, y: CGFloat(yValue))
            self.QuestionView.frame.origin.y = self.view.frame.width/2
            self.questionViewContainer.layer.mask = self.questionViewMask
            self.playerViewContainer.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
            self.playerViewContainer.layer.cornerRadius = self.view.frame.width/2
            self.playerViewContainer.clipsToBounds = true
            
            self.revealAnimation(self.questionViewMask!, duration: 0.75)
            
            
            
        }
        
        Timer.scheduledTimer(withTimeInterval: 5, repeats: false){_ in
            
            Timer.scheduledTimer(withTimeInterval: 10, repeats: true) {_ in
                
                
                self.playerViewContainer.layer.mask = self.playerViewMask
                self.revealAnimation(self.playerViewMask!, duration: 0.75)
                self.playerViewContainer.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.playerViewContainer.layer.cornerRadius = 0
                self.playerViewContainer.clipsToBounds = false
                
            }}
    }
    
    func loadVideo(videoId: String) {
        playerView.playerVars = [
            "playsinline": "1" as AnyObject,
            "controls": "0" as AnyObject,
            "showinfo": "0" as AnyObject,
            "rel": "0" as AnyObject,
        ]
        playerView.loadVideoID(videoId)
        
    }
    
    func playerReady(_ videoPlayer: YouTubePlayerView){
        playerView.play()
        animate()
        
    }
    
    
    func playerStateChanged(_ videoPlayer: YouTubePlayerView, playerState: YouTubePlayerState){
        if playerView.playerState != YouTubePlayerState.Playing{
            playerView.play()
            
        }
    }
    
    
    override var prefersStatusBarHidden : Bool {
        
        return true;
    }
    
    
    func revealAnimation(_ mask : CALayer, duration : CFTimeInterval){
        let keyFrameAnimation = CAKeyframeAnimation(keyPath: "bounds")
        keyFrameAnimation.duration = duration
        keyFrameAnimation.beginTime = CACurrentMediaTime()
        
        let initialBounds = NSValue(cgRect:CGRect(x: 0, y: 0, width:0, height:0))
        let finalBounds = NSValue(cgRect:CGRect(x: 0, y: 0, width: 2500, height: 2500))
        
        keyFrameAnimation.values = [initialBounds,finalBounds]
        keyFrameAnimation.keyTimes = [0, 1]
        
        keyFrameAnimation.timingFunctions = [CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut), CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)]
        
        keyFrameAnimation.fillMode = kCAFillModeForwards
        keyFrameAnimation.isRemovedOnCompletion = false
        mask.add(keyFrameAnimation, forKey: "bounds")
        
        
    }
    
}

