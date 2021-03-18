//
//  HomeVC.m
//  HelthZip
//
//  Created by Tristate on 5/30/16.
//  Copyright © 2016 Tristate. All rights reserved.
//

#import "HomeVC.h"

#import "Webservice.h"
#import "MemberDetail.h"
#import "LoginVC.h"
#import "MemberCVCell.h"
#import "MemberDetailVC.h"
#import "UIImageView+WebCache.h"
#import <Crashlytics/Crashlytics.h>
#import "TestGraphCell.h"
#import "HealthBlogVC.h"
#import "GraphReportVC.h"
#import "OtherTestVC.h"
#import "TestReportDetail.h"
#import "TestOptionCell.h"
#import "PrivacyPolicyVC.h"
#import "EditReportListVC.h"

@interface HomeVC ()

@end

@implementation HomeVC
@synthesize numberOfVisibleUser,txtTestSelect,CVGraph,arrayOfimages,tblTestOption,txtFromDate,txtToDate;
@synthesize btnMenu,objMemberDetail,arrayTextFields;
#pragma mark - VIEW LIFECYCLE METHODS -

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"> > > > > > > > > > > >%@ > > > > > > > > >",NSStringFromClass([self class]));
    // Do any additional setup after loading the view.
    _btnEditProfile.alpha=0.0;
    _viewDisplayMenu.hidden=YES;
    [CVGraph registerNib:[UINib nibWithNibName:@"TestGraphCell" bundle:nil] forCellWithReuseIdentifier:@"TestGraphCell"];
    [tblTestOption registerNib:[UINib nibWithNibName:@"TestOptionCell" bundle:nil] forCellReuseIdentifier:@"TestOptionCell"];
    [self.CVGraph registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    arrayMemberData =[[NSMutableArray alloc] init];
    //    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideTable)];
    //    [self.view addGestureRecognizer:tapGesture];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(menuStateEventOccurred:)
                                                 name:MFSideMenuStateNotificationEvent
                                               object:nil];
    
    [self setUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    objUserDetail=[UserDetail sharedInstance];
    objUserDetail=[objUserDetail getDetail];
    self.btnForHideTable.hidden=YES;
    
    NSString *updateDashboard = [USERDEFAULTS valueForKey:@"DASHBOARD"];
    
    
    NSLog(@"\nUpdate DashBoard Key is %@ \n",updateDashboard);
    
    if ([updateDashboard isEqualToString:@"1"]) {
        [self callGetMemberWebservice];
        self.lblUserName.text=objUserDetail.str_first_name;
        
        arrayUserTestReport = [[NSMutableArray alloc] init];
        self.arrayUserTestReportTemp = [[NSMutableArray alloc] init];
        iCurrentUserIndex = 0;
        [self getUserTestReport:objUserDetail.str_user_id];
    }
    txtTestSelect.text =@"Kidney";
}

-(void)isUpdateMember{
    [self callGetMemberWebservice];
    self.lblUserName.text=objUserDetail.str_first_name;
    arrayUserTestReport = [[NSMutableArray alloc] init];
    [self getUserTestReport:objUserDetail.str_user_id];
}
-(void)isUpdateTestReport:(NSString *)userId{
    [self getUserTestReport:userId];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)menuStateEventOccurred:(NSNotification *)notification {
    
    MFSideMenuStateEvent event = [[[notification userInfo] objectForKey:@"eventType"] integerValue];
    // MFSideMenuContainerViewController *containerViewController = notification.object;
    // ...
    if (event == 1) {
        
        btnMenu.selected=YES;
    }else{
        btnMenu.selected=NO;
        
    }
}
#pragma mark - SETUI METHOD-

-(void)setUI
{
    tblTestOption.layer.borderWidth = 1.0;
    tblTestOption.layer.cornerRadius = 3.0;
    tblTestOption.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //tblTestOption.tableFooterView = [UIView new];
    [self setPadding_BorderForTextField:txtTestSelect];
    if (IS_IPHONE_4_OR_LESS) {
        self.conStep1Top.constant = 20;
        self.conStep2Top.constant = 5;
        self.conStep3Top.constant = -10;
        self.conStep4Top.constant = 35;
        self.conStep4Left.constant = 5;
        self.conStep5Top.constant = 40;
        self.conStep6Top.constant = 40;
        
    }else if (IS_IPHONE_6) {
        self.conStep1Top.constant = 35;
        self.conStep2Top.constant = 22;
        self.conStep3Top.constant = 10;
        self.conStep4Top.constant = 105;
        self.conStep4Left.constant = 45;
        self.conStep5Top.constant = 100;
        self.conStep6Top.constant = 60;
        
    } else if (IS_IPHONE_6P) {
        self.conStep1Top.constant = 35;
        self.conStep2Top.constant = 40;
        self.conStep3Top.constant = 20;
        self.conStep4Top.constant = 135;
        self.conStep4Left.constant = 65;
        self.conStep5Top.constant = 100;
        self.conStep6Top.constant = 70;
        
    }
    self.btnGotIt.layer.cornerRadius = 5;
    //     self.btnGotIt.hidden = YES;
    self.btnGotIt.alpha = 0.0;
    [self fadeIn:self.viewStap1 withDuration:0.5 andWait:1.0];
    viewStap = 0;
    self.btnGotIt.layer.borderWidth = 1;
    self.btnGotIt.layer.borderColor = [UIColor whiteColor].CGColor;
    self.viewStap7.layer.cornerRadius = 5;
    
    NSString *startUpView=[[NSUserDefaults standardUserDefaults] objectForKey:@"IntroductionScreen1"];
    
    objUserDetail=[UserDetail sharedInstance];
    objUserDetail=[objUserDetail getDetail];
    
    
    if ([objUserDetail.str_tutorial_status isEqualToString:@"0"] || [objUserDetail.str_tutorial_status isEqualToString:@""]) {
        self.viewIntro.hidden = NO;
        self.viewIntroBackGround.hidden = NO;
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"IntroductionScreen1"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self addCenterGesture:NO];
        [self callAPIForTutorial];
    }else{
        self.viewIntro.hidden = YES;
        self.viewIntroBackGround.hidden = YES;
        [self addCenterGesture:YES];
    }
    
    for (UITextField *textField in arrayTextFields) {
        
        //textField.layer.borderColor = COLORCODE_LIGHT_GRAY.CGColor;
        textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
        textField.layer.borderWidth = 1.0;
        textField.layer.cornerRadius = 3.0;
        textField.layer.masksToBounds = true;
        
        UIImageView *paddingView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        paddingView.image =[UIImage imageNamed:IMG_CALENDER_ICON];
        textField.leftView = paddingView;
        textField.leftViewMode = UITextFieldViewModeAlways;
    }
    
}

