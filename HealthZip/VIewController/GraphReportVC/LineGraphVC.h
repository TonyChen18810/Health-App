//
//  LineGraphVC.h
//  OneTrackHealth
//
//  Created by Pragnesh Dixit on 11/07/17.
//  Copyright © 2017 Tristate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSLineChart.h"
#import "UserDetail.h"
#import "BaseViewController.h"
#import "PMCalendar.h"
#import "TestReportDetail.h"
#import <MessageUI/MessageUI.h>
#import "MemberDetail.h"
@interface LineGraphVC : BaseViewController<PMCalendarControllerDelegate,MFMailComposeViewControllerDelegate>
{
    UserDetail *objUserDetail;
    double fromTimeInterval,toTimeInterval;
    BOOL isFromDate;
    NSMutableArray *bufferArray;
    NSMutableArray *arrayMonths;
    NSString *newCSVName;
    NSString *oldCSVName;
}

@property double fromTimeInterval;
@property double toTimeInterval;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UIImageView *imgUserProfile;
@property (weak, nonatomic) IBOutlet UITextField *txtFromDate;
@property (weak, nonatomic) IBOutlet FSLineChart *lineChart;
@property (nonatomic, strong) PMCalendarController *pmCC;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewChart;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightChat;
@property (strong, nonatomic) TestReportDetail *objTestReport;
@property (strong, nonatomic) TestReportDetail *objTestReportTemp;
@property (strong, nonatomic) MemberDetail *objMemberDetail;
@property (nonatomic) BOOL isMainUser;

@property (weak, nonatomic) IBOutlet UIView *viewScreenshort;
@property (weak, nonatomic) IBOutlet UIButton *btnReset;
- (IBAction)btnResetAction:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *txtToDate;
@property (weak, nonatomic) IBOutlet UILabel *lblGraphName;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *arrayTextFields;

- (IBAction)btnExportEmailClickAction:(id)sender;
- (IBAction)btnBackClickAction:(id)sender;
@end
