//
//  SpanGridCollectionViewLayout.swift
//  GridLayoutDemo
//
//  Created by Jianhua Wang on 2/17/17.
//  Copyright © 2017 WJH. All rights reserved.
//

import UIKit

enum PageType {
    case even
    case odd
    case two
}

struct PageLayoutCode {
    let colNum: Int
    let rowNum: Int
    let layoutCode: [Int]
    init(colNum: Int, rowNum: Int, layoutCode: [Int]) {
        self.colNum = colNum
        self.rowNum = rowNum
        self.layoutCode = layoutCode
    }
}

protocol SpanGridCollectionViewLayoutDelegate : class {
    func totalPhotoCountInGallery() -> Int
    func loadingError() -> Error?
}

class SpanGridCollectionViewLayout: UICollectionViewLayout  {
    var xLineSpace = CGFloat(5.0)
    var yLineSpace = CGFloat(4.0)
    var cellAspectRatio = CGFloat(1) //height/width
    var heightOfLoadingSupplementaryView = CGFloat(100)
    var pageLayoutCodes: [PageType : PageLayoutCode] = [.even: PageLayoutCode(colNum: 3, rowNum: 2, layoutCode: [1, 1, 2, 1, 1, 3]), .odd : PageLayoutCode(colNum: 3, rowNum: 2, layoutCode: [1, 1, 1, 3, 2, 2]), .two: PageLayoutCode(colNum: 2, rowNum: 1, layoutCode:  [1, 2])]
    weak var delegate: SpanGridCollectionViewLayoutDelegate?
    
    private var totalPhotoCount = 0
    let columns = 3
    let rows = 2
    private var pageHeight = CGFloat(0.0)
    private var cellWidth = CGFloat(0.0)
    private var cellHeight = CGFloat(0.0)
    private var viewWidth = CGFloat(0.0)
    private var numberOfItems = 0
    private var numberOfPages = 0
    private var pageFrameSets = [PageType : [CGRect]]()
    
