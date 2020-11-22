//
//  PinterestTypeLayout.swift
//  simbe
//
//  Created by 권지수 on 2020/10/30.
//

import UIKit

protocol PinterestTypeLayoutDelegate : AnyObject {
    func collectionView(_ collectionView: UICollectionView, sizeIndexPath: IndexPath) -> CGFloat
}

class PinterestTypeLayout: UICollectionViewLayout {
    var delegate: PinterestTypeLayoutDelegate?
    
    private let numberOfColumns = 2
    private let cellPadding: CGFloat = 6
    private var cache: [UICollectionViewLayoutAttributes] = []
    
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        
        return collectionView.bounds.width - (collectionView.contentInset.left + collectionView.contentInset.right)
    }
//    private var contentHeight: CGFloat = 0
    var contentHeight: CGFloat = 0
    private let defaultHeight: CGFloat = 180
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
}
// MARK: - Necessary func
extension PinterestTypeLayout {
    override func prepare() {
        guard let collectionView = collectionView else {
            return
        }
        
        cache.removeAll()
        
        let columnsWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset: [CGFloat] = []
        for column in 0 ..< numberOfColumns {
            xOffset.append(CGFloat(column) * columnsWidth)
        }
        
        var column = 0
        var yOffset: [CGFloat] = .init(repeating: 0, count: numberOfColumns)
        
        // 첫 번째 섹션의 아이템 갯 수 만큼 반복
        for item in 0 ..< collectionView.numberOfItems(inSection: 0){
            let indexPath = IndexPath(item: item, section: 0)
            let customHeight = delegate?.collectionView(collectionView, sizeIndexPath: indexPath) ?? defaultHeight
            
            let height = customHeight
            
            if yOffset[0] > yOffset[1]{
                column = 1
            }else {
                column = 0
            }
            
            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnsWidth, height: height)
            let insetFrame = frame
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
//            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height
            contentHeight = max(yOffset[0], yOffset[1])
            column = column < (numberOfColumns - 1) ? (column + 1) : 0
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        
        
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
}
