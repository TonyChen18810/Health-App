//
//  AddMemberVC.h
//  HealthZip
//
//  Created by Tristate on 5/31/16.
//  Copyright © 2016 Tristate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "UserDetail.h"
#import "MemberDetail.h"

@protocol UpdateMember <NSObject>
@optional
-(void)isUpdateMember;
@end
@interface AddMemberVC : BaseViewController<UIScrollViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>

{
    UserDetail *objUserDetail;
    NSData *userImageData;
}

//-------------PROPERTY AND METHODS FOR ADD MEMBER--------------//
@property (strong, nonatomic) id <UpdateMember> delegate;
@property (strong, nonatomic) MemberDetail *objMemberDetail;

@property (weak, nonatomic) IBOutlet UIImageView *imgProfilePic;
@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txtLastName;
@property (nonatomic) BOOL isEdit;
@property (nonatomic) BOOL isMainUser;

@property (weak, nonatomic) IBOutlet UIImageView *ivBtnBg;
@property (weak, nonatomic) IBOutlet UIButton *btnCameraIcon;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)btnImageSlectClickAction:(id)sender;
- (IBAction)btnCloseClickAction:(id)sender;

//---------------------------END-------------------------------//


//-------------PROPERTY AND METHODS FOR EDIT MEMBER--------------//

@property (weak, nonatomic) IBOutlet UIView *viewForEditButtons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpaceOfViewEdit;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;

@property void (^callListAPI)(bool);

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *arrayButtons;
- (IBAction)btnEditSaveClickAction:(id)sender;
//---------------------------END-------------------------------//





@end