-(void)callAPIForTutorial{
    if ([self isNetworkReachable]) {
        [self showSpinnerWithUserActionEnable:false];
        Webservice *webserviceObj = [[Webservice alloc]init];
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:@"1" forKey:@"tutorial_status"];
        [dictParam setObject:SAFESTRING([objUserDetail.str_user_id trimSpaces]) forKey:@"user_id"];
        
        [webserviceObj callJSONMethod:@"user_tutorial_status" withParameters:dictParam  isEncrpyted:NO  onSuccessfulResponse:^(NSMutableDictionary *dict) {
            [self hideSpinner];
            self->objUserDetail.str_tutorial_status = @"1";
            [self->objUserDetail saveDetail:self->objUserDetail];
        } onFailure:^(NSError *error) {
            //Error
            [UIAlertController infoAlertWithMessage:[error localizedDescription] andTitle:APPNAME controller:self];
            [self hideSpinner];
        }];
    }else {
        [UIAlertController infoAlertWithMessage:ALERT_NO_INTERNET andTitle:APPNAME controller:self];
    }
}


#pragma mark - SET MEMBERVIEW DATA METHOD -

-(void)setMemberData
{
    [arrayMemberData insertObject:objUserDetail atIndex:0];
    arrayOfimages = [[NSMutableArray alloc] initWithCapacity:arrayMemberData.count];
    
    for (NSInteger i = 0; i < arrayMemberData.count; ++i)
    {
        [arrayOfimages addObject:[NSNull null]];
    }
    
    [[self.viewMember subviews]
     makeObjectsPerformSelector:@selector(removeFromSuperview)];
    numberOfVisibleUser = 5;
    
    self.viewMember = [[LTInfiniteScrollView alloc] initWithFrame:CGRectMake(0, 63, CGRectGetWidth(self.view.bounds), 80)];
    [self.viewScrollView addSubview:self.viewMember];
    self.viewMember.dataSource = self;
    
    self.lblUserName.text=objUserDetail.str_first_name;
    
    self.viewSize = 50;//CGRectGetWidth(self.view.bounds) / numberOfVisibleUser;
    self.viewMember.delegate = self;
    [self.viewMember reloadDataWithInitialIndex:0];
    [self showbtnEdit];
}



