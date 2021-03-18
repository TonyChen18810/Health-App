//
//  BookAppointmentListVC.h
//  OneTrackHealth
//
//  Created by Pragnesh Dixit on 09/08/17.
//  Copyright © 2017 Tristate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "UserDetail.h"
#import "BlogDetail.h"
#import "BookAppointmentVC.h"
@interface BookAppointmentListVC : BaseViewController<UITableViewDataSource,UITableViewDelegate,BookAppointmetnDelegate>

{
    UserDetail *objUserDetail;
    NSMutableArray *arrayBlogList;
    NSString *lastId;
    BOOL isPaging;
     BOOL pullRefreshFlag;
}
@property (strong, nonatomic) IBOutlet UITableView *tblAppointmentList;

- (IBAction)btnBackAction:(id)sender;
- (IBAction)btnBookAppintmentAction:(id)sender;

@end
