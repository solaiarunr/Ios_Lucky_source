//
//  Config.swift
//  Randoo
//
//  Created by HTS-Product on 31/01/19.
//  Copyright © 2019 Hitasoft. All rights reserved.

import Foundation

//MARK: APP NAME
//qwerty
//let APP_NAME = "iDemand"
let APP_NAME = "Lucki.app"
//qwerty
//iCloud.com.app.lucki
//736381350050-qb1tjc03nqe26c1e2okep4eesvai6a4n.apps.googleusercontent.com
//project-736381350050

//MARK: Default Language **************
let DEFAULT_LANGUAGE = "English" // default app language

//MARK: PUSH NOTIFICATION **************
let DEVICE_MODE = "1" //0-Development, 1-Production

//MARK: GIPHY key
let GIPHY_API_KEY = "or4yESJhLlDX0DHe65nAZxtYps4Ve5EM"
// qwerty
//MARK: GOOGLE
let GOOGLE_CLIENT_ID = "736381350050-qb1tjc03nqe26c1e2okep4eesvai6a4n.apps.googleusercontent.com"//"GOOGLE_CLIENT_ID"
let GOOGLE_API_KEY = "AIzaSyBGERF12brxOpO3himAYV0FpjZJS9GqV5g"
//"AIzaSyBGERF12brxOpO3himAYV0FpjZJS9GqV5g"//"GOOGLE_API_KEY"
//qwerty
//let GOOGLE_API_KEY = "AIzaSyCiFwC7B_BNQlynZw1Zyt3VWyKIVIAnHvo"
//let GOOGLE_API_KEY = "AIzaSyDtNUe5cqn8QR9Zidfz_fVFPa5jv0NYoyE"

let GOOGLE_URL = "https://maps.google.com/maps/api/geocode/json?sensor=false"

let BANNER_ID = "ca-app-pub-3940256099942544/2934735716"
let ADD_ON = false
// qwerty
//MARK: SERVER DETAILS
let SITE_URL = "https://appservices.hitasoft.in/lucki/"//"yoursiteurl.com/"

let SOCKET_URL = "https://appservices.hitasoft.in:8090"//"\(SITE_URL):8082"
let API_BASE_URL = "https://appservices.hitasoft.in:4001/api/v1/"//"\(SITE_URL):4000/api/v1/"
//qwerty
//let UPLOAD_BASE_URL = "\(SITE_URL)/idemand/api/v1/"
let UPLOAD_BASE_URL = "\(SITE_URL)api/v1/"


//Sub api
let CATEGORIES_API = "categories"
let SUB_CATEGORIES_API = "subcategories"
let SERVICES_API = "services"
let CONTACT_US_API  = "contactus"
let SEARCH_CATEGORIES_API = "searchcategories"
let REVIEWS_LIST_API = "reviews"

let APPDEFAULT_API = "appdefaults"
//USER
let USER_SIGNUP_API = "user/signup"
let USER_SIGNIN_API = "user/signin"
let USER_SOCIAL_SIGNIN_API = "user/socialsignin"
let USER_FORGOT_API = "user/forgotpassword"
let USER_PROFILE_API = "user/profile"
let USER_DEACTIVATE_API = "user/deactivateaccount"
let USER_LOGOUT_API = "user/signout"
let USER_HELP_API = "helps/user"
let USER_CONTACT_API = "user/contactus"
let USER_CHANGE_PASSWORD = "user/resetpassword"
let USER_PICTURE_UPLOAD = "user/profileupload"
let USER_HOME_API = "user/home"
let BOOK_SERVICE_API = "user/bookservice"
let HIRE_TASKER_API = "user/hiretaskers"
let BOOKING_DETAILS_API = "user/bookingdetails"
//qwerty
//let PAY_BOOKING_API = "user/paybooking"
let PAY_BOOKING_API = "user/stripesplitpaytest"

