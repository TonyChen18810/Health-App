//
//  MemberDetailVC.m
//  HealthZip
//
//  Created by Tristate on 6/1/16.
//  Copyright © 2016 Tristate. All rights reserved.
//

#import "MemberDetailVC.h"
#import "Constants.h"
#import "UIImageView+WebCache.h"
#import "Webservice.h"
#import "TestParameterCell.h"
#import "TestParameterDetail.h"
#import "AddTestReportVC.h"


@interface MemberDetailVC ()

@end


@implementation MemberDetailVC

@synthesize objMemberDetail,tblTestParameter,textViewNote,arrayTextFields,txtDate,txtLaboratoryName;

#pragma mark - VIEW LIFECYCLE METHODS -
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"> > > > > > > > > > > >%@ > > > > > > > > >",NSStringFromClass([self class]));
    // Do any additional setup after loading the view.
    
    [tblTestParameter registerNib:[UINib nibWithNibName:@"TestParameterCell" bundle:nil] forCellReuseIdentifier:@"TestParameterCell"];
    tblTestParameter.separatorStyle= UITableViewCellSeparatorStyleNone;
    
    arrayTestParameterList=[[NSMutableArray alloc] init];
    [self setUserData];
    [self getUserTestReport];
    
//    self.automaticallyAdjustsScrollViewInsets=NO;
    //textViewNote.contentInset = UIEdgeInsetsMake(0,20,0,0);
//   
}

-(void)viewDidAppear:(BOOL)animated
{
    objUserDetail=[UserDetail sharedInstance];
    objUserDetail=[objUserDetail getDetail];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - SET USERDATA METHOD -
-(void)setUserData
{
    self.lblUserName.text=objMemberDetail.str_first_name;
    
    NSString *strImageName =[objMemberDetail.str_profile_pic stringByRemovingPercentEncoding];
    if ([strImageName length] > 0) {
        
        NSString *strPhotoUrl = [NSString stringWithFormat:@"%@%@",URL_IMGS,strImageName];
        NSURL *urlPhoto = [NSURL URLWithString:strPhotoUrl];
        
        //[cell.spiner startAnimating];
        [self.imgUserProfile sd_setImageWithURL:urlPhoto placeholderImage:[UIImage imageNamed:IMG_USER_PROFILE] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image == nil) {
                //display default image
            }
            //[cell.spiner stopAnimating];
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
    
    cell.lblParameterName.text = objTestParam.str_test_parameter_name;
    cell.lblNormalValue.text = [NSString stringWithFormat:@"%@ %@",objTestParam.str_test_parameter_maximum_ratio,objTestParam.str_test_parameter_unit];
    cell.lblValueUnit.text =objTestParam.str_test_parameter_unit;
    
    return cell;
}


#pragma mark - BUTTON CLICK ACTION -

- (IBAction)btnAddNewReportClickAction:(id)sender {
    
    AddTestReportVC *objAddtestVC =[self.storyboard instantiateViewControllerWithIdentifier:@"AddTestReportVC"];
    objAddtestVC.objMemberDetail=objMemberDetail;
    [self.navigationController pushViewController:objAddtestVC animated:YES];
}

- (IBAction)btnBackClickAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnDoneClickAction:(id)sender
{
    
}

#pragma mark - WEBSERVICE CALL : For User Test Report -

-(void)getUserTestReport
{
    if ([self isNetworkReachable]) {
        [self showSpinnerWithUserActionEnable:false];
        
        Webservice *webserviceObj = [[Webservice alloc]init];
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        
        [dictParam setObject:SAFESTRING([objMemberDetail.str_user_id trimSpaces]) forKey:@"user_id"];
        [webserviceObj callJSONMethod:@"get_test_parameter" withParameters:dictParam isEncrpyted:NO onSuccessfulResponse:^(NSMutableDictionary *dict) {
            
            [self hideSpinner];
            NSString *strMsg=[dict valueForKey:@"message"];
            
            if ([[dict valueForKey:@"status"] integerValue] == 1 ) {
                self->arrayTestParameterList=[TestParameterDetail initWithArray:[dict valueForKey:@"data"]];
                [self->tblTestParameter reloadData];
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

    if ([self.pmCC isCalendarVisible])
    {
        [self.pmCC dismissCalendarAnimated:NO];
    }
    
    BOOL isPopover = YES;
    
    // limit apple calendar to 2 months before and 2 months after current date
    PMPeriod *allowed = [PMPeriod periodWithStartDate:[[NSDate date] dateByAddingMonths:-2]
                                              endDate:[[NSDate date] dateByAddingMonths:2]];
    

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
  
    return NO;
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

@end
