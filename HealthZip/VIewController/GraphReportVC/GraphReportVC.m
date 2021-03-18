
//
//  GraphReportVC.m
//  HealthZip
//
//  Created by Tristate on 6/14/16.
//  Copyright © 2016 Tristate. All rights reserved.
//

#import "GraphReportVC.h"
#import "Constants.h"
#import "UIImageView+WebCache.h"
#import "LineGraphVC.h"
#import "Webservice.h"

#include <stdlib.h>

@interface GraphReportVC ()
@property (assign) CGRect rect;
@end

@implementation GraphReportVC

@synthesize imgUserProfile,txtFromDate,txtToDate,lblGraphName,lblUserName,arrayTextFields,objTestReport,arrayUserTestReportTemp,arrReportFilterData;




BOOL isFirstCall;
// CGRectMake graphFram = CGRectMake(0, 0, 0, 0);

#pragma mark - VIEW LIFECYCLE METHODS -

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"> > > > > > > > > > > >%@ > > > > > > > > >",NSStringFromClass([self class]));
    
    // Do any additional setup after loading the view.
    [USERDEFAULTS setObject:@"0" forKey:@"DASHBOARD"];
    
    
    graphData = [[GraphView alloc] init];
    
    arrayMonths = [[NSMutableArray alloc] init];
    
    objTestReport = [self.arrayUserTestReport objectAtIndex:_selectIndex];
    
    UISwipeGestureRecognizer *swipeLeftGreen = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(slideToLeftWithGestureRecognizer:)];
    swipeLeftGreen.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.viewSwipe addGestureRecognizer:swipeLeftGreen];
    UISwipeGestureRecognizer *swipeRightBlack = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(slideToRightWithGestureRecognizer:)];
    swipeRightBlack.direction = UISwipeGestureRecognizerDirectionRight;
    [self.viewSwipe addGestureRecognizer:swipeRightBlack];
    [self setUI:true];
    [self designConstratin];
}

-(void)slideToLeftWithGestureRecognizer:(UISwipeGestureRecognizer *)left{
    _btnPrivous.enabled = true;
    
    if (_selectIndex < self.arrayUserTestReport.count-1) {
        _selectIndex++;
        objTestReport = [self.arrayUserTestReport objectAtIndex:_selectIndex];
        //        [self setUI];
        [self setUI:false];
        
    }
    
    if (_selectIndex == self.arrayUserTestReport.count-1) {
        _btnNext.enabled = false;
    }
}
-(void)slideToRightWithGestureRecognizer:(UISwipeGestureRecognizer *)left{
    NSLog(@"right");
    _btnNext.enabled = true;
    if (_selectIndex > 0) {
        isFirstCall = isFirstCall;
        _selectIndex--;
        objTestReport = [self.arrayUserTestReport objectAtIndex:_selectIndex];
        //        [self setUI];
        [self setUI:false];
        
    }else{
        _selectIndex = 0;
        if(isFirstCall){
            
        }
        else {
            isFirstCall = !isFirstCall;
            objTestReport = [self.arrayUserTestReport objectAtIndex:_selectIndex];
            [self setUI:false];
            
        }
    }
    if (_selectIndex == 0) {
        _btnPrivous.enabled = false;
    }else{
        _btnPrivous.enabled = true;
    }
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    objUserDetail=[UserDetail sharedInstance];
    objUserDetail=[objUserDetail getDetail];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - BUTTON CLICK ACTION -

- (IBAction)btnExportEmailClickAction:(id)sender {
    
    UIImage *image = [self getScreenshotImage];
    NSData *imageData = UIImageJPEGRepresentation(image, 2.0);
    NSString *title =[NSString stringWithFormat:@"%@ Test Report",objTestReport.str_test_name] ;
    NSString *strBody =@"my new report card";
    NSArray *toRecipents = [[NSArray alloc]  initWithObjects:@"", nil];
    MFMailComposeViewController *mailComposer =[[MFMailComposeViewController alloc]  init];
    
    mailComposer.mailComposeDelegate =self;
    [mailComposer setSubject:title];
    
    [mailComposer setMessageBody:strBody isHTML:NO];
    [mailComposer setToRecipients:toRecipents];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    oldCSVName =[NSString stringWithFormat:@"%@TestReport.csv",objTestReport.str_test_name];
    
    //--------------------------------------------
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:APPNAME
                                                                   message:@"Please enter TestReport CSV name."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        // optionally configure the text field
        textField.keyboardType = UIKeyboardTypeAlphabet;
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action) {
                                                         UITextField *textField = [alert.textFields firstObject];
                                                         self->newCSVName=[NSString stringWithFormat:@"%@.csv",textField.text];
                                                         [self renameFileWithName:self->oldCSVName toName:self->newCSVName];
                                                         NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, self->newCSVName];
                                                         [mailComposer addAttachmentData:[NSData dataWithContentsOfFile:filePath]
                                                                                mimeType:@"text/csv"
                                                                                fileName:self->newCSVName];
        if (imageData){
            [mailComposer addAttachmentData:imageData mimeType:@"image/jpeg" fileName:@"Test"];
        }
                                                         
        [self showEmailAlert:mailComposer objUserDetail:self->objUserDetail completion:^(NSString *strEmail) {
            [self apiCallForSaveEmail:strEmail composer:mailComposer];
        }];
                                                     }];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}

