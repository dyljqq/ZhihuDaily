//
//  Extension.swift
//  ZhihuDaily
//
//  Created by 季勤强 on 16/8/25.
//  Copyright © 2016年 季勤强. All rights reserved.
//

import UIKit
import Accelerate
import SwiftDate

private var overlayKey: Void?

extension UINavigationBar {
    
    private func dyl_overlay()-> UIView? {
        return objc_getAssociatedObject(self, &overlayKey) as? UIView
    }
    
    private func dyl_setOverlay(overlayView: UIView?) {
        objc_setAssociatedObject(self, &overlayKey, overlayView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    public var overlay: UIView? {
        get {
            return self.dyl_overlay()
        }
        
        set {
            if newValue == overlay {
                return
            } else {
                guard let newValue = newValue else {
                    self.removeFromSuperview()
                    self.dyl_setOverlay(nil)
                    return
                }
                self.dyl_setOverlay(newValue)
            }
        }
    }
    
    func dyl_setBackgroundColor(backgroundColor: UIColor) {
        if overlay == nil {
            self.setBackgroundImage(UIImage(), forBarMetrics: .Default)
            overlay = UIView(frame: CGRectMake(0, -20, screenSize.width, self.bounds.size.height + 20))
            overlay!.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
            self.insertSubview(overlay!, atIndex: 0)
        }
        overlay?.backgroundColor = backgroundColor
    }
    
}

extension NSDate {
    func format(format format: String)-> String {
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = format
        return dateFormat.stringFromDate(self)
    }
}

extension String {
    func dateString(format: String)-> String {
        
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = format
        
        guard let date = dateFormat.dateFromString(self) else {
            print("时间不合法")
            return ""
        }
        print("date: \(date)")
        
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Month, .Day, .Weekday], fromDate: date)
        return "\(components.month)月\(components.day)日 \(components.weekday.weekday())"
    }
}

extension Int {
    func weekday()-> String {
        var  str = ""
        switch self {
        case 7: str = "星期日"
        case 1: str = "星期一"
        case 2: str = "星期二"
        case 3: str = "星期三"
        case 4: str = "星期四"
        case 5: str = "星期五"
        case 6: str = "星期六"
        default:
            str = ""
        }
        return str
    }
}

extension UIImage {
    