#pragma mark  - BUTTON CLICK ACTION -
- (IBAction)btnBackClickAction:(id)sender {
    //[self.navigationController popViewControllerAnimated:YES];
    
    //temp code for logout
    [USERDEFAULTS setObject:@"0" forKey:IsLogin];
    LoginVC *loginVC=[self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
    [self.navigationController pushViewController:loginVC animated:YES];
    //    UIImageView *img =[[UIImageView alloc] initWithFrame:CGRectMake(40, 500,300, 250)];
    //    img.image =[self getScreenshotImage];
    //    [self.view addSubview:img];
}
- (IBAction)btnEditReportListAction:(id)sender {
    [self addCenterGesture:NO];
    _viewDisplayMenu.hidden=YES;
    _btnDisplayMenu.selected=NO;
    EditReportListVC *erlVC=[self.storyboard instantiateViewControllerWithIdentifier:@"EditReportListVC"];
    erlVC.delegate = self;
    erlVC.strTitle=_lblUserName.text;
    
    erlVC.objMemberDetail = [arrayMemberData objectAtIndex:iCurrentUserIndex];
    [self.navigationController pushViewController:erlVC animated:YES];
}

- (IBAction)btnDisplayMenuAction:(id)sender {
    if (_btnDisplayMenu.isSelected) {
        _btnDisplayMenu.selected = NO;
        [_btnAddResult setTitle:@"" forState:UIControlStateNormal];
        [_btnEditReportList setTitle:@"" forState:UIControlStateNormal];
        [_btnEditReportList setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_btnAddResult setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        _conHightBtnEdit.constant=0;
        _viewDisplayMenu.hidden=YES;
    } else {
        _viewDisplayMenu.hidden=NO;
        _btnDisplayMenu.selected = YES;
        _viewDisplayMenu.backgroundColor=[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:.9];
        
        [_btnEditReportList setImage:[UIImage imageNamed:@"Report_icon_Edit"] forState:UIControlStateNormal];
        [_btnAddResult setImage:[UIImage imageNamed:@"img_report_icon"] forState:UIControlStateNormal];
        [_btnEditReportList setTitle:@" View History" forState:UIControlStateNormal];
        [_btnAddResult setTitle:@" Add Test Results  " forState:UIControlStateNormal];
        _conHightBtnEdit.constant=44;
    }
    
}

- (IBAction)btnAddNewTestAction:(id)sender {
    if (arrayMemberData.count == 0){
        return;
    }
    self.viewDisplayMenu.hidden=YES;
    _btnDisplayMenu.selected=NO;
    [self addCenterGesture:NO];
    AddNewTestVC *addTestVC=[self.storyboard instantiateViewControllerWithIdentifier:@"AddNewTestVC"];
    addTestVC.delegate = self;
    
    objMemberDetail = [arrayMemberData objectAtIndex:iCurrentUserIndex];
    addTestVC.strUserId=SAFESTRING([objMemberDetail.str_user_id trimSpaces]);
    //    }
    [self.navigationController pushViewController:addTestVC animated:YES];
    
}
- (IBAction)btnMenuAction:(id)sender {
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
}
-(UIImage *)getScreenshotImage {
    if ([[UIScreen mainScreen] scale] == 2.0) {
        UIGraphicsBeginImageContextWithOptions(self.view.frame.size, YES, 2.0);
    } else {
        UIGraphicsBeginImageContextWithOptions(self.view.frame.size, FALSE, 1.0);
    }
    
    [self.view.window.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}


- (IBAction)btnTestReportClickAction:(id)sender {
    _viewDisplayMenu.hidden=YES;
    _btnDisplayMenu.selected=NO;
    AddTestReportVC *testReportVC =[self.storyboard instantiateViewControllerWithIdentifier:@"AddTestReportVC"];
    testReportVC.objMemberDetail = [arrayMemberData objectAtIndex:iCurrentUserIndex];
    [self addCenterGesture:NO];
    testReportVC.delegate=self;
    [self.navigationController pushViewController:testReportVC animated:YES];
    
}

- (IBAction)btnLogOutClickAction:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:APPNAME message:ALERT_LOGOUT delegate:self cancelButtonTitle:nil otherButtonTitles:@"Yes",@"No", nil];
    [alert show];
}

- (IBAction)btnAddMenberClickAction:(id)sender {
    [self addCenterGesture:NO];
    _viewDisplayMenu.hidden=YES;
    _btnDisplayMenu.selected=NO;
    AddMemberVC *memberVC=[self.storyboard instantiateViewControllerWithIdentifier:@"AddMemberVC"];
    [self.navigationController pushViewController:memberVC animated:YES];
}

- (IBAction)btnTabButtonClickAction:(id)sender {
    if ([sender tag] == 0) {
        HealthBlogVC *healthBLogVC =[self.storyboard instantiateViewControllerWithIdentifier:@"HealthBlogVC"];
        [self.navigationController  pushViewController:healthBLogVC animated:NO];
    }
}

- (IBAction)btnDropDownClickAction:(id)sender {
    
    if (tblTestOption.hidden) {
        tblTestOption.hidden = NO;
        self.btnForHideTable.hidden=NO;
    }
    else{
        tblTestOption.hidden = YES;
        self.btnForHideTable.hidden=YES;
    }
}

- (IBAction)btnHidetableClickAction:(id)sender {
    tblTestOption.hidden= YES;
    self.btnForHideTable.hidden=YES;
}

- (IBAction)btnFeedbackAction:(id)sender {
    NSArray *toRecipents = [NSArray arrayWithObject:[NSString stringWithFormat:@"info@onetrackhealth.com"]];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    //    [mc setSubject:emailTitle];
    //    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
}

- (IBAction)btnPrivacyPolicyAction:(id)sender {
    PrivacyPolicyVC *ppVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PrivacyPolicyVC"];
    [self presentViewController:ppVC animated:YES completion:nil];
}

#pragma mark - ALERTVIEW CLICKED BUTTON METHOD -
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        [USERDEFAULTS setObject:@"0" forKey:IsLogin];
        LoginVC *loginVC=[self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    else{
        
    }
    
}

#pragma mark - TABLEVIEW DELEGATE AND DATASOURCE METHODS  -
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35.0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TestOptionCell *cell =[tblTestOption dequeueReusableCellWithIdentifier:@"TestOptionCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 0) {
        cell.lblTestName.text = @"Kidney";
    }
    else {
        cell.lblTestName.text = @"Other";
    }
    return cell;
}

-(void)navigateToOtherTestVC{
    OtherTestVC *otherTestVC = [self.storyboard instantiateViewControllerWithIdentifier:@"OtherTestVC"];
    [self.navigationController pushViewController:otherTestVC animated:true];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TestOptionCell *cell = (TestOptionCell *)[tblTestOption cellForRowAtIndexPath:indexPath];
    txtTestSelect.text =cell.lblTestName.text;
    tblTestOption.hidden = YES;
    
    if (indexPath.row == 1) {
        [self navigateToOtherTestVC];
    }
    self.btnForHideTable.hidden=YES;
}