-(void)apiCallForSaveEmail:(NSString *)strEmail composer:(MFMailComposeViewController*)mailComposer {
    if (![self NSStringIsValidEmail:SAFESTRING([strEmail trimSpaces])]){
        [UIAlertController infoAlertWithMessage:ALERT_Invalid_EmailId andTitle:APPNAME controller:self];
        return;
    }else{
        NSArray *toRecipents = [[NSArray alloc]  initWithObjects:strEmail, nil];
        [mailComposer setToRecipients:toRecipents];
        [self.navigationController presentViewController:mailComposer animated:YES completion:NULL];
    }
    if ([objUserDetail.str_saved_email isEqualToString:strEmail]) {
        return;
    }
    
    objUserDetail.str_saved_email = strEmail;
    [objUserDetail saveDetail:objUserDetail];
    
    if ([self isNetworkReachable]) {
        [self showSpinnerWithUserActionEnable:false];
        Webservice *webserviceObj = [[Webservice alloc]init];
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:SAFESTRING([strEmail trimSpaces]) forKey:@"saved_Email_Id"];
        [dictParam setObject:SAFESTRING([objUserDetail.str_user_id trimSpaces]) forKey:@"user_id"];
        
        [webserviceObj callJSONMethod:@"export_email_save" withParameters:dictParam  isEncrpyted:NO  onSuccessfulResponse:^(NSMutableDictionary *dict) {
            //Success
            [self hideSpinner];
        } onFailure:^(NSError *error) {
            //Error
            [UIAlertController infoAlertWithMessage:[error localizedDescription] andTitle:APPNAME controller:self];
            [self hideSpinner];
        }];
    }else {
        [UIAlertController infoAlertWithMessage:ALERT_NO_INTERNET andTitle:APPNAME controller:self];
    }
}

-(void)animationCompleted{
    
    // Whatever you want to do after finish animation
    [self renameFileWithName:newCSVName toName:oldCSVName];
}
- (void)renameFileWithName:(NSString *)srcName toName:(NSString *)dstName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePathSrc = [documentsDirectory stringByAppendingPathComponent:srcName];
    NSString *filePathDst = [documentsDirectory stringByAppendingPathComponent:dstName];
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePathSrc]) {
        NSError *error = nil;
        [manager moveItemAtPath:filePathSrc toPath:filePathDst error:&error];
        if (error) {
            NSLog(@"There is an Error: %@", error);
        }
    } else {
        NSLog(@"File %@ doesn't exists", srcName);
    }
}

