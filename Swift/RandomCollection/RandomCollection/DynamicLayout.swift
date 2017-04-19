//
//  DynamicLayout.swift
//  RandomCollection
//
//  Created by GK on 2017/4/9.
//  Copyright © 2017年 GK. All rights reserved.
//

import UIKit


class DataSource: NSObject, UICollectionViewDataSource
{
    let items = (0..<100).map { _ in
        return Item(height: randomHeight())
    }
    
    let cellOrigins: [CGPoint]
    let cellSizes: [CGSize]
    
    override init() {
        
        var tempOrigins = [CGPoint]()
        var tempSizes = [CGSize]()
        var leftHeight: Float = 16.0
        var rightHeight: Float = 16.0
        let padding: Float = 32.0
        let leftOrigin: Float = 16.0
        let rightOrigin: Float = 200.0
        
        items.enumerated().forEach { (index,event) in
            var x: Float = leftOrigin
            var y: Float = 0.0
            let width: Float = 150.0
            let height: Float = event.height
            
            if rightHeight > leftHeight {
                y = leftHeight
                leftHeight += event.height + padding
            } else {
                x = rightOrigin
                y = rightHeight
                rightHeight += event.height + padding
            }
            
            tempOrigins.append(CGPoint(x: CGFloat(x), y: CGFloat(y)))
            tempSizes.append(CGSize(width: CGFloat(width), height: CGFloat(height)))
        }
        
        cellOrigins = tempOrigins
        cellSizes = tempSizes
        super.init()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = UIColor.red
        return cell
    }
}

struct Item {
    var height: Float
}
func randomHeight() -> Float {
    return Float((arc4random() % 100) + 50)
}
class DynamicLayout: UICollectionViewLayout {
    let verticalPadding: Float = 10.0
    var dynamicAnimator: UIDynamicAnimator?
    var latestDelta: Float = 0.0
    var staticContentSize: CGSize = CGSize.zero
    
    override init() {
        super.init()
        dynamicAnimator = UIDynamicAnimator(collectionViewLayout: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        dynamicAnimator = UIDynamicAnimator(collectionViewLayout: self)

    }
    
    func firstIndexPath(rect: CGRect) -> IndexPath {
        guard let dataSource = collectionView?.dataSource as? DataSource else  {
            return IndexPath(row: 0, section: 0)
        }
        
        for (index,origin) in dataSource.cellOrigins.enumerated() {
            if origin.y  >= rect.minY {
                return IndexPath(row: index, section: 0)
            }
        }
        return IndexPath(row: 0, section: 0)
    }
    func lastIndexPath(rect: CGRect) -> IndexPath {
        guard let dataSource = collectionView?.dataSource as? DataSource else {
            return IndexPath(row: 0, section: 0)
        }
        
        for (index,origin) in dataSource.cellOrigins.enumerated() {
            if origin.y >= rect.maxY {
                return IndexPath(row: index, section: 0)
            }
        }
        return IndexPath(row: dataSource.items.count - 1, section: 0)
    }
    func indexPaths(rect: CGRect) -> [IndexPath] {
        let min = firstIndexPath(rect: rect).item
        let max = lastIndexPath(rect: rect).item
        
        
        return (min ... max).map {
            return IndexPath(row: $0, section: 0)
        }
    }
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView,
              let dataSource = collectionView.dataSource as? DataSource,
              let dynamicAnimator = dynamicAnimator else {
            return
        }
        
        let visibleRect = collectionView.bounds.insetBy(dx: 0, dy: -100)
        let visiblePaths = indexPaths(rect: visibleRect)
        var currentVisible: [IndexPath] = []
        
        dynamicAnimator.behaviors.forEach { behavior in
            if let behavior = behavior as? UIAttachmentBehavior, let item = behavior.items.first as? UICollectionViewLayoutAttributes {
                if !visiblePaths.contains(item.indexPath) {
                    dynamicAnimator.removeBehavior(behavior)
                } else {
                    currentVisible.append(item.indexPath)
                }
            }
        }
        
        let newlyVisible = visiblePaths.filter { path -> Bool in
            return !currentVisible.contains(path)
        }
        let staticAttributes: [UICollectionViewLayoutAttributes] = newlyVisible.map { path in
            let attributes = UICollectionViewLayoutAttributes(forCellWith: path)
            let size = dataSource.cellSizes[path.item]
            let origin = dataSource.cellOrigins[path.item]
            attributes.frame = CGRect(origin: origin, size: size)
            return attributes
        }
        let touchLocation = collectionView.panGestureRecognizer.location(in: collectionView)
        
        staticAttributes.forEach { attributes in
            let center = attributes.center
            let spring = UIAttachmentBehavior(item: attributes, attachedToAnchor: center)
            spring.length = 0.5
            spring.damping = 0.1
            spring.frequency = 1.5
            
            if (!__CGPointEqualToPoint(CGPoint.zero, touchLocation)){
                let yDistanceFromTouch = touchLocation.y - spring.anchorPoint.y
                let xDistanceFromTouch = touchLocation.x - spring.anchorPoint.x
                let scrollResistance = Float((yDistanceFromTouch + xDistanceFromTouch) / 1500)
                var center = attributes.center
                if (latestDelta < 0) {
                    center.y += CGFloat(max(latestDelta, latestDelta * scrollResistance))
                }else {
                    center.y += CGFloat(min(latestDelta, latestDelta * scrollResistance))
                }
                attributes.center = center
            }
            dynamicAnimator.addBehavior(spring)
        }
        
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView = collectionView,let dynamicAnimator = dynamicAnimator else {
            return false
        }
        
        let delta = newBounds.origin.y - collectionView.bounds.origin.y
        latestDelta = Float(delta)
        
        let touchLocation = collectionView.panGestureRecognizer.location(in: collectionView)
        dynamicAnimator.behaviors.forEach { behavior in
            if let springBehaviour = behavior as? UIAttachmentBehavior,let item = springBehaviour.items.first {
                let yDistanceFromTouch = touchLocation.y - springBehaviour.anchorPoint.y
                let xDistanceFromTouch = touchLocation.x - springBehaviour.anchorPoint.x
                let scrollResistance = (yDistanceFromTouch + xDistanceFromTouch) / 1500.0
                var center = item.center
                if (delta < 0) {
                    center.y += max(delta, delta*scrollResistance);
                } else {
                    center.y += min(delta, delta*scrollResistance);
                }
                item.center = center
                dynamicAnimator.updateItem(usingCurrentState: item)
            }
        }
        return false
    }
    
    override var collectionViewContentSize: CGSize {
        get {
            if staticContentSize != CGSize.zero {
                return staticContentSize
            }
            
            guard let collectionView = collectionView,
                  let dataSource = collectionView.dataSource as? DataSource else {
                    return CGSize.zero
            }
            
            var maxY: CGFloat = 0.0
            (0..<dataSource.items.count).forEach { index in
                let originY = dataSource.cellOrigins[index].y
                let height = dataSource.cellSizes[index].height
                let newMax = originY + height
                if newMax > maxY {
                    maxY = newMax
                }
            }
            staticContentSize = CGSize(width: 320, height: maxY + 10)
            return staticContentSize
            }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return dynamicAnimator?.items(in: rect).map{
            ($0 as? UICollectionViewLayoutAttributes)!
        }
    }
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return dynamicAnimator?.layoutAttributesForCell(at: indexPath)
    }
}
