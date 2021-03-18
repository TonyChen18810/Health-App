//
//  RegisterVC.h
//  HealthZip
//
//  Created by Tristate on 5/30/16.
//  Copyright © 2016 Tristate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "UserDetail.h"

@interface RegisterVC : BaseViewController<UITextFieldDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIScrollViewDelegate>
{
    UserDetail *objUserDetail;
    NSData *userImageData;
    NSString *strUserImageName;
}
@property (weak, nonatomic) IBOutlet UIImageView *imgProfilePic;

@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *arrayTextFields;

@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;

@property (weak, nonatomic) IBOutlet UITextField *txtLastName;

@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtConfPassword;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightViewContainer;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpaceSignupButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpaceCheckbutton;
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *arrayTopSpace;
@property (weak, nonatomic) IBOutlet UILabel *lblPricacyPolicy;
@property (weak, nonatomic) IBOutlet UIButton *btnIagree;

@property (weak, nonatomic) IBOutlet UIImageView *ivBtnBg;

- (IBAction)btnIagreeAction:(id)sender;
- (IBAction)btnPrivacyPolicyAction:(id)sender;
- (IBAction)btnImageSlectClickAction:(id)sender;
- (IBAction)btnSignInClickAction:(id)sender;
- (IBAction)btnSIgnUpClickAction:(id)sender;

@end
