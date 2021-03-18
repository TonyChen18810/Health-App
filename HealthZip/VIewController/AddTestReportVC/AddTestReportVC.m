//
//  AddTestReportVC.m
//  HealthZip
//
//  Created by Tristate on 6/3/16.
//  Copyright © 2016 Tristate. All rights reserved.
//

#import "AddTestReportVC.h"
#import "TestParameterCell.h"
#import "Constants.h"
#import "UIImageView+WebCache.h"

#import "TestParameterDetail.h"
#import "IQKeyboardManager.h"
#import "BaseViewController.h"

@interface AddTestReportVC ()

@end

@implementation AddTestReportVC
@synthesize tblTestParameter,objMemberDetail,viewForTestparameterBG,txtTestValue;
@synthesize textViewNote,arrayTextFields,txtDate,txtLaboratoryName;
@synthesize arrayTestValue;
#pragma mark VIEW LIFECYCLE METHODS

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"> > > > > > > > > > > >%@ > > > > > > > > >",NSStringFromClass([self class]));
    // Do any additional setup after loading the view.
    [USERDEFAULTS setObject:@"0" forKey:@"DASHBOARD"];
     webserviceObj = [[Webservice alloc]init];
    
    [tblTestParameter registerNib:[UINib nibWithNibName:@"TestParameterCell" bundle:nil] forCellReuseIdentifier:@"TestParameterCell"];
    tblTestParameter.separatorStyle= UITableViewCellSeparatorStyleNone;
    
    arrayTestValue=[[NSMutableArray alloc] init];
    arrayTestParameterList=[[NSMutableArray alloc] init];
    CGRect frame = CGRectMake(tblTestParameter.frame.origin.x,0,tblTestParameter.frame.size.width ,165);
    
    self.viewForHeader.frame = frame;
    tblTestParameter.tableHeaderView = self.viewForHeader;
    [self setUserData];
    if (_dictUpdate) {
        [self callUpdateParameterWebservice];

        NSDateFormatter *formater =[[NSDateFormatter alloc] init];
        [formater setDateFormat:@"dd-MMM-yyyy"];
        NSDate *date =[NSDate dateWithTimeIntervalSince1970:[[_dictUpdate objectForKey:@"report_date"] floatValue]];
        NSString *strDate = [formater stringFromDate:date];
        self.txtDate.text = strDate;
        self.txtLaboratoryName.text=[_dictUpdate objectForKey:@"report_lab"];
        self.textViewNote.text=[_dictUpdate objectForKey:@"report_description"];
    } else {
        [self callGetTestParameterWebservice];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    objUserDetail=[UserDetail sharedInstance];
    objUserDetail=[objUserDetail getDetail];
}

-(void)viewDidAppear:(BOOL)animated
{
  
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)isUpdateTestListListTable{
    if (_dictUpdate) {
        [self callUpdateParameterWebservice];
    } else {
        [self callGetTestParameterWebservice];
    }
}
#pragma mark - SET USERDATA METHOD -
-(void)setUserData
{
    self.lblUserName.text=objMemberDetail.str_first_name;
    NSString *strName =@"kidney";
    
    strName =  [strName uppercaseString];
    self.lblTestName.text = strName;
    
    NSString *strImageName =[objMemberDetail.str_profile_pic stringByRemovingPercentEncoding];
    if ([strImageName length] > 0) {
        
        NSString *strPhotoUrl = [NSString stringWithFormat:@"%@%@",URL_IMGS,strImageName];
        NSURL *urlPhoto = [NSURL URLWithString:strPhotoUrl];
        
        [self.imgUserProfile sd_setImageWithURL:urlPhoto placeholderImage:[UIImage imageNamed:IMG_USER_PROFILE] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image == nil) {
                //display default image
            }
        }];
        self.imgUserProfile.layer.cornerRadius=self.imgUserProfile.frame.size.width/2;
        self.imgUserProfile.layer.masksToBounds=YES;
        self.imgUserProfile.layer.borderWidth=2.0;
        self.imgUserProfile.layer.borderColor=[UIColor whiteColor].CGColor;
        
    }
    
    for (UITextField *textField in arrayTextFields) {
        
        textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
        textField.layer.borderWidth = 1.0;
        textField.layer.cornerRadius = 3.0;
        textField.layer.masksToBounds = true;
        
        
        if (textField == txtDate) {
            
            UIImageView *paddingView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
            paddingView.image =[UIImage imageNamed:IMG_CALENDER_ICON];
            textField.leftView = paddingView;
            
        }
        else{
            UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 18, 20)];
            textField.leftView = paddingView;
            
        }
        
        textField.leftViewMode = UITextFieldViewModeAlways;
        
        UIView *rightPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
        textField.rightView = rightPaddingView;
        textField.rightViewMode = UITextFieldViewModeAlways;
        
    }
    
    textViewNote.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textViewNote.layer.borderWidth = 1.0;
    textViewNote.layer.cornerRadius = 3.0;
    textViewNote.layer.masksToBounds = true;
    
    
}


