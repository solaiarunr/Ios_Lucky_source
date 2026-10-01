//
//  ExtensionClass.swift
//  iDemand
//
//  Created by Roby on 28/08/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import Foundation
import UIKit
import SafariServices
import UITextView_Placeholder
import MaterialComponents

let customLoader = UIActivityIndicatorView()
let loaderView = UIView()

//MARK: TEXT FIELD **********************************************
extension UITextField{
    
    public func config(color:UIColor,font:UIFont?, align:NSTextAlignment,place:String){
        self.textColor = color
        self.textAlignment = align
        if place != ""{
            self.placeholder = (Utility.shared.Json().value(forKey: place) as! String)
        }
        self.font = font
    }
    
    //MARK: check textfield is empty
    func isEmptyValue() -> Bool {
        if  (self.text! == "") || (self.text! == "NULL") || (self.text! == "(null)") || (self.text! == "<null>") || (self.text! == "Json Error") || (self.text! == "0") || (self.text!.isEmpty) ||  self.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            return true
        }
        return false
    }
    //border
    func makeBorder()  {
        self.layer.borderWidth = 1
        self.layer.borderColor = LINE_COLOR?.cgColor
    }
    //left padding
    func leftPadding()  {
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    //add left icon
    func addPadding(left:Bool)  {
        let height = self.frame.size.height
        let searchView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: height))
        let padding = height/2
        let imageView: UIImageView = UIImageView(frame: CGRect(x: 11, y: padding-9, width: 18, height: 18))
        imageView.image = #imageLiteral(resourceName: "search_icon")
        imageView.contentMode = .scaleAspectFill
        searchView.addSubview(imageView)
        if left{
            self.leftView = searchView
            self.leftViewMode = .always

        }else{
            self.rightView = searchView
            self.rightViewMode = .always

        }

    }
}

//MARK: LABEL **********************************************

extension UILabel{
    //MARK: configure label
    public func config(color:UIColor,font:UIFont?, align:NSTextAlignment, text:String){
        self.textColor = color
        self.textAlignment = align
        // qwerty
        if text != ""{
            self.text = (Utility.shared.Json().value(forKey: text) as! String)
        }
        self.font = font
    }
    func setCustom(fullTxt:String,activeTxt:String,color:UIColor) {
        let termsAttributeString = NSMutableAttributedString(string: fullTxt)
        let termsRange = (fullTxt as NSString).range(of: activeTxt)
        termsAttributeString.addAttribute(NSAttributedString.Key.foregroundColor, value:color, range: termsRange)
        self.attributedText = termsAttributeString
        self.isUserInteractionEnabled = true
    }
     func heightFor(text:NSAttributedString, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect.init(x: 20, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.attributedText = text

        label.sizeToFit()
        return label.frame.height
    }
    

}

//MARK: UITEXTVIEW **********************************************

extension UITextView{
    //MARK: configure text view
    public func config(color:UIColor,font:UIFont?, align:NSTextAlignment, place:String){
        self.textColor = color
        self.textAlignment = align
        if place != ""{
            self.placeholder = (Utility.shared.Json().value(forKey: place) as! String)
        }
        self.placeholderColor = LINE_COLOR
        self.font = font
    }
    //MARK: check text view is empty
    func isEmptyValue() -> Bool {
        if  (self.text! == "") || (self.text! == "NULL") || (self.text! == "(null)") || (self.text! == "<null>") || (self.text! == "Json Error") || (self.text! == "0") || (self.text!.isEmpty) ||  self.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            return true
        }
        return false
    }
    
}

//MARK: UIVIEWCONTROLLER **********************************************

extension UIViewController{
    func addLoader() {
        customLoader.color = PRIMARY_COLOR
        customLoader.hidesWhenStopped = true
        loaderView.frame = CGRect.init(x: 0, y: 0, width: FULL_WIDTH, height: FULL_HEIGHT)
        loaderView.backgroundColor = UIColor.init(named: "loader_background")
        customLoader.center = loaderView.center
        loaderView.addSubview(customLoader)
        self.view.addSubview(loaderView)
        self.stopLoading()
    }
    func stopLoading()  {
        loaderView.isHidden = true
        customLoader.stopAnimating()
    }
    func startLoading()  {
        loaderView.isHidden = false
        self.view.bringSubviewToFront(loaderView)
        customLoader.startAnimating()
    }
    func updateTheme(){
        self.view.backgroundColor = BACKGROUND_COLOR
        if #available(iOS 13.0, *) {
            if LocalDefault.shared.theme() == Utility.shared.Json().value(forKey: "dark") as? NSString{
                overrideUserInterfaceStyle = .dark
            }else if LocalDefault.shared.theme() == Utility.shared.Json().value(forKey: "light") as? NSString{
                overrideUserInterfaceStyle = .light
            }
        }
    }
    
}

