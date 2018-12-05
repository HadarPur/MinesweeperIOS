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
    
    var mLastUpdate: Int = 0
    var mCount: Int = 0 , mSeconds: Int? , mCountOfPressed: Int = 0 , mChosenLevel: Int?
    var mIsLost: Bool = false, mIsFirstClick: Bool = true, mFirstAsk: Bool = false
    var mIsChangedOnce: Bool = false ,mIsChangeMines: Bool = false

    var mDiff: Int? = 0
    var mNumOfRows: Int?
    var mNumOfColumns: Int?
    var mIsGameEnabled = true
    var mJsonData: FirebaseStorage!
    var mCells = [[CollectionViewCell]]()
    var mSetFlags = Set<Int>()
    
    @IBOutlet weak var mTimeTextView: UITextView!
    @IBOutlet weak var mFlagsTextView: UITextView!
    @IBOutlet weak var mGameBoard: UICollectionView!
    @IBOutlet weak var mRestartBtn: UIButton!
    
    let unPressedImage = UIImage(named: "table.png") as UIImage?
    let pressedImage = UIImage(named: "tableopen.png") as UIImage?
    let bombImage = UIImage(named: "tablebombopen.png") as UIImage?
    let flagImage = UIImage(named: "tableflag.png") as UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mGameBoard.isScrollEnabled = false
        
        let longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(longPressGR:)))
        longPressGR.minimumPressDuration = 0.5
        longPressGR.delaysTouchesBegan = true
        self.mGameBoard.addGestureRecognizer(longPressGR)
        
        self.mJsonData = FirebaseStorage()
        // need to do network check!!!!!!!!!!!!!!!!!!!
        createNewGame()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    func createNewGame() {
        self.mIsLost = false
        self.mCountOfPressed = 0
        
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
        self.mIsFirstClick = true
        self.mSeconds=0
        createNewGame()
    }
    
    func initGame(level: Int, boardSize: Int) {
        self.mCount = level
        
        while self.mSetFlags.count < level {
            let randomSource = GKRandomSource.sharedRandom()
            let index = randomSource.nextInt(upperBound: boardSize*boardSize)+0 // returns random Int between 0 and 9
            print("index: \(index)")
            self.mSetFlags.insert(index)
        }
        
        print("count flags: \(self.mSetFlags.count)")
        
        for i in 0..<boardSize {
            var row = [CollectionViewCell]()
            for j in 0..<boardSize {
                let oneCell = CollectionViewCell()

                if self.mSetFlags.contains(i*boardSize+j) {
                    print("[\(i), \(j)]")
                    oneCell.configure(row: i, col: j, status: -1)
                }
                else {
                    oneCell.configure(row: i, col: j, status: 0)
                }
                row.append(oneCell)
            }
            self.mCells.append(row)
        }
        
        createTimeStartFlags()
        setBombsNum(boardSize: boardSize)
    }

    func createTimeStartFlags() {
        self.mFlagsTextView.text = "\(mCount)"
        self.mTimeTextView.text = "\(0)"
    }
    
    func setBombsNum(boardSize: Int) {
        var sum: Int = 0, i: Int = 0, j: Int = 0

        print("setBombsNum")
        
        for i in 1..<boardSize-1 {
            for j in 1..<boardSize-1 {
                if self.mCells[i][j].getStatus() != -1 {
                    sum = calculateSum(startRow: i-1, endRow: i+1, startCol: j-1, endCol: j+1)
                    self.mCells[i][j].setStatus(status: sum)
                }
                else {
                    print("[\(i), \(j)]")
                }
            }
        }
        
        // first col
        j = 0
        for i in 1..<boardSize-1 {
            if self.mCells[i][j].getStatus() != -1 {
                sum = calculateSum(startRow: i-1, endRow: i+1, startCol: j, endCol: j+1)
                self.mCells[i][j].setStatus(status: sum)
            }
            else {
                print("[\(i), \(j)]")
            }
        }
        
        // first row
        i = 0
        for j in 1..<boardSize-1 {
            if self.mCells[i][j].getStatus() != -1 {
                sum = calculateSum(startRow: i, endRow: i+1, startCol: j-1, endCol: j+1)
                self.mCells[i][j].setStatus(status: sum)
            }
            else {
                print("[\(i), \(j)]")
            }
        }
        
        // last col
        j = boardSize-1
        for i in 1..<boardSize-1 {
            if self.mCells[i][j].getStatus() != -1  {
                sum = calculateSum(startRow: i-1, endRow: i+1, startCol: j-1, endCol: j)
                self.mCells[i][j].setStatus(status: sum)
            }
            else {
                print("[\(i), \(j)]")
            }
        }
        
        // last row
        i = boardSize-1
        for j in 1..<boardSize-1 {
            if self.mCells[i][j].getStatus() != -1  {
                sum = calculateSum(startRow: i-1, endRow: i, startCol: j-1, endCol: j+1)
                self.mCells[i][j].setStatus(status: sum)
            }
            else {
                print("[\(i), \(j)]")
            }
        }
        
        j = 0
        i = 0
        if self.mCells[i][j].getStatus() != -1 {
            sum = calculateSum(startRow: i, endRow: i+1, startCol: j, endCol: j+1)
            self.mCells[i][j].setStatus(status: sum)
        }
        else {
            print("[\(i), \(j)]")
        }
        
        j = boardSize-1
        if self.mCells[i][j].getStatus() != -1 {
            sum = calculateSum(startRow: i, endRow: i+1, startCol: j-1, endCol: j)
            self.mCells[i][j].setStatus(status: sum)
        }
        else {
            print("[\(i), \(j)]")
        }
        
        i = boardSize-1
        if self.mCells[i][j].getStatus() != -1 {
            sum = calculateSum(startRow: i-1, endRow: i, startCol: j-1, endCol: j)
            self.mCells[i][j].setStatus(status: sum)
        }
        else {
            print("[\(i), \(j)]")
        }
    
        j = 0
        if self.mCells[i][j].getStatus() != -1 {
            sum = calculateSum(startRow: i-1, endRow: i, startCol: j, endCol: j+1)
            self.mCells[i][j].setStatus(status: sum)
        }
        else {
            print("[\(i), \(j)]")
        }
    }
    
    func calculateSum(startRow: Int, endRow: Int, startCol: Int, endCol: Int) -> Int {
        var sum: Int = 0
        for i in startRow...endRow  {
            for j in startCol...endCol {
                if self.mCells[i][j].getStatus() == -1 {
                    sum += 1
                }
            }
        }
        return sum
    }
    
    
    func creatNewCollectionView(colNum: Int, rowNum: Int ,mines: Int) {
        self.mNumOfRows = rowNum
        self.mNumOfColumns = colNum
    }
    
    func showAllMines() {
        print("showAllMines")
        for i in self.mSetFlags {
            print("[\(i/mCells.count), \(i%mCells[0].count)]")
            self.mCells[i/mCells.count][i%mCells[0].count].pressButton()
            self.mCells[i/mCells.count][i%mCells[0].count].cellImage.image = bombImage
        }
    }
    