#pragma mark - COLLECTIONVIEW DELEGATE AND DATASOURCE METHODS  -

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(100, 100);
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_arrAllData.count) {
        return _arrAllData.count;
    } else {
        return 3;
    }
    
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TestGraphCell *cell =[CVGraph dequeueReusableCellWithReuseIdentifier:@"TestGraphCell" forIndexPath:indexPath];
    
    cell.viewGraph.maxValue = 1;
    cell.viewGraph.progressAngle=80;
    cell.viewGraph.progressCapType=0;
    cell.viewGraph.emptyCapType= 0;
    cell.viewGraph.unitFontName=FONT_ITCAVANTGARDESTD_DEMI;
    cell.viewGraph.unitFontSize = 12;
    cell.viewGraph.showUnitString=YES;
    cell.viewGraph.showValueString=YES;
    cell.viewGraph.progressLineWidth= 5;
    cell.viewGraph.emptyLineWidth= 5;
    cell.viewGraph.backgroundColor=[UIColor clearColor];
    
    //set dynamic values
    if (_arrAllData.count) {
        TestReportDetail *objTestReport = [_arrAllData objectAtIndex:indexPath.row];
        
        NSMutableArray *arrayTest=[NSMutableArray array];
        arrayTest = objTestReport.array_Test_value;
        while (arrayTest.count > 3) {
            [arrayTest removeObjectAtIndex:0];
        }
        
        if (objTestReport.is_Empty_Value) {
            cell.viewGraph.progressColor = COLORCODE_BLUE_BUTTON;
        }else{
            if ([objTestReport.str_test_Color isEqualToString:@"GREEN"]) {
                cell.viewGraph.progressColor = COLORCODE_GREEN;
            } else {
                cell.viewGraph.progressColor = COLORCODE_RED;
            }
        }
        
        cell.viewGraph.value= 1;//objTestReport.array_Test_value.count;
        cell.viewGraph.unitString =@"";
        cell.lblTestName.text=objTestReport.str_test_name;
        
        cell.viewGraph.progressStrokeColor = cell.viewGraph.progressColor;
        NSArray * arryTest = [[NSArray alloc]init];
        if (objTestReport.array_Test_value.count != 0) {
            arryTest = objTestReport.array_Test_value[0];
            NSLog(@"month: %@", [arryTest valueForKey:@"str_month"]);
            cell.lblDetail.text = [NSString stringWithFormat:@"%@ tests",objTestReport.str_Total_Test_value];
        }else{
            cell.lblDetail.text=@"1 test";
        }
        
        
    } else {
        cell.viewGraph.value=1;
        NSArray *arrtest=[[NSArray alloc] initWithObjects:@"Test A",@"Test B",@"Test C", nil];
        cell.viewGraph.unitString =@"";
        cell.lblTestName.text=[arrtest objectAtIndex:indexPath.row];
        cell.viewGraph.progressColor = COLORCODE_BLUE_BUTTON;
        cell.viewGraph.progressStrokeColor = cell.viewGraph.progressColor;
        cell.lblDetail.text=[NSString stringWithFormat:@"%lu tests",(unsigned long)3];
    }
    
    
    cell.lblTestName.textColor=[UIColor darkGrayColor];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (arrayUserTestReport.count) {
        GraphReportVC *graphReport = [self.storyboard instantiateViewControllerWithIdentifier:@"GraphReportVC"];
        //        graphReport.objTestReport = [arrayUserTestReport objectAtIndex:indexPath.row];
        graphReport.selectIndex = indexPath.row;
        graphReport.arrayUserTestReport = arrayUserTestReport;
        graphReport.arrayUserAllReports = _arrAllData;
        graphReport.arrayUserTestReportTemp = self.arrayUserTestReportTemp;
        graphReport.objMemberDetail = [arrayMemberData objectAtIndex:iCurrentUserIndex];
        [self addCenterGesture:NO];
        
        NSMutableArray *arrAverage = [self getAverageOfTestReport];
        graphReport.arrTestValueTemp = arrAverage;
        
        [self.navigationController pushViewController:graphReport animated:YES];
    } else {
        
    }
}

-(NSMutableArray*)getAverageOfTestReport{
    NSMutableArray *arrAverage = [[NSMutableArray alloc]init];
    for (TestReportDetail *obj in self.arrayUserTestReportTemp){
        double average = 0.0;
        double totalTest = 0;
        
        for (TestReportDetail *objTest in obj.array_Test_value){
            if ([objTest.str_test_parameter_value isEqualToString:@""]) {
                continue;
            }
            
            double d = [objTest.str_test_parameter_value doubleValue];
            average = average + d;
            totalTest = totalTest + 1;
        }
        NSString *avg = [NSString stringWithFormat:@"%0.2f",average/totalTest];
        [arrAverage addObject:avg];
    }
    return arrAverage;
}


#pragma mark - WEBSERVICE CALL : For Member List -

-(void)callGetMemberWebservice
{
    if ([self isNetworkReachable]) {
        [self showSpinnerWithUserActionEnable:false];
                
        Webservice *webserviceObj = [[Webservice alloc]init];
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        
        [dictParam setObject:SAFESTRING([objUserDetail.str_user_id trimSpaces]) forKey:@"user_id"];
        [webserviceObj callJSONMethod:@"get_mamber" withParameters:dictParam isEncrpyted:NO onSuccessfulResponse:^(NSMutableDictionary *dict) {
            
            [self hideSpinner];
            NSString *strMsg=[dict valueForKey:@"message"];
            
            if ([[dict valueForKey:@"status"] integerValue] == 1 ) {
                
                self->arrayMemberData=[MemberDetail initWithArray:[dict valueForKey:@"data"] ];
                [self setMemberData];
                
            }
            else if ([[dict valueForKey:@"status"] integerValue] == 2){
                
                self->arrayMemberData = [[NSMutableArray alloc] init];
                [self setMemberData];
            }
            else{
                [UIAlertController infoAlertWithMessage:strMsg andTitle:APPNAME controller:self];
            }
            
        } onFailure:^(NSError *error) {
            [UIAlertController infoAlertWithMessage:[error localizedDescription] andTitle:APPNAME controller:self];
            [self hideSpinner];
        }];
    }
    else{
        [UIAlertController infoAlertWithMessage:ALERT_NO_INTERNET andTitle:APPNAME controller:self];
    }
    
}

