//
//  ViewController.swift
//  GameQ iOS
//
//  Created by Fabian Wikström on 6/25/15.
//  Copyright (c) 2015 Fabian Wikström. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var queueTimer: QueueTimer!
    @IBOutlet weak var readyTimer: ReadyTimer!
    @IBOutlet weak var gameqLabel: UILabel!
    @IBOutlet weak var game: UILabel!
    @IBOutlet weak var status: UILabel!
    var time:CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
        queueTimer.start()
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
        game.textColor = Colors().MenuTextGray
        status.textColor = Colors().MenuTextGray
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func update(){
        time = time + 0.1
        readyTimer.progress = time / 45
    }
}

