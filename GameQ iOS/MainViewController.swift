//
//  ViewController.swift
//  GameQ iOS
//
//  Created by Fabian Wikström on 6/25/15.
//  Copyright (c) 2015 Fabian Wikström. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var spinner: QueueTimer!
    @IBOutlet weak var readyTimer: ReadyTimer!
    @IBOutlet weak var lblGame: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblCountdown: PulsatingLabel!
    var bolGotLastAnswer:Bool = true
    var lastStatus:Status = Status.Offline
    
    var tmrStatus = NSTimer()
    var bolTimerRunning = false
    
    var tmrCountdown = NSTimer()
    var totalCountdown:Int = 0
    var endTime:Int = 0
    var startTime:Int = 0
    var tenthCounter:Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        (UIApplication.sharedApplication().delegate as! AppDelegate).mainViewController = self
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
                
                var game:Int = 0
                if success {
                    if aGame != nil {
                        game = aGame!
                    }
                    status = aStatus
                }
                dispatch_async(dispatch_get_main_queue(), {
                    self.lblStatus.text = Encoding.getStringFromGameStatus(game, status: status)
                    if game != 0 {
                        self.lblGame.text = Encoding.getStringFromGame(game)
                    } else {
                        self.lblGame.text = ""
                    }
                    switch Encoding.getStatusFromInt(status) {
                    case Status.Offline:
                        //båda av
                        self.spinner.isGame = false
                        self.spinner.reset()
                        self.stopReadyCountdownAt(0)
                        break
                    case Status.Online:
                        self.spinner.isGame = false
                        self.spinner.reset()
                        self.stopReadyCountdownAt(0)
                        //båda av
                        break
                    case Status.InLobby:
                        self.spinner.isGame = false
                        self.spinner.reset()
                        self.stopReadyCountdownAt(0)
                        //båda av
                        break
                    case Status.InQueue:
                        self.spinner.isGame = false
                        self.spinner.start()
                        self.stopReadyCountdownAt(0)
                        //blå snurra
                        //röd av
                        break
                    case Status.GameReady:
                        self.spinner.isGame = true
                        self.spinner.reset()
                        self.startReadyCountdown(acceptBefore)

                        
                        //röd börja
                        //helblå
                        break
                    case Status.InGame:
                        self.spinner.isGame = true
                        self.spinner.reset()
                        self.stopReadyCountdownAt(1)
                        //helorange
                        //helblå
                        break
                    }
                    
                    
                    
                    self.lastStatus = Encoding.getStatusFromInt(status)
                })
                
            })
        }
    }
    
    private func stopStatusUpdates() {
        tmrStatus.invalidate()
    }
    
    private func stopReadyCountdownAt(fraction:CGFloat) {
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
        startTime = Int(NSDate().timeIntervalSince1970)
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
        
        readyTimer.progress = CGFloat(Double(Double(NSDate().timeIntervalSince1970)-Double(startTime)) / Double(totalCountdown))
        
    }
    
    private func decrementCountdownLabel() {
        if endTime - Int(NSDate().timeIntervalSince1970) < 0 {
            lblCountdown.text = ""
            tmrCountdown.invalidate()
            bolTimerRunning = false
        } else {
            lblCountdown.text = "\(endTime - Int(NSDate().timeIntervalSince1970))"
        }
        lblCountdown.stopPulsating()
    }
    
    
    
    
}