#pragma mark - WEBSERVICE CALL : For User Test Report -

-(void)getUserTestReport:(NSString *)userId
{
    if ([self isNetworkReachable]) {
        [self showSpinnerWithUserActionEnable:false];
                
        Webservice *webserviceObj = [[Webservice alloc]init];
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        
        [dictParam setObject:SAFESTRING([userId trimSpaces]) forKey:@"user_id"];
        //        [webserviceObj callJSONMethod:@"report_details" withParameters:dictParam isEncrpyted:NO onSuccessfulResponse:^(NSMutableDictionary *dict) {
        NSLog(@"Parameters are %@ ->>>>>>>",dictParam);
        [webserviceObj callJSONMethod:@"last3_month_report_details" withParameters:dictParam isEncrpyted:NO onSuccessfulResponse:^(NSMutableDictionary *dict) {
            [self hideSpinner];
            // NSString *strMsg=[dict valueForKey:@"message"];
            
            if ([[dict valueForKey:@"status"] integerValue] == 1 ) {
                
                self->arrayUserTestReport=[TestReportDetail initWithArrayAverage:[dict valueForKey:@"data"]];
                self.arrayUserTestReportTemp=[TestReportDetail initWithArray:[dict valueForKey:@"data"]];
                
                self->_arrAllData = [TestReportDetail initWithAllData:[dict valueForKey:@"data"]];
            }
            else{
                NSLog(@"Data Not Coming Error");
                self->_arrAllData =  [[NSArray alloc]init];
            }
            [self->CVGraph reloadData];
            if (self->arrayUserTestReport.count>0) {
                long temp = self->arrayUserTestReport.count / 3;
                temp = temp * 110;
                long temp2 = self->arrayUserTestReport.count % 3;
                if (temp2 > 0) {
                    temp2=110;
                }
                self->_heightScrollview.constant = self->_heightHeaderview.constant + temp + temp2 + 15;
            }else{
                self->_heightScrollview.constant = self->_heightHeaderview.constant + 115;
            }
            
            
            
            
        } onFailure:^(NSError *error) {
            [UIAlertController infoAlertWithMessage:[error localizedDescription] andTitle:APPNAME controller:self];
            [self hideSpinner];
        }];
    }
    else{
        [UIAlertController infoAlertWithMessage:ALERT_NO_INTERNET andTitle:APPNAME controller:self];
    }
    
}

# pragma mark - LTInfiniteScrollView dataSource -
- (NSInteger)numberOfViews
{
    //added 4 extra cell 2 for left side and 2 for right side !!
    return arrayMemberData.count + 4;
    // return 1;
}

- (NSInteger)numberOfVisibleViews
{
    //number of visible view are always 5 if there is no any menber then 4 extra cell and one for main user !!
    return numberOfVisibleUser;;
}


# pragma mark - LTInfiniteScrollView delegate -