let USER_BOOKING_LIST_API = "user/bookings"
let VIEW_TASKER_API = "user/taskerprofile"
let PAY_REWARD_API = "user/payreward"
let POST_REVIEW_API = "user/postreview"
let USER_BOOKING_STATUS_API = "user/bookingstatus"
let ADD_NEED_API = "user/addneed"
let MY_NEEDS_API = "user/needs"
let USER_CHATS_API = "user/chats"
let USER_MESSAGE_API = "user/messages"
let USER_CHAT_UPLOAD_API = "user/chatupload"
let USER_NOTIFICATIONS_API = "user/notifications"
let USER_CHAT_INFO = "user/chatinfo"
let USER_CREATE_CHAT_ID = "user/createchat"
let USER_ADMIN_CHATS = "adminnotifications/user"
let USER_AUDIO_UPLOAD_API = "user/audioupload"
let GET_SUBCATEGORIES = "user/subcategories"
let GET_TASK_DETAILS = "user/taskdetail"


//TASKER
let TASKER_SIGNUP_API = "tasker/signup"
let TASKER_SIGNIN_API = "tasker/signin"
let TASKER_PROFILE_API = "tasker/profile" // profileupdate
let TASKER_FORGOT_API = "tasker/forgotpassword"
let TASKER_DEACTIVATE_API = "tasker/deactivateaccount"
let TASKER_LOGOUT_API = "tasker/signout"
let TASKER_HELP_API = "helps/tasker"
let TASKER_CONTACT_API = "tasker/contactus"
let TASKER_CHANGE_PASSWORD = "tasker/resetpassword"
let TASKER_PICTURE_UPLOAD = "tasker/profileupload"
let TASKER_DASHBOARD_API = "tasker/dashboard"
let MEDIA_UPLOAD_API = "tasker/mediaupload"
let GET_MEDIA_API = "tasker/media"
let DELETE_MEDIA_API = "tasker/deletemedia"
let ADD_SERVICES_API = "tasker/addservice"
let MY_SERVICES_API = "tasker/services"
let MY_SERVICE_CATEGORY_API = "tasker/servicecategories"
let DELETE_SERVICE_API = "tasker/deleteservice"
let TASKER_BOOKING_LIST_API = "tasker/bookings"
let TASKER_BOOKING_DETAILS_API = "tasker/bookingdetails"
let TASKER_BOOKING_STATUS_API = "tasker/bookingstatus"
let TASKER_BROWSE_NEEDS_API = "tasker/browseneeds"
let TASKER_CHATS_API = "tasker/chats"
let TASKER_MESSAGE_API = "tasker/messages"
let TASKER_CHAT_UPLOAD_API = "tasker/chatupload"
let TASKER_NOTIFICATIONS_API = "tasker/notifications"
let TASKER_CHAT_INFO = "tasker/chatinfo"
let TASKER_CREATE_CHAT_ID = "tasker/createchat"
let TASKER_ADMIN_CHATS = "adminnotifications/tasker"
let PAYMENT_DETAILS_API = "tasker/stripeurl"
let TASKER_AUDIO_UPLOAD_API = "tasker/audioupload"
let TASKER_SOCIAL_SIGNIN_API = "tasker/socialsignin"

let STRIPE_STATUS_API = "tasker/stripestatus"

let MAP_CONNECT_ACCOUNT_API = "tasker/mapconnectaccount"
// qwerty
let STRIPE_URL = "https://connect.stripe.com/express/oauth/authorize?redirect_uri=\(SITE_URL)/&client_id="

let BALLENCE_SHEET_URL = "user/createpaymentintent"

//AddONs
let MOBILE_LOGIN_URL = "user/mobilelogin"
let TASKER_MOBILE_LOGIN_URL = "tasker/mobilelogin"


//modified-AR
let GET_TASKER = "tasker/getTasker"
let GET_TASK = "tasker/browseneeds"
