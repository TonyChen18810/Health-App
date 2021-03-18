//
//  AddNewTestVC.h
//  OneTrackHealth
//
//  Created by Pragnesh Dixit on 19/09/16.
//  Copyright © 2016 Tristate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "MemberDetail.h"
#import "UserDetail.h"

@protocol UpdateTestList <NSObject>
@optional
-(void)isUpdateTestListListTable;
@end

@protocol UpdateTestListData <NSObject>
@optional
-(void)addNewTest:(NSString *)userId;
@end

@interface AddNewTestVC : BaseViewController
{
     UserDetail *objUserDetail;
}
@property (strong,nonatomic) MemberDetail *objMemberDetail;
@property (strong, nonatomic) id <UpdateTestListData> delegate;
@property (strong, nonatomic) NSString *strUserId;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbarView;

@property (weak, nonatomic) IBOutlet UITextField *txtTestName;
@property (weak, nonatomic) IBOutlet UITextField *txtMinRatio;
@property (weak, nonatomic) IBOutlet UITextField *txtMaxRatio;
@property (weak, nonatomic) IBOutlet UITextField *txtUnit;
@property (weak, nonatomic) IBOutlet UITextView *txttestDescription;

- (IBAction)btnDoneTextViewAction:(id)sender;
- (IBAction)btnSaveAction:(id)sender;
- (IBAction)btnBackAction:(id)sender;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *arrViewBorder;

@end
