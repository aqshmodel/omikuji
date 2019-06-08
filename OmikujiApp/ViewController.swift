//
//  ViewController.swift
//  OmikujiApp
//
//  Created by Takahiro Tsukada on 2019/06/08.
//  Copyright © 2019 Takahiro Tsukada. All rights reserved.
//

import UIKit
import AVFoundation // 音を出すためのライブラリ読み込み 追加

class ViewController: UIViewController {
    
    // 結果を表示したときに音を出すための再生オブジェクトを格納 追加
    var resultAudioPlayer: AVAudioPlayer = AVAudioPlayer()

    @IBOutlet weak var stickView: UIView!
    @IBOutlet weak var stickLabel: UILabel!
    @IBOutlet weak var stickHeight: NSLayoutConstraint!
    @IBOutlet weak var stickBottomMargin: NSLayoutConstraint!
    @IBOutlet weak var overView: UIView!
    @IBOutlet weak var bigLabel: UILabel!
    @IBOutlet weak var happyImage: UIImageView!
    
    
    let resultTexts: [String] = [
        "大吉",
        "中吉",
        "小吉",
        "吉",
        "末吉",
        "凶",
        "大凶",
        "超絶大吉",
        "超絶大凶",
        "極楽浄土"
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupSound(name: "drum")
//        setupSound(name: "bell") // 効果音を読み込む処理
    }
    
    
    //  モーション動作で起きる処理を呼び出す関数
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        
        if motion != UIEvent.EventSubtype.motionShake || overView.isHidden == false {
            // シェイクモーション以外では動作させない
            // 結果の表示中は動作させない
            return
        }
        
        // おみくじ棒の位置が初期値の場合のみ、処理を行う
        if stickBottomMargin.constant == 0 {
            
        // arc4random_uniform関数は、0〜引数にとった値-1 の範囲の整数をランダムに返す関数
        let resultNum = Int( arc4random_uniform(UInt32(resultTexts.count)) )
                
            // おみくじのデータ配列から要素を取り出し、おみくじのラベルに表示
            stickLabel.text = resultTexts[resultNum]
            
            switch stickLabel.text {
            case "超絶大凶": happyImage.image = UIImage(named: "chokyou")
            case "大凶": happyImage.image = UIImage(named: "daikyou")
            case "凶": happyImage.image = UIImage(named: "kyou")
            case "末吉": happyImage.image = UIImage(named: "suekichi")
            case "吉": happyImage.image = UIImage(named: "kichi")
            case "小吉": happyImage.image = UIImage(named:"shokichi")
            case "中吉": happyImage.image = UIImage(named: "chukichi")
            case "大吉": happyImage.image = UIImage(named: "daikichi")
            case "超絶大吉": happyImage.image = UIImage(named: "chozetsu")
            case "極楽浄土": happyImage.image = UIImage(named: "gokuraku")
            default: break
            }
        
        // おみくじの下辺の制約に、高さの分だけマイナス方向にした値を代入し位置を変える
        stickBottomMargin.constant = stickHeight.constant * -1
        
        // UIView.animate関数を使うことでアニメーションを行う
        UIView.animate(withDuration: 2.0, animations: {
            
            // 制約の変更でアニメーションさせる場合は以下の1行のみでアニメーションが反映
            self.view.layoutIfNeeded()
            // シェイクモーションのときに音を再生(Play)する！
            self.setupSound(name: "bell")
            self.resultAudioPlayer.play()
            
            // アニメーションが終わった後の処理
        },completion: { (finished: Bool) in
            // stickLabelで出た結果と同じものをbigLabelに表示
            self.bigLabel.text = self.stickLabel.text
            //  ストーリーボードで設定したHiddenをfalseにして、半透明のViewと中のパーツを表示
            self.overView.isHidden = false
            // 結果表示のときに音を再生(Play)する！
            self.setupSound(name: "drum")
            self.resultAudioPlayer.play()
            
    })
        
        }
} // ここまでシェイクモーションでの動作関数
    
    // リトライボタンの処理関数
    @IBAction func tapRetryButton(_ sender: Any) {
        // 半透明のViewを隠す
        overView.isHidden = true
        // 制約の下辺マージンを元々設定されていた0にして位置を戻す
        stickBottomMargin.constant = 0
    } // ここまで関数
    
    
    //追記！→ 結果表示するときに鳴らす音の準備
    func setupSound(name: String) {
        // ファイルがあるかどうかを確認するif
        if let sound = Bundle.main.path(forResource: name, ofType: ".mp3")
        {
                                // try! で例外処理をスキップ
            resultAudioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound))
            resultAudioPlayer.prepareToPlay()
        }
    } //ここまで関数
    
    

}