//    if (x < 0 || y < 0 || x > cells.length - 1 || y > cells[x].length - 1)
//    return;
//
//    else if (cells[x][y].getStatus() > 0) {
//    if(cells[x][y].pressed() == false) {
//    cells[x][y].pressButton();
//    countOfPressed++;
//    ((ImageAdapterLevel) gridview.getAdapter()).notifyDataSetChanged();
//    }
//    return;
//    }
//    if (cells[x][y].getStatus() == 0 && cells[x][y].pressed() == false && cells[x][y].longPressed() == false) {
//    cells[x][y].pressButton();
//    countOfPressed++;
//    ((ImageAdapterLevel) gridview.getAdapter()).notifyDataSetChanged();
//    openCellRec(x - 1, y); //left
//    openCellRec(x, y + 1);//down
//    openCellRec(x, y - 1);//up
//    openCellRec(x + 1, y); //right
//    }
    
    func openCellRec(x: Int, y: Int) {
        if x < 0 || y < 0 || x > self.mCells.count - 1 || y > self.mCells.count - 1 {
            return
        }
        else if self.mCells[x][y].getStatus() > 0 {
            if self.mCells[x][y].pressed() == false {
                self.mCells[x][y].pressButton()
                self.mCountOfPressed+=1
                self.mCells[x][y].cellImage.image = pressedImage
                self.mCells[x][y].cellLable.text = "\(self.mCells[x][y].getStatus())"
            }
            return
        }
        
        if self.mCells[x][y].getStatus() == 0 && self.mCells[x][y].pressed() == false && self.mCells[x][y].longPressed() == false {
            self.mCells[x][y].pressButton()
            self.mCountOfPressed+=1
            self.mCells[x][y].cellImage.image = pressedImage
            openCellRec(x: x - 1, y: y); //left
            openCellRec(x: x, y: y + 1);//down
            openCellRec(x: x, y: y - 1);//up
            openCellRec(x: x + 1, y: y); //right
        }

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
        print("Long press with index path: \(String(describing: indexPath))")

        if let indexPath = indexPath {
            if !self.mIsChangeMines {
                if !self.mCells[indexPath[0]][indexPath[1]].pressed() {
                    if !self.mCells[indexPath[0]][indexPath[1]].longPressed() {
                        if self.mCount>0 {
                            self.mCount -= 1
                            self.mCells[indexPath[0]][indexPath[1]].pressLongButton()
                            self.mCells[indexPath[0]][indexPath[1]].cellImage.image = flagImage

                        }
                    }
                    else if self.mCells[indexPath[0]][indexPath[1]].longPressed() {
                        self.mCount+=1
                        self.mCells[indexPath[0]][indexPath[1]].pressLongButton()
                        self.mCells[indexPath[0]][indexPath[1]].cellImage.image = unPressedImage

                    }
                    self.mFlagsTextView.text = "\(mCount)"
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
            
            var image: UIImage!
            var lable: String!
            
            if cell.cellImage != nil {
                image = unPressedImage
            }
            
            cell.cellImage.image = image
            
            if cell.cellLable != nil {
                lable = ""
            }
            cell.cellLable.textAlignment = .center
            cell.cellLable.text = lable
            
            self.mCells[indexPath[0]][indexPath[1]].cellImage = cell.cellImage
            self.mCells[indexPath[0]][indexPath[1]].cellLable = cell.cellLable
            
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            collectionView.backgroundColor = UIColor.clear
            
            return self.mNumOfColumns ?? 10
        }
        
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            return self.mNumOfRows ?? 10
        }
        
        // MARK: - UICollectionViewDelegate
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            if !mIsChangeMines {
                print(" cell touched with indexPath row: \(indexPath[0]) indexPath col: \(indexPath[1])")
                if !self.mCells[indexPath[0]][indexPath[1]].isLongPressed {
                    if mIsFirstClick {
                        self.mIsFirstClick = false
                        //                        timer(mines)
                    }
                    if self.mCells[indexPath[0]][indexPath[1]].getStatus() == -1 {
                        self.mRestartBtn.setImage(UIImage(named: "burnsmile"), for: .normal)
                        self.mRestartBtn.isEnabled = false
                        showAllMines()
                        self.mIsLost = true
                        print("player lose")
                        return
                    }
                    else {
                        openCellRec(x: indexPath[0], y: indexPath[1]);
                    }
                    self.mCells[indexPath[0]][indexPath[1]].pressButton()
                    self.mCells[indexPath[0]][indexPath[1]].cellImage.image = pressedImage
                    self.mCells[indexPath[0]][indexPath[1]].cellLable.text = "\(self.mCells[indexPath[0]][indexPath[1]].getStatus())"

                    //animation when the player win
                    if (self.mCountOfPressed + self.mSetFlags.count >= self.mCells.count*self.mCells[0].count && self.mIsLost == false) {
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
            return self.mGameBoard.frame.width / rowsCount * 0.8
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