- (UIView *)viewAtIndex:(NSInteger)index reusingView:(UIView *)view;
{
    if (view) {
        /*this code is for reuseble view if its one of the extra cell then do nothing */
        if (index == 0 || index == 1 || index == arrayMemberData.count+2 || index == arrayMemberData.count+3) {
            //do nothing (extra cell)
            UIImageView *aView =(UIImageView *)view;
            aView.image = nil;
            view.backgroundColor = [UIColor clearColor];
            view.layer.borderColor=[UIColor clearColor].CGColor;
            return aView;
        }else {
            //user cell so check is image is downloaded or not !!
            NSInteger tempIndex = index - 2;
            if ([arrayOfimages objectAtIndex:tempIndex] != [NSNull null]){
                //image is available in imageArray so set it from array!!
                UIImageView *aView =(UIImageView *)view;
                aView.image = [arrayOfimages objectAtIndex:tempIndex];
                aView.backgroundColor = [UIColor clearColor];
                aView.layer.cornerRadius = self.viewSize/2.0f;
                aView.layer.masksToBounds = YES;
                aView.layer.borderWidth=2;
                aView.layer.borderColor=[UIColor whiteColor].CGColor;
                
                return aView;
                
            } else{
                NSString *strImageName;
                if (tempIndex == 0) {
                    strImageName = [objUserDetail.str_profile_pic stringByRemovingPercentEncoding];
                }
                else{
                    MemberDetail *objMember =[arrayMemberData objectAtIndex:tempIndex];
                    strImageName =[objMember.str_profile_pic stringByRemovingPercentEncoding];
                }
                
                UIImageView *aView =(UIImageView *)view;
                if ([strImageName length] > 0) {
                    
                    NSString *strPhotoUrl = [NSString stringWithFormat:@"%@%@",URL_IMGS,strImageName];
                    NSURL *urlPhoto = [NSURL URLWithString:strPhotoUrl];
                    
                    [(UIImageView *)view sd_setImageWithURL:urlPhoto placeholderImage:[UIImage imageNamed:IMG_USER_PROFILE] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        if (image) {
                            
                            aView.backgroundColor = [UIColor clearColor];
                            aView.layer.cornerRadius = self.viewSize/2.0f;
                            aView.layer.masksToBounds = YES;
                            aView.layer.borderWidth=2;
                            aView.layer.borderColor=[UIColor whiteColor].CGColor;
                            
                            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapHandel:)];
                            
                            tapGesture.numberOfTapsRequired = 1;
                            [tapGesture setDelegate:self];
                            [aView addGestureRecognizer:tapGesture];
                            
                            [self->arrayOfimages replaceObjectAtIndex:tempIndex withObject:image];
                        }
                        
                        
                    }];
                }else{ //Added Image Hide Issue
                    aView.image = [UIImage imageNamed:IMG_USER_PROFILE];
                    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapHandel:)];
                    
                    tapGesture.numberOfTapsRequired = 1;
                    [tapGesture setDelegate:self];
                    [aView addGestureRecognizer:tapGesture];
                    aView.backgroundColor = [UIColor clearColor];
                    aView.layer.cornerRadius = self.viewSize/2.0f;
                    aView.layer.masksToBounds = YES;
                    aView.layer.borderWidth=2;
                    aView.layer.borderColor=[UIColor whiteColor].CGColor;
                }
                return aView;
            }
        }
    }else{
        
        UIImageView *aView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.viewSize, self.viewSize)];
        aView.userInteractionEnabled = YES;
        
        if (index == 0 || index == 1 || index == arrayMemberData.count+2 || index == arrayMemberData.count+3) {
            
            aView.backgroundColor = [UIColor  clearColor];
            return aView;
            
        }else{
            NSString *strImageName;
            NSInteger tempIndex = index- 2;
            
            aView.backgroundColor = [UIColor clearColor];
            aView.layer.cornerRadius = self.viewSize/2.0f;
            aView.layer.masksToBounds = YES;
            aView.layer.borderWidth=2;
            aView.layer.borderColor=[UIColor whiteColor].CGColor;
            
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapHandel:)];
            
            tapGesture.numberOfTapsRequired = 1;
            [tapGesture setDelegate:self];
            [aView addGestureRecognizer:tapGesture];
            
            if (tempIndex == 0) {
                strImageName =[objUserDetail.str_profile_pic stringByRemovingPercentEncoding];
            }
            else{
                MemberDetail *objMember =[arrayMemberData objectAtIndex:tempIndex];
                strImageName =[objMember.str_profile_pic stringByRemovingPercentEncoding];
            }
            
            if ([strImageName length] > 0) {
                NSString *strPhotoUrl = [NSString stringWithFormat:@"%@%@",URL_IMGS,strImageName];
                NSURL *urlPhoto = [NSURL URLWithString:strPhotoUrl];
                
                [aView sd_setImageWithURL:urlPhoto placeholderImage:[UIImage imageNamed:IMG_USER_PROFILE] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if (image) {
                        [self->arrayOfimages replaceObjectAtIndex:tempIndex withObject:image];
                    }
                }];
            }else{
                aView.image=[UIImage imageNamed:IMG_USER_PROFILE];
            }
            return aView;
        }
    }
}


- (void)updateView:(UIView *)view withProgress:(CGFloat)progress scrollDirection:(ScrollDirection)direction
{
    // you can apply animations duration scrolling here
    _btnEditProfile.alpha=0.0;
    CATransform3D transform = CATransform3DIdentity;
    
    // scale
    CGFloat size = self.viewSize;
    CGPoint center = view.center;
    view.center = center;
    size = size * (1.4 - 0.3 * (fabs(progress)));
    view.frame = CGRectMake(0, 0, size, size);
    view.layer.cornerRadius = size / 2;
    view.center = center;
    
    // translate
    CGFloat translate = self.viewSize / 3 * progress;
    if (progress > 1) {
        translate = self.viewSize / 3;
    } else if (progress < -1) {
        translate = -self.viewSize / 3;
    }
    transform = CATransform3DTranslate(transform, translate, 0, 0);
    
    // rotate
    if (fabs(progress) < 1) {
        CGFloat angle = 0;
        if(progress > 0) {
            angle = - M_PI * (1 - fabs(progress));
        } else {
            angle =  M_PI * (1 - fabs(progress));
        }
        transform.m34 = 1.0 / -400;
        if (fabs(progress) <= 1.0) {
            angle =  M_PI * progress;
            
            UIImageView *imageview = (UIImageView*) view;
            imageview.alpha= 1.0;
            
        } else {
            
            UIImageView *imageview = (UIImageView*) view;
            imageview.alpha= 0.1;
            
            
        }
        transform = CATransform3DRotate(transform, angle , 0.0f, 1.0f, 0.0f);
    } else {
        
        
        UIImageView *imageview = (UIImageView*) view;
        imageview.alpha= 0.5;
        //        _btnEditProfile.alpha=0.5;
        
    }
    
    view.layer.transform = transform;
    
}

