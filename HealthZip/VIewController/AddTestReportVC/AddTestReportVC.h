//
//  AddTestReportVC.h
//  HealthZip
//
//  Created by Tristate on 6/3/16.
//  Copyright © 2016 Tristate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "MemberDetail.h"
#import "UserDetail.h"
#import "MemberDetail.h"
#import "TestParameterCell.h"
#import "PMCalendar.h"
#import "AddNewTestVC.h"
#import "Webservice.h"

@protocol UpdateTestReport <NSObject>
@optional
-(void)isUpdateTestReport:(NSString *)userId;
@end

@interface AddTestReportVC : BaseViewController<UITableViewDataSource,UITableViewDelegate,AddTestParameterDelegate,PMCalendarControllerDelegate,UITextFieldDelegate,UITextViewDelegate,UpdateTestList>

{
    UserDetail *objUserDetail;
     NSMutableArray *arrayTestParameterList;
   
    NSInteger index;
    Webservice *webserviceObj;
}
@property (strong, nonatomic) NSMutableArray *arrayTestValue;
@property (strong, nonatomic) NSMutableDictionary *dictUpdate;
@property (strong, nonatomic) id <UpdateTestReport> delegate;
@property (strong, nonatomic) IBOutlet UIView *viewForHeader;

@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UIImageView *imgUserPic;
@property (strong,nonatomic) MemberDetail *objMemberDetail;
@property (strong, nonatomic) IBOutlet UITableView *tblTestParameter;

@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UIButton *btnAddTest;

- (IBAction)btnSubmitReportClickAction:(id)sender;
- (IBAction)btnBackClickAction:(id)sender;


- (IBAction)btnAddTestAction:(id)sender;

//----------------TEST PARAMETER POPUP -------------------//

@property (weak, nonatomic) IBOutlet UIView *viewForTestparameterBG;
@property (weak, nonatomic) IBOutlet UITextField *txtTestValue;

- (IBAction)btnAddClickAction:(id)sender;
- (IBAction)btnCancelClickAction:(id)sender;

//----------------END-------------------//

@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UIImageView *imgUserProfile;
@property (nonatomic, strong) PMCalendarController *pmCC;

@property (weak, nonatomic) IBOutlet UILabel *lblTestName;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *arrayTextFields;
@property (weak, nonatomic) IBOutlet UITextField *txtLaboratoryName;
@property (weak, nonatomic) IBOutlet UITextField *txtDate;
@property (weak, nonatomic) IBOutlet UITextView *textViewNote;


- (IBAction)btnDoneClickAction:(id)sender;



@end