    override func prepare() {
        super.prepare()
        viewWidth = self.collectionView?.frame.width ?? CGFloat(0)
        cellWidth = (viewWidth + xLineSpace) / CGFloat(columns)
        cellHeight = cellWidth * cellAspectRatio
        pageHeight = cellHeight * CGFloat(rows)
        pageFrameSets[.even] = self.frameSet(forPageType: .even)
        pageFrameSets[.odd] = self.frameSet(forPageType: .odd)
        pageFrameSets[.two] = self.frameSet(forPageType: .two)
        totalPhotoCount = self.delegate?.totalPhotoCountInGallery() ?? 0
        numberOfItems = self.collectionView?.numberOfItems(inSection: 0) ?? 0
        numberOfPages = (numberOfItems + 2) / 3
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributes = [UICollectionViewLayoutAttributes]()
        let allIndexPathsInRect = indexPaths(inRect: rect)
        allIndexPathsInRect.forEach { (indexPath) in
            if let attribute = self.layoutAttributesForItem(at: indexPath) {
                if attribute.frame.intersects(rect) {
                    attributes.append(attribute)
                }
            }
        }
        if let footerSupplementaryView = self.layoutAttributesForSupplementaryView(ofKind: UICollectionElementKindSectionFooter, at: IndexPath(row: 0, section: 0)) {
            if(footerSupplementaryView.frame.intersects(rect)) {
                attributes.append(footerSupplementaryView)
            }
        }
        return attributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        let pageIndex = indexPath.row / 3
        let numberPhotosInCurrentPage = (self.totalPhotoCount - pageIndex * 3) < 3 ?  (self.totalPhotoCount - pageIndex * 3) : 3
        let indexInPage = (indexPath.row - pageIndex * 3) % numberPhotosInCurrentPage
        var newFrame = CGRect(x: 0, y: 0, width: viewWidth, height: pageHeight)
        if(numberPhotosInCurrentPage == 2) {
            if let frameSet = pageFrameSets[.two] {
                newFrame = frameSet[indexInPage]
            }
        }
        else if(numberPhotosInCurrentPage == 3) {
            if let frameSet = ((pageIndex % 2) == 0) ? pageFrameSets[.even] : pageFrameSets[.odd] {
                newFrame = frameSet[indexInPage]
            }
        }
        attribute.frame = newFrame.offsetBy(dx: 0, dy: CGFloat(pageIndex) * pageHeight)
        return attribute
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        // print("\(#function), indexPath: \(indexPath)")
        if(self.hasMorePhoto()) {
            let attribute = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, with: indexPath)
            attribute.frame = CGRect(x: 0, y: CGFloat(numberOfPages) * pageHeight , width: viewWidth, height: heightOfLoadingSupplementaryView)
            return attribute
        }
        else {
            return nil
        }
    }
    
    override var collectionViewContentSize: CGSize {
        let shouldShowSupplementaryView = self.hasMorePhoto() || (self.delegate?.loadingError() != nil)
        var contentSize = CGSize(width: self.collectionView?.frame.width ?? 0, height: CGFloat(numberOfPages) * pageHeight + (shouldShowSupplementaryView ? heightOfLoadingSupplementaryView : 0))
        
        if(!self.hasMorePhoto() && (numberOfItems % 3) == 2) {
            let cellHeightForTwo = (viewWidth - xLineSpace) / 2
            contentSize.height -= pageHeight - cellHeightForTwo
        }
        return contentSize
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    private func frameSet(forPageType pageType: PageType ) -> [CGRect] {
        var frameSet = [CGRect]()
        switch pageType {
        case .even:
            let newFrameSet = self.frameset(fromPageLayoutCode: pageLayoutCodes[.even]!)
            frameSet.append(newFrameSet[0])
            frameSet.append(newFrameSet[1])
            frameSet.append(newFrameSet[2])
            break
        case .odd:
            let newFrameSet = self.frameset(fromPageLayoutCode: pageLayoutCodes[.odd]!)
            frameSet.append(newFrameSet[0])
            frameSet.append(newFrameSet[1])
            frameSet.append(newFrameSet[2])
        case .two:
            let newFrameSet = self.frameset(fromPageLayoutCode: pageLayoutCodes[.two]!)
            frameSet.append(newFrameSet[0])
            frameSet.append(newFrameSet[1])
        }
        return frameSet
    }
    
    private func hasMorePhoto() -> Bool {
        return (self.collectionView?.numberOfItems(inSection: 0) ?? 0) < (self.delegate?.totalPhotoCountInGallery() ?? 0)
    }
    
    private func indexPaths(inRect rect: CGRect) -> [IndexPath] {
        let totalItemNumber = self.collectionView?.numberOfItems(inSection: 0) ?? 0
        var indexPaths = [IndexPath]()
        let fromPageIndex = Int((rect.minY > 0 ? rect.minY : 0) / CGFloat(pageHeight))
        let toPageIndex = Int((rect.maxY > 0 ? rect.maxY : 0) / CGFloat(pageHeight))
        for i in fromPageIndex...toPageIndex {
            for j in 0...2 {
                let indexPath = IndexPath(row: (i * 3) + j, section: 0)
                if(indexPath.row < totalItemNumber) {
                    indexPaths.append(indexPath)
                }
            }
        }
        return indexPaths
    }
    
    private func frameset(fromPageLayoutCode pageLayoutCode: PageLayoutCode) -> [CGRect] {
        // [1, 1, 2, 1, 1, 3], [1, 2, 2, 3, 2, 2], [1, 1, 2, 3, 3, 4]
        let cellnum = pageLayoutCode.colNum * pageLayoutCode.rowNum
        let cellWidth = CGFloat(viewWidth + xLineSpace) / CGFloat(pageLayoutCode.colNum)
        let cellHeight = CGFloat(cellWidth) * CGFloat(cellAspectRatio)
        var checked = [Bool]()
        var frameSet = [CGRect]()
        var frameSize = CGSize.zero
        let layoutCode = pageLayoutCode.layoutCode
        var maxIndex = layoutCode[0]
        for i in 1 ... cellnum - 1 {
            if(layoutCode[i] > maxIndex) {
                maxIndex = layoutCode[i]
            }
        }
        frameSet = [CGRect](repeating: CGRect.zero, count: maxIndex)
        checked = [Bool](repeating: false, count: maxIndex)
        for i in 0...cellnum - 1 {
            if(checked[layoutCode[i] - 1]) {
                continue
            }
            else {
                checked[layoutCode[i] - 1] = true
                frameSize = CGSize.zero
                var j = i
                while(j < cellnum && layoutCode[j] == layoutCode[i]) {
                    j += 1
                    frameSize.width += 1
                }
                j = i
                while(j < cellnum && layoutCode[j] == layoutCode[i]) {
                    j += pageLayoutCode.colNum
                    frameSize.height += 1
                }
                let normalizeRect = CGRect(x: i % pageLayoutCode.colNum, y: i / pageLayoutCode.colNum, width: Int(frameSize.width), height: Int(frameSize.height))
                frameSet[layoutCode[i] - 1] = normalizeRect.applying(CGAffineTransform(scaleX: CGFloat(cellWidth), y: CGFloat(cellHeight))).insetBy(dx: 0.5 * CGFloat(xLineSpace), dy: 0.5 * CGFloat(yLineSpace)).offsetBy(dx: -0.5 * CGFloat(xLineSpace), dy: -0.5 * CGFloat(yLineSpace))
            }
        }
        return frameSet
    }
}

