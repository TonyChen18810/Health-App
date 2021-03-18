//
//  EditReportListVC.h
//  OneTrackHealth
//
//  Created by Pragnesh Dixit on 18/11/16.
//  Copyright © 2016 Tristate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "Webservice.h"
#import "UserDetail.h"
#import "MemberDetail.h"
#import "AddTestReportVC.h"
#import "AddMemberVC.h"
@interface EditReportListVC : BaseViewController<UpdateMember,UpdateTestReport>
{
    UserDetail *objUserDetail;
    Webservice *webserviceObj;
}
@property (strong, nonatomic) NSString *strTitle;
@property (strong, nonatomic) NSMutableArray *arrReportList;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (strong,nonatomic) MemberDetail *objMemberDetail;
@property (weak, nonatomic) IBOutlet UITableView *tblReportList;
@property (weak, nonatomic) IBOutlet UILabel *lblViewTitle;
@property (strong, nonatomic) id <UpdateTestReport> delegate;

- (IBAction)btnBackAction:(id)sender;
@end
