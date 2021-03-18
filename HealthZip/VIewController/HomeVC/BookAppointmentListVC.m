//
//  BookAppointmentListVC.m
//  OneTrackHealth
//
//  Created by Pragnesh Dixit on 09/08/17.
//  Copyright © 2017 Tristate. All rights reserved.
//

#import "BookAppointmentListVC.h"

#import "BookAppointmentCell.h"
#import "Webservice.h"
#import "BlogDetail.h"
#import "tblFooterView.h"
@interface BookAppointmentListVC ()
{
    tblFooterView *tblFooter;
}
@end

@implementation BookAppointmentListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"> > > > > > > > > > > >%@ > > > > > > > > >",NSStringFromClass([self class]));
    // Do any additional setup after loading the view.
    [self.tblAppointmentList registerNib:[UINib nibWithNibName:@"BookAppointmentCell" bundle:nil] forCellReuseIdentifier:@"BookAppointmentCell"];
    tblFooter=[tblFooterView loadView];
    objUserDetail =[UserDetail sharedInstance];
    objUserDetail = [objUserDetail getDetail];
    lastId=@"";
    self.tblAppointmentList.separatorStyle = UITableViewCellSeparatorStyleNone;
    arrayBlogList = [[NSMutableArray alloc] init];
    [self callGetBookAppointmentDataWebservice];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnBackAction:(id)sender {
   
      [self dismissViewControllerAnimated:NO completion:nil];

}

- (IBAction)btnBookAppintmentAction:(id)sender {
    BookAppointmentVC *memberVC=[self.storyboard instantiateViewControllerWithIdentifier:@"BookAppointmentVC"];
    memberVC.delegate=self;
    [self presentViewController:memberVC animated:YES completion:nil];
}
-(void)btnBookAppointmentGetData:(NSArray *)arrBook{
    [arrayBlogList addObject:[arrBook objectAtIndex:0]];
    
    NSArray *sortArray = [self sortingArray:arrayBlogList];
    [arrayBlogList removeAllObjects];
    [arrayBlogList addObjectsFromArray:sortArray];
    [self.tblAppointmentList reloadData];
}

