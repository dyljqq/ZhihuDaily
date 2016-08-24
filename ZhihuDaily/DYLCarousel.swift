//
//  DYLCarousel.swift
//  TGLParallaxCarousel
//
//  Created by 季勤强 on 16/8/19.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import UIKit

// 数据源
@objc public protocol DYLCarouselDatasource {
    func viewForItemInCarousel(index: Int, carousel: DYLCarousel)-> DYLCarouselItem
    func numOfItemsInCarousel(carousel: DYLCarousel)-> Int
}

@objc public protocol DYLCarouselDelegate {
    func didMoveToItemAtIndex(index: Int)
    optional func didTapItemAtIndex(carouselView: DYLCarousel ,index: Int)
}

public class DYLCarouselItem: UIView {
    var xDisplay: Double = 0.0
    var zDisplay: Double = 0.0
}

public enum CarouselType {
    case Normal
    case ThreeDimensional
}

public class DYLCarousel: UIView {
    
    var upperView: UIView!
    var pageControl: UIPageControl!
    
    // weak protocol must declare with @objc
    
    public weak var delegate: DYLCarouselDelegate?
    public weak var datasource: DYLCarouselDatasource? {
        didSet {
            reload()
        }
    }
    
    public var selectedIndex = -1 {
        didSet {
            if selectedIndex < 0 {
                selectedIndex = 0
            } else if (selectedIndex > self.datasource!.numOfItemsInCarousel(self) - 1) {
                selectedIndex = self.datasource!.numOfItemsInCarousel(self) - 1
            }
            updatePageControl(selectedIndex)
            // TODO move to index
            self.delegate?.didMoveToItemAtIndex(selectedIndex)
        }
    }
    
    public var type: CarouselType = .ThreeDimensional {
        didSet {
            reload()
        }
    }
    
    private var carouselItems = [DYLCarouselItem]()
    private var containerView: UIView!
    
    private let nibName = "DYLCarousel"
    
    private var itemWidth: CGFloat?
    private var itemHeight: CGFloat?
    
    private var currentGestureVelocity: CGFloat = 0.0
    private var startGesturePoint: CGPoint = CGPointZero
    private var endGesturePoint: CGPoint = CGPointZero
    private var currentItem: DYLCarouselItem?
    private var currentFoundItem: DYLCarouselItem?
    
    
    var displacement: Double {
        switch type {
        case .Normal:
            if let itemWidth = itemWidth {
                return Double(itemWidth)
            }
        case .ThreeDimensional:
            return 50.0
        }
        return 0.0
    }
    
    var parallaxFactor: Double {
        if let itemWidth = itemWidth {
            return (Double)(itemWidth) / displacement
        }
        return 1
    }
    
    var zDisplayFactor: Double {
        switch type {
        case .Normal:
            return 0.0
        default:
            return 1.0
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    init() {
        super.init(frame: CGRectZero)
        initView()
    }
    
    func initView() {
        
        upperView = UIView(frame: CGRectMake(0, 0, self.frame.size.width, 166))
        self.addSubview(upperView)
        
        let bottomView = UIView(frame: CGRectMake(0, 166, self.frame.size.width, 34))
        self.addSubview(bottomView)
        
        pageControl = UIPageControl()
        pageControl.center = CGPointMake(bottomView.frame.size.width / 2, bottomView.frame.size.height / 2)
        pageControl.bounds = CGRectMake(0, 0, bottomView.frame.size.width, bottomView.frame.size.height)
        bottomView.addSubview(pageControl)

    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }
    
    func xibSetup() {
        containerView = loadView()
        containerView.frame = bounds
        containerView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        self.addSubview(containerView)
    }
    
    func loadView()-> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: String(self.dynamicType), bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }
    
    override public func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        let pan: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(detectPan(_:)))
        upperView.addGestureRecognizer(pan)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(detectTap(_:)))
        upperView.addGestureRecognizer(tap)
    }
    
}

// data handle
extension DYLCarousel {
    
    func reload() {
        guard let datasource = datasource else { return }
        pageControl.numberOfPages = datasource.numOfItemsInCarousel(self)
        for i in 0..<datasource.numOfItemsInCarousel(self) {
            addItem(datasource.viewForItemInCarousel(i, carousel: self))
        }
        layoutIfNeeded()
    }
    
    func addItem(item: DYLCarouselItem) {
        if selectedIndex < 0 {
            selectedIndex = 0
        }
        if itemWidth == nil {
            itemWidth = item.frame.size.width
        }
        if itemHeight == nil {
            itemHeight = item.frame.size.height
        }
        item.center = CGPointMake(upperView.center.x, upperView.center.y + (upperView.frame.size.height - itemHeight!) / 2)
        dispatch_async(dispatch_get_main_queue()){
            self.upperView.layer.addSublayer(item.layer)
            self.carouselItems.append(item)
            self.refreshItemsPosition(animated: true)
        }
    }
    