//MARK: MDCCARD **********************************************

extension MDCCard {
    //Elevation effect
    func elevation(radius:CGFloat)  {
        self.cornerRadius = radius
        self.isInteractable = false
        self.setShadowElevation(.appBar, for: .normal)
        self.setShadowColor(LINE_COLOR, for: .normal)
    }
    
    //Elevation effect
     func switchElevation(radius:CGFloat)  {
         self.cornerRadius = radius
         self.isInteractable = false
         self.setShadowElevation(.switch, for: .normal)
         self.setShadowColor(LINE_COLOR, for: .normal)
     }
}

//MARK: UIIMAGE **********************************************

extension UIImage {

class func colorForNavBar(color: UIColor) -> UIImage {
       let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
       //    Or if you need a thinner border :
       //    let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 0.5)
       UIGraphicsBeginImageContext(rect.size)
       let context = UIGraphicsGetCurrentContext()

       context!.setFillColor(color.cgColor)
       context!.fill(rect)

       let image = UIGraphicsGetImageFromCurrentImageContext()
       UIGraphicsEndImageContext()

       return image!
   }
}
//MARK: UIVIEW **********************************************

extension UIView {
    func radius(value:CGFloat)  {
        self.layer.cornerRadius = value
        self.clipsToBounds = true
    }
    func addBorder(width:CGFloat,color:UIColor)  {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    //Specific corner radius
    func bottomRadius()  {
        let rectShape = CAShapeLayer()
        rectShape.bounds = self.frame
        rectShape.position = self.center
        rectShape.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [ .bottomRight , .bottomLeft], cornerRadii: CGSize(width: 20, height: 20)).cgPath
        self.layer.mask = rectShape
    }
    func topRadius()  {
        let rectShape = CAShapeLayer()
        rectShape.bounds = self.frame
        rectShape.position = self.center
        rectShape.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [ .topRight , .topLeft], cornerRadii: CGSize(width: 20, height: 20)).cgPath
        self.layer.mask = rectShape
    }
    func corner(position:UIRectCorner)  {
        let rectShape = CAShapeLayer()
        rectShape.bounds = self.frame
        rectShape.position = self.center
        rectShape.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [position], cornerRadii: CGSize(width: 20, height: 20)).cgPath
        self.layer.mask = rectShape
    }
    func topRight()  {
        let rectShape = CAShapeLayer()
        rectShape.bounds = self.frame
        rectShape.position = self.center
        rectShape.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topRight], cornerRadii: CGSize(width: 20, height: 20)).cgPath
        self.layer.mask = rectShape
    }
    func addDottedLine()  {
        var count = 0
        for lay in self.layer.sublayers! {
            if lay.isKind(of: CAShapeLayer.self) {
                self.layer.sublayers?.remove(at: count)
            }
            count += 1
        }
        let yourViewBorder = CAShapeLayer()
        yourViewBorder.strokeColor = PRIMARY_COLOR!.cgColor
        yourViewBorder.lineDashPattern = [2, 2]
        yourViewBorder.frame = self.bounds
        yourViewBorder.fillColor = nil
        yourViewBorder.path = UIBezierPath(rect: self.bounds).cgPath
        self.layer.addSublayer(yourViewBorder)
    }
    func removeRadius()  {
        self.superview!.layer.cornerRadius  = 0.0
        self.superview!.layer.masksToBounds = false
    }
    //add raja
    func dropShadow(opacity: Float,scale: Bool = true) {
//        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = CGSize(width: -1, height: 1)
//        layer.shadowRadius = 1
//
//        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
//        layer.shouldRasterize = true
//        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
      }
    
