//
//  ViewController.swift
//  GameQ iOS
//
//  Created by Fabian Wikström on 6/25/15.
//  Copyright (c) 2015 Fabian Wikström. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var topInnerCircleInset: NSLayoutConstraint!
    @IBOutlet weak var bottomInnerCircleInset: NSLayoutConstraint!
    @IBOutlet weak var rightInnerCircleInset: NSLayoutConstraint!
    @IBOutlet weak var leftInnerCircleInset: NSLayoutConstraint!
    
    @IBOutlet weak var acceptButtonHeight: NSLayoutConstraint!
    let acceptButtonHeightInflated:CGFloat = 40
    let acceptButtonHeightDeflated:CGFloat = 0
    @IBOutlet weak var btnDecline: DeclineQueueButton!
    @IBOutlet weak var btnAccept: AcceptQueueButton!
    
    
    @IBOutlet weak var crosshairWidth2: NSLayoutConstraint!
    @IBOutlet weak var crosshairLength2: NSLayoutConstraint!
    @IBOutlet weak var crosshairWidth1: NSLayoutConstraint!
    @IBOutlet weak var crosshairLength1: NSLayoutConstraint!
    
    @IBOutlet weak var topYConstraint: NSLayoutConstraint!
    @IBOutlet weak var fourthYConstraint: NSLayoutConstraint!
    @IBOutlet weak var thirdYConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomYConstraint: NSLayoutConstraint!
    @IBOutlet weak var SecondYConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var crossHair: UIView!
    @IBOutlet weak var spinner: QueueTimer!
    @IBOutlet weak var leftCrosshairArm: UIView!
    @IBOutlet weak var rightCrosshairArm: UIView!
    @IBOutlet weak var bottomCrosshairArm: UIView!
    @IBOutlet weak var topCrosshairArm: UIView!
    @IBOutlet weak var readyTimer: ReadyTimer!
    @IBOutlet weak var lblGame: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblCountdown: PulsatingLabel!
    var bolGotLastAnswer:Bool = true
    var lastStatus:Status = Status.Offline
    var bolCrosshairRotationShouldStop = true
    
    var tmrStatus = NSTimer()
    var bolTimerRunning = false
    
    var tmrCountdown = NSTimer()
    var totalCountdown:Int = 0
    var endTime:Int = 0
    var startTime:Int = 0
    var tenthCounter:Int = 0
    var degrees:CGFloat = 0.0
    
    var currentGame:Game = Encoding.getGameFromInt(0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        (UIApplication.sharedApplication().delegate as! AppDelegate).mainViewController = self
        setCrosshairColor(Colors().LightBlue)
        
        leftInnerCircleInset.constant = 10
        rightInnerCircleInset.constant = 10
        topInnerCircleInset.constant = 10
        bottomInnerCircleInset.constant = 10
        
        
        crosshairLength1.constant = self.view.frame.width/20
        crosshairWidth1.constant = self.view.frame.width/80
        crosshairLength2.constant = crosshairLength1.constant
        crosshairWidth2.constant = crosshairWidth1.constant
        
        let constant:CGFloat = (topYConstraint.constant - (lblStatus.frame.origin.y + lblStatus.frame.height - UIScreen.mainScreen().bounds.height) + SecondYConstraint.constant + thirdYConstraint.constant + fourthYConstraint.constant)/5
        
        if constant < 20.0 {
            /*topYConstraint.constant = 20
            SecondYConstraint.constant = constant-20/3
            thirdYConstraint.constant = constant-20/3*/
        } else {
            topYConstraint.constant = constant
            SecondYConstraint.constant = constant
            thirdYConstraint.constant = constant
            fourthYConstraint.constant = constant
        }
        
        
        self.view.setNeedsUpdateConstraints()
        self.view.updateConstraintsIfNeeded()
        
        

        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
        navigationController!.navigationBar.tintColor = UIColor(netHex: 0xffffff)
        navigationController!.navigationBar.barTintColor = UIColor(netHex: 0x465568)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.view.backgroundColor = Colors().MainGray
        lblStatus.text = ""
        lblGame.text = ""
        startStatusUpdates()
    }
    
    override func viewWillDisappear(animated: Bool) {
        stopStatusUpdates()
        stopReadyCountdownAt(0)
        super.viewWillDisappear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    private func startStatusUpdates() {
        bolGotLastAnswer = true
        tmrStatus = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: Selector("updateStatus"), userInfo: nil, repeats: true)
        updateStatus()
    }
    
    func updateStatus() {
        if bolGotLastAnswer {
            bolGotLastAnswer = false
            ConnectionHandler.getStatus({
                (success:Bool, error:String?, aStatus:Int, aGame:Int?, acceptBefore:Int) in
                self.bolGotLastAnswer = true
                var status:Int = 0
                if let ag = aGame {
                    self.currentGame = Encoding.getGameFromInt(ag)
                }
                var game:Int = 0
                if success {
                    if aGame != nil {
                        game = aGame!
                    }
                    status = aStatus
                }
                dispatch_async(dispatch_get_main_queue(), {
                    self.lblStatus.text = Encoding.getStringFromGameStatus(game, status: status)
                    self.lblGame.text = Encoding.getStringFromGame(game, status: status)
                    switch Encoding.getStatusFromInt(status) {
                    case Status.Offline:
                        //båda av
                        self.spinner.isGame = false
                        self.spinner.reset()
                        self.stopReadyCountdownAt(0)
                        self.stopRotateCrosshair()
                        break
                    case Status.Online:
                        self.spinner.isGame = false
                        self.spinner.reset()
                        self.stopReadyCountdownAt(0)
                        self.startRotateCrosshair()
                        //båda av
                        break
                    case Status.InLobby:
                        self.spinner.isGame = false
                        self.spinner.reset()
                        self.stopReadyCountdownAt(0)
                        self.startRotateCrosshair()
                        //båda av
                        break
                    case Status.InQueue:
                        self.spinner.isGame = false
                        self.spinner.start()
                        self.stopReadyCountdownAt(0)
                        self.startRotateCrosshair()
                        //blå snurra
                        //röd av
                        break
                    case Status.GameReady:
                        self.spinner.isGame = true
                        self.spinner.reset()
                        self.startReadyCountdown(acceptBefore)
                        self.startRotateCrosshair()

                        
                        //röd börja
                        //helblå
                        break
                    case Status.InGame:
                        self.spinner.isGame = true
                        self.spinner.reset()
                        self.stopReadyCountdownAt(1)
                        self.startRotateCrosshair()
                        //helorange
                        //helblå
                        break
                    }
                    
                    
                    
                    self.lastStatus = Encoding.getStatusFromInt(status)
                })
                
            })
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    private func stopStatusUpdates() {
        tmrStatus.invalidate()
    }
    
    private func stopReadyCountdownAt(fraction:CGFloat) {
        deflateAcceptButtons()
        tmrCountdown.invalidate()
        readyTimer.progress = fraction
        lblCountdown.text = ""
        lblCountdown.stopPulsating()
        bolTimerRunning = false
    }
    
    func startReadyCountdown(to:Int) {
        if bolTimerRunning {
            return
        }
        bolTimerRunning = true
        endTime = to + ConnectionHandler.delayToServer
        
        switch currentGame {
        case Game.CSGO:
            startTime = endTime - 20
            inflateAcceptButtons()
        case Game.Dota2:
            startTime = endTime - 45
            inflateAcceptButtons()
        case Game.LoL:
            startTime = endTime - 10
            inflateAcceptButtons()
        default:
            startTime = endTime - 5
            deflateAcceptButtons()
        }
        totalCountdown = endTime - startTime
        tmrCountdown.invalidate()
        tmrCountdown = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("decrement"), userInfo: nil, repeats: true)
        lblCountdown.startPulsating(Colors().LightBlue)
    }
    
    func decrement() {
        if tenthCounter >= 10 {
            decrementCountdownLabel()
            tenthCounter = 0
        }
        tenthCounter++
        println("ready ish:\(Double(NSDate().timeIntervalSince1970)) \(startTime) \(totalCountdown)")
        println(CGFloat(Double(Double(NSDate().timeIntervalSince1970)-Double(startTime)) / Double(totalCountdown)))
        readyTimer.progress = CGFloat(Double(Double(NSDate().timeIntervalSince1970)-Double(startTime)) / Double(totalCountdown))
        
    }
    
    private func decrementCountdownLabel() {
        lblCountdown.alpha = 1.0
        UIView.animateWithDuration(1, delay: 0, options:nil, animations: {
            self.lblCountdown.alpha = 0
            }, completion: nil)
        if endTime - Int(NSDate().timeIntervalSince1970) < 0 {
            lblCountdown.text = ""
            tmrCountdown.invalidate()
            bolTimerRunning = false
        } else {
            lblCountdown.text = "\(endTime - Int(NSDate().timeIntervalSince1970))"
        }
        lblCountdown.stopPulsating()
    }
    
    private func setCrosshairColor(color:UIColor)->() {
        bottomCrosshairArm.backgroundColor = color
        topCrosshairArm.backgroundColor = color
        leftCrosshairArm.backgroundColor = color
        rightCrosshairArm.backgroundColor = color
    }
    
    private func startRotateCrosshair() {
        if bolCrosshairRotationShouldStop {
            crossHair.setTranslatesAutoresizingMaskIntoConstraints(false)
            bolCrosshairRotationShouldStop = false
            rotateOnce(false)
        }
    }
    private func rotateOnce(firstTimeOrSuccess:Bool) -> Void {
        if degrees == -CGFloat(2*M_PI) {
            degrees = 0
        }
        degrees -= CGFloat(M_PI*0.5)
        if bolCrosshairRotationShouldStop {
            UIView.animateWithDuration(4, delay: 0, options: .CurveEaseOut, animations: {
                let transform:CGAffineTransform = CGAffineTransformRotate(CGAffineTransformIdentity, self.degrees)
                self.crossHair.transform = transform
                }, completion: nil)
        } else if !firstTimeOrSuccess {
            UIView.animateWithDuration(4, delay: 0, options: .CurveEaseIn, animations: {
                let transform:CGAffineTransform = CGAffineTransformRotate(CGAffineTransformIdentity, self.degrees)
                self.crossHair.transform = transform
                }, completion: rotateOnce)
        } else {
            UIView.animateWithDuration(3, delay: 0, options: .CurveLinear, animations: {
                let transform:CGAffineTransform = CGAffineTransformRotate(CGAffineTransformIdentity, self.degrees)
                self.crossHair.transform = transform
                }, completion: rotateOnce)
        }
    }
    
    private func stopRotateCrosshair() {
        bolCrosshairRotationShouldStop = true
    }
    
    
    private func inflateAcceptButtons() {
//        println("infalting buttons")
        UIView.animateWithDuration(1, delay: 0, options: .CurveEaseInOut, animations: {
            self.acceptButtonHeight.constant = self.acceptButtonHeightInflated
            self.btnAccept.enabled = true
            self.btnAccept.alpha = 1.0
            self.btnDecline.alpha = 1.0
            self.btnDecline.enabled = true
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    private func deflateAcceptButtons() {
//        println("deflating buttons")
        deflateAccept(0)
        deflateDecline(0)
        deflateAcceptButtonHeights(0)
    }
    
    private func deflateAcceptButtonFirst() {
        deflateAccept(0)
        deflateDecline(1)
        deflateAcceptButtonHeights(1)
    }
    private func deflateDeclineButtonFirst() {
        deflateAccept(1)
        deflateDecline(0)
        deflateAcceptButtonHeights(1)
    }
    
    private func deflateAccept(delay:NSTimeInterval) {
        UIView.animateWithDuration(1, delay: delay, options: .CurveEaseInOut, animations: {
            self.btnAccept.enabled = false
            self.btnAccept.alpha = 0.0
            }, completion: nil)
    }
    private func deflateDecline(delay:NSTimeInterval) {
        UIView.animateWithDuration(1, delay: delay, options: .CurveEaseInOut, animations: {
            self.btnDecline.alpha = 0.0
            self.btnDecline.enabled = false
            }, completion: nil)
    }
    private func deflateAcceptButtonHeights(delay:NSTimeInterval) {
        UIView.animateWithDuration(1, delay: delay, options: .CurveEaseInOut, animations: {
            self.acceptButtonHeight.constant = self.acceptButtonHeightDeflated
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    @IBAction func pressedAccept(sender: AnyObject) {
//        println("pressed accept")
        deflateDeclineButtonFirst()
        ConnectionHandler.acceptQueue(true, finalCallBack: {
            (success:Bool, error:String?) in
            
        })
    }
    @IBAction func pressedDecline(sender: AnyObject) {
//        println("pressed decline")
        deflateAcceptButtonFirst()
        ConnectionHandler.acceptQueue(false, finalCallBack: {
            (success:Bool, error:String?) in
            
        })
    }
    
    
    
    
}

