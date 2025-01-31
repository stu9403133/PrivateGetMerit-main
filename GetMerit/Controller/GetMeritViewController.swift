//
//  GetMeritViewController.swift
//  GetMerit
//
//  Created by stu on 2024/1/23.
//

import UIKit
import AVFoundation

class GetMeritViewController: UIViewController {
    
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
    var score = Int() {
        didSet{
            UserDefaults.standard.set(score, forKey: "score")
            print("來看看有沒有觸發儲存", score)
        }
    }
    
    var colorSet = ButtonColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
    
    //宣告播放器
    let woodenPlayer = AVPlayer()
    let bellPlayer = AVPlayer()
    var touchPlayer = AVPlayer()
    var looper : AVPlayerLooper? // 用於重複播放背景音樂
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateColorNoti(noti:)), name: ColorNotifactionName.name, object: nil)
        
        
        updateButtonUI()
        animationConfiguration()
        updateScore()
//        UserDefaults.standard.removeObject(forKey: "score") // 刪除儲存
    }
    
    
    
    // 讀取上次紀錄和更新分數
    func updateScore() {
        score = UserDefaults.standard.integer(forKey: "score")
        print("updateScore():", score)
        totalMerit.text = String(score)
    }
    
    //設定畫面開始木魚的顏色
    func updateButtonUI() {
        if let data = UserDefaults.standard.data(forKey: "buttonColor") {
            do{
                colorSet = try JSONDecoder().decode(ButtonColor.self, from: data)
                
                muyuBell.tintColor = UIColor(red: colorSet.red, green: colorSet.green, blue: colorSet.blue, alpha: colorSet.alpha)
                print("儲存成功，並呈現", colorSet)
            } catch {
                muyuBell.tintColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
                print("儲存失敗，此為預設顏色")
            }
            
        } else {
            print("沒有儲存，原本就初始化好了")
            
        }
    }
    
    //設定起始畫面, 背景音樂重複回放
    func animationConfiguration() {
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
    }
    
    
    
    
    // Notification 相關的function
    @objc func updateColorNoti(noti: Notification){
        if let userInfo = noti.userInfo,
           let color = userInfo[ColorNotifactionName.notificationKey] as? ButtonColor{
            colorSet = color
            muyuBell.tintColor = UIColor(red: colorSet.red, green: colorSet.green, blue: colorSet.blue, alpha: colorSet.alpha)
        }
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
    
    // 進入頁面傳送數據
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let source = segue.destination as? ButtonColorViewController {
            source.colorSet = colorSet
        }
    }
    
    //  返回頁面接收數據
    @IBAction func unwindToGetMerit(for unwindSegue: UIStoryboardSegue) {
        if let sourece = unwindSegue.source as? ButtonColorViewController {
            colorSet = sourece.colorSet
            print("unwind: ", colorSet)
            updateButtonUI()
        }
    }
    
    
}
