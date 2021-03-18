//
//  LeftMenuViewController.m
//  Veterinary
//
//  Created by Pragnesh Dixit on 7/14/15.
//  Copyright (c) 2015 Tristate Team. All rights reserved.
//

#import "LeftMenuViewController.h"

#import "MFSideMenu.h"
#import "LoginVC.h"
#import "Constants.h"
#import "AddMemberVC.h"
#import "PrivacyPolicyVC.h"
#import "BookAppointmentListVC.h"
@interface LeftMenuViewController ()

@end

typedef enum
{
    MENU_OPTION_RECEIVE_ORDERS = 0,
    MENU_OPTION_MY_PROFILE = 1,
    MENU_OPTION_MY_CATERER = 2,
    MENU_OPTION_VERIFY_PHONE = 3,
    MENU_OPTION_MY_NOTIFICATIONS = 4,
    MENU_OPTION_NOTIFICATION_SETTINGS = 5,
    MENU_OPTION_PAYMENT_DETAILS = 6,
    MENU_OPTION_MY_MESSAGES = 7,
    MENU_OPTION_ABOUT_US = 12,
    MENU_OPTION_CONTACT_US = 9,
    MENU_OPTION_TERMS_CONDITIONS = 10,
    MENU_OPTION_PRIVACY_POLICY = 11,
    MENU_OPTION_INVITE_FRIENDS = 8,
    MENU_OPTION_LOGOUT = 13
} MENU_OPTION;

@implementation LeftMenuViewController

#pragma mark - Life Cycle Mathod
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"> > > > > > > > > > > >%@ > > > > > > > > >",NSStringFromClass([self class]));
    
    
    self.arrMenu = [[NSMutableArray alloc]initWithObjects:@"Add Dr. Appointments",@"Feedback",@"Privacy Pollicy",@"Log out", nil];
    
    self.arrMenuImages=[[NSMutableArray alloc]initWithObjects:@"appo_icon",@"Feedback_icon",@"Privacy_Policy_icon",@"img_logout_btn", nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableViews numberOfRowsInSection:(NSInteger)section
{
    return self.arrMenu.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableViews cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //   NSString *strTemp=[self.arrMenu objectAtIndex:indexPath.row];
    LeftMenuCell *cell=[self.tblLeftMenu dequeueReusableCellWithIdentifier:@"LeftMenuCell"];
    cell.lblMenuItemName.text=[self.arrMenu objectAtIndex:indexPath.row];
    cell.ivMenuItem.image=[UIImage imageNamed:[self.arrMenuImages objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableVie didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [USERDEFAULTS setObject:@"0" forKey:@"DASHBOARD"];
    switch (indexPath.row) {
        case MENU_OPTION_RECEIVE_ORDERS:
        {
              BookAppointmentListVC *memberVC=[self.storyboard instantiateViewControllerWithIdentifier:@"BookAppointmentListVC"];
                [self presentViewController:memberVC animated:NO completion:nil];
            break;
        }
        case MENU_OPTION_MY_PROFILE:
        {
            NSArray *toRecipents = [NSArray arrayWithObject:[NSString stringWithFormat:@"info@onetrackhealth.com"]];
            
            MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
            mc.mailComposeDelegate = self;
            //    [mc setSubject:emailTitle];
            //    [mc setMessageBody:messageBody isHTML:NO];
            [mc setToRecipients:toRecipents];
            
            // Present mail view controller on screen
            [self presentViewController:mc animated:YES completion:NULL];
            return;
//            break;
        }
        case MENU_OPTION_MY_CATERER:
        {
            PrivacyPolicyVC *ppVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PrivacyPolicyVC"];
            [self presentViewController:ppVC animated:NO completion:nil];
            break;
        }
        case MENU_OPTION_VERIFY_PHONE:
        {
            [self confirmToLogout];
            return;
        }
            
        default:
            break;
    }
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
}

- (void)confirmToLogout{
    
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:APPNAME
                                message:ALERT_LOGOUT
                                preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self logOut];
        //do something when click button
    }];
    [alert addAction:okAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        //do something when click button
    }];
    [alert addAction:cancelAction];
    
    UIViewController *vc = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    [vc presentViewController:alert animated:YES completion:nil];
}

- (void)logOut{
    
    LoginVC *vcLogin = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
     [USERDEFAULTS removeObjectForKey:IsLogin];
    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"IntroductionScreen1"];
    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"IntroductionScreen2"];
    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"IntroductionScreen3"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[LoginVC class]]){
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
    [self.navigationController setViewControllers:@[vcLogin] animated:YES];
}
#pragma mark - mail compose delegate
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
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