#pragma mark - TABLEVIEW DATA SOURCE AND DELEGATE METHODS -

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrayBlogList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BookAppointmentCell *cell =[self.tblAppointmentList dequeueReusableCellWithIdentifier:@"BookAppointmentCell" forIndexPath:indexPath];
    
    if (indexPath.row % 2 == 1) {
        cell.contentView.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:1];
    }
    else{
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    
    BlogDetail *objBlogDetail = [arrayBlogList objectAtIndex:indexPath.row];
    cell.lblTitle.text = objBlogDetail.str_blog_title;
    cell.lblDescription.text = objBlogDetail.str_blog_description;
    
    NSDateFormatter *formater =[[NSDateFormatter alloc] init];
    [formater setPMSymbol:@"PM"];
    [formater setAMSymbol:@"AM"];
    [formater setDateFormat:@"dd-MMM-yyyy h:mm a"];
    NSDate *date =[NSDate dateWithTimeIntervalSince1970:[objBlogDetail.str_blog_date floatValue]];
    NSString *strDate = [formater stringFromDate:date];
    cell.lblDate.text = strDate;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BlogDetail *selectedBlog = arrayBlogList[indexPath.row];
    NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:[selectedBlog.str_blog_date doubleValue]];
    NSTimeInterval interval = [date timeIntervalSinceReferenceDate];
    NSURL *url = [[NSURL alloc]initWithString:[NSString stringWithFormat: @"calshow:%f",interval]];
    if (url){
        [[UIApplication sharedApplication]openURL:url options:@{} completionHandler:^(BOOL success) {
            if (success) {
                NSLog(@"URL Is %@",url);
            }else{
                [UIAlertController infoAlertWithMessage:@"Problem opening calender." andTitle:APPNAME controller:self];
            }
        }];
    }
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        if ([self isNetworkReachable]) {
            [self showSpinnerWithUserActionEnable:false];
            
            // {"method_name":"get_mamber","body":{"user_id":"1"}}
             BlogDetail *objBlogDetail = [arrayBlogList objectAtIndex:indexPath.row];
            Webservice *webserviceObj = [[Webservice alloc]init];
            NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
             [dictParam setObject:SAFESTRING([objBlogDetail.str_blog_id trimSpaces]) forKey:@"appointment_id"];
            [dictParam setObject:SAFESTRING([objUserDetail.str_user_id trimSpaces]) forKey:@"user_id"];
            [webserviceObj callJSONMethod:@"delete_appointment" withParameters:dictParam isEncrpyted:NO onSuccessfulResponse:^(NSMutableDictionary *dict) {
                
                [self hideSpinner];
                NSString *strMsg=[dict valueForKey:@"message"];
                
                if ([[dict valueForKey:@"status"] integerValue] == 1 ) {
                    
                    //[UIAlertController infoAlertWithMessage:[dict valueForKey:@"message"] andTitle:APPNAME controller:self];
                    [self->arrayBlogList removeObjectAtIndex:indexPath.row];
                    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                    [self.tblAppointmentList reloadData];
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
}

#pragma mark - WEBSERVICE CALL : For Health Blog -

-(void)callGetBookAppointmentDataWebservice
{
    if ([self isNetworkReachable]) {
       if ([lastId isEqualToString:@""]) {
             [self showSpinnerWithUserActionEnable:false];
        }
        
        Webservice *webserviceObj = [[Webservice alloc]init];
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        
        [dictParam setObject:SAFESTRING([objUserDetail.str_user_id trimSpaces]) forKey:@"user_id"];
        [dictParam setObject: lastId forKey:@"last_appointment_id"];
        
        [webserviceObj callJSONMethod:@"get_appointment" withParameters:dictParam isEncrpyted:NO onSuccessfulResponse:^(NSMutableDictionary *dict) {
            
            [self hideSpinner];
            NSString *strMsg=[dict valueForKey:@"message"];
            
            if ([[dict valueForKey:@"status"] integerValue] == 1 ) {
                NSArray *temparray=[BlogDetail initWithArrayBookAppointment:[dict valueForKey:@"data"] ];
                if (!self->pullRefreshFlag) {
                    [self->arrayBlogList addObjectsFromArray:temparray];
                } else {
                    self->pullRefreshFlag = NO;
                    [self->arrayBlogList removeAllObjects];
                    self->arrayBlogList=[BlogDetail initWithArrayBookAppointment:[dict valueForKey:@"data"] ];
                }
                self->lastId=[NSString stringWithFormat:@"%lu",(unsigned long)self->arrayBlogList.count];
//                arrayBlogList=[BlogDetail initWithArrayBookAppointment:[dict valueForKey:@"data"] ];
                if (temparray.count==10) {
                    self->isPaging=YES;
                } else {
                     self.tblAppointmentList.tableFooterView=nil;
                    self->isPaging=NO;
                    
                }
                [self.tblAppointmentList reloadData];
            }
            else{
                 self.tblAppointmentList.tableFooterView=nil;
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

- (NSArray *)sortingArray:(NSArray *)array{
    NSArray *sorted = [array sortedArrayUsingComparator:^(id obj1, id obj2){
        if ([obj1 isKindOfClass:[BlogDetail class]] && [obj2 isKindOfClass:[BlogDetail class]]) {
            BlogDetail *s1 = obj1;
            BlogDetail *s2 = obj2;
            
            if (s1.str_blog_date.integerValue < s2.str_blog_date.integerValue) {
                return (NSComparisonResult)NSOrderedAscending;
            } else if (s1.str_blog_date.integerValue > s2.str_blog_date.integerValue) {
                return (NSComparisonResult)NSOrderedDescending;
            }
        }
        
        // TODO: default is the same?
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    return sorted;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //    isPaging=YES;
    if (!pullRefreshFlag) {
        NSArray *indexes = [self.tblAppointmentList indexPathsForVisibleRows];
        //        NSInteger count = pageIndex;
        if (([[indexes lastObject] row] == (arrayBlogList.count-1) ) && isPaging == YES) {
           
            self.tblAppointmentList.tableFooterView=tblFooter;
            [self.tblAppointmentList scrollRectToVisible:[self.tblAppointmentList convertRect:self.tblAppointmentList.tableFooterView.bounds fromView:self.tblAppointmentList.tableFooterView] animated:YES];
            [self callGetBookAppointmentDataWebservice];
        }
    }
}
@end
