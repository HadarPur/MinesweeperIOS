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
import Cheers

class GameViewController: UIViewController, UIGestureRecognizerDelegate {
    // outlet
    @IBOutlet weak var mTimeTextView: UITextView!
    @IBOutlet weak var mFlagsTextView: UITextView!
    @IBOutlet weak var mGameBoard: UICollectionView!
    @IBOutlet weak var mRestartBtn: UIButton!
    
    let unPressedImage = UIImage(named: "table.png") as UIImage?
    let pressedImage = UIImage(named: "tableopen.png") as UIImage?
    let bombImage = UIImage(named: "tablebombopen.png") as UIImage?
    let flagImage = UIImage(named: "tableflag.png") as UIImage?
    
    // levels
    let EASY: Int = 0
    let NORMAL: Int = 1
    let HARD: Int = 2
    
    // board size
    let BOARD_CELL10: Int = 10
    let BOARD_CELL5: Int = 5
    
    // board flags
    let EASY_FLAGS: Int = 5
    let HARD_FLAGS: Int = 10
    
    // state
    let LOSS: Int = 0
    let WIN: Int = 1
    
    let MAX_RECORDS: Int = 10
    let mCheerView = CheerView()
    let mFbStorage = FirebaseStorage()
    
    var mTimer = Timer()
    var mLastUpdate: Int = 0
    var mCount: Int = 0
    var mSeconds: Int = 0
    var mCountOfPressed: Int = 0
    var mChosenLevel: Int?
    var mIsLost: Bool = false
    var mIsFirstClick: Bool = true
    var mFirstAsk: Bool = false
    var mIsDone: Bool = false
    var mIsChangedOnce: Bool = false
    var mIsChangeMines: Bool = false
    var mIsNetworkEnabled: Bool?
    var mDiff: Int? = 0
    var mNumOfRows: Int?
    var mNumOfColumns: Int?
    var mIsGameEnabled = true
    var mCells = [[CollectionViewCell]]()
    var mSetFlags = Set<Int>()
    var mUsersData : Array<UserInfo> = Array()
    var mCurrentLat: Double?
    var mCurrentLong: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mGameBoard.isScrollEnabled = false
        self.mIsChangedOnce = false
        self.mIsChangeMines = false
        
