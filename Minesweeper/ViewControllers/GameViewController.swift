//
//  GameViewController.swift
//  Minesweeper
//
//  Created by Hadar Pur on 18/10/2018.
//  Copyright © 2018 Hadar Pur. All rights reserved.
//
import Foundation
import UIKit
import GameplayKit

class GameViewController: UIViewController, UIGestureRecognizerDelegate {
    let EASY: Int = 0, NORMAL: Int = 1, HARD: Int = 2
    let BOARD_CELL10: Int = 10, BOARD_CELL5: Int = 5
    let EASY_FLAGS: Int = 5, HARD_FLAGS: Int = 10
    let LOSS: Int = 0, WIN: Int = 1
    let MAX_RECORDS: Int = 10

    let mFunctions = FuncUtils()
    
    var lastUpdate: Int = 0
    var oldX: Float? ,oldY: Float? ,oldZ: Float?
    var count: Int = 0 , seconds: Int? , countOfPressed: Int = 0 , chosenLevel: Int? , isMute: Int?
    var isLost: Bool = false, isFirstClick: Bool = true, firstAsk: Bool = false
    var isChangedOnce: Bool = false ,isChangeMines: Bool = false

    var mDiff: Int? = 0
    var mNumOfRows: Int?
    var mNumOfColumns: Int?
    var mIsGameEnabled = true
    var jsonData: FirebaseStorage!
    var cells = [[CollectionViewCell]]()
    var setFlags = Set<Int>()
    @IBOutlet weak var mTimeTextView: UITextView!
    @IBOutlet weak var mFlagsTextView: UITextView!
    @IBOutlet weak var mGameBoard: UICollectionView!
    @IBOutlet weak var mRestartBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mGameBoard.isScrollEnabled = false
        
