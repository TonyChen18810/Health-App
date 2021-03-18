//
//  MemberDetailVC.h
//  HealthZip
//
//  Created by Tristate on 6/1/16.
//  Copyright © 2016 Tristate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemberDetail.h"
#import "BaseViewController.h"
#import "UserDetail.h"
#import "PMCalendar.h"

@interface MemberDetailVC : BaseViewController<UITableViewDataSource,UITableViewDelegate,PMCalendarControllerDelegate>

{
    UserDetail *objUserDetail;
    NSMutableArray *arrayTestParameterList;
    
}
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UIImageView *imgUserProfile;
@property (nonatomic, strong) PMCalendarController *pmCC;

@property (weak, nonatomic) IBOutlet UILabel *lblTestName;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *arrayTextFields;
@property (weak, nonatomic) IBOutlet UITextField *txtLaboratoryName;
@property (weak, nonatomic) IBOutlet UITextField *txtDate;

@property (weak, nonatomic) IBOutlet UITextView *textViewNote;
@property (strong,nonatomic) MemberDetail *objMemberDetail;
@property (strong, nonatomic) IBOutlet UITableView *tblTestParameter;



- (IBAction)btnDoneClickAction:(id)sender;
- (IBAction)btnBackClickAction:(id)sender;


@end