- (IBAction)btnBackClickAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnResetAction:(id)sender {
    if (txtToDate.text.length>0 && txtFromDate.text.length>0) {
        self.txtFromDate.text = self.txtToDate.text = @"";
        objTestReport = [self.arrayUserTestReport objectAtIndex:_selectIndex];
        //            [self setUI];
        toTimeInterval = 0;
        fromTimeInterval = 0;
        [self setUI:true];
        
    }
}
- (IBAction)btnNextAction:(id)sender {
    _btnPrivous.enabled = true;
    if (_selectIndex < self.arrayUserTestReport.count-1) {
        _selectIndex++;
        objTestReport = [self.arrayUserTestReport objectAtIndex:_selectIndex];
        //        [self setUI];
        [self setUI:false];
        
    }
    if (_selectIndex == self.arrayUserTestReport.count-1) {
        _btnNext.enabled = false;
    }
}
- (IBAction)btnPrivousAction:(id)sender {
    _btnNext.enabled = true;
    if (_selectIndex > 0) {
        isFirstCall = isFirstCall;
        _selectIndex--;
        objTestReport = [self.arrayUserTestReport objectAtIndex:_selectIndex];
        //        [self setUI];
        [self setUI:false];
        
    }else{
        _selectIndex = 0;
        if(isFirstCall){
            
        }
        else {
            isFirstCall = !isFirstCall;
            //do anything you want to do.
            objTestReport = [self.arrayUserTestReport objectAtIndex:_selectIndex];
            //            [self setUI];
            [self setUI:false];
            
        }
    }
    if (_selectIndex == 0) {
        _btnPrivous.enabled = false;
    }else{
        _btnPrivous.enabled = true;
    }
}
#pragma mark - MAIL COMPOSER DELEGATE METHODS

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    [self animationCompleted];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Save CSV File Function
- (void) saveDataToCSV {
    TestReportDetail *objTestTempReport = [self.arrayUserTestReportTemp objectAtIndex:_selectIndex];
    NSMutableArray *arrData = [[NSMutableArray alloc]init];
    arrData = objTestTempReport.array_Test_value;
    
    NSMutableString *csvString = [[NSMutableString alloc]initWithCapacity:0];
    [csvString appendString:@"Date, Lab Name, Notes,  Normal Range, Test Value, \n"];
    
    NSMutableArray *arrFilter = [self getDataByFilteringDate:toTimeInterval toTime:fromTimeInterval FromTime:arrReportFilterData];
    if (arrFilter.count > 0){
        [arrData removeAllObjects];
        arrData = arrFilter;
    }
    
    for (TestReportDetail *objTemp in arrData) {
        NSString *strReportDate = [self getStrDateChangeFormat:objTemp.str_report_date];
        
        NSString *strNormalRange=[NSString stringWithFormat:@"%@ - %@",objTestReport.str_test_minimum_value,objTestReport.str_test_maximum_value];
        
        if ([objTemp.str_test_parameter_value isEqualToString:@""] || [objTemp.str_test_parameter_value isEqualToString:@"0.00"]) {
        
        }else {
            [csvString appendString:[NSString stringWithFormat:@"%@, %@, %@, %@, %@\n",strReportDate,objTemp.str_report_Lab,objTemp.str_report_Description,strNormalRange,objTemp.str_test_parameter_value]];
        }
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *strcsvFile=[NSString stringWithFormat:@"%@TestReport.csv",objTestReport.str_test_name];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, strcsvFile];
    [csvString writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
}

#pragma mark - DISPLAY GRAPH METHOD - AND GENERATE CSV

- (void)loadChartWithDates:(NSMutableArray *)arrayTest
{
    NSInteger tempMaxCount=arrayTest.count;
    NSMutableArray* testValue = [NSMutableArray arrayWithCapacity:tempMaxCount];
    
    [self saveDataToCSV];
    tempMaxCount=arrayTest.count;
    testValue = [NSMutableArray arrayWithCapacity:tempMaxCount];
    
    NSMutableArray *arrMonth = [NSMutableArray array];
    NSMutableArray *arrValue = [NSMutableArray array];
    
    for(int i=0;i<tempMaxCount;i++) {
        TestReportDetail *objTemp = [arrayTest objectAtIndex:i];
        testValue[i] = [NSNumber numberWithFloat:[objTemp.str_test_parameter_value floatValue]];
        NSString *strReportDate = [self getStrDate:objTemp.str_report_date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"dd-MM-yy";
        NSDate *date = [dateFormatter dateFromString:strReportDate];
        
        dateFormatter.dateFormat=@"MMM";
        NSString *monthString = [[dateFormatter stringFromDate:date] capitalizedString];
        
        if (![objTemp.str_test_parameter_value isEqualToString:@""]) {
            
            if (txtToDate.text.length>0 && txtFromDate.text.length>0) {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"dd-MM-yy"];
                NSDate *reportDate = [dateFormatter dateFromString:strReportDate];
                NSTimeInterval reportDateinterval = [reportDate timeIntervalSince1970];
                [dateFormatter setDateFormat:@"dd-MMM-yyyy"];
                NSDate *toDate = [dateFormatter dateFromString:txtToDate.text];
                NSTimeInterval tointerval = [toDate timeIntervalSince1970];
                NSDate *fromDate = [dateFormatter dateFromString:txtFromDate.text];
                NSTimeInterval frominterval = [fromDate timeIntervalSince1970];
                
                if (reportDateinterval <= tointerval + 86400 && reportDateinterval >= frominterval){
                    [arrMonth addObject:monthString];
                    [arrValue addObject:[NSNumber numberWithFloat:[objTemp.str_test_parameter_value floatValue]]];
                }
            }else{
                [arrMonth addObject:monthString];
                [arrValue addObject:[NSNumber numberWithFloat:[objTemp.str_test_parameter_value floatValue]]];
            }
        }
        
    }
    if (arrValue.count <= 0) {
//        self.chartView.hidden = YES;
//        self.lblNodatafound.hidden = NO;
//        self.lblUnitDisplay.text = @"";
    }else{
        self.chartView.hidden = NO;
        self.lblNodatafound.hidden = YES;
        self.lblUnitDisplay.text = objTestReport.str_test_parameter_unit;
    }
    
    self.chartView.iGraphMaxValue = [objTestReport.str_test_maximum_value floatValue];
    self.chartView.iGraphMinValue = [objTestReport.str_test_minimum_value floatValue];
    self.chartView.arrayGraphValues=[NSMutableArray arrayWithArray:arrValue];
    self.chartView.dates = [NSMutableArray arrayWithArray:arrMonth];
    [self.chartView createGraph];
}

-(NSString *)getStrDate:(NSString *)reportDate{
    double testTime = [reportDate doubleValue];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd-MM-YY";
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:testTime];
    
    
    NSString *monthString = [[dateFormatter stringFromDate:date] capitalizedString];
    return monthString;
}
-(NSString *)getStrDateChangeFormat:(NSString *)reportDate{
    double testTime = [reportDate doubleValue];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:NSLocale.currentLocale];
    dateFormatter.dateFormat = @"MM-dd-YY";
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:testTime];
    NSString *monthString = [dateFormatter stringFromDate:date];
    
    
    return monthString;
}
#pragma mark - SET UI METHOD -
-(void)designConstratin{
    if (IS_IPHONE_4_OR_LESS)
    {
        
    }
    else if(IS_IPHONE_5)
    {
        
        self.conHeightSwipeView.constant = 80;
        self.conWidthNoteView.constant = 280;
    }
    else if(IS_IPHONE_6)
    {
        
        self.conWidthNoteView.constant = 350;
        self.conHeightSwipeView.constant = 80;
    }
    else
    {
        
        self.conWidthNoteView.constant = 350;
        self.conTopChart.constant = 35 + 15;
        self.conHeightChart.constant = 250;
        self.conHeightSwipeView.constant = 90;
    }
}
-(void)setUI:(bool)isFromStart
{
    if (IS_IPHONE_4_OR_LESS) {
        self.conStep9Top.constant = 70;
    }else if (IS_IPHONE_6) {
        self.conStep9Top.constant = 130;
        
    } else if (IS_IPHONE_6P) {
        self.conStep9Top.constant = 150;
    }
    self.btnGotIt.layer.cornerRadius = 5;
    //     self.btnGotIt.hidden = YES;
    self.btnGotIt.alpha = 0.0;
    [self fadeIn:self.viewStap7 withDuration:0.5 andWait:1.0];
    viewStap = 0;
    self.btnGotIt.layer.borderWidth = 1;
    self.btnGotIt.layer.borderColor = [UIColor whiteColor].CGColor;
    self.viewStap7.layer.cornerRadius = 5;
    self.conGotItY.constant = 150;
    
    NSString *startUpView=[[NSUserDefaults standardUserDefaults] objectForKey:@"IntroductionScreen2"];
    if ([startUpView isEqualToString:@"YES"]) {
        self.viewIntro.hidden = NO;
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"IntroductionScreen2"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else{
        self.viewIntro.hidden = YES;
    }
    
    lblGraphName.text = [objTestReport.str_test_name capitalizedString];
    self.lblGreen.text = @"Great Job! Keep it up! 😊";
    
    for (UITextField *textField in arrayTextFields) {
        textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
        textField.layer.borderWidth = 1.0;
        textField.layer.cornerRadius = 3.0;
        textField.layer.masksToBounds = true;
        
        UIImageView *paddingView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        paddingView.image =[UIImage imageNamed:IMG_CALENDER_ICON];
        textField.leftView = paddingView;
        textField.leftViewMode = UITextFieldViewModeAlways;
    }
    
    NSString *strProfile = SAFESTRING(self.objMemberDetail.str_profile_pic);
    NSURL *UrlProfilePic = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_IMGS,strProfile]];
    
    [imgUserProfile sd_setImageWithURL:UrlProfilePic placeholderImage:[UIImage imageNamed:IMG_USER_PROFILE] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (image) {
            
            self->imgUserProfile.layer.borderColor = [UIColor whiteColor].CGColor;
            self->imgUserProfile.layer.borderWidth = 2.0;
            self->imgUserProfile.layer.cornerRadius = self->imgUserProfile.frame.size.width/2;
            self->imgUserProfile.layer.masksToBounds = true;
        }
        
    }];
    
    lblUserName.text = self.objMemberDetail.str_first_name;
    
    TestReportDetail *tempData = [_arrayUserAllReports objectAtIndex:_selectIndex];
    [self findMonthsData:tempData.array_All_Test_value]; //Pass Data From TempArray
    
    for(TestReportDetail *objTemp in self.objTestReport.array_Test_value)
    {
        double testTime = [objTemp.str_report_date doubleValue];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"MM-dd-yy";
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:testTime];
        NSLog(@"monthDATE: %@", date);
        dateFormatter.dateFormat=@"MMM";
        NSString *monthString = [[dateFormatter stringFromDate:date] capitalizedString];
        [arrayMonths addObject:monthString];
    }
    while (arrayMonths.count > 3) {
        [arrayMonths removeObjectAtIndex:0];
    }
    if (isFromStart){
        [self loadChartWithDates:objTestReport.array_Test_value];
    }else{
        NSMutableArray *arrFilter =[self getDataByFilteringDate:toTimeInterval toTime:fromTimeInterval FromTime:arrReportFilterData];
        if (arrFilter.count != 0){
            [self setUserTestData:arrFilter];//Pass month filter data
        }else{
            [self loadChartWithDates:objTestReport.array_Test_value];
        }
    }
    
    if ([_arrTestValueTemp[_selectIndex] isEqualToString:@"nan"]) {
        lblGraphName.numberOfLines = 1;
    }else{
        NSString *str = [NSString stringWithFormat:@"%@\nAverage : %@",[objTestReport.str_test_name capitalizedString],_arrTestValueTemp[_selectIndex]];
        lblGraphName.text = str;
    }
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
    
    PMPeriod *allowed = [PMPeriod periodWithStartDate:[[NSDate date] dateByAddingMonths:-6]
                                              endDate:[[NSDate date] dateByAddingMonths:+6]];
    
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
                    NSMutableArray *arrFilter = [self getDataByFilteringDate:toTimeInterval toTime:fromTimeInterval FromTime:arrReportFilterData];
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
                    NSMutableArray *arrFilter =[self getDataByFilteringDate:toTimeInterval toTime:fromTimeInterval FromTime:arrReportFilterData];
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

