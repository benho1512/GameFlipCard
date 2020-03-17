//
//  ViewController.swift
//  GameFlipCard
//
//  Created by Nguyen Duy anh on 2/4/20.
//  Copyright © 2020 Nguyen Duy anh. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    var model = CardModel()
    
    var cardArray = [Card]()
    
    var firstFlippedCardIndex: IndexPath?
    
    var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    var timer: Timer?
    
    var millisecond: Float = 30 * 1000
    
    //var soundManager = SoundManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardArray = model.getCard()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerElapsed), userInfo: nil, repeats: true)
        //RunLoop.main.add(timer!, forMode: .common) ==>> Kiem tra srcoll khong bi tam dung timer lai
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupCollectionViewItemSize()
        SoundManager.playSound(.shuffle)
    
    }

 
    // MARK: - Timer Methods
    @objc func timerElapsed() {
        millisecond -= 1
        
        let second = String(format: "%.2f", millisecond / 1000)
        
        timerLabel.text = "Time Remaining: \(second)"
        
        if millisecond <= 0 {
            timer?.invalidate()
            timerLabel.textColor = UIColor.orange
            
            // Check game ended
            checkGameEnded()
        }
    }
    
    // MARK: - UICollectionView Protocol Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        let card = cardArray[indexPath.row]
        
        cell.setCard(card)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        
        let card = cardArray[indexPath.row]
        
        if millisecond <= 0 {
            return
        }
        
        if card.isFlipped == false && card.isMatched == false {
            cell.flip()
            
            SoundManager.playSound(.flip)
            
            card.isFlipped = true
            
            if firstFlippedCardIndex == nil {
                firstFlippedCardIndex = indexPath
            } else {
                checkForMatches(indexPath)
            }
        } else {
            
        }
    }
    
    
    // MARK: - Game Logic Methods
    func checkForMatches(_ secondFlippedCardIndex: IndexPath) {
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        
        let cardOne = cardArray[firstFlippedCardIndex!.row]
        let cardTwo = cardArray[secondFlippedCardIndex.row]
        
        if cardOne.imageName == cardTwo.imageName {
            
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
            checkGameEnded()
            
            SoundManager.playSound(.match)
        } else {
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
            cardOneCell?.flipBack()
            cardTwoCell?.flipBack()
            
            SoundManager.playSound(.nomatch)
        }
        firstFlippedCardIndex = nil
    }

    func checkGameEnded() {
        var isWon = true
        
        for card in cardArray {
            if card.isMatched == false {
                isWon = false
                break
            }
        }
        
        var title = ""
        var message = ""
        
        if isWon == true {
            if millisecond > 0 {
                timer?.invalidate()
            }
            
            title = "Congratulations!"
            message = "You've won"
        } else {
            if millisecond > 0 {
                return
            }
            title = "Game Over"
            message = "You've lost"
        }
        
        showAlert(title, message)
    }
    
    func showAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Autolayout CollectionView
    func setupCollectionViewItemSize() {
        if collectionViewFlowLayout == nil {
            let numberOfItemPerRow: CGFloat = 4
            let lineSpacing: CGFloat = 5
            let interItemSpacing: CGFloat = 8
            
            let width = (collectionView.frame.width - interItemSpacing * (numberOfItemPerRow - 1)) / numberOfItemPerRow
            let height = (collectionView.frame.height - interItemSpacing * (numberOfItemPerRow - 1)) / numberOfItemPerRow
            
            collectionViewFlowLayout = UICollectionViewFlowLayout()
            
            collectionViewFlowLayout.itemSize = CGSize(width: width, height: height)
            collectionViewFlowLayout.scrollDirection = .vertical
            collectionViewFlowLayout.minimumLineSpacing = lineSpacing
            collectionViewFlowLayout.minimumInteritemSpacing = interItemSpacing
            
            collectionView.setCollectionViewLayout(collectionViewFlowLayout, animated: true)
        }
    }
    
} // End Block ViewController

