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
    @IBOutlet weak var gameqLabel: UILabel!
    @IBOutlet weak var lblGame: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblCountdown: PulsatingLabel!
    var bolGotLastAnswer:Bool = true
    var lastStatus:Int = 0
    
    var tmrStatus = NSTimer()
    
    var tmrCountdown = NSTimer()
    var currentIncrementation:Double = 0
    var maxIncrementation:Int = 0
    var secondsRemaining:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
        navigationController!.navigationBar.tintColor = UIColor(netHex: 0xffffff)
        navigationController!.navigationBar.barTintColor = UIColor(netHex: 0x465568)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.view.backgroundColor = Colors().MainGray
        gameqLabel.textColor = Colors().NameGray
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
        tmrStatus = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: Selector("updateStatus"), userInfo: nil, repeats: true)
        updateStatus()
    }
    
    func updateStatus() {
        if bolGotLastAnswer {
            bolGotLastAnswer = false
            ConnectionHandler.getStatus({
                (success:Bool, error:String?, aStatus:Int, aGame:Int?) in
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
                    // TODO animation control
                    
                    
                    
                    self.lastStatus = status
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
    }
    
    private func startReadyCountdown(seconds:Int) {
        maxIncrementation = seconds
        currentIncrementation = 0
        tmrCountdown = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("decrement"), userInfo: nil, repeats: true)
        lblCountdown.startPulsating(Colors().LightBlue)
    }
    
    func decrement() {
        if currentIncrementation % 1 != 0 {
            decrementCountdownLabel()
        }
        currentIncrementation += 0.1
        readyTimer.progress = CGFloat(currentIncrementation / Double(maxIncrementation))
        if currentIncrementation >= Double(maxIncrementation) {
            tmrCountdown.invalidate()
        }
    }
    
    private func decrementCountdownLabel() {
        if secondsRemaining == 0 {
            lblCountdown.text = ""
        }
        lblCountdown.text = "\(secondsRemaining)"
        secondsRemaining--
        lblCountdown.stopPulsating()
    }
    
    
    
    
}