//    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
//        layer.masksToBounds = false
//        layer.shadowColor = color.cgColor
//        layer.shadowOpacity = opacity
//        layer.shadowOffset = offSet
//        layer.shadowRadius = radius
//        
//        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
//        layer.shouldRasterize = true
//        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
//    }
}


//MARK: BUTTON **********************************************
extension UIButton{
    public func config(color:UIColor,font:UIFont?,align:UIControl.ContentHorizontalAlignment,title:String){
        self.setTitleColor(color, for: .normal)
        if title != ""{
            
            self.setTitle((Utility.shared.Json().value(forKey: title) as! String), for: .normal)
        }
        self.contentHorizontalAlignment = align
        self.titleLabel?.font = font
    }
}


//MARK: GESTURE **********************************************

extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        //let textContainerOffset = CGPointMake((labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
        //(labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        
        //let locationOfTouchInTextContainer = CGPointMake(locationOfTouchInLabel.x - textContainerOffset.x,
        // locationOfTouchInLabel.y - textContainerOffset.y);
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
    
}

//MARK: STRING **********************************************
extension String {
    //check string contains emoji
    func containsEmoji() -> Bool {
        for character in self {
            if character.isEmoji {
                return true
            }
        }
        return false
    }
    //check mail is valid
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    //MARK: check is empty
    func isEmptyVal() -> Bool {
        if  (self == "") || (self == "NULL") || (self == "(null)") || (self == "<null>") || (self == "Json Error") || (self == "0") || (self.isEmpty) ||  self.trimmingCharacters(in: .whitespaces).isEmpty {
            return true
        }
        return false
    }
    
    func CGFloatValue() -> CGFloat? {
        guard let doubleValue = Double(self) else {
            return nil
        }
        
        return CGFloat(doubleValue)
    }
}
//MARK: CHARACTER **********************************************

extension Character {
    var isEmoji: Bool {
        guard let scalar = unicodeScalars.first else { return false }
        return scalar.properties.isEmoji && (scalar.value > 0x238C || unicodeScalars.count > 1)
    }
}

//MARK: UIDEVICE **********************************************
extension UIDevice {
    var hasNotch: Bool {
        let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
}

//MARK: SAFARI VIEW CONTROLLER **********************************************
extension SFSafariViewController {
    override open var modalPresentationStyle: UIModalPresentationStyle {
        get { return .fullScreen}
        set { super.modalPresentationStyle = newValue }
    }
}

//MARK: UITABBAR CONTROLLER **********************************************
extension UITabBarController {
    open override var childForStatusBarStyle: UIViewController? {
        return selectedViewController?.childForStatusBarStyle ?? selectedViewController
    }
}
//MARK: UINAVIGATION CONTROLLER **********************************************
extension UINavigationController {
    open override var childForStatusBarStyle: UIViewController? {
        return topViewController?.childForStatusBarStyle ?? topViewController
    }
}
//MARK: ATTRIBUTED STRING **********************************************

extension NSAttributedString {

    convenience init(htmlString html: String) throws {
        let options: [NSAttributedString.DocumentReadingOptionKey : Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        let data = html.data(using: .utf8, allowLossyConversion: true)
        guard (data != nil), let fontFamily = subReg?.familyName, let attr = try? NSMutableAttributedString(data: data!, options: options, documentAttributes: nil) else {
            try self.init(data: data ?? Data(html.utf8), options: options, documentAttributes: nil)
            return
        }

        let range = NSRange(location: 0, length: attr.length)
        attr.enumerateAttribute(.font, in: range, options: .longestEffectiveRangeNotRequired) { attrib, range, _ in
            if let htmlFont = attrib as? UIFont {
                let traits = htmlFont.fontDescriptor.symbolicTraits
                var descrip = htmlFont.fontDescriptor.withFamily(fontFamily)

                if (traits.rawValue & UIFontDescriptor.SymbolicTraits.traitBold.rawValue) != 0 {
//                    descrip = descrip.withSymbolicTraits(.traitBold)!
                }

                if (traits.rawValue & UIFontDescriptor.SymbolicTraits.traitItalic.rawValue) != 0 {
                    descrip = descrip.withSymbolicTraits(.traitItalic)!
                }

                attr.addAttribute(.font, value:subReg!, range: range)
            }
        }

        self.init(attributedString: attr)
    }

}
