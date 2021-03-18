//
//  Constants.h
//  HelthZip
//
//  Created by Tristate on 5/30/16.
//  Copyright © 2016 Tristate. All rights reserved.
//

#ifndef Constants_h
#define Constants_h


#endif /* Constants_h */

#define APPNAME @"One Track Health"


//   WEBSERVICE URL PATH FOR DATA AND IMAGES  
#pragma mark - WEBSERVICE URL PATH FOR DATA AND IMAGES -
//   WEBSERVICE URL PATH FOR DATA AND IMAGES  


#define WEBSERVICE_URL_ENCRYPTED @"https://1trackhealth.org/healthapp/webservice/main.php"//@"http://35.167.194.150/healthapp/webservice/main.php"
#define WEBSERVICE_CIPHER_KEY @"hojr3a2oI55a24iidGUkhYSUl818pJ3g"

//Live URL :-
#define WEBSERVICE_URL @"https://1trackhealth.org/healthapp/webservice/main.php"//@"http://35.167.194.150/healthapp/webservice/main.php"
#define URL_IMGS @"https://1trackhealth.org/healthapp/admin_panel/"

//   NSUserDefaults NAME  
#pragma mark - NSUserDefaults NAME -
//   NSUserDefaults NAME  

#define USERDEFAULTS [NSUserDefaults standardUserDefaults]
#define USERDEFAULT_DEVICE_TOKEN @"Device_Token"
#define IsLogin @"isLogin"


//   KEY NAME  
#pragma mark - KEY NAME -
//   KEY NAME  

#define IS_ARABIC           @"IS_ARABIC"
#define LISTING_PAGE        @"LISTING_PAGE"
#define IS_LISTING_PAGE     @"IS_LISTING_PAGE"
#define IS_LOCATION_SERVICE @"IS_LOCATION_SERVICE"

//   NOTIFICATION NAME  
#pragma mark - NOTIFICATION NAME -
//   NOTIFICATION NAME  

#define NOTIFICATION_MENUOPTIONSELECT   @"MENUOPTIONSELECT"
#define NOTIFICATION_CHANGE_LANGUAGE    @"CHANGE_LANGUAGE"
#define NOTIFICATION_SETUPMENUGUI       @"SETUPMENUGUI"
#define NOTIFICATION_LOADSEARCHDATA     @"LOADSEARCHDATA"
//Added By pankaj
#define NOTIFICATION_LOADSEARCHDATAFORRENT     @"LOADSEARCHDATAFORRENT"


#define NOTIFICATION_UPDATEADDRESSFIELD @"UPDATEADDRESSFIELD"
//   Safe String Function  
#pragma mark - SAFESTRING Function -
//   Safe String Function  


#define SAFESTRING(str) ISVALIDSTRING(str) ? str : @""
#define ISVALIDSTRING(str) (str != nil && [str isKindOfClass:[NSNull class]] == NO)
#define VALIDSTRING_PREDICATE [NSPredicate predicateWithBlock:^(id evaluatedObject, NSDictionary *bindings) {return (BOOL)ISVALIDSTRING(evaluatedObject);}]

//   UIDEVICE RESOLUTIONS  
#pragma mark - UIDEVICE RESOLUTIONS -
//   UIDEVICE RESOLUTIONS  


#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))
#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH <= 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6_OR_HIGHER (IS_IPHONE && SCREEN_MAX_LENGTH > 568.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

//   STORYBOARD NAME  
#pragma mark - STORYBOARD NAME -
//   STORYBOARD NAME  

#define MAIN_STORYBOARD_INIT [UIStoryboard storyboardWithName:@"Main" bundle:nil]
#define STORYBOARD1_INIT [UIStoryboard storyboardWithName:@"Storyboard1" bundle:nil]
#define STORYBOARD2_INIT [UIStoryboard storyboardWithName:@"Storyboard2" bundle:nil]
#define STORYBOARD3_INIT [UIStoryboard storyboardWithName:@"Storyboard3" bundle:nil]
//   FONT NAME  
#pragma mark - FONT NAME -
//   FONT NAME  