#pragma mark - GET SCREENSHOT METHOD

-(UIImage *)getScreenshotImage {
    CGRect rect = [self.viewScreenshort bounds];
    UIGraphicsBeginImageContextWithOptions(rect.size,YES,0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.viewScreenshort.layer renderInContext:context];
    UIImage *capturedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return capturedImage;
}

//local Time to UTC
-(void)getDateString{
    NSDateFormatter *dt = [[NSDateFormatter alloc]init];
    [dt setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss Z"];
    [dt setTimeZone:[NSTimeZone defaultTimeZone]];
    
    double secsUtc1970 = [[NSDate date]timeIntervalSince1970];
    NSDate* ts_utc1 = [NSDate dateWithTimeIntervalSince1970:secsUtc1970];
    
    NSLog(@"Date String UTC %@",[dt stringFromDate:ts_utc1]);
    
    [dt setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dt setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss Z"];
    
    NSLog(@"Date String UTC %@",[dt stringFromDate:ts_utc1]);
}

-(void)setUserTestData:(NSMutableArray *)arrDataByDate
{
    bufferArray = [[NSMutableArray alloc] init];
    arrayMonths =[[NSMutableArray alloc] init];
    
    if (arrDataByDate.count > 0) {
        [self loadChartWithDates:arrDataByDate];
        graphData.hidden=NO;
    }
    else{
        [UIAlertController infoAlertWithokAction:ALERT_NO_REPORT_FOUND andTitle:APPNAME controller:self completion:^(BOOL isClick) {
            self->toTimeInterval = 0;
            self->fromTimeInterval = 0;
            self->txtToDate.text = @"";
            self->txtFromDate.text = @"";
        }];
        graphData.hidden=YES;
        
    }
}
- (IBAction)btnLineGraphVCAction:(id)sender {
    LineGraphVC *graphReport = [self.storyboard instantiateViewControllerWithIdentifier:@"LineGraphVC"];
    
    TestReportDetail *obj = [[TestReportDetail alloc]init]; //Assign Null Object
    
    obj.str_test_parameter_unit = objTestReport.str_test_parameter_unit;
    obj.str_test_name = objTestReport.str_test_name;
    obj.array_Test_value = arrReportFilterData; //Add Filtered Data
    obj.str_test_maximum_value = objTestReport.str_test_maximum_value;
    obj.str_test_minimum_value = objTestReport.str_test_minimum_value;
    
    graphReport.objTestReport = obj;
    
    
    TestReportDetail *obj1 = [[TestReportDetail alloc]init]; //Assign Null Object
    
    obj1.str_test_parameter_unit = objTestReport.str_test_parameter_unit;
    obj1.str_test_name = objTestReport.str_test_name;
    obj1.array_Test_value = arrayUserTestReportTemp; //Add Filtered Data
    obj1.str_test_maximum_value = objTestReport.str_test_maximum_value;
    obj1.str_test_minimum_value = objTestReport.str_test_minimum_value;
    
    graphReport.objTestReportTemp = obj1;
    
    graphReport.objMemberDetail = self.objMemberDetail;
    graphReport.objTestReportTemp = [self.arrayUserTestReportTemp objectAtIndex:_selectIndex];
    
    graphReport.toTimeInterval = toTimeInterval;
    graphReport.fromTimeInterval = fromTimeInterval;
    
    [self.navigationController pushViewController:graphReport animated:YES];
}
- (IBAction)btnGotItAction:(id)sender {
    self.conGotItY.constant = 0;
    viewStap ++;
    switch (viewStap) {
        case 1:{
            self.conGotItY.constant = 150;
            [self fadeOut:self.viewStap7 withDuration:0.0 andWait:1.0];
            [self fadeIn:self.viewStap8 withDuration:1.0 andWait:1.0];
            break;
        }
        case 2:
            self.conGotItY.constant = 150;
            [self fadeOut:self.viewStap8 withDuration:0.0 andWait:1.0];
            [self fadeIn:self.viewStap9 withDuration:0.5 andWait:1.0];
            break;
        case 3:
            self.viewIntro.hidden = YES;
            break;
        default:
            break;
    }
}


-(void) fadeIn:(UIView*)viewToFadeIn withDuration:(NSTimeInterval)duration andWait:(NSTimeInterval)wait

{
    [UIView beginAnimations: @"Fade In" context:nil];
    
    // wait for time before begin
    [UIView setAnimationDelay:wait];
    
    // druation of animation
    [UIView setAnimationDuration:duration];
    viewToFadeIn.alpha = 1;
    self.btnGotIt.alpha = 1.0;
    
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

/*
 Use for find unique months and data
 */
-(void)findMonthsData:(NSMutableArray *)arrTestData{
    NSLog(@"All Month Data %@",arrTestData);
    
    NSMutableArray *arrMonthData = [NSMutableArray array];
    NSMutableArray *arrData = [NSMutableArray array];
    
    for (TestReportDetail *obj in arrTestData){
        NSString *timeStamp = obj.str_report_date;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStamp doubleValue]];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDate *currentDate = [NSDate date];
        NSDateComponents *componentsCurrent = [calendar components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:currentDate];
        NSDateComponents *componentsCompare = [calendar components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:date];
        
        NSNumber *val = [NSNumber numberWithInteger:componentsCompare.month];
        
        if ([arrData containsObject:val]){
            
        }else{
            [arrData addObject:val];
            [arrMonthData addObject:componentsCompare];
        }
    }
    
    NSLog(@"Month Data Count is %lu",(unsigned long)arrMonthData.count);
    [self filterDataByMonth:arrMonthData :arrTestData];
    
}

/*
 Use for divide array into months with data
 */

-(void)filterDataByMonth:(NSMutableArray *)arrTestData:(NSMutableArray *)arrAllTestData{
    NSLog(@"Month Data is %@",arrTestData);
    
    NSMutableArray *arrData = [NSMutableArray array];
    NSMutableArray *arrMonthData = [NSMutableArray array];
    
    for (NSDateComponents *dateComponent in arrTestData){
        arrData = [NSMutableArray array];;
        for (TestReportDetail *obj in arrAllTestData){
            
            NSDateComponents *comp = [self findDateComponent:obj];
            
            if (comp.year == dateComponent.year && comp.month == dateComponent.month){
                [arrData addObject:obj];
            }
        }
        [arrMonthData addObject:arrData];
        NSLog(@"ArrTest Log Datais %lu",arrMonthData.count);
    }
    [self getDatabyMonthWithAverage:arrMonthData];
}
/*
 Return Array with Month and average of specific month parameter Value
 */

-(NSMutableArray *)getDatabyMonthWithAverage:(NSMutableArray *)arrMonthData{
    NSMutableArray *arrWithAverage = [NSMutableArray array];
    
    for (NSMutableArray *arrMonth in arrMonthData){
        TestReportDetail *obj = [[TestReportDetail alloc]init]; //Assign Null Object For Assign Data
        float sum = 0;
        for (TestReportDetail *obj1 in arrMonth){
            NSString *strValue= obj1.str_test_parameter_value;
            sum+=[strValue floatValue];
            obj = obj1;
        }
        obj.str_test_parameter_value = [NSString stringWithFormat:@"%.2f",sum/arrMonth.count];
        [arrWithAverage addObject:obj];
    }
    arrReportFilterData = arrWithAverage;
    return arrWithAverage;
}

/*
 Use for compare datecomponent (to find unique months)
 */
-(NSDateComponents *)findDateComponent:(TestReportDetail *)obj{
    NSString *timeStamp = obj.str_report_date;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStamp doubleValue]];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *componentsCompare = [calendar components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:date];
    return componentsCompare;
}
/*
 Get data using date filter
 */

-(NSMutableArray *)getDataByFilteringDate:(double)timeIntervalToDate toTime:(double)timeIntervalFromDate FromTime:(NSMutableArray *)arrFilteredArray{
    NSMutableArray *arrDataFromDate = [NSMutableArray array];
    for (TestReportDetail *obj in arrFilteredArray) {
        NSString *timeStampCurrentDate = obj.str_report_date;
        
        if ([timeStampCurrentDate doubleValue] >= (timeIntervalFromDate - 66700) && [timeStampCurrentDate doubleValue] <= (timeIntervalToDate - 66700) ) {
            [arrDataFromDate addObject: obj];
        }else{
            
        }
    }
    return  arrDataFromDate;
}


@end
