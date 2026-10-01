//
//  Constant.swift
//  Randoo
//
//  Created by HTS-Product on 31/01/19.
//  Copyright © 2019 Hitasoft. All rights reserved.
//

import Foundation
import UIKit

//MARK: Size configuration
let FULL_WIDTH = UIScreen.main.bounds.width
let FULL_HEIGHT = UIScreen.main.bounds.height

//MARK: Device Models
let IS_IPHONE_X = UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height >= 2436
let IS_IPHONE_PLUS = UIDevice().userInterfaceIdiom == .phone && (UIScreen.main.nativeBounds.height == 2208 || UIScreen.main.nativeBounds.height == 1920)
let IS_IPHONE_678 = UIDevice().userInterfaceIdiom == .phone && (UIScreen.main.nativeBounds.height == 1334)
let IS_IPHONE_5 = UIDevice().userInterfaceIdiom == .phone && (UIScreen.main.nativeBounds.height == 1136)

//MARK: Color
let PRIMARY_COLOR = UIColor.init(named: "primary")
let SECONDARY_COLOR = UIColor.init(named: "secondary")

//other colors
let SENDER_BG = UIColor.init(named: "sender_bg")
let SENDER_INNER_BG = UIColor.init(named: "sender_inner_bg")
let RECEIVER_BG = UIColor.init(named: "receiver_bg")
let RECEIVER_INNER_BG = UIColor.init(named: "receiver_inner_bg")
let RATING_GREEN = UIColor.init(named: "rating_green")
let TEXT_BLACK_COLOR = UIColor.init(named: "TextBlack")
let TEXT_WHITE_COLOR = UIColor.init(named: "TextWhite")
let TEXT_LITE_COLOR  = UIColor.init(named: "TextGray")
let LINE_COLOR = UIColor.init(named: "line_color")
let SEARCH_BG_COLOR  = UIColor.init(named: "searchBg")
let BACKGROUND_COLOR = UIColor.init(named: "background_color")!
let POPUP_COLOR = UIColor.init(named: "popup_color")!

//MARK: Config Font
let APP_FONT_BOLD = "Averta-Bold"
let APP_FONT_ITALIC = "AvertaDemo-ExtraBoldItalic"
let APP_FONT_REGULAR = "AvertaDemo-Regular"

//MARK: Font sizes
let highBold = UIFont.init(name: APP_FONT_BOLD, size: 32)
let headBold = UIFont.init(name: APP_FONT_BOLD, size: 18)
let subBold = UIFont.init(name: APP_FONT_BOLD, size: 16)
let smallBold = UIFont.init(name: APP_FONT_BOLD, size: 14)
let normalBold = UIFont.init(name: APP_FONT_BOLD, size: 12)

let headReg = UIFont.init(name: APP_FONT_REGULAR, size: 18)
let subReg = UIFont.init(name: APP_FONT_REGULAR, size: 16)
let smallReg = UIFont.init(name: APP_FONT_REGULAR, size: 14)
let normalReg = UIFont.init(name: APP_FONT_REGULAR, size: 12)
let liteReg = UIFont.init(name: APP_FONT_REGULAR, size: 10)

let RISTRICTED_CHARACTERS = "'*=+[]\\|;:'\",<>/?%!@#$^&(){}[].~-_£€₹"
let USERNAME_CHARACTERS = "'*=+[]\\|;:'\",<>/?%!@#$^&(){}[].~-_£€₹"
