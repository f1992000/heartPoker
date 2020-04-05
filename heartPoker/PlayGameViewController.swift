//
//  PlayGameViewController.swift
//  heartPoker
//
//  Created by  DARFON on 2020/3/19.
//  Copyright © 2020 JasonPika. All rights reserved.
//

import UIKit

struct Card{
    let suit: String
    let rank: String
}

class PlayGameViewController: UIViewController {

    @IBOutlet weak var showGameNumber: UILabel!
    @IBOutlet weak var pokerImageView: UIImageView!
    @IBOutlet weak var computerHand: UIImageView!
    @IBOutlet weak var userHand: UIImageView!
    
    let suits = ["♠️", "♥️", "♦️", "♣️"]
    let ranks = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]
    var pokerCard:[Card] = []
    var gameTimer:Timer?
    var judgeWinner:Bool = false // 是否判斷勝負
    var showPokerNumber:Int = 0 // 牌組中第幾張牌
    var hitNumber:[String] = [] // 中獎的數字
    var gameNumber:Int = 0 // 中獎的矩陣第幾個
    var gameOverAlertTitle:String = "" // 遊戲結束的提醒文字
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 創建遊戲牌組
        pokerCard = pokerList()
        self.hitNumber = self.ranks
    
        self.gameInitial()
//        self.gameStart()

        
        while judgeWinner == false{
            print("1")
            // 延遲執行
            DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 0.4...1.2)) {
                print("2")
                self.gameStart()
            }
        }

        
    }
    
    // 點擊螢幕觸發
    @IBAction func gamerTap(_ sender: Any) {
        if judgeWinner == false{
            self.gameTimer?.invalidate()
            self.userHand?.transform = CGAffineTransform(translationX: 0, y: -300)
            battle("gamerEaryearly")
        }else if judgeWinner == true{
            self.userHand?.transform = CGAffineTransform(translationX: 0, y: -300)
            battle("gamerWin")
        }
    }
    
    // 遊戲初始化
    func gameInitial(){
        // 牌組亂序
        pokerCard.shuffle()
        // 數值歸零
        self.judgeWinner = false
        self.gameNumber = 0
        self.showPokerNumber = 0
        // 手掌圖片歸位
        computerHand?.transform = CGAffineTransform.identity.scaledBy(x: 1, y: -1)
        //self.computerHand?.transform = CGAffineTransform(scaleX: 1, y: -1)
        userHand?.transform = CGAffineTransform.identity
    }
    
    // 產生52張撲克牌
    func pokerList() -> [Card]{
        var cards = [Card]()
        for suit in suits{
            for rank in ranks{
                cards.append(Card(suit: suit, rank: rank))
            }
        }
        return cards
    }
    
    // 遊戲開始
    func gameStart() -> (){
//        self.gameTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (_) in
            
            // 判斷是否中獎
            if  self.hitNumber[self.gameNumber] == self.pokerCard[self.showPokerNumber].rank{
                // 時間停止
                self.gameTimer?.invalidate()
                self.judgeWinner = true
                
                // 電腦隨機秒數按下
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double.random(in: 0.4...0.8)) {
                    self.battle("AIWin")
                }
            }
            // 顯示目前的牌及遊戲數字
            self.pokerImageView.image = UIImage(named: "\(self.pokerCard[self.showPokerNumber].suit + self.pokerCard[self.showPokerNumber].rank)")
            self.showGameNumber.text = "\(self.hitNumber[self.gameNumber])"
            
            // 牌組的牌使用完則重新亂數並歸零
            self.showPokerNumber += 1
            if self.showPokerNumber >= 52{
                self.showPokerNumber = 0
                self.pokerCard.shuffle()
            }
            
            // 使遊戲中獎的數字為1~13循環
            self.gameNumber += 1
            if self.gameNumber >= 13{
                self.gameNumber = 0
            }
//        })
    }
    
    
    // 判斷勝負(1:玩家提早按, 2:玩家獲勝, 3:電腦獲勝)
    func battle(_ winner:String) -> (){
        
        if presentedViewController == nil {
            switch winner{
            case "gamerEaryearly":
                gameOverAlertTitle = "You are the loser!"
            case "gamerWin":
                gameOverAlertTitle = "You are the winner!"
            case "AIWin":
                self.computerHand?.transform = CGAffineTransform(translationX: 0, y:400).scaledBy(x: 1, y: -1)
                gameOverAlertTitle = "You are the loser!"
            default:
                print("error")
            }
            // 遊戲結束提醒視窗
            let gameOverController = UIAlertController(title: gameOverAlertTitle, message: nil, preferredStyle: .alert)
            let gameOverAction = UIAlertAction(title: "Play again", style: .default) { (_) in
                self.gameInitial()
                self.gameStart()
                
            }
            gameOverController.addAction(gameOverAction)
            present(gameOverController, animated: true, completion: nil)
        }
    }
    
}
