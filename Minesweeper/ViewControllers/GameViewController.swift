//
//  GameViewController.swift
//  Minesweeper
//
//  Created by Hadar Pur on 18/10/2018.
//  Copyright © 2018 Hadar Pur. All rights reserved.
//
import Foundation
import UIKit

class GameViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    let EASY: Int = 0, NORMAL: Int = 1, HARD: Int = 2
    let BOARD_CELL10: Int = 10, BOARD_CELL5: Int = 5
    let EASY_FLAGS: Int = 5, HARD_FLAGS: Int = 10
    let LOSS: Int = 0, WIN: Int = 1
    let MAX_RECORDS: Int = 10
    
    let mFunctions = FuncUtils()
    
    var lastUpdate: Int = 0
    var oldX: Float? ,oldY: Float? ,oldZ: Float?
    var count: Int? , seconds: Int? , countOfPressed: Int? , chosenLevel: Int? , isMute: Int?
    var isLost: Bool = false, isFirstClick: Bool = true, firstAsk: Bool = false
    var isChangedOnce: Bool? ,isChangeMines: Bool?

    var mDiff: Int? = 0
    var mNumOfRows: Int?
    var mNumOfColumns: Int?
    var mIsGameEnabled = true
 //   var  cells: [[CollectionViewCell]]!


    @IBOutlet weak var mTimeTextView: UITextView!
    @IBOutlet weak var mFlagsTextView: UITextView!
    @IBOutlet weak var mGameBoard: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isChangedOnce = false
        self.isChangeMines = false
        
        self.mGameBoard.isScrollEnabled = false
        
        createNewGame()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    func createNewGame() {
        switch self.mDiff {
        case EASY:
            mNumOfRows = BOARD_CELL10
            mNumOfColumns = BOARD_CELL10
            break
        case NORMAL:
            mNumOfRows = BOARD_CELL10
            mNumOfColumns = BOARD_CELL10
            break
        case HARD:
            mNumOfRows = BOARD_CELL5
            mNumOfColumns = BOARD_CELL5
            break
        default:
            break
        }
    }
    
    func pressNewGame() {
        
    }

    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView.backgroundColor = UIColor.clear

        return mNumOfColumns ?? 10
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return mNumOfRows ?? 10
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // If the move is confirmed, the delegate will be called
//        game.playMove(player: game.currentPlayer, row: indexPath.section, column: indexPath.item)
    }

    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    var cellWidth: CGFloat {
        let rowsCount = CGFloat(mNumOfColumns ?? 10)
        return mGameBoard.frame.width / rowsCount * 0.8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        let totalCellWidth = cellWidth * CGFloat(mNumOfColumns ?? 10)
        let totalSpacingWidth = CGFloat(4) * CGFloat((mNumOfColumns ?? 10))
        
        let leftInset = (mGameBoard.frame.width - CGFloat(totalCellWidth - totalSpacingWidth))/4
        let rightInset = leftInset
        
        return UIEdgeInsetsMake(0, leftInset, 0, rightInset)
    }
    // MARK: Actions
    @IBAction func backBtn(_ sender: Any) {
        _=self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func restartBtn(_ sender: UIButton) {
        sender.rotationAnimation()
    }
}