    public func applyBlurWithRadius(blurRadius: CGFloat, tintColor: UIColor?, saturationDeltaFactor: CGFloat, maskImage: UIImage? = nil) -> UIImage? {
        // Check pre-conditions.
        if (size.width < 1 || size.height < 1) {
            print("*** error: invalid size: \(size.width) x \(size.height). Both dimensions must be >= 1: \(self)")
            return nil
        }
        if self.CGImage == nil {
            print("*** error: image must be backed by a CGImage: \(self)")
            return nil
        }
        if maskImage != nil && maskImage!.CGImage == nil {
            print("*** error: maskImage must be backed by a CGImage: \(maskImage)")
            return nil
        }
        
        let __FLT_EPSILON__ = CGFloat(FLT_EPSILON)
        let screenScale = UIScreen.mainScreen().scale
        let imageRect = CGRect(origin: CGPointZero, size: size)
        var effectImage = self
        
        let hasBlur = blurRadius > __FLT_EPSILON__
        let hasSaturationChange = fabs(saturationDeltaFactor - 1.0) > __FLT_EPSILON__
        
        if hasBlur || hasSaturationChange {
            func createEffectBuffer(context: CGContext) -> vImage_Buffer {
                let data = CGBitmapContextGetData(context)
                let width = UInt(CGBitmapContextGetWidth(context))
                let height = UInt(CGBitmapContextGetHeight(context))
                let rowBytes = CGBitmapContextGetBytesPerRow(context)
                
                return vImage_Buffer(data: data, height: height, width: width, rowBytes: rowBytes)
            }
            
            UIGraphicsBeginImageContextWithOptions(size, false, screenScale)
            let effectInContext = UIGraphicsGetCurrentContext()
            
            CGContextScaleCTM(effectInContext, 1.0, -1.0)
            CGContextTranslateCTM(effectInContext, 0, -size.height)
            CGContextDrawImage(effectInContext, imageRect, self.CGImage)
            
            var effectInBuffer = createEffectBuffer(effectInContext!)
            
            UIGraphicsBeginImageContextWithOptions(size, false, screenScale)
            let effectOutContext = UIGraphicsGetCurrentContext()
            
            var effectOutBuffer = createEffectBuffer(effectOutContext!)
            
            
            if hasBlur {
                // A description of how to compute the box kernel width from the Gaussian
                // radius (aka standard deviation) appears in the SVG spec:
                // http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
                //
                // For larger values of 's' (s >= 2.0), an approximation can be used: Three
                // successive box-blurs build a piece-wise quadratic convolution kernel, which
                // approximates the Gaussian kernel to within roughly 3%.
                //
                // let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
                //
                // ... if d is odd, use three box-blurs of size 'd', centered on the output pixel.
                //
                
                let inputRadius = blurRadius * screenScale
                var radius = UInt32(floor(inputRadius * 3.0 * CGFloat(sqrt(2 * M_PI)) / 4 + 0.5))
                if radius % 2 != 1 {
                    radius += 1 // force radius to be odd so that the three box-blur methodology works.
                }
                
                let imageEdgeExtendFlags = vImage_Flags(kvImageEdgeExtend)
                
                vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
                vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
                vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
            }
            
            var effectImageBuffersAreSwapped = false
            
            if hasSaturationChange {
                let s: CGFloat = saturationDeltaFactor
                let floatingPointSaturationMatrix: [CGFloat] = [
                    0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
                    0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
                    0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
                    0,                    0,                    0,  1
                ]
                
                let divisor: CGFloat = 256
                let matrixSize = floatingPointSaturationMatrix.count
                var saturationMatrix = [Int16](count: matrixSize, repeatedValue: 0)
                
                for i: Int in 0 ..< matrixSize {
                    saturationMatrix[i] = Int16(round(floatingPointSaturationMatrix[i] * divisor))
                }
                
                if hasBlur {
                    vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, Int32(divisor), nil, nil, vImage_Flags(kvImageNoFlags))
                    effectImageBuffersAreSwapped = true
                } else {
                    vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, Int32(divisor), nil, nil, vImage_Flags(kvImageNoFlags))
                }
            }
            
            if !effectImageBuffersAreSwapped {
                effectImage = UIGraphicsGetImageFromCurrentImageContext()
            }
            
            UIGraphicsEndImageContext()
            
            if effectImageBuffersAreSwapped {
                effectImage = UIGraphicsGetImageFromCurrentImageContext()
            }
            
            UIGraphicsEndImageContext()
        }
        
        // Set up output context.
        UIGraphicsBeginImageContextWithOptions(size, false, screenScale)
        let outputContext = UIGraphicsGetCurrentContext()
        CGContextScaleCTM(outputContext, 1.0, -1.0)
        CGContextTranslateCTM(outputContext, 0, -size.height)
        
        // Draw base image.
        CGContextDrawImage(outputContext, imageRect, self.CGImage)
        
        // Draw effect image.
        if hasBlur {
            CGContextSaveGState(outputContext)
            if let image = maskImage {
                CGContextClipToMask(outputContext, imageRect, image.CGImage);
            }
            CGContextDrawImage(outputContext, imageRect, effectImage.CGImage)
            CGContextRestoreGState(outputContext)
        }
        
        // Add in color tint.
        if let color = tintColor {
            CGContextSaveGState(outputContext)
            CGContextSetFillColorWithColor(outputContext, color.CGColor)
            CGContextFillRect(outputContext, imageRect)
            CGContextRestoreGState(outputContext)
        }
        
        // Output image is ready.
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return outputImage
    }
    
}

extension UIViewController {
    
    func setLeftNavigationItemBack() {
//        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.dyl_setBackgroundColor(navigationColor)
        let left = UIBarButtonItem(image: UIImage(named: "left_back"), style: .Plain, target: self, action: #selector(backAction))
        left.tintColor = whiteColor
        navigationItem.setLeftBarButtonItem(left, animated: true)
    }
    
    func backAction() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}

