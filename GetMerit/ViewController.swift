//
//  ViewController.swift
//  GetMerit
//
//  Created by stu on 2023/11/29.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    
    //顯示總攻得數目的label
    @IBOutlet weak var totalMerit: UILabel!
    
    //發出聲音的三條線動畫
    @IBOutlet weak var soundImageView: UIImageView!
    
    //切換敲擊圖片的segment control
    @IBOutlet weak var selectedSegment: UISegmentedControl!
    
    //敲擊的button（木魚或鐘的圖片）
    @IBOutlet weak var muyuBell: UIButton!
   
    //+1的圖片
    @IBOutlet weak var plusOneImageView: UIImageView!
    
    //敲擊次數
    var score = 0
    
    //宣告播放器
    let woodenPlayer = AVPlayer()
    let bellPlayer = AVPlayer()
    var touchPlayer = AVPlayer()
    var looper : AVPlayerLooper?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //設定起始畫面, 背景音樂重複回放
        
        let backgroundUrl = Bundle.main.url(forResource: "backgroundmusic", withExtension: "mp3")!
        let playerItem = AVPlayerItem(url: backgroundUrl)
        let backgroundPlayer = AVQueuePlayer()
        self.looper = AVPlayerLooper(player: backgroundPlayer, templateItem: playerItem)
        backgroundPlayer.play()

        //宣告音效的player和url
        let bellUrl = Bundle.main.url(forResource: "bellSound", withExtension: "mp3")!
        let bellPlayerItam = AVPlayerItem(url: bellUrl)
        
        let woodenUrl = Bundle.main.url(forResource: "muyuSound", withExtension: "mp3")!
        let woodenPlayerItem = AVPlayerItem(url: woodenUrl)
        
        bellPlayer.replaceCurrentItem(with: bellPlayerItam)
        woodenPlayer.replaceCurrentItem(with: woodenPlayerItem)
        touchPlayer = woodenPlayer
        
        //設定畫面開始木魚的顏色
        muyuBell.tintColor = UIColor.systemBrown
        
    }
    
    @IBAction func touchWoodenFish(_ sender: Any) {
        //點一下木魚數字跟著加1
        score = score + 1
        totalMerit.text = "\(score)"
        plusOneImageView.isHidden = false
        soundImageView.isHidden = false
        
        //宣告＋1的動畫
        let plusOneAnimator = UIViewPropertyAnimator(duration: 0.3, curve: .linear){
            self.plusOneImageView.frame.origin.y -= 5
        }
        
        plusOneAnimator.addCompletion
        {
            (position) in
            if position == .end {
                self.plusOneImageView.isHidden = true
                self.plusOneImageView.frame.origin.y += 5
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.soundImageView.isHidden = true
        }
        plusOneAnimator.startAnimation()
        
        touchPlayer.play()
        self.touchPlayer.seek(to: .zero)
        
    }
    
    @IBAction func restart(_ sender: Any) {
        
        score = 0
        totalMerit.text = "0"
        
    }
    
    @IBAction func changePage(_ sender: Any) {
        
        if selectedSegment.selectedSegmentIndex == 0 {
            muyuBell.setImage(UIImage(named: "wooden_fish"), for: .normal)
            touchPlayer = woodenPlayer
        } else if selectedSegment.selectedSegmentIndex == 1 {
            muyuBell.setImage(UIImage(named: "bell"), for: .normal)
            touchPlayer = bellPlayer
        }
    }
}