        let longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(longPressGR:)))
        longPressGR.minimumPressDuration = 0.5
        longPressGR.delaysTouchesBegan = true
        self.mGameBoard.addGestureRecognizer(longPressGR)
        
        self.jsonData = FirebaseStorage()
        // need to do network check!!!!!!!!!!!!!!!!!!!
        
        createNewGame()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    func createNewGame() {
        self.isLost = false
        self.countOfPressed = 0
        
        switch self.mDiff {
        case EASY:
            initGame(level: EASY_FLAGS, boardSize: BOARD_CELL10)
            creatNewCollectionView(colNum: BOARD_CELL10, rowNum: BOARD_CELL10 , mines: EASY_FLAGS)
            break
        case NORMAL:
            initGame(level: HARD_FLAGS, boardSize: BOARD_CELL10)
            creatNewCollectionView(colNum: BOARD_CELL10, rowNum: BOARD_CELL10 , mines: HARD_FLAGS)
            break
        case HARD:
            initGame(level: HARD_FLAGS, boardSize: BOARD_CELL5)
            creatNewCollectionView(colNum: BOARD_CELL5, rowNum: BOARD_CELL5 , mines: HARD_FLAGS)
            break
        default:
            break
        }
    }
    
    func pressNewGame() {
        self.isFirstClick = true
        self.seconds=0
        createNewGame()
    }
    
    func initGame(level: Int, boardSize: Int) {
        self.count = level
        
        while self.setFlags.count < level {
            let randomSource = GKRandomSource.sharedRandom()
            let index = randomSource.nextInt(upperBound: boardSize*boardSize)+0 // returns random Int between 0 and 9
            self.setFlags.insert(index)
        }
        
        for i in 0..<boardSize {
            var row = [CollectionViewCell]()
            for j in 0..<boardSize {
                let oneCell = CollectionViewCell()
                if self.setFlags.contains(i*boardSize+j) {
                    oneCell.configure(row: i, col: j, status: -1)
                }
                else {
                    oneCell.configure(row: i, col: j, status: 0)
                }
                row.append(oneCell)
            }
            self.cells.append(row)
        }
        
        createTimeStartFlags()
        setBombsNum(boardSize: boardSize)
    }

    func createTimeStartFlags() {
        mFlagsTextView.text = "\(count)"
        mTimeTextView.text = "\(0)"
    }
    
    func setBombsNum(boardSize: Int) {
        var sum: Int = 0, i: Int = 0, j: Int = 0

        for i in 1..<boardSize-1 {
            for j in 1..<boardSize-1 {
                if self.cells[i][j].getStatus() != -1 {
                    sum = abs(calculateSum(startRow: i-1, endRow: i+1, startCol: j-1, endCol: j+1))
                    self.cells[i][j].setStatus(status: sum)
                }
            }
        }
        
        // first col
        j = 0
        for i in 1..<boardSize-1 {
            if self.cells[i][j].getStatus() != -1 {
                sum = abs(calculateSum(startRow: i-1, endRow: i+1, startCol: j, endCol: j+1))
                self.cells[i][j].setStatus(status: sum)
            }
        }
        
        // first row
        i = 0
        for j in 1..<boardSize-1 {
            if self.cells[i][j].getStatus() != -1 {
                sum = abs(calculateSum(startRow: i, endRow: i+1, startCol: j-1, endCol: j+1))
                self.cells[i][j].setStatus(status: sum)
            }
        }
        
        // last col
        j = boardSize-1
        for i in 1..<boardSize-1 {
            if self.cells[i][j].getStatus() != -1  {
                sum = abs(calculateSum(startRow: i-1, endRow: i+1, startCol: j-1, endCol: j))
                self.cells[i][j].setStatus(status: sum)
            }
        }
        
        // last row
        i = boardSize-1
        for j in 1..<boardSize-1 {
            if self.cells[i][j].getStatus() != -1  {
                sum = abs(calculateSum(startRow: i-1, endRow: i, startCol: j-1, endCol: j+1))
                self.cells[i][j].setStatus(status: sum)
            }
        }
        
        j = 0
        i = 0
        if self.cells[i][j].getStatus() != -1 {
            sum = abs(calculateSum(startRow: i, endRow: i+1, startCol: j, endCol: j+1))
            self.cells[i][j].setStatus(status: sum)
        }
        
        j = boardSize-1
        if self.cells[i][j].getStatus() != -1 {
            sum = abs(calculateSum(startRow: i, endRow: i+1, startCol: j-1, endCol: j))
            self.cells[i][j].setStatus(status: sum)
        }
        
        i = boardSize-1
        if self.cells[i][j].getStatus() != -1 {
            sum = abs(calculateSum(startRow: i-1, endRow: i, startCol: j-1, endCol: j))
            self.cells[i][j].setStatus(status: sum)
        }
    
        j = 0
        if self.cells[i][j].getStatus() != -1 {
            sum = abs(calculateSum(startRow: i-1, endRow: i, startCol: j, endCol: j+1))
            self.cells[i][j].setStatus(status: sum)
        }
    }
    
    func calculateSum(startRow: Int, endRow: Int, startCol: Int, endCol: Int) -> Int {
        var sum: Int = 0
        for i in startRow...endRow  {
            for j in startCol...endCol {
                if self.cells[i][j].getStatus() == -1 {
                    sum += self.cells[i][j].getStatus()
                }
            }
        }
        return sum
    }
    
    
    func creatNewCollectionView(colNum: Int, rowNum: Int ,mines: Int) {
        mNumOfRows = rowNum
        mNumOfColumns = colNum
    }
    
    func showAllMines() {
        for i in 0..<setFlags.count {
            cells[i/cells.count][i%cells[0].count].pressButton()
        }
    }
    
    func openCellRec(x: Int, y: Int) {
        
    }
    func explodeVictoryAnimation() {
        
    }

    //MARK: - UILongPressGestureRecognizer Action -
    @objc
    func handleLongPress(longPressGR: UILongPressGestureRecognizer) {
        if longPressGR.state != .ended {
            return
        }
        
        let point = longPressGR.location(in: self.mGameBoard)
        let indexPath = self.mGameBoard.indexPathForItem(at: point)
        if let indexPath = indexPath {
            if !isChangeMines {
                if !cells[indexPath[0]][indexPath[1]].pressed() {
                    if !cells[indexPath[0]][indexPath[1]].longPressed() {
                        if count>0 {
                            count -= 1
                            cells[indexPath[0]][indexPath[1]].pressLongButton()
                        }
                    }
                    else if cells[indexPath[0]][indexPath[1]].longPressed() {
                        count+=1
                        cells[indexPath[0]][indexPath[1]].pressLongButton()
                    }
                    mFlagsTextView.text = "\(count)"
                }
            }
        } else {
            print("Could not find index path")
        }
    }
    
    // MARK: Actions
    @IBAction func backBtn(_ sender: Any) {
        _=self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func restartBtn(_ sender: UIButton) {
        pressNewGame();
        sender.rotationAnimation()
    }
}

extension GameViewController: UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
        
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
            if !isChangeMines {
                print(" cell touched with indexPath row: \(indexPath[0]) indexPath col: \(indexPath[1])")
                if !cells[indexPath.row][indexPath[1]].isLongPressed {
                    if isFirstClick {
                        isFirstClick = false
                        //                        timer(mines)
                    }
                    if cells[indexPath.row][indexPath[1]].getStatus() == -1 {
                        mRestartBtn.setImage(UIImage(named: "burnsmile"), for: .normal)
                        showAllMines()
                        isLost = true
                        print("player lose")
                    }
                    else {
                        openCellRec(x: indexPath[0], y: indexPath[1]);
                    }
                    cells[indexPath.row][indexPath[1]].pressButton()
                    cells[indexPath.row][indexPath[1]].displayContent(image: UIImage(named: "tableopen")!, text: "n")

                    //animation when the player win
                    if (countOfPressed + setFlags.count >= cells.count*cells[0].count && isLost == false) {
                        explodeVictoryAnimation();
                        print("player win")
                    }
                }
            }
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
            
            return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
        }
}
