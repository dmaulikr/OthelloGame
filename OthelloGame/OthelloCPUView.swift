//
//  OthelloCPUView.swift
//  OthelloGame
//
//  Created by 相澤渉太 on 2015/07/17.
//  Copyright (c) 2015年 Shota Aizawa. All rights reserved.
//

import UIKit


let Empty = 0 , Black_Stone = 1, White_Stone = 2

let initboard = [
    [0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,2,1,0,0,0,0],
    [0,0,0,0,1,2,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0],
];



class OthelloCPUView: UIView {
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
    
    
    
    
    
    //    override func touchesBegan(touches: Set<NSObject>, withEvent event: (UIEvent!)) {
    //
    //        if isGameOver {
    //            board = initboard
    //            updateGame()
    //            setNeedsDisplay()
    //            return
    //        }
    //
    //        if let canBlack = canPlaced(board, Black_Stone){
    //                if let (x,y) = getPos(touches) {
    //                    if let blackPlaces = flip(board, x, y, Black_Stone){
    //                        putStones(blackPlaces, stone: Black_Stone)
    //
    //                        if let whitePlaces = cpuFlip(board, White_Stone){
    //
    //                            putStones(whitePlaces, stone: White_Stone)
    //                        }
    //                    }
    //
    //            }
    //
    //        } else {
    //
    //            if let whitePlaces = cpuFlip(board, White_Stone){
    //                putStones(whitePlaces, stone: White_Stone)
    //            }
    //        }
    //
    //        updateGame()
    //        setNeedsDisplay()
    //
    //    }
    
    
    
    @IBOutlet weak var showTurn: UILabel!
    
    var myTurn:Bool = true
    
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
            showTurn.text = "Turn: white"
            
        } else {
            
            if let whitePlaces = cpuFlip(board, White_Stone){
                
                putStones(whitePlaces, stone: White_Stone)
            }
            
            myTurn = true
            updateGame()
            setNeedsDisplay()
            showTurn.text = "Turn: black"
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


func flip(board:[[Int]], x:Int, y:Int, stone:Int) -> [(Int, Int)]? {
    if board[y][x] != Empty { return nil }
    var result:[(Int, Int)] = []
    result += flipTotal(board, x, y, stone, 1, 0)
    result += flipTotal(board, x, y, stone,-1, 0)
    result += flipTotal(board, x, y, stone, 0, 1)
    result += flipTotal(board, x, y, stone, 0,-1)
    result += flipTotal(board, x, y, stone, 1, 1)
    result += flipTotal(board, x, y, stone,-1,-1)
    result += flipTotal(board, x, y, stone, 1,-1)
    result += flipTotal(board, x, y, stone,-1, 1)
    if result.count > 0 {
        result += [(x, y)]
        return result
    } else {
        return nil
    }
}






func flipTotal(board:[[Int]], x:Int, y:Int, stone:Int, dx:Int, dy:Int) -> [(Int, Int)] {
    
    var flipLoop: (Int, Int) -> [(Int,Int)]? = { _ in nil }
    flipLoop = {(x:Int, y:Int) -> [(Int,Int)]? in
        if board[y][x]  == Empty {
            return nil
        } else if board[y][x] == stone {
            return []
        } else if var result = flipLoop(x+dx, y+dy){
            
            result += [(x,y)]
            return result
        }
        return nil
    }
    if let result = flipLoop(x+dx, y+dy){
        return result
    }
    return []
    
}


func canPlaced(board:[[Int]], stone: Int) -> [(Int,Int)]? {
    var result:[(Int, Int)] = []
    for y in 1...8 {
        for x in 1...8 {
            if let res = flip(board, x, y, stone){
                result += [(x, y)]
            }
        }
    }
    if result.isEmpty {
        return nil
    } else {
        return result
    }
    
}

func cpuFlip(board:[[Int]], stone:Int) -> [(Int, Int)]? {
    if let places = canPlaced(board, stone){
        let (x, y) = places [Int((arc4random())  % UInt32(places.count)) ]
        
        
        
        return flip(board, x, y, stone)
        
    }
    return nil
    
}

func calcStones(board: [[Int]]) -> (free:Int, black:Int, white:Int) {
    var free = 0, white = 0, black = 0
    for y in 1...8 {
        for x in 1...8 {
            
            switch board[y][x]{
            case Black_Stone: black++
            case White_Stone: white++
            default: free++
            }
        }
    }
    return (free, black, white)
    
}