        let longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(longPressGR:)))
        longPressGR.minimumPressDuration = 0.5
        longPressGR.delaysTouchesBegan = true
        self.mGameBoard.addGestureRecognizer(longPressGR)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)

        // Configure Cheers
        self.view.addSubview(mCheerView)
        
        createNewGame()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if self.mIsDone {
            self.mIsDone = false
            pressNewGame()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.mCheerView.frame = self.view.bounds
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizer.Direction.right {
            print("Swipe Right")
            _=self.navigationController?.popViewController(animated: true)
        }
    }
    
    func moveToScoreViewController() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let scoreViewController = storyBoard.instantiateViewController(withIdentifier: "ScoreViewController") as? ScoreViewController
        
        guard scoreViewController != nil else {
            return
        }
    
        scoreViewController!.mUsersData = self.mUsersData
        scoreViewController!.mPoints = self.mSeconds
        scoreViewController!.mLevel = self.mDiff
        scoreViewController!.mLatitude = self.mCurrentLat
        scoreViewController!.mLongitude = self.mCurrentLong
        
        // if location != null
        let deadlineTimeAnimate = DispatchTime.now() + .milliseconds(2000)
        DispatchQueue.main.asyncAfter(deadline: deadlineTimeAnimate, execute: {
            // Stop
            self.mCheerView.stop()
        })
        
        let deadlineTime = DispatchTime.now() + .milliseconds(3500)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
            self.navigationController?.pushViewController(scoreViewController!, animated: true)
        })
    }
    
    func moveToResultsViewController() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let resultsViewController = storyBoard.instantiateViewController(withIdentifier: "ResultViewController") as? ResultViewController
        
        guard resultsViewController != nil else {
            return
        }
        
        resultsViewController!.mStatus = self.mIsLost
        resultsViewController!.mState = false
        resultsViewController!.mLevel = self.mDiff
        resultsViewController!.mPoints = self.mSeconds
        resultsViewController!.mIsNetworkEnabled = self.mIsNetworkEnabled

        // if location != null
        let deadlineTimeAnimate = DispatchTime.now() + .milliseconds(2000)
        DispatchQueue.main.asyncAfter(deadline: deadlineTimeAnimate, execute: {
            // Stop
            self.mCheerView.stop()
        })

        let deadlineTime = DispatchTime.now() + .milliseconds(3500)
        // need to check if there is loaction anf if there is so to moving forward this one
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
            self.navigationController?.pushViewController(resultsViewController!, animated: true)
        })
    }
    
    func createNewGame() {
        self.mIsLost = false
        self.mCountOfPressed = 0

        switch self.mDiff {
        case EASY:
            initGame(level: EASY_FLAGS, boardSize: BOARD_CELL10)
            creatNewCollectionView(colNum: BOARD_CELL10, rowNum: BOARD_CELL10 , mines: EASY_FLAGS)
            self.mFbStorage.readResults(level: EASY, callback: {
                self.performQuery()
                print("array count: \(self.mUsersData.count)")
            })
            break
        case NORMAL:
            initGame(level: HARD_FLAGS, boardSize: BOARD_CELL10)
            creatNewCollectionView(colNum: BOARD_CELL10, rowNum: BOARD_CELL10 , mines: HARD_FLAGS)
            self.mFbStorage.readResults(level: NORMAL, callback: {
                self.performQuery()
            })
            break
        case HARD:
            initGame(level: HARD_FLAGS, boardSize: BOARD_CELL5)
            creatNewCollectionView(colNum: BOARD_CELL5, rowNum: BOARD_CELL5 , mines: HARD_FLAGS)
            self.mFbStorage.readResults(level: HARD, callback: {
                self.performQuery()
            })
            break
        default:
            break
        }
    }
    
    func pressNewGame() {
        self.mTimer.invalidate()
        self.mIsFirstClick = true
        self.mSeconds = 0
        self.mIsLost = false
        self.mIsDone = false
        self.mRestartBtn.setImage(UIImage(named: "smileisland"), for: .normal)
        self.mRestartBtn.isEnabled = true
        
        createNewGame()
    }
    
    func initGame(level: Int, boardSize: Int) {
        self.mCount = level
        if self.mSetFlags.count > 0 {
            self.mSetFlags.removeAll()
        }
        if self.mCells.count > 0 {
            self.mCells.removeAll()
            self.mGameBoard.reloadData()
        }
        
        while self.mSetFlags.count < level {
            let randomSource = GKRandomSource.sharedRandom()
            let index = randomSource.nextInt(upperBound: boardSize*boardSize)+0 // returns random Int between 0 and 9
            self.mSetFlags.insert(index)
        }
        
        for i in 0..<boardSize {
            var row = [CollectionViewCell]()
            for j in 0..<boardSize {
                let oneCell = CollectionViewCell()

                if self.mSetFlags.contains(i*boardSize+j) {
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
        self.mTimeTextView.text = "\(0)\(0)"
    }
    
    func setBombsNum(boardSize: Int) {
        var sum: Int = 0, i: Int = 0, j: Int = 0
        
        for i in 1..<boardSize-1 {
            for j in 1..<boardSize-1 {
                if self.mCells[i][j].getStatus() != -1 {
                    sum = calculateSum(startRow: i-1, endRow: i+1, startCol: j-1, endCol: j+1)
                    self.mCells[i][j].setStatus(status: sum)
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
        }
        
        // first row
        i = 0
        for j in 1..<boardSize-1 {
            if self.mCells[i][j].getStatus() != -1 {
                sum = calculateSum(startRow: i, endRow: i+1, startCol: j-1, endCol: j+1)
                self.mCells[i][j].setStatus(status: sum)
            }
        }
        
        // last col
        j = boardSize-1
        for i in 1..<boardSize-1 {
            if self.mCells[i][j].getStatus() != -1  {
                sum = calculateSum(startRow: i-1, endRow: i+1, startCol: j-1, endCol: j)
                self.mCells[i][j].setStatus(status: sum)
            }
        }
        
        // last row
        i = boardSize-1
        for j in 1..<boardSize-1 {
            if self.mCells[i][j].getStatus() != -1  {
                sum = calculateSum(startRow: i-1, endRow: i, startCol: j-1, endCol: j+1)
                self.mCells[i][j].setStatus(status: sum)
            }
        }
        
        j = 0
        i = 0
        if self.mCells[i][j].getStatus() != -1 {
            sum = calculateSum(startRow: i, endRow: i+1, startCol: j, endCol: j+1)
            self.mCells[i][j].setStatus(status: sum)
        }
        
        j = boardSize-1
        if self.mCells[i][j].getStatus() != -1 {
            sum = calculateSum(startRow: i, endRow: i+1, startCol: j-1, endCol: j)
            self.mCells[i][j].setStatus(status: sum)
        }

        
        i = boardSize-1
        if self.mCells[i][j].getStatus() != -1 {
            sum = calculateSum(startRow: i-1, endRow: i, startCol: j-1, endCol: j)
            self.mCells[i][j].setStatus(status: sum)
        }
    
        j = 0
        if self.mCells[i][j].getStatus() != -1 {
            sum = calculateSum(startRow: i-1, endRow: i, startCol: j, endCol: j+1)
            self.mCells[i][j].setStatus(status: sum)
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
        for i in self.mSetFlags {
            self.mCells[i/mCells.count][i%mCells[0].count].pressButton()
            self.mCells[i/mCells.count][i%mCells[0].count].cellImage.image = bombImage
        }
    }
    
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
            if !self.mIsChangeMines && !self.mIsDone {
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
    
    @objc func action() {
        self.mSeconds += 1
        self.mTimeTextView.text = "\(self.mSeconds)"
    }
    
    //When starting a new conversation
    func performQuery() {
        print("Start reading users from DB\n")
        self.mUsersData = self.mFbStorage.getUserInfoArray()
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
            if !self.mIsChangeMines && !self.mIsDone {
                print(" cell touched with indexPath row: \(indexPath[0]) indexPath col: \(indexPath[1])")
                if !self.mCells[indexPath[0]][indexPath[1]].mIsLongPressed {
                    if mIsFirstClick {
                        self.mIsFirstClick = false
                        self.mTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameViewController.action), userInfo: nil, repeats: true)
                    }
                    if self.mCells[indexPath[0]][indexPath[1]].getStatus() == -1 {
                        self.mTimer.invalidate()
                        
                        // Cheers animation
                        let string = NSAttributedString(string: "😔", attributes: [
                            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)
                            ])
                        let size = CGSize(width: 40, height: 40)
                        self.mCheerView.config.particle = .text(size, [string])
                        // Change colors
                        self.mCheerView.config.colors = [UIColor.yellow, UIColor.orange, UIColor.red]
                        // Start
                        self.mCheerView.start()
                        
                        self.mRestartBtn.setImage(UIImage(named: "burnsmile"), for: .normal)
                        self.mRestartBtn.isEnabled = false
                        self.mIsLost = true
                        self.mIsDone = true
                        showAllMines()
                        moveToResultsViewController()
                        print("player lose")
                        return
                    }
                    else {
                        openCellRec(x: indexPath[0], y: indexPath[1]);
                    }
                    self.mCells[indexPath[0]][indexPath[1]].pressButton()
                    self.mCells[indexPath[0]][indexPath[1]].cellImage.image = pressedImage
                    if self.mCells[indexPath[0]][indexPath[1]].getStatus() != 0 {
                        self.mCells[indexPath[0]][indexPath[1]].cellLable.text = "\(self.mCells[indexPath[0]][indexPath[1]].getStatus())"
                    }

                    //animation when the player win
                    if (self.mCountOfPressed + self.mSetFlags.count >= self.mCells.count*self.mCells[0].count && self.mIsLost == false) {
                        self.mTimer.invalidate()
                        
                        // Cheers animation
                        self.mCheerView.config.particle = .confetti(allowedShapes: Particle.ConfettiShape.all)
                        // Change colors
                        self.mCheerView.config.colors = [UIColor.red, UIColor.green, UIColor.blue, UIColor.yellow]
                        // Start
                        self.mCheerView.start()

                        self.mRestartBtn.isEnabled = false
                        self.mIsLost = false
                        self.mIsDone = true
                        
                        // if network is available
                        if Reachability.isConnectedToNetwork(){
                            print("Internet Connection Available!")
                            self.mIsNetworkEnabled = true
                            
                        }else{
                            print("Internet Connection not Available!")
                            self.mIsNetworkEnabled = false
                        }
                        
                        if self.mIsNetworkEnabled ?? false {
                            if self.mUsersData.count>0 {
                                if self.mUsersData.count < MAX_RECORDS || self.mUsersData[self.mUsersData.count-1].getPoints() > self.mSeconds {
                                    moveToScoreViewController()
                                } else {
                                    moveToResultsViewController()
                                }
                            } else {
                                moveToScoreViewController()
                            }
                        } else {
                            moveToResultsViewController()
                        }
                        
                        // else go to results view controller
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
