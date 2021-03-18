//
//  GraphReportVC.h
//  HealthZip
//
//  Created by Tristate on 6/14/16.
//  Copyright © 2016 Tristate. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UserDetail.h"
#import "BaseViewController.h"
#import "PMCalendar.h"
#import "TestReportDetail.h"
#import <MessageUI/MessageUI.h>
#import "MemberDetail.h"
#import "GraphView.h"

@interface GraphReportVC : BaseViewController<PMCalendarControllerDelegate,MFMailComposeViewControllerDelegate>

{
    UserDetail *objUserDetail;
    double fromTimeInterval,toTimeInterval;
    BOOL isFromDate;
    NSMutableArray *bufferArray;
    NSMutableArray *arrayMonths;
    NSString *newCSVName;
    NSString *oldCSVName;
    GraphView *graphData;
    int viewStap;
}

@property (weak, nonatomic) IBOutlet UILabel *lblUnitDisplay;
@property (weak, nonatomic) IBOutlet UILabel *lblGreen;

@property (weak, nonatomic) IBOutlet GraphView *chartView;

@property (weak, nonatomic) IBOutlet UIView *viewScreenshort;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
- (IBAction)btnLineGraphVCAction:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet UIButton *btnEmailExport;
- (IBAction)btnNextAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnPrivous;
- (IBAction)btnPrivousAction:(id)sender;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conHeightChart;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conWidthNoteView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conHeightSwipeView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conTopChart;




@property (nonatomic, strong) UIColor *tempColor;
@property (weak, nonatomic) IBOutlet UIButton *btnReset;
- (IBAction)btnResetAction:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UIImageView *imgUserProfile;
@property (weak, nonatomic) IBOutlet UITextField *txtFromDate;
@property (weak, nonatomic) IBOutlet UIView *viewSwipe;

@property (weak, nonatomic) IBOutlet UILabel *lblNodatafound;
@property (nonatomic, strong) PMCalendarController *pmCC;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewChart;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightChat;
@property (strong, nonatomic) TestReportDetail *objTestReport;
@property (strong, nonatomic) MemberDetail *objMemberDetail;
@property (nonatomic) BOOL isMainUser;
@property (nonatomic) long selectIndex;
@property (strong, nonatomic) NSMutableArray *arrayUserTestReport;
@property (strong, nonatomic) NSMutableArray *arrayUserTestReportTemp;
@property (strong, nonatomic) NSMutableArray *arrTestValueTemp;
@property (weak, nonatomic) IBOutlet UITextField *txtToDate;
@property (weak, nonatomic) IBOutlet UILabel *lblGraphName;

@property (strong, nonatomic) NSMutableArray *arrReportFilterData;
@property (strong, nonatomic) NSMutableArray *arrayUserAllReports;


@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *arrayTextFields;

- (IBAction)btnExportEmailClickAction:(id)sender;
- (IBAction)btnBackClickAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *viewStap7;
@property (weak, nonatomic) IBOutlet UIView *viewStap8;
@property (weak, nonatomic) IBOutlet UIView *viewStap9;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conStep9Top;
@property (weak, nonatomic) IBOutlet UIView *viewIntro;
@property (weak, nonatomic) IBOutlet UIButton *btnGotIt;
- (IBAction)btnGotItAction:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conGotItY;
@end
