//
//  HealthBlogVC.h
//  HealthZip
//
//  Created by Tristate on 6/13/16.
//  Copyright © 2016 Tristate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "UserDetail.h"


@interface HealthBlogVC : BaseViewController <UITableViewDataSource,UITableViewDelegate>

{
    UserDetail *objUserDetail;
    NSMutableArray *arrayBlogList;
}
@property (strong, nonatomic) IBOutlet UITableView *tblHealthBlog;

- (IBAction)btnTabButtonClickAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewStap10;
@property (weak, nonatomic) IBOutlet UIButton *btnGotIt;
@property (weak, nonatomic) IBOutlet UIView *viewIntro;
- (IBAction)btnGotItAction:(id)sender;

@end
