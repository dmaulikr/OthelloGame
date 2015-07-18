//
//  OthelloPLAView.swift
//  OthelloGame
//
//  Created by 相澤渉太 on 2015/07/17.
//  Copyright (c) 2015年 Shota Aizawa. All rights reserved.
//

import UIKit





class OthelloPLAView: UIView {
    var board:[[Int]] = []
    let white = UIColor.whiteColor().CGColor
    let black = UIColor.blackColor().CGColor
    let green = UIColor(red:0.7, green:1.0, blue:0.3, alpha:1.0).CGColor
    var side:CGFloat = 0.0
    var top:CGFloat = 0.0
    let left:CGFloat = 0
    let lbl:UILabel = UILabel()
    var isGameOver = false
    

    required init(coder aDecoder: NSCoder) {
        let appFrame = UIScreen.mainScreen().applicationFrame
        side = appFrame.size.width / 8
        top = (appFrame.size.height - (side * 8)) / 2
        board = initboard
        
        super.init(coder:aDecoder)
        
        lbl.text = ""
        lbl.frame = CGRectMake(10, top/2, appFrame.size.width, top/2)
        addSubview(lbl)
        
    }
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextSetStrokeColorWithColor(context, white)
        CGContextSetLineWidth(context, 1.5)
        
        for y in 1...8 {
            for x in 1...8 {
                let rx = left + side * CGFloat(x-1)
                let ry = top + side * CGFloat(y-1)
                let rect = CGRectMake(rx, ry, side, side)
                CGContextSetFillColorWithColor(context, green)
                CGContextFillRect(context, rect)
                CGContextStrokeRect(context, rect)
                
                if board[y][x] == Black_Stone {
                    CGContextSetFillColorWithColor(context, black)
                    CGContextFillEllipseInRect(context, rect) // draw black stone
                } else if board[y][x] == White_Stone {
                    CGContextSetFillColorWithColor(context, white)
                    CGContextFillEllipseInRect(context, rect) // draw white stone
                }
            }
        }
    }
    
    
    func getPos (touches: NSSet!) -> (Int,Int)? {
        
        let touch = touches.anyObject() as! UITouch
        let point = touch.locationInView(self)
        for y in 1...8 {
            for x in 1...8 {
                
                let rx = left + side * CGFloat(x-1)
                let ry = top + side * CGFloat(y-1)
                let rect = CGRectMake(rx, ry, side, side)
                if CGRectContainsPoint(rect, point) {
                    return (x,y)
                }
            }
            
            
        }
        return nil
    }
    
    
    
    
    
    
  
    
    var myTurn:Bool = true
    
    
            

    
    @IBOutlet weak var showTurn2: UILabel!
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: (UIEvent!)) {
        
        if isGameOver {
            board = initboard
            updateGame()
            setNeedsDisplay()
            return
        }
        
        if myTurn {
            
            if let canBlack = canPlaced(board, Black_Stone){
                if let (x,y) = getPos(touches) {
                    if let blackPlaces = flip(board, x, y, Black_Stone){
                        putStones(blackPlaces, stone: Black_Stone)
                        
                        
                    }
                    else {
                        myTurn = true
                        return
                    }
                }
                
            }
            
            myTurn = false
            updateGame()
            setNeedsDisplay()
            showTurn2.text = "Turn: white"
            
        } else {
            
            
            if let canWhite = canPlaced(board, White_Stone){
                if let (x,y) = getPos(touches) {
                    if let whitePlaces = flip(board, x, y, White_Stone){
                        putStones(whitePlaces, stone: White_Stone)
                        
                        
                    }
                    else {
                        myTurn = false
                        return
                    }
                }
            
            
            
            }
            
            myTurn = true
            updateGame()
            setNeedsDisplay()
            showTurn2.text = "Turn: black"
            
        }
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    func putStones(places: [(Int, Int)], stone: Int){
        for (x, y) in places {
            board[y][x] = stone
        }
        
    }
    
    
    func updateGame() {
        
        let (free, black, white) = calcStones(board)
        let canBlack = canPlaced(board, Black_Stone)
        let canWhite = canPlaced(board, White_Stone)
        
        if free == 0 || (canBlack == nil && canWhite == nil){
            
            lbl.text = ("Game Over (Black:\(black)) (White: \(white))")
            isGameOver = true
        } else {
            lbl.text = ""
            isGameOver = false
            
        }
        
}



}


         
    






