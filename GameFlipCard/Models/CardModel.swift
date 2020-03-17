//
//  CardModel.swift
//  GameFlipCard
//
//  Created by Nguyen Duy anh on 2/4/20.
//  Copyright © 2020 Nguyen Duy anh. All rights reserved.
//

import Foundation


class CardModel {
    
    func getCard() -> [Card] {
        
        var generatedNumberArray = [Int]()
        
        var generatedCardArray = [Card]()
        
        while generatedNumberArray.count < 8 {
            
            let randomNumber = arc4random_uniform(13) + 1
            
            if generatedNumberArray.contains(Int(randomNumber)) == false {
                
                generatedNumberArray.append(Int(randomNumber))
                
                //print(randomNumber)
                
                let cardOne = Card()
                cardOne.imageName = "card\(randomNumber)"
                generatedCardArray.append(cardOne)
                
                let cardTwo = Card()
                cardTwo.imageName = "card\(randomNumber)"
                generatedCardArray.append(cardTwo)
            }
            
        }
        
        for index in 0...generatedNumberArray.count - 1 {
            let randomNumber = Int(arc4random_uniform(UInt32(generatedNumberArray.count)))
        
            let temporaryStorage = generatedCardArray[index]
            generatedCardArray[index] = generatedCardArray[randomNumber]
            generatedCardArray[randomNumber] = temporaryStorage
        }
        
        return generatedCardArray
    }
}
