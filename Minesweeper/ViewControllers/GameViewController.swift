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
    var mDiff: Int? = 0
    var mNumOfRows: Int?
    var mNumOfColumns: Int?
    var isGameEnabled = true
    let mFunctions = FuncUtils()
    let TileMargin = CGFloat(1.0)

    @IBOutlet weak var mGameBoard: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch self.mDiff {
        case 0:
            mNumOfRows = 10
            mNumOfColumns = 10
            break
        case 1:
            mNumOfRows = 10
            mNumOfColumns = 10
            break
        case 2:
            mNumOfRows = 5
            mNumOfColumns = 5
            break
        default:
            break
        }
        
        mGameBoard.isScrollEnabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isGameEnabled {
            reloadGame()
        } else {
            self.mFunctions.showToast(msg: "There's nothing to see here...")
            _=self.navigationController?.popViewController(animated: true)
        }
    }
    
    func reloadGame() {
        mGameBoard.reloadData()
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let rowsCount = CGFloat(mNumOfColumns ?? 10) - 1
        let dimentions = collectionView.frame.height / rowsCount * 0.7
        return CGSize(width: dimentions, height: dimentions)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(TileMargin, TileMargin, TileMargin, TileMargin)
    }
    // MARK: Actions
    @IBAction func backBtn(_ sender: Any) {
        _=self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func restartBtn(_ sender: UIButton) {
        sender.rotationAnimation()
    }
}
