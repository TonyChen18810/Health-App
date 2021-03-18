//
//  LoginVC.h
//  HelthZip
//
//  Created by Tristate on 5/30/16.
//  Copyright © 2016 Tristate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "UserDetail.h"
#import <QuartzCore/QuartzCore.h>
#import "UIButtonCustom.h"

@interface LoginVC : BaseViewController<UITextFieldDelegate,UICollisionBehaviorDelegate>

{
    UserDetail *objUserDetail;
}
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *arrayViewBorder;
@property (weak, nonatomic) IBOutlet UIView *viewPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIView *viewLoginButton;

@property (weak, nonatomic) IBOutlet UIView *viewBGForgetPassword;
@property (weak, nonatomic) IBOutlet UIView *viewForgetPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtForgetPasswordEmail;
@property (weak, nonatomic) IBOutlet UIImageView *imgSeparator;
@property (weak, nonatomic) IBOutlet UIButton *btnForgetPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtUsenrName;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UIView *viewUsername;
@property (weak, nonatomic) IBOutlet UILabel *lblPricacyPolicy;
@property (weak, nonatomic) IBOutlet UIButton *btnIagree;
- (IBAction)btnIagreeAction:(id)sender;

- (IBAction)btnPrivacyPolicyAction:(id)sender;

@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (weak, nonatomic) IBOutlet UIImageView *imgLogo;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UIButtonCustom *btnForgetPasswordSubmit;

@property (weak, nonatomic) IBOutlet UIButtonCustom *btnForgetPasswordCancel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conTopLogo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conTopIv;

@property (nonatomic) CGRect frameLogo;
@property (nonatomic) CGRect frameName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpaceLoginButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpaceLogingView;


- (IBAction)btnLoginClickAction:(id)sender;
- (IBAction)btnSignUpClickAction:(id)sender;
- (IBAction)btnForgetPasswordClickAction:(id)sender;
- (IBAction)btnCancelClickAction:(id)sender;
- (IBAction)btnForgetPasswordSubmitClickAction:(id)sender;

@end