    func refreshItemsPosition(animated animated: Bool) {
        if animated {
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationCurve(.Linear)
            UIView.setAnimationBeginsFromCurrentState(true)
            UIView.setAnimationDuration(0.2)
        }
        
        for (index, item) in carouselItems.enumerate() {
            item.xDisplay = displacement * Double(index)
            item.zDisplay = round(-fabs(item.xDisplay)) * zDisplayFactor
            
            item.layer.anchorPoint = CGPointMake(0.5, 0.5)
            
            var t = CATransform3DIdentity
            t.m34 = -(1/500)
            t = CATransform3DTranslate(t, CGFloat(item.xDisplay), 0.0, CGFloat(item.zDisplay))
            item.layer.transform = t
        }
        
        if animated {
            UIView.commitAnimations()
        }
        
    }
    
    func updatePageControl(index: Int) {
        self.pageControl.currentPage = index
    }
    
}


// gesture
extension DYLCarousel {
    
    func detectPan(panGesture: UIPanGestureRecognizer) {
        // TODO
        switch panGesture.state {
        case .Began:
            startGesturePoint = panGesture.locationInView(panGesture.view)
            currentGestureVelocity = 0
            
        case .Changed:
            currentGestureVelocity = panGesture.velocityInView(panGesture.view).x
            endGesturePoint = panGesture.locationInView(panGesture.view)
            
            // let xOffset = (startGesturePoint.x - endGesturePoint.x ) * (1/parallaxFactor)
            let xOffset = (startGesturePoint.x - endGesturePoint.x ) / CGFloat(parallaxFactor)
            
            move(Double(xOffset))
            startGesturePoint = endGesturePoint
            
        case .Ended, .Cancelled, .Failed:
            startDecelerating()
        case.Possible:
            break
        }
    }
    
    func detectTap(tapGesture: UITapGestureRecognizer) {
        let targetPoint = tapGesture.locationInView(tapGesture.view)
        let layer = upperView.layer.hitTest(targetPoint)
        guard let targetItem = findItem(layer!) else {
            return
        }
        let firstItemOffset = carouselItems[0].xDisplay - targetItem.xDisplay
        let tappedIndex = -Int(round(firstItemOffset/displacement))
        if targetItem.xDisplay == 0 {
            guard let function = self.delegate?.didTapItemAtIndex else {
                return
            }
            function(self, index: tappedIndex)
        } else {
            let offset = displacement * Double(tappedIndex - selectedIndex)
            selectedIndex = tappedIndex
            move(offset)
        }
    }
    
}


// Helper
extension DYLCarousel {
   
    func move(offset: Double) {
        if offset == 0 {
            return
        }
        for (_, item) in carouselItems.enumerate() {
            item.xDisplay -= offset
            item.zDisplay = -fabs(item.xDisplay) * zDisplayFactor
            let factor = xFactor(item.zDisplay)
            dispatch_async(dispatch_get_main_queue()) {
                UIView.animateWithDuration(0.2) {
                    var t = CATransform3DIdentity
                    t.m34 = -(1/500)
                    t = CATransform3DTranslate(t,(CGFloat)(item.xDisplay * factor), 0.0, (CGFloat)(item.zDisplay))
                    (item as DYLCarouselItem).layer.transform = t
                }
            }
        }
    }
    
    func xFactor(x: Double)-> Double {
        // formula: f(x) = kx + b
        let k = (1 - parallaxFactor) / (displacement - displacement / 2)
        let b = 1 - k * displacement
        let y = k * fabs(x) + b
        switch fabs(x) {
        case 0..<(displacement/2):
            return parallaxFactor
        case displacement/2..<displacement:
            return y
        default:
            return 1
        }
    }
    
    func startDecelerating() {
        
        let distance = decelerationDistance()
        let offsetItems = carouselItems[0].xDisplay
        let endOffsetItems = offsetItems + Double(distance)
        
        selectedIndex = -Int(round(endOffsetItems / displacement))
        
        let offsetToAdd = displacement * -Double(selectedIndex) - offsetItems
        move(-offsetToAdd)
    }
    
    
    func decelerationDistance()-> CGFloat {
        let acceleration = -currentGestureVelocity * 25
        if acceleration == 0 {
            return 0
        }else {
            return -pow(currentGestureVelocity, 2.0) / (2.0 * acceleration)
        }
    }
    
    func findItem(layer: CALayer)-> DYLCarouselItem? {
        currentFoundItem = nil
        for item in carouselItems {
            currentItem = item
            checkInSubView(item, layer: layer)
        }
        return currentFoundItem
    }
    
    // recursion
    func checkInSubView(view: UIView, layer: CALayer) {
        let subviews = view.subviews
        for subview in subviews {
            if subview.layer.isEqual(layer) {
                currentFoundItem = currentItem
                return
            }
            checkInSubView(subview, layer: layer)
        }
    }
    
}