//
//  HomeVC.h
//  HelthZip
//
//  Created by Tristate on 5/30/16.
//  Copyright © 2016 Tristate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserDetail.h"
#import "BaseViewController.h"
#import "MBCircularProgressBarView.h"
#import "LTInfiniteScrollView.h"
#import <MessageUI/MessageUI.h>
#import "AddMemberVC.h"
#import "AddTestReportVC.h"
#import "MemberDetail.h"
@interface HomeVC : BaseViewController<PMCalendarControllerDelegate,LTInfiniteScrollViewDelegate,LTInfiniteScrollViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate,MFMailComposeViewControllerDelegate,UpdateMember,UpdateTestReport, UIScrollViewDelegate,UpdateTestListData>

{
    UserDetail *objUserDetail;
    double fromTimeInterval,toTimeInterval;
    BOOL isFromDate;
    NSMutableArray *arrayMemberData;
    NSMutableArray *arrayUserTestReport;
    NSInteger iCurrentUserIndex;
    int viewStap;
 
}
@property (nonatomic, strong) NSMutableArray *arrAllData; //For All Test Value
@property (nonatomic, strong) NSMutableArray *arrayTestValue;
@property (nonatomic, strong) NSMutableArray *arrayUserTestReportTemp;
@property (nonatomic, strong) NSDictionary *singleItems; // indexPath -> RWBarChartItem
@property (nonatomic, strong) NSArray *itemCounts;
@property (nonatomic, strong) NSIndexPath *indexPathToScroll;
@property (strong,nonatomic) MemberDetail *objMemberDetail;

@property (strong, nonatomic) IBOutlet LTInfiniteScrollView *viewMember;
@property (nonatomic) CGFloat viewSize;
@property (nonatomic) int numberOfVisibleUser;
@property (weak, nonatomic) IBOutlet UITextField_CustomDesign *txtTestSelect;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UICollectionView *CVGraph;
@property (weak, nonatomic) IBOutlet UIView *viewScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightScrollview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightHeaderview;

@property (strong, nonatomic) NSMutableArray *arrayOfimages;
@property (strong, nonatomic) IBOutlet UITableView *tblTestOption;
@property (weak, nonatomic) IBOutlet UIButton *btnForHideTable;
@property (weak, nonatomic) IBOutlet UIButton *btnMenu;
@property (weak, nonatomic) IBOutlet UIButton *btnEditReportList;
@property (weak, nonatomic) IBOutlet UIButton *btnAddResult;
@property (weak, nonatomic) IBOutlet UIButton *btnDisplayMenu;
@property (weak, nonatomic) IBOutlet UIView *viewDisplayMenu;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conHightBtnEdit;

@property (nonatomic, strong) PMCalendarController *pmCC;
@property (weak, nonatomic) IBOutlet UITextField *txtFromDate;
@property (weak, nonatomic) IBOutlet UITextField *txtToDate;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *arrayTextFields;


typedef NS_ENUM(NSInteger, TestColor) {
    BLUE,
    RED,
    GREEN,
};


//------ALL ACTIONS METHODS-----//
- (IBAction)btnTestReportClickAction:(id)sender;
- (IBAction)btnLogOutClickAction:(id)sender;
- (IBAction)btnAddMenberClickAction:(id)sender;
- (IBAction)btnTabButtonClickAction:(id)sender;
- (IBAction)btnDropDownClickAction:(id)sender;
- (IBAction)btnHidetableClickAction:(id)sender;
- (IBAction)btnFeedbackAction:(id)sender;
- (IBAction)btnPrivacyPolicyAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnEditProfile;
- (IBAction)btnEditReportListAction:(id)sender;
- (IBAction)btnDisplayMenuAction:(id)sender;
- (IBAction)btnAddNewTestAction:(id)sender;

//--------------END--------------//

@property (weak, nonatomic) IBOutlet UIView *viewStap1;
@property (weak, nonatomic) IBOutlet UIView *viewStap2;
@property (weak, nonatomic) IBOutlet UIView *viewStap3;
@property (weak, nonatomic) IBOutlet UIView *viewStap4;
@property (weak, nonatomic) IBOutlet UIView *viewStap5;
@property (weak, nonatomic) IBOutlet UIView *viewStap6;
@property (weak, nonatomic) IBOutlet UIView *viewStap7;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conStep1Top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conStep2Top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conStep3Top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conStep4Top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conStep5Top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conStep6Top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conStep4Left;
@property (weak, nonatomic) IBOutlet UIView *viewIntro;
@property (weak, nonatomic) IBOutlet UIView *viewIntroBackGround;
@property (weak, nonatomic) IBOutlet UIButton *btnGotIt;
- (IBAction)btnGotItAction:(id)sender;
- (IBAction)btnCloseIntroView:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conGotItY;

@end
