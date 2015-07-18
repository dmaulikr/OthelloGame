//
//  ViewController.swift
//  OthelloGame
//
//  Created by 相澤渉太 on 2015/07/17.
//  Copyright (c) 2015年 Shota Aizawa. All rights reserved.
//

import UIKit
import QuartzCore

class ViewController: UIViewController {

  

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.cyanColor()
        
        
        
        
        var label = UILabel(frame: CGRectMake(0, 0, 200, 50))
        label.center = CGPointMake(170, 200)//表示位置
        label.textAlignment = NSTextAlignment.Center//整列
        label.font = UIFont(name:"Helvetica", size:24)
//        label.font = UIFont.systemFontOfSize(24);//文字サイズ
        label.textColor = UIColor.whiteColor()////文字色
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 20.0
        label.backgroundColor = UIColor.greenColor()////背景色
        label.text = "Mode"
        self.view.addSubview(label)

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