#define FONT_ITCAVANTGARDESTD_BK       @"ITCAvantGardeStd-Bk"
#define FONT_ITCAVANTGARDESTD_MD         @"ITCAvantGardeStd-Md"
#define FONT_ITCAVANTGARDESTD_DEMI        @"ITCAvantGardeStd-Demi"

//Added BY PANKAJ
#define FONTSIZE_ENGLISH_SMALL 13
#define FONTSIZE_ARABIC_SMALL 15

#define LOCALIZED(str) NSLocalizedString(str, nil)
#define LOCALIZED_NOT_NULL(str) NSLocalizedString(str, @"")



//   COLOR CODE  
#pragma mark - COLOR CODE -
//   COLOR CODE  

#define COLORCODE_GREEN  [UIColor colorWithRed:82.0/255.0 green:188.0/255.0 blue:80.0/255.0 alpha:1]

#define COLORCODE_RED  [UIColor colorWithRed:228.0/255.0 green:85.0/255.0 blue:61.0/255.0 alpha:1]

#define COLORCODE_LIGHT_GRAY  [UIColor colorWithRed:244.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:1]

#define COLORCODE_TEXT_BLACK  [UIColor colorWithRed:32.0/255.0 green:35.0/255.0 blue:41.0/255.0 alpha:1]

#define COLORCODE_TEXT_LIGHT_GRAY  [UIColor colorWithRed:106.0/255.0 green:110.0/255.0 blue:117.0/255.0 alpha:1]

#define COLORCODE_RED_BUTTON [UIColor colorWithRed:247.0/255.0 green:119.0/255.0 blue:118.0/255.0 alpha:1]

#define COLORCODE_BLUE_BUTTON [UIColor colorWithRed:53.0/255.0 green:91.0/255.0 blue:183.0/255.0 alpha:1]

#define COLORCODE_HEADER_YELLOW [UIColor colorWithRed:253.0/255.0 green:132.0/255.0 blue:20.0/255.0 alpha:1.0]

//   UIIMAGE's NAME  
#pragma mark - UIIMAGE's NAME -
//   UIIMAGE's NAME  
#define IMG_EDIT_ICON @"img_edit_btn.png"
#define IMG_CAMERA_ICON @"img_camera_bt.png"


#define IMG_DOWN_ARROW_RIGHT @"img_down_arrow_right"
#define IMG_CALENDER_ICON @"img_calender_icon"
#define IMG_USER_PROFILE @"img_user_icon"



#define IMG_USER_PROFILE_WHITE @"img_user_profile_white"



// 

#pragma mark -  STATIC STRINGS AND ALERT's MESSAGES  -
//

#define STR_ASTERISK    @"//*"

//   STATIC STRINGS  
#pragma mark - STATIC STRINGS By APPDELEGATE ACTION -
//   STATIC STRINGS  



//   ALERT's MESSAGES  
#pragma mark - ALERT's MESSAGES -
//   ALERT's MESSAGES  
#define ALERT_FirstName_Required @"Please enter the firstname."
#define ALERT_LastName_Required @"Please enter the lastname."
#define ALERT_Password_Required @"Please enter the password."
#define ALERT_Password_too_small @"Please enter minimum six digit of password."
#define ALERT_Confirm_Password_Mismatch @"confirm password mismatch."
#define ALERT_EmailId_required @"Email id is required."
#define ALERT_Invalid_EmailId @"Invalid email id."
#define ALERT_Contact_No_required @"Contact no is required."
#define ALERT_NO_INTERNET   @"No internet connection is available."
#define ALERT_TEST_VALUE_REQUIRED   @"Please enter test value."
#define ALERT_SELECT_DATE @"Please select date."
#define ALERT_LAB_NAME_REQUIRED @"Please enter laboratory name."
#define ALERT_NO_REPORT_FOUND @"There is no report available."
#define ALERT_REMOVE_USER @"Are you sure you want to remove this user?"
#define ALERT_LOGOUT @"Are you sure you want to logout?"

#define ALERT_PRIVACY_POLICY @"Please agree privacy policy then try to login in the application."
#define ALERT_PRIVACY_POLICY_SIGNUP @"Please agree privacy policy then try to signup in the application."