#pragma mark BUTTON CLICK ACTION
- (IBAction)btnAddClickAction:(id)sender {
    if ([self validateAllTestValue]) {
    
    }

}

- (IBAction)btnCancelClickAction:(id)sender{
    viewForTestparameterBG.hidden=YES;
    txtTestValue.text=@"";
    
}

- (IBAction)btnSubmitReportClickAction:(id)sender {
    
    }

- (IBAction)btnAddNewReportClickAction:(id)sender {
    
    AddTestReportVC *objAddtestVC =[self.storyboard instantiateViewControllerWithIdentifier:@"AddTestReportVC"];
    objAddtestVC.objMemberDetail=objMemberDetail;
    [self.navigationController pushViewController:objAddtestVC animated:YES];
}


- (IBAction)btnDoneClickAction:(id)sender
{
    [self.view endEditing:YES];
    if ([self validateAllTestValue]) {
        [self callWebserviceToUploadData];
    }
}

- (IBAction)btnBackClickAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnAddTestAction:(id)sender {
    AddNewTestVC *addTestVC=[self.storyboard instantiateViewControllerWithIdentifier:@"AddNewTestVC"];
    addTestVC.delegate = self;
    
    if (_dictUpdate) {
        addTestVC.strUserId=SAFESTRING([_dictUpdate objectForKey:@"user_id"]);
    } else {
        addTestVC.strUserId=SAFESTRING([objMemberDetail.str_user_id trimSpaces]);
    }
    [self.navigationController pushViewController:addTestVC animated:YES];
}

