//
//  EditReportListVC.m
//  OneTrackHealth
//
//  Created by Pragnesh Dixit on 18/11/16.
//  Copyright © 2016 Tristate. All rights reserved.
//

#import "EditReportListVC.h"
#import "TestOptionCell.h"
@interface EditReportListVC ()

@end

@implementation EditReportListVC
@synthesize btnBack,objMemberDetail;
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"> > > > > > > > > > > >%@ > > > > > > > > >",NSStringFromClass([self class]));
    
    webserviceObj = [[Webservice alloc]init];
   
    [USERDEFAULTS setObject:@"0" forKey:@"DASHBOARD"];
    _arrReportList=[NSMutableArray array];
    _lblViewTitle.text=_strTitle;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    objUserDetail=[UserDetail sharedInstance];
    objUserDetail=[objUserDetail getDetail];
    [self callGetTestReportWebservice];
}

#pragma mark - WEBSERVICE CALL : For User Test Report -

-(void)callGetTestReportWebservice
{
    if ([self isNetworkReachable]) {
        [self showSpinnerWithUserActionEnable:false];
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        
        [dictParam setObject:SAFESTRING([objMemberDetail.str_user_id trimSpaces]) forKey:@"user_id"];
        [webserviceObj callJSONMethod:@"user_report" withParameters:dictParam isEncrpyted:NO onSuccessfulResponse:^(NSMutableDictionary *dict) {
            
            [self hideSpinner];
            NSString *strMsg=[dict valueForKey:@"message"];
            
            if ([[dict valueForKey:@"status"] integerValue] == 1 ) {
                self->_arrReportList=[dict valueForKey:@"data"];
                NSArray *sortedArray;
                sortedArray = [self->_arrReportList sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
                    double d1 = [[a objectForKey:@"report_date"]doubleValue];
                    double d2 = [[b objectForKey:@"report_date"]doubleValue];
                    return  d1 < d2;
                }];
                
                [self->_arrReportList removeAllObjects];
                self->_arrReportList = [NSMutableArray arrayWithArray:sortedArray];
                
                [self->_tblReportList reloadData];
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
- (IBAction)btnBackAction:(id)sender {
    
    if ([_delegate respondsToSelector:@selector(isUpdateTestReport:)]) {
        [_delegate isUpdateTestReport:objMemberDetail.str_user_id];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrReportList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TestOptionCell *cell=[_tblReportList dequeueReusableCellWithIdentifier:@"TestOptionCell" forIndexPath:indexPath];
    NSDictionary *dict=[_arrReportList objectAtIndex:indexPath.row];
    cell.lblLabName.text=SAFESTRING([dict objectForKey:@"report_lab"]);
    
    NSDateFormatter *formater =[[NSDateFormatter alloc] init];
    [formater setDateFormat:@"dd-MMM-yyyy"];
    NSDate *date =[NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:@"report_date"] floatValue]];
    NSString *strDate = [formater stringFromDate:date];
    cell.lblReportDate.text = strDate;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *dict=[_arrReportList objectAtIndex:indexPath.row];
    AddTestReportVC *testReportVC =[self.storyboard instantiateViewControllerWithIdentifier:@"AddTestReportVC"];
    testReportVC.dictUpdate=dict;
    testReportVC.objMemberDetail = objMemberDetail;
    [self addCenterGesture:NO];
    testReportVC.delegate=self;
    [self.navigationController pushViewController:testReportVC animated:YES];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict=[_arrReportList objectAtIndex:indexPath.row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if ([self isNetworkReachable]) {
            [self showSpinnerWithUserActionEnable:false];
            NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
            [dictParam setObject:SAFESTRING([dict objectForKey:@"report_id"]) forKey:@"report_id"];
            [dictParam setObject:SAFESTRING([dict objectForKey:@"user_id"]) forKey:@"user_id"];
            [webserviceObj callJSONMethod:@"delete_report" withParameters:dictParam isEncrpyted:NO onSuccessfulResponse:^(NSMutableDictionary *dict) {
                
                [self hideSpinner];
                NSString *strMsg=[dict valueForKey:@"message"];
                [USERDEFAULTS setObject:@"1" forKey:@"DASHBOARD"];
                if ([[dict valueForKey:@"status"] integerValue] == 1 ) {
                    [self->_arrReportList removeObjectAtIndex:indexPath.row];
                    [tableView reloadData]; // tell table to refresh now
                }
                [UIAlertController infoAlertWithMessage:strMsg andTitle:APPNAME controller:self];
            } onFailure:^(NSError *error) {
                [UIAlertController infoAlertWithMessage:[error localizedDescription] andTitle:APPNAME controller:self];
                [self hideSpinner];
            }];
        }
        else{
            [UIAlertController infoAlertWithMessage:ALERT_NO_INTERNET andTitle:APPNAME controller:self];
        }
    }
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
@end
