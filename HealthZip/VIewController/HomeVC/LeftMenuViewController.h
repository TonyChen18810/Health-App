//
//  LeftMenuViewController.h
//  Veterinary
//
//  Created by Pragnesh Dixit on 7/14/15.
//  Copyright (c) 2015 Tristate Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftMenuCell.h"
#import "BaseViewController.h"
#import <MessageUI/MessageUI.h>

@interface LeftMenuViewController : BaseViewController<MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tblLeftMenu;
@property (nonatomic, strong) NSMutableArray *arrMenu;
@property (nonatomic, strong) NSMutableArray *arrMenuImages;

@property (strong, nonatomic) IBOutlet UIImageView *imgProfilePic;
@property (strong, nonatomic) IBOutlet UILabel *lblUserName;
@property (strong, nonatomic) IBOutlet UILabel *lblLocation;
@property (strong, nonatomic) IBOutlet UIView *viewBG;
@end
