//
//  LineGraphVC.m
//  OneTrackHealth
//
//  Created by Pragnesh Dixit on 11/07/17.
//  Copyright © 2017 Tristate. All rights reserved.
//

#import "LineGraphVC.h"
#import "Constants.h"
#import "UIImageView+WebCache.h"
#import "Webservice.h"

@interface LineGraphVC ()

@end

@implementation LineGraphVC
@synthesize lineChart,imgUserProfile,txtFromDate,txtToDate,lblGraphName,lblUserName,arrayTextFields,objTestReport,objTestReportTemp;


#pragma mark - VIEW LIFECYCLE METHODS -

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"> > > > > > > > > > > >%@ > > > > > > > > >",NSStringFromClass([self class]));
    // Do any additional setup after loading the view.
    [USERDEFAULTS setObject:@"0" forKey:@"DASHBOARD"];
    objUserDetail=[UserDetail sharedInstance];
    objUserDetail=[objUserDetail getDetail];
    
    arrayMonths =[[NSMutableArray alloc] init];
    
   
    if (_fromTimeInterval != 0 || _toTimeInterval != 0) {
        toTimeInterval = _toTimeInterval;
        fromTimeInterval = _fromTimeInterval;
        [self setDate];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [self setUI];
    if (fromTimeInterval != 0 || toTimeInterval != 0) {
        [self setUserTestData];
    }
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

-(void)apiCallForSaveEmail:(NSString *) strEmail composer: (MFMailComposeViewController*)mailComposer {
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
        bufferArray = [[NSMutableArray alloc] init];
        arrayMonths =[[NSMutableArray alloc] init];
        
        for(TestReportDetail *objTemp in self.objTestReport.array_Test_value)
        {
            double testTime = [objTemp.str_report_date doubleValue];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"MM-dd-yyyy";
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:testTime];
            
            dateFormatter.dateFormat=@"MMM";
            NSString *monthString = [[dateFormatter stringFromDate:date] capitalizedString];
            
            [bufferArray addObject:objTemp];
            [arrayMonths addObject:monthString];
        }
        
        if (bufferArray.count > 0) {
            [self loadChartWithDates:bufferArray];
            lineChart.hidden=NO;
        }
        else{
            [UIAlertController infoAlertWithMessage:ALERT_NO_REPORT_FOUND andTitle:APPNAME controller:self];
            
            lineChart.hidden=YES;
        }
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
    // Close the Mail Interface
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Save Data in CSV
- (void) saveDataToCSV {
    NSMutableArray *arrData = [[NSMutableArray alloc]init];
    arrData = objTestReportTemp.array_Test_value;
    
    NSMutableString *csvString = [[NSMutableString alloc]initWithCapacity:0];
    [csvString appendString:@"Date, Lab Name, Notes,  Normal Range, Test Value, \n"];
    
    NSMutableArray *arrFilter = [self getDataByFilteringDate:toTimeInterval toTime:fromTimeInterval FromTime:arrData];
    if (arrFilter.count > 0){
        [arrData removeAllObjects];
        arrData = arrFilter;
    }
    
    for (TestReportDetail *objTemp in arrData) {
        NSString *strReportDate = [self getStrDate:objTemp.str_report_date];
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

-(void)setDate{
    NSDateFormatter *formater =[[NSDateFormatter alloc] init];
    [formater setDateFormat:@"dd-MMM-yyyy"];
    NSDate *date =[NSDate dateWithTimeIntervalSince1970:toTimeInterval - 86500 - 86400];
    NSString *strDate = [formater stringFromDate:date];
    txtToDate.text = strDate;
    
    NSDate *date1 =[NSDate dateWithTimeIntervalSince1970:fromTimeInterval - 86500];
    NSString *strDate1 = [formater stringFromDate:date1];
    txtFromDate.text = strDate1;
}

#pragma mark - DISPLAY GRAPH METHOD -
- (void)loadChartWithDates:(NSMutableArray *)arrayTest
{
    NSInteger tempMaxCount=arrayTest.count;
    NSMutableArray* testValue = [NSMutableArray arrayWithCapacity:tempMaxCount];
    
    NSMutableString *csvString = [[NSMutableString alloc]initWithCapacity:0];
    [csvString appendString:@"Date, Lab Name, Notes,  Normal Range, Test Value, \n"];
    
    BOOL isHight = false;
    
    for(int i=0;i<tempMaxCount;i++) {
        
        TestReportDetail *objTemp = [arrayTest objectAtIndex:i];
        testValue[i] = [NSNumber numberWithFloat:[objTemp.str_test_parameter_value floatValue]];
        NSString *strReportDate = [self getStrDate:objTemp.str_report_date];
        NSString *strNormalRange=[NSString stringWithFormat:@"%@ - %@",objTestReport.str_test_minimum_value,objTestReport.str_test_maximum_value];
        
        [csvString appendString:[NSString stringWithFormat:@"%@, %@, %@, %@, %@\n",strReportDate,objTemp.str_report_Lab,objTemp.str_report_Description,strNormalRange,objTemp.str_test_parameter_value]];
        
        if ([objTestReport.str_test_maximum_value floatValue] < [objTemp.str_test_parameter_value floatValue]) {
            isHight = true;
        }
    }
    
    [self saveDataToCSV];
    if (isHight == true) {
        _heightChat.constant=700;
    }else{
        _heightChat.constant=170;
    }
     _heightChat.constant=170;
    
    // Setting up the line chart
    //viewGraph.gridStep=3;
    lineChart.verticalGridStep = 3;
    lineChart.horizontalGridStep =(int)arrayMonths.count;
    lineChart.fillColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.5 alpha:0.1];
    lineChart.displayDataPoint = YES;
    
    lineChart.valueLabelFont = [UIFont fontWithName:FONT_ITCAVANTGARDESTD_BK size:10.0];
    lineChart.indexLabelFont =[UIFont fontWithName:FONT_ITCAVANTGARDESTD_BK size:12.0];
    lineChart.animationDuration = 0.5;
    
    lineChart.dataPointBackgroundColor = [UIColor blueColor];
    lineChart.dataPointRadius = 2.0;
    lineChart.dataPointColor = [UIColor blueColor];
    lineChart.lineWidth = 2.0;
    
    lineChart.color = [lineChart.dataPointColor colorWithAlphaComponent:0.3];
    lineChart.valueLabelPosition = ValueLabelLeftMirrored;
    
    lineChart.minValue = [objTestReport.str_test_minimum_value floatValue];
    lineChart.maxValue =[objTestReport.str_test_maximum_value floatValue];
    
    float maxValue = 0.0;
    for (NSString * strMaxi in testValue) {
        float currentValue=[strMaxi floatValue];
        if (currentValue > maxValue) {
            maxValue=currentValue;
        }
    }
    float miniValue = 0.0;
    for (NSString * strMini in testValue) {
        float currentValue=[strMini floatValue];
        if (currentValue < miniValue) {
            miniValue=currentValue;
        }
    }
    float midpoint = (maxValue + miniValue) / 2;
    lineChart.minValue = miniValue;
    lineChart.maxValue=maxValue+midpoint;
    
    lineChart.labelForIndex = ^(NSUInteger item) {
        return self->arrayMonths[item];
    };
    
    lineChart.labelForValue = ^(CGFloat value) {
        return [NSString stringWithFormat:@"%.0f %@", value,self->objTestReport.str_test_parameter_unit];
    };
    
    lineChart.valueLabelPosition=ValueLabelLeft;
    lineChart.indexLabelTextColor=[UIColor blackColor];
    [lineChart setChartData:testValue];
    
    
    [self performSelector:@selector(scrollview) withObject:nil afterDelay:0.2];
}
-(void)scrollview{
    CGPoint bottomOffset = CGPointMake(0, self.scrollViewChart.contentSize.height - self.scrollViewChart.bounds.size.height);
    [self.scrollViewChart setContentOffset:bottomOffset animated:YES];
}
-(NSString *)getStrDate:(NSString *)reportDate{
    double testTime = [reportDate doubleValue];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MM-dd-YY";
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:testTime];
    
    
    NSString *monthString = [[dateFormatter stringFromDate:date] capitalizedString];
    return monthString;
}

#pragma mark - SET UI METHOD -

-(void)setUI
{
    lblGraphName.text = [objTestReport.str_test_name capitalizedString];
    
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
    
    
    for(TestReportDetail *objTemp in self.objTestReport.array_Test_value)
    {
        double testTime = [objTemp.str_report_date doubleValue];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"MM-dd-yy";
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:testTime];
        
        dateFormatter.dateFormat=@"MMM";
        NSString *monthString = [[dateFormatter stringFromDate:date] capitalizedString];
        [arrayMonths addObject:monthString];
    }
    [self loadChartWithDates:objTestReport.array_Test_value];
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
                    [self setUserTestData];
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
                    [self setUserTestData];
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

#pragma mark - SET ARRAY BASED ON DATE SELECTION :- setuserTestData Method -
-(void)setUserTestData
{
    bufferArray = [[NSMutableArray alloc] init];
    arrayMonths =[[NSMutableArray alloc] init];
    
    for (TestReportDetail *obj in self.objTestReport.array_Test_value) {
        double testTime = [obj.str_report_date doubleValue];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"MM-dd-yyyy";
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:testTime];
        
        dateFormatter.dateFormat=@"MMM";
        NSString *monthString = [[dateFormatter stringFromDate:date] capitalizedString];
        
        NSString *timeStampCurrentDate = obj.str_report_date;
        
        if ([timeStampCurrentDate doubleValue] >= (fromTimeInterval - 66700) && [timeStampCurrentDate doubleValue] <= (toTimeInterval - 66700) ) {
            NSLog(@"From Current To Inside %f  %@  %f", fromTimeInterval,timeStampCurrentDate,toTimeInterval);
            [bufferArray addObject:obj];
            [arrayMonths addObject:monthString];
        }else{
            NSLog(@"From Current To Not Inside %f  %@  %f", fromTimeInterval,timeStampCurrentDate,toTimeInterval);
        }
    }
    
    if (bufferArray.count > 0) {
        [self loadChartWithDates:bufferArray];
        lineChart.hidden=NO;
    }
    else{
        [UIAlertController infoAlertWithMessage:ALERT_NO_REPORT_FOUND andTitle:APPNAME controller:self];
        //[lineChart clearChartData];
        lineChart.hidden=YES;
    }
}

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