- (void)scrollView:(LTInfiniteScrollView *)scrollView didScrollToIndex:(NSInteger)index
{
    NSLog(@"scroll to: %ld", (long)index);
    arrayUserTestReport = [[NSMutableArray alloc] init];
    
    if (index == 0 || index == 1 || index == arrayMemberData.count+2 || index == arrayMemberData.count+3) {
        
    }
    else{
        NSInteger tempIndex = index-2;
        iCurrentUserIndex = tempIndex;
        if (tempIndex == 0) {
            
            self.lblUserName.text=objUserDetail.str_first_name;
            [self getUserTestReport:objUserDetail.str_user_id];
        }
        else
        {
            MemberDetail *objMember =[arrayMemberData objectAtIndex:tempIndex];
            self.lblUserName.text=objMember.str_first_name;
            
            [self getUserTestReport:objMember.str_user_id];
        }
        [self performSelector:@selector(showbtnEdit) withObject:nil afterDelay:.5];
        
    }
    
}
-(void)showbtnEdit{
    [UIView
     animateWithDuration:.5
     delay:0.0
     options:UIViewAnimationOptionAllowUserInteraction
     animations:^{ self->_btnEditProfile.alpha=1.0; }
     completion:nil];
}

#pragma mark - EXTRA ANIMATION METHODS -
-(void)animation
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(150, 400, 50,50)];
    view.backgroundColor=[UIColor redColor];
    CGRect boundingRect = CGRectMake(-50, -50, 100, 100);
    
    CAKeyframeAnimation *orbit = [CAKeyframeAnimation animation];
    orbit.keyPath = @"position";
    orbit.path = CFAutorelease(CGPathCreateWithEllipseInRect(boundingRect, NULL));
    orbit.duration = 4;
    orbit.additive = YES;
    orbit.repeatCount = HUGE_VALF;
    orbit.calculationMode = kCAAnimationPaced;
    orbit.rotationMode = kCAAnimationRotateAutoReverse;
}


- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - MEMBER IMAGE TAP HANDEL METHOD -

-(void)imageTapHandel:(UIGestureRecognizer *)sender
{
    UIImageView *imageView = (UIImageView *)sender.view;
    //NSLog(@"----------%ld",(long)imageView.tag);
    NSInteger tempIndex = imageView.tag - 2;
    
    AddMemberVC *memberVC=[self.storyboard instantiateViewControllerWithIdentifier:@"AddMemberVC"];
    memberVC.callListAPI = ^void(bool isDeleted){
        if (isDeleted){
            [self callGetMemberWebservice];
        }
        return;
    };
    
    if (tempIndex > 0) {
        
        memberVC.isEdit = YES;
        memberVC.isMainUser = NO;
        memberVC.objMemberDetail = [arrayMemberData objectAtIndex:tempIndex];
    }
    else
    {
        memberVC.isEdit = YES;
        memberVC.isMainUser = YES;
    }
    memberVC.delegate=self;
    //    [self.navigationController pushViewController:memberVC animated:YES];
    [self  presentViewController:memberVC animated:YES completion:nil];
    
}
- (IBAction)btnGotItAction:(id)sender {
    self.conGotItY.constant = 0;
    viewStap ++;
    switch (viewStap) {
        case 1:{
            [self fadeOut:self.viewStap1 withDuration:0.0 andWait:1.0];
            [self fadeIn:self.viewStap2 withDuration:1.0 andWait:1.0];
            break;
        }
        case 2:
            self.conGotItY.constant = 50;
            [self fadeOut:self.viewStap2 withDuration:0.0 andWait:1.0];
            [self fadeIn:self.viewStap3 withDuration:0.5 andWait:1.0];
            break;
        case 3:
            
            [self fadeOut:self.viewStap3 withDuration:0.0 andWait:1.0];
            [self fadeIn:self.viewStap4 withDuration:0.5 andWait:1.0];
            break;
        case 4:
            [self fadeOut:self.viewStap4 withDuration:0.0 andWait:1.0];
            [self fadeIn:self.viewStap5 withDuration:0.5 andWait:1.0];
            break;
        case 5:
            [self fadeOut:self.viewStap5 withDuration:0.0 andWait:1.0];
            [self fadeIn:self.viewStap6 withDuration:0.5 andWait:1.0];
            break;
        case 6:
            [self fadeOut:self.viewStap6 withDuration:0.0 andWait:1.0];
            [self fadeIn:self.viewStap7 withDuration:0.5 andWait:1.0];
            break;
        default:
            break;
    }
    //    self.btnGotIt.hidden = YES;
}

- (IBAction)btnCloseIntroView:(id)sender {
    self.viewIntro.hidden = YES;
    self.viewIntroBackGround.hidden = YES;
    [self addCenterGesture:YES];
}
-(void) fadeIn:(UIView*)viewToFadeIn withDuration:(NSTimeInterval)duration andWait:(NSTimeInterval)wait

{
    [UIView beginAnimations: @"Fade In" context:nil];
    
    // wait for time before begin
    [UIView setAnimationDelay:wait];
    
    // druation of animation
    [UIView setAnimationDuration:duration];
    viewToFadeIn.alpha = 1;
    if (viewToFadeIn != self.viewStap7) {
        self.btnGotIt.alpha = 1.0;
    }
    [UIView commitAnimations];
    
    //    [self performSelector:@selector(showGotitBtn) withObject:nil afterDelay:1.5];
}
-(void)showGotitBtn{
    self.btnGotIt.hidden = NO;
}
-(void)fadeOut:(UIView*)viewToDissolve withDuration:(NSTimeInterval)duration   andWait:(NSTimeInterval)wait
{
    [UIView beginAnimations: @"Fade Out" context:nil];
    
    // wait for time before begin
    [UIView setAnimationDelay:wait];
    
    // druation of animation
    [UIView setAnimationDuration:duration];
    viewToDissolve.alpha = 0.0;
    self.btnGotIt.alpha = 0.0;
    [UIView commitAnimations];
}