#pragma mark - TABLEVIEW DELEGATE AND DATASOURCE METHODS -

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (arrayTestParameterList .count > 0) {
        
        //        TestParameterDetail *objTestParam =[arrayTestParameterList objectAtIndex:section];
        //        return [objTestParam.arrayTestList count];
        return arrayTestParameterList.count;
    }
    else
    {
        return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TestParameterCell *cell =[tblTestParameter dequeueReusableCellWithIdentifier:@"TestParameterCell" forIndexPath:indexPath];
    TestParameterDetail *objTestParam =[arrayTestParameterList objectAtIndex:indexPath.row];
    cell.tag = indexPath.row;
    //cell.txtTestValue.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    cell.delegate = self;
    cell.lblParameterName.text = [objTestParam.str_test_parameter_name capitalizedString];
    cell.lblNormalValue.text = [NSString stringWithFormat:@"%@ - %@ %@",objTestParam.str_test_parameter_minimum_ratio,objTestParam.str_test_parameter_maximum_ratio,objTestParam.str_test_parameter_unit];
    cell.lblValueUnit.text =objTestParam.str_test_parameter_unit;
    cell.minVal=[objTestParam.str_test_parameter_minimum_ratio floatValue];
    cell.maxVal=[objTestParam.str_test_parameter_maximum_ratio floatValue];
    NSMutableDictionary *dict =[arrayTestValue objectAtIndex:cell.tag];
    if ([[dict valueForKey:@"name"] isEqualToString:cell.lblParameterName.text]) {
        cell.txtTestValue.text = [dict valueForKey:@"test_val"];
    }else if (_dictUpdate){
        cell.txtTestValue.text = [dict valueForKey:@"test_val"];
    }
    if (cell.minVal <= [cell.txtTestValue.text floatValue] && cell.maxVal >= [cell.txtTestValue.text floatValue]) {
        cell.txtTestValue.textColor = COLORCODE_GREEN;
    }else{
        cell.txtTestValue.textColor = COLORCODE_RED;
       
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    [self.view endEditing:YES];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    TestParameterDetail *objTestParam =[arrayTestParameterList objectAtIndex:indexPath.row];
    if (![objTestParam.str_test_user_id isEqualToString:@"0"]) {
        
    }else{
         [UIAlertController infoAlertWithMessage:@"Sorry, You can't delete this test because it's created by Admin." andTitle:APPNAME controller:self];
        return;
    }
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //remove the deleted object from your data source.
        //If your data source is an NSMutableArray, do this
        if ([self isNetworkReachable]) {
            [self showSpinnerWithUserActionEnable:false];
            
            //{"method_name":"get_test_parameter","body":{"user_id":"1"}}
            NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
            [dictParam setObject:SAFESTRING([objTestParam.str_test_parameter_id trimSpaces]) forKey:@"parameterId"];
            [webserviceObj callJSONMethod:@"deleteTestParameter" withParameters:dictParam isEncrpyted:NO onSuccessfulResponse:^(NSMutableDictionary *dict) {
                
                [self hideSpinner];
                NSString *strMsg=[dict valueForKey:@"message"];
                
                if ([[dict valueForKey:@"status"] integerValue] == 1 ) {
                    
                    [self->arrayTestParameterList removeObjectAtIndex:indexPath.row];
                    [self->arrayTestValue removeObjectAtIndex:indexPath.row];
                    [tableView reloadData]; // tell table to refresh now
                }
                else{
                    [UIAlertController infoAlertWithMessage:strMsg andTitle:APPNAME  controller:self];
                }
                
                
            } onFailure:^(NSError *error) {
                [UIAlertController infoAlertWithMessage:[error localizedDescription] andTitle:APPNAME  controller:self];
                [self hideSpinner];
            }];
        }
        else{
            [UIAlertController infoAlertWithMessage:ALERT_NO_INTERNET andTitle:APPNAME  controller:self];
        }
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
#pragma mark -  TESTPARAMETR CELL DELEGATE METHOD -

-(void)getTestValue:(TestParameterCell *)cell
{
    NSMutableDictionary *dict =[arrayTestValue objectAtIndex:cell.tag];
    NSString *strParamName =[cell.lblParameterName.text lowercaseString];
    NSString *strDictName =[[dict valueForKey:@"name"] lowercaseString];
    
    if ([[strDictName trimSpaces] isEqualToString:[strParamName trimSpaces]]) {
        
        [dict setValue:SAFESTRING(cell.txtTestValue.text) forKey:@"test_val"];
        
    }
}

#pragma mark - SET ARRAY METHOD -
-(void)createTestValueArray
{
    [arrayTestValue removeAllObjects];
    for (int i =0; i< arrayTestParameterList.count; i++) {
        TestParameterDetail *objTemp = [arrayTestParameterList objectAtIndex:i];
        
        NSMutableDictionary *dict =[[NSMutableDictionary alloc] init];
        [dict setObject:SAFESTRING(objTemp.str_test_parameter_name) forKey:@"name"];
        [dict setObject:SAFESTRING(objTemp.str_test_parameter_id) forKey:@"test_id"];
        if (_dictUpdate) {
            [dict setObject:SAFESTRING(objTemp.str_test_parameter_value)forKey:@"test_val"];
        }else{
            [dict setObject:@""forKey:@"test_val"];
        }
        
        
        
        [arrayTestValue addObject:dict];
    }
    
    
}
#pragma mark - WEBSERVICE CALL : For User Test Report -

-(void)callUpdateParameterWebservice
{
    
    if ([self isNetworkReachable]) {
        [self showSpinnerWithUserActionEnable:false];
        
        //{"method_name":"get_test_parameter","body":{"user_id":"1"}}
        
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        
        [dictParam setObject:SAFESTRING([_dictUpdate objectForKey:@"user_id"]) forKey:@"user_id"];
        [dictParam setObject:SAFESTRING([_dictUpdate objectForKey:@"report_id"]) forKey:@"report_id"];
        [webserviceObj callJSONMethod:@"user_report_details" withParameters:dictParam isEncrpyted:NO onSuccessfulResponse:^(NSMutableDictionary *dict) {
            
            [self hideSpinner];
            NSString *strMsg=[dict valueForKey:@"message"];
            
            if ([[dict valueForKey:@"status"] integerValue] == 1 ) {
                
                //[UIAlertController infoAlertWithMessage:[dict valueForKey:@"message"] andTitle:APPNAME controller:self];
                
                self->arrayTestParameterList=[TestParameterDetail initWithArray:[dict valueForKey:@"data"]];
                [self createTestValueArray];
                [self.tblTestParameter reloadData];
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

-(void)callGetTestParameterWebservice
{
    
    if ([self isNetworkReachable]) {
        [self showSpinnerWithUserActionEnable:false];
        
        //{"method_name":"get_test_parameter","body":{"user_id":"1"}}
        
      
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        
        [dictParam setObject:SAFESTRING([objMemberDetail.str_user_id trimSpaces]) forKey:@"userId"];
        [webserviceObj callJSONMethod:@"get_test_parameter" withParameters:dictParam isEncrpyted:NO onSuccessfulResponse:^(NSMutableDictionary *dict) {
            
            [self hideSpinner];
            NSString *strMsg=[dict valueForKey:@"message"];
//             [USERDEFAULTS setObject:@"1" forKey:@"DASHBOARD"];
            if ([[dict valueForKey:@"status"] integerValue] == 1 ) {
                
                //[UIAlertController infoAlertWithMessage:[dict valueForKey:@"message"] andTitle:APPNAME controller:self];
                
                self->arrayTestParameterList=[TestParameterDetail initWithArray:[dict valueForKey:@"data"]];
                [self createTestValueArray];
                [self.tblTestParameter reloadData];
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

-(void)callWebserviceToUploadData
{
    if ([self isNetworkReachable]) {
        [self showSpinnerWithUserActionEnable:false];
       
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        
        NSDateFormatter *formater =[[NSDateFormatter alloc] init];
        [formater setDateFormat:@"dd-MMM-yyyy"];
        
        NSDate *date = [self appendTimeandDate:txtDate.text]; //Get Time By Append Current TIme and Selected Date
        NSTimeInterval interval  = [date timeIntervalSince1970] ;
        NSString *strTime = [NSString stringWithFormat:@"%d",(int)interval];
        
        [dictParam setObject:SAFESTRING([objMemberDetail.str_user_id trimSpaces]) forKey:@"user_id"];
        [dictParam setObject:SAFESTRING([strTime trimSpaces]) forKey:@"report_date"];
        
        for (int i = 0; i<arrayTestValue.count; i++) {
            [[arrayTestValue objectAtIndex:i] removeObjectForKey:@"name"];
        }
        
        [dictParam setObject:SAFESTRING(textViewNote.text) forKey:@"reportDescription"];
        [dictParam setObject:SAFESTRING(txtLaboratoryName.text) forKey:@"reportLab"];
        [dictParam setObject:arrayTestValue forKey:@"report_array"];
        NSString *strWebserviceName;
        if (_dictUpdate) {
            strWebserviceName = @"update_user_report_details";
            [dictParam setObject:SAFESTRING([_dictUpdate objectForKey:@"user_id"]) forKey:@"user_id"];
            [dictParam setObject:SAFESTRING([_dictUpdate objectForKey:@"report_id"]) forKey:@"report_id"];
        } else {
            strWebserviceName = @"insert_report";
        }
       
        [webserviceObj callJSONMethod:strWebserviceName withParameters:dictParam isEncrpyted:NO onSuccessfulResponse:^(NSMutableDictionary *dict) {
            
            [self hideSpinner];
            NSString *strMsg=[dict valueForKey:@"message"];
            if ([[dict valueForKey:@"status"] integerValue] == 1 ) {
                
                [UIAlertController infoAlertWithokAction:[dict valueForKey:@"message"] andTitle:APPNAME controller:self completion:^(BOOL isEdit) {
                    [self.navigationController popViewControllerAnimated:YES];
                    if ([self.delegate respondsToSelector:@selector(isUpdateTestReport:)]) {
                        [self.delegate isUpdateTestReport:self.objMemberDetail.str_user_id];
                    }
                }];
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


#pragma mark TEXTFIELD DELEGATE METHODS

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textViewNote.text isEqualToString:@""]) {
        
        textViewNote.text=@"Note";
        textViewNote.textColor = COLORCODE_TEXT_LIGHT_GRAY;
    }
    [textViewNote resignFirstResponder];
    
    if (textField == txtDate) {
        
        if ([self.pmCC isCalendarVisible])
        {
            [self.pmCC dismissCalendarAnimated:NO];
        }
        
        BOOL isPopover = YES;
        
        // limit apple calendar to 2 months before and 2 months after current date
        PMPeriod *allowed = [PMPeriod periodWithStartDate:[[NSDate date] dateByAddingMonths:-6] endDate:[[NSDate date] dateByAddingMonths:+0]];
        
        
        self.pmCC = [[PMCalendarController alloc] initWithThemeName:@"default" andSize:CGSizeMake(240,200)];
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
        [self.view endEditing:YES];
        return NO;

    }
    else
    {
        return YES;
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark TEXTVIEW DELEGATE METHODS

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Note"]) {
        textView.text =@"";
        textView.textColor = COLORCODE_TEXT_BLACK;
       
    }
    return YES;
}

- (BOOL) textView: (UITextView*) textView shouldChangeTextInRange: (NSRange) range
  replacementText: (NSString*) text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        if ([textView.text isEqualToString:@""]) {
            
            textView.text=@"Note";
            textViewNote.textColor = COLORCODE_TEXT_LIGHT_GRAY;
        }
        return NO;
    }
    return YES;
}


#pragma mark - CALENDAR DELEGATE METHODS -
- (void)calendarController:(PMCalendarController *)calendarController didChangePeriod:(PMPeriod *)newPeriod
{
    NSString *date = [NSString stringWithFormat:@"%@"
                      , [newPeriod.startDate dateStringWithFormat:@"dd-MMM-yyyy"]];
    
    if (self.pmCC.isOnlyMonthChnaged) {
        //NSLog(@"Month has been changed!!");
    }
    else{
        //NSLog(@"Date is selected!!");
        self.txtDate.text=date;
        [self.pmCC dismissCalendarAnimated:NO];
    }
    
}

#pragma mark - VALIDATION METHOD -

-(BOOL)validateAllTestValue
{
    
    if (txtDate.text.length <= 0) {
        [UIAlertController infoAlertWithMessage:ALERT_SELECT_DATE andTitle:APPNAME controller:self];
        return NO;
    }
    else if (txtLaboratoryName.text.length <= 0) {
        [UIAlertController infoAlertWithMessage:ALERT_LAB_NAME_REQUIRED andTitle:APPNAME controller:self];
        return NO;
    }

    BOOL check=NO;
    for (int i = 0; i<arrayTestParameterList.count; i++) {
        
        NSMutableDictionary *dict = [arrayTestValue objectAtIndex:i];
        NSString *strValue= [dict valueForKey:@"test_val"];
        
        if ([strValue length] > 0) {
            NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
            nf.decimalSeparator = @".";
            BOOL isDecimal = [nf numberFromString:strValue] != nil;
            if (!isDecimal) {
                [UIAlertController infoAlertWithMessage:[NSString stringWithFormat:@"please enter valid value of %@",[dict valueForKey:@"name"]] andTitle:APPNAME controller:self];
                return NO;
            }
            check = YES;
        }
       
    }
    if (check==YES) {
        return YES;
    }else{
        [UIAlertController infoAlertWithMessage:[NSString stringWithFormat:@"please enter any test value"] andTitle:APPNAME controller:self];
        return NO;
    }
    
}

@end
