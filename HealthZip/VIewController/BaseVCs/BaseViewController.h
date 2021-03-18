//
//  BaseViewController.h
//  iDeals
//
//  Created by Pragnesh Dixit on 08/02/16.
//  Copyright © 2016 Pragnesh Dixit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITextField+CustomDesign.h"
#import "MBProgressHUD.h"
#import "UIAlertView+utils.h"
#import "AppDelegate.h"
#import "NSString+Extensions.h"
#import "MFSideMenu.h"
#import "Constants.h"
#import <MessageUI/MessageUI.h>
#import "UserDetail.h"

@interface BaseViewController : UIViewController
{
    MBProgressHUD *HUD;
    IBOutlet UIView *viewAccessory;
    __weak IBOutlet UIButton *btnDone;
    __weak IBOutlet UIButton *btnCancel;
    AppDelegate *appDelegate;
    
}
@property (weak, nonatomic) UITextField *txtFieldCheck;
@property (weak, nonatomic) IBOutlet UILabel *lblTitleTopBar;
@property (weak, nonatomic) IBOutlet UIButton *btnMenu;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIView *viewTopBar;

@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *spinner;

- (BOOL)isNetworkReachable:(NSString*)NetPath;
- (BOOL)isNetworkReachable;
- (void)showHud;
- (void)hidHud;
- (void)showSpinnerWithUserActionEnable:(BOOL)isEnable;
- (void)hideSpinner;
-(void)addCenterGesture:(BOOL)isAdd;
-(UIToolbar *)addDoneButtonToKeyBoard;

#pragma  mark - SET UILABEL TEXT WITH FONT AND STYLE -

-(NSMutableAttributedString *)applystringColor_FONT_STYLE:(NSString*)strMessage withWord:(NSString *)searchedString withFont:(UIFont*)font withTextAlignment:(NSTextAlignment)alignment;
-(NSMutableAttributedString *)applystringColor_Font_Style:(NSString*)strMessage withWord:(NSString *)searchedString withFont:(UIFont *)font color: (UIColor *)color;
#pragma mark - SET LABEL TEXT -
-(NSAttributedString*)setLabelText:(NSString *)strMessage withFontSize:(CGFloat)fontSize;



-(void)setButtonTextAlignmentCenter:(UIButton*)button;
- (void)btnShowLeftMenuAction:(id)sender;
- (IBAction)btnBackAction:(id)sender;

#pragma mark - UITextField Padding -

-(void)setPadding_BorderForTextField:(UITextField*)textField;
//-(void)setPadding_BorderForTextField:(UITextField*)textField andDownArrow:(BOOL)showArrow;

-(id)predicateOnArray:(NSMutableArray *)arrayData withPredicateFormateString:(NSString*)strPredicateFormate;
-(NSString*)setPriceWithCommaOperator:(NSString *)strPrice;

-(BOOL)checkIfUserIsLogin;
-(void)addTapGestureToView:(UIView*)view;
-(void)removeTapGestureToView:(UIView*)view;

-(NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding withString:(NSString*)strPath;
-(CGFloat)getDescriptionHeight:(NSString *)strDescription withLabelFrame:(CGRect)framelabel withFont:(UIFont *)font;

- (UIImage *)portraitImageForImage:(UIImage *)image;
- (NSString *) getCurrentTime;
-(void)getDateString:(NSString*)strSelectedDate;
-(NSDate *)appendTimeandDate:(NSString *)selectedDate;

//-------NEW ADDED BY PANKAJ-------//
-(void)showViewAnimation:(UIView *)view animationPos:(int)position isXpos:(BOOL)direction duratineTime:(float)Duration andDelay:(float)delay;
-(void)popUpAnimation:(UIView *)view;
-(void)setPlaceHolder:(NSString *)strPlaceholder forTextFiled:(UITextField *)textFiled withColor:(UIColor*)color;

-(void)showEmailAlert:(MFMailComposeViewController*)mailComposer objUserDetail :(UserDetail *) userDetail  completion :(void(^)(NSString *))okCompletion;
-(BOOL) NSStringIsValidEmail:(NSString *)checkString;
@end