#pragma mark : Delegate Method
-(void)addNewTest:(NSString *)userId{
    [self getUserTestReport:userId];
}

#pragma mark TEXTFIELD DELEGATE METHODS

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == txtFromDate) {
        isFromDate = YES;
    }
    else{
        isFromDate = NO;
    }
    
    if ([self.pmCC isCalendarVisible])
    {
        [self.pmCC dismissCalendarAnimated:NO];
    }
    
    BOOL isPopover = YES;
    
    // limit apple calendar to 2 months before and 2 months after current date
    PMPeriod *allowed = [PMPeriod periodWithStartDate:[[NSDate date] dateByAddingMonths:-6]
                                              endDate:[[NSDate date] dateByAddingMonths:+6]];
    
    //self.pmCC = [[PMCalendarController alloc] initWithSize:CGSizeMake(200, 150)];
    self.pmCC = [[PMCalendarController alloc] initWithThemeName:@"default"];
    self.pmCC.allowedPeriod = allowed;
    [self.pmCC presentCalendarFromView:textField
              permittedArrowDirections:PMCalendarArrowDirectionUp
                             isPopover:isPopover
                              animated:YES];
    
    self.pmCC.delegate = self;
    self.pmCC.allowsPeriodSelection=YES;
    self.pmCC.mondayFirstDayOfWeek = NO;
    self.pmCC.showOnlyCurrentMonth = NO;
    
    //Only show days in current month
    
    // self.pmCC.period = [PMPeriod oneDayPeriodWithDate:[NSDate date]];
    //    [self calendarController:pmCC didChangePeriod:pmCC.period];
    
    return NO;
}

#pragma mark - CALENDAR DELEGATE METHODS -
- (void)calendarController:(PMCalendarController *)calendarController didChangePeriod:(PMPeriod *)newPeriod
{
    NSString *date1 = [NSString stringWithFormat:@"%@"
                       , [newPeriod.startDate dateStringWithFormat:@"dd-MMM-yyyy"]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:NSTimeZone.systemTimeZone];
    [dateFormatter setDateFormat:@"dd-MMM-yyyy"];
    NSDate *selecteDate = [dateFormatter dateFromString:date1];
    NSTimeInterval interval = [selecteDate timeIntervalSince1970] + 86500;
    
    
    if (self.pmCC.isOnlyMonthChnaged) {
        //NSLog(@"Month has been changed!!");
    }
    else{
        //NSLog(@"Date is selected!!");
        if (isFromDate) {
            fromTimeInterval = interval;
            txtFromDate.text=date1;
            if (toTimeInterval > 0) {
                
                if (toTimeInterval > fromTimeInterval) {
                    NSMutableArray *arrFilter = [self getDataByFilteringDate:toTimeInterval toTime:fromTimeInterval FromTime:_arrAllData];
                    [self setUserTestData:arrFilter]; //Pass Month Filtered Data
                }
                else
                {
                    [UIAlertController infoAlertWithMessage:@"please select valid from Date" andTitle:APPNAME controller:self];
                    txtFromDate.text=@"";
                }
            }
        }
        else{
            
            toTimeInterval = interval + 86400;
            if (fromTimeInterval > 0) {
                
                if (toTimeInterval > fromTimeInterval) {
                    txtToDate.text=date1;
                    NSMutableArray *arrFilter =[self getDataByFilteringDate:toTimeInterval toTime:fromTimeInterval FromTime:_arrAllData];
                    [self setUserTestData:arrFilter];//Pass month filter data
                }
                else
                {
                    [UIAlertController infoAlertWithMessage:@"please select valid to Date" andTitle:APPNAME controller:self];
                }
            }else{
                [UIAlertController infoAlertWithMessage:@"please select valid to Date" andTitle:APPNAME controller:self];
            }
            
        }
        [self.pmCC dismissCalendarAnimated:NO];
    }
    
}
- (IBAction)btnResetAction:(id)sender {
    if (txtToDate.text.length>0 && txtFromDate.text.length>0) {
        self.txtFromDate.text = self.txtToDate.text = @"";
        toTimeInterval = 0;
        fromTimeInterval = 0;
    }
}

-(NSMutableArray *)getDataByFilteringDate:(double)timeIntervalToDate toTime:(double)timeIntervalFromDate FromTime:(NSMutableArray *)arrFilteredArray{
    
    NSMutableArray *arrDataFromDate = [NSMutableArray array];
    for (TestReportDetail *obj in arrFilteredArray) {
        NSMutableArray *arrDataFilter = [NSMutableArray array];
        
        for (TestReportDetail *objTemp in obj.array_Test_value) {
            NSString *timeStampCurrentDate = objTemp.str_report_date;
            
            if ([timeStampCurrentDate doubleValue] >= (timeIntervalFromDate - 66700) && [timeStampCurrentDate doubleValue] <= (timeIntervalToDate - 66700) ) {
                [arrDataFilter addObject: objTemp];
            }else{
            }
        }
        [arrDataFromDate addObject:arrDataFilter];
    }
    return  arrDataFromDate;
}

-(void)setUserTestData:(NSMutableArray *)arrDataByDate
{
    if (arrDataByDate.count > 0) {
    
    
    }
    else{
        [UIAlertController infoAlertWithMessage:ALERT_NO_REPORT_FOUND andTitle:APPNAME controller:self];
    }
}

@end
