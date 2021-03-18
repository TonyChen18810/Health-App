//
//  LoginVC.m
//  HelthZip
//
//  Created by Tristate on 5/30/16.
//  Copyright © 2016 Tristate. All rights reserved.
//

#import "LoginVC.h"
#import "RegisterVC.h"
#import "Webservice.h"
#import "HomeVC.h"
#import "PrivacyPolicyVC.h"
@interface LoginVC ()

@end

@implementation LoginVC
@synthesize txtUsenrName,txtPassword,arrayViewBorder,viewUsername,viewPassword,viewLoginButton,viewBGForgetPassword,viewForgetPassword,txtForgetPasswordEmail,btnForgetPassword,btnForgetPasswordSubmit,btnLogin,btnForgetPasswordCancel,lblName;


#pragma mark - VIEW LIFECYCLE METHODS -

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"> > > > > > > > > > > >%@ > > > > > > > > >",NSStringFromClass([self class]));
    // Do any additional setup after loading the view.
    /*
     txtUsenrName.text = @"test@gmail.com";
     txtPassword.text = @"123123";
     */
    //set UI Befor view load
    for (UIView *view in arrayViewBorder) {
        view.layer.borderWidth = 1.0;
        view.layer.cornerRadius = 3.0;
        view.layer.borderColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:0.40].CGColor;
    }
    if (IS_IPHONE_4_OR_LESS) {
        self.topSpaceLoginButton.constant = 50.0;
        self.conTopLogo.constant=-10.0;
        self.conTopIv.constant = -100;
        _topSpaceLogingView.constant=_topSpaceLogingView.constant/2+45;
    }else{
        //        _topSpaceLogingView.constant=_topSpaceLogingView.constant + 15;
    }
    UIFont *regularFont = [UIFont fontWithName:@"ITCAvantGardeStd-Bk" size:12.0];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:_lblPricacyPolicy.text];
    // And before you set the bold range, set your attributed string (the whole range!) to the new attributed font name
    [attrString setAttributes:@{ NSFontAttributeName: regularFont } range:NSMakeRange(0, _lblPricacyPolicy.text.length - 1)];
    
    [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:@" "
                                                                       attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone)}]];
    
    [attrString addAttributes: @{NSForegroundColorAttributeName:[UIColor whiteColor],NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]} range:NSMakeRange(29,16)];
    self.lblPricacyPolicy.attributedText = attrString;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    //SetView Animation come from left right and Bottom and shake it.
    [self showViewAnimation:viewUsername animationPos:-200 isXpos:YES duratineTime:1.0 andDelay:0.0];
    [self showViewAnimation:viewPassword animationPos:200 isXpos:YES duratineTime:1.0 andDelay:0.0];
    [self showViewAnimation:btnLogin animationPos:-200 isXpos:NO duratineTime:1.0 andDelay:0.0];
    
    self.imgLogo.transform = CGAffineTransformScale(self.imgLogo.transform, 0.2, 0.2);
    self.lblName.transform = CGAffineTransformScale(self.lblName.transform, 0.15, 0.15);
//
    //PlaceHolder color set
    UIColor *color = [UIColor whiteColor];
    [self setPlaceHolder:@"Email Address" forTextFiled:txtUsenrName withColor:color];
    [self setPlaceHolder:@"Password" forTextFiled:txtPassword withColor:color];
    [self setPlaceHolder:@"Email" forTextFiled:txtForgetPasswordEmail withColor:[UIColor grayColor]];

    [self setPadding_BorderForTextField:txtForgetPasswordEmail];
    
    [btnForgetPassword setAlpha:0.0f];
    [_btnIagree setAlpha:.0f];
    [_lblPricacyPolicy setAlpha:.0f];
    [UIView animateWithDuration:4.0f animations:^{
        [self->btnForgetPassword setAlpha:1.0f];
        [self->_btnIagree setAlpha:1.0f];
        [self->_lblPricacyPolicy setAlpha:1.0f];
    } completion:^(BOOL finished) {
    }];
    
    btnLogin.layer.cornerRadius=3.0;
    btnForgetPasswordSubmit.layer.cornerRadius=3.0;
    btnForgetPasswordCancel.layer.cornerRadius=3.0;

    //LOGO AND LABEL ZOOM EFFECT
    [self showLogoAnimation];

    //WAVE EFFECT
    CGPoint oldCenter = viewUsername.center;
    [UIView animateWithDuration:2.0
                     animations: ^{ self->viewUsername.center = CGPointMake(-10.0,oldCenter.y); }
                     completion:
     ^(BOOL finished) {
         [UIView animateWithDuration:1.0
                          animations:^{ self->viewUsername.center =self->viewUsername.center; }];
     }];
    
    CGPoint oldCenter1 = viewPassword.center;
    [UIView animateWithDuration:2.0
                     animations: ^{ self->viewPassword.center = CGPointMake(310,oldCenter1.y); }
                     completion:
     ^(BOOL finished) {
         [UIView animateWithDuration:1.0
                          animations:^{ self->viewPassword.center =self->viewPassword.center; }];
     }];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    self.animator=nil;
//    [self showLogoAnimation];
//    [self playWithBall];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [self.animator removeAllBehaviors];
    self.imgLogo.transform = CGAffineTransformIdentity;
    self.lblName.transform = CGAffineTransformIdentity;
}

-(void)showSeprator
{
    //self.imgSeparator.hidden=NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ANIMATION METHODS -

-(void)showLogoAnimation
{
    //Zooming effect for logo and name
    [UIView animateWithDuration:1.0 animations:^{
        self.imgLogo.transform = CGAffineTransformScale(self.imgLogo.transform, 5, 5);
        self.lblName.transform = CGAffineTransformScale(self.lblName.transform, 10, 10);
    }];
    
}

-(void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id)item1 withItem:(id)item2 atPoint:(CGPoint)p{

    ////    if (item1 == self.orangeBall && item2 == self.paddle) {
    //        UIPushBehavior *pushBehavior = [[UIPushBehavior alloc] initWithItems:@[self.lblName] mode:UIPushBehaviorModeInstantaneous];
    //        pushBehavior.angle = 0.0;
    //        pushBehavior.magnitude = -2.0;
    //        [self.animator addBehavior:pushBehavior];
    //}
}

#pragma mark - BUTTON CLICK ACTION -
- (IBAction)btnLoginClickAction:(id)sender {
   
    if ([self isValidDetail:1]) {
        [self callLoginWebservice];
    }
}

- (IBAction)btnSignUpClickAction:(id)sender {
    RegisterVC *regVC=[self.storyboard instantiateViewControllerWithIdentifier:@"RegisterVC"];
    [self.navigationController pushViewController:regVC animated:YES];
    
}

- (IBAction)btnForgetPasswordClickAction:(id)sender {
     [self.view endEditing:YES];
    viewBGForgetPassword.hidden=NO;
   [self popUpAnimation:viewForgetPassword];
    
}

- (IBAction)btnCancelClickAction:(id)sender {
     viewBGForgetPassword.hidden=YES;
    [self.view endEditing:YES];
}

- (IBAction)btnForgetPasswordSubmitClickAction:(id)sender {
    
    if ([self isValidDetail:0]) {
        [self callForgetPasswordWebservice];
    }
}


#pragma mark - UITEXFIELD DELEGATE METHODS -

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - VALIDATION METHODS -
-(BOOL)isValidDetail:(int)tag
{
    //Validate Login Field Data
    if (tag == 1) {
        
        if (txtUsenrName.text.length <= 0) {
            [UIAlertController infoAlertWithMessage:ALERT_EmailId_required andTitle:APPNAME controller:self];
            return NO;
        }
        else if (![self NSStringIsValidEmail:SAFESTRING([self.txtUsenrName.text trimSpaces])]){
            [UIAlertController infoAlertWithMessage:ALERT_Invalid_EmailId andTitle:APPNAME controller:self];
            return NO;
        }
        else if (txtPassword.text.length <= 0) {
            [UIAlertController infoAlertWithMessage:ALERT_Password_Required andTitle:APPNAME controller:self];
            return NO;
        }
        else
        {
            return YES;
        }

    }
    else  //Validate Forget password Field Data
    {
        if (txtForgetPasswordEmail.text.length <= 0) {
            [UIAlertController infoAlertWithMessage:ALERT_EmailId_required andTitle:APPNAME controller:self];
            return NO;
        }
        else if (![self NSStringIsValidEmail:SAFESTRING([self.txtForgetPasswordEmail.text trimSpaces])]){
            [UIAlertController infoAlertWithMessage:ALERT_Invalid_EmailId andTitle:APPNAME controller:self];
            return NO;
        }
        else{
            return YES;
        }

    }
}
-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}


#pragma mark - WEBSERVICE CALL : For Login -

-(void)callLoginWebservice
{
    if (_btnIagree.selected) {
        
    }else{
        [UIAlertController infoAlertWithMessage:ALERT_PRIVACY_POLICY andTitle:APPNAME controller:self];
        return;
    }
    
    if ([self isNetworkReachable]) {
        [self showSpinnerWithUserActionEnable:false];
    
        
        Webservice *webserviceObj = [[Webservice alloc]init];
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        
        [dictParam setObject:SAFESTRING([txtUsenrName.text trimSpaces]) forKey:@"email_id"];
        
        [dictParam setObject:SAFESTRING([[txtPassword.text trimSpaces] MD5]) forKey:@"password"];

        [webserviceObj callJSONMethod:@"login" withParameters:dictParam isEncrpyted:NO onSuccessfulResponse:^(NSMutableDictionary *dict) {
            
            [self hideSpinner];
            NSString *strMsg=[dict valueForKey:@"message"];
            
            if ([[dict valueForKey:@"status"] integerValue] == 1 ) {
                
                self->objUserDetail = [UserDetail sharedInstance];
                NSMutableDictionary *dictData = [[dict objectForKey:@"data"] objectAtIndex:0];
                
                self->objUserDetail.str_user_id       = SAFESTRING([dictData objectForKey:@"user_id"]);
                self->objUserDetail.str_first_name    = SAFESTRING([dictData objectForKey:@"first_name"]);
                self->objUserDetail.str_last_name     = SAFESTRING([dictData objectForKey:@"last_name"]);
                self->objUserDetail.str_email         = SAFESTRING([dictData objectForKey:@"email_id"]);
                self->objUserDetail.str_password      = SAFESTRING([dictData objectForKey:@"password"]);
                self->objUserDetail.str_profile_pic   = SAFESTRING([dictData objectForKey:@"profile_pic"]);
                self->objUserDetail.str_is_verify     = SAFESTRING([dictData objectForKey:@"is_verify"]);
                self->objUserDetail.str_saved_email   = SAFESTRING([dictData objectForKey:@"saved_Email_Id"]);
                self->objUserDetail.str_tutorial_status   = SAFESTRING([dictData objectForKey:@"tutorial_status"]);
                
                [self->objUserDetail saveDetail:self->objUserDetail];
                [USERDEFAULTS setObject:@"1" forKey:IsLogin];
               
                 [self menuCreate];
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
-(void)menuCreate{
    HomeVC *homeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeVC"];
    UIViewController *menuVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LeftMenuViewController"];
    MFSideMenuContainerViewController *container = [self.storyboard instantiateViewControllerWithIdentifier:@"MFSideMenuContainerViewController"];
    container.leftMenuWidth=[self designConstratin];
    [container setLeftMenuViewController:menuVC];
    UINavigationController *navControllerOfMfMenu=[[UINavigationController alloc] init];
    navControllerOfMfMenu.navigationBarHidden=YES;
    [navControllerOfMfMenu setViewControllers:[NSArray arrayWithObject:homeVC] animated:YES];
    [container setCenterViewController:navControllerOfMfMenu];
    [USERDEFAULTS setObject:@"1" forKey:@"DASHBOARD"];
    [self.navigationController pushViewController:container animated:YES];
}
-(NSInteger)designConstratin{
    
    if (IS_IPHONE_4_OR_LESS)
    {
        return 220;
    }
    else if(IS_IPHONE_5)
    {
        return 220;
    }
    else if(IS_IPHONE_6)
    {
        return 220;
    }
    else
    {
        return 220;
    }
}
-(void)callForgetPasswordWebservice
{
    if ([self isNetworkReachable]) {
        [self showSpinnerWithUserActionEnable:false];
        
        Webservice *webserviceObj = [[Webservice alloc]init];
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        
        [dictParam setObject:SAFESTRING([txtForgetPasswordEmail.text trimSpaces]) forKey:@"email_id"];
        
        [webserviceObj callJSONMethod:@"forgot_password" withParameters:dictParam isEncrpyted:NO onSuccessfulResponse:^(NSMutableDictionary *dict) {
            
            [self hideSpinner];
            NSString *strMsg=[dict valueForKey:@"message"];
            
            if ([[dict valueForKey:@"status"] integerValue] == 1 ) {
                 [UIAlertController infoAlertWithMessage:strMsg andTitle:APPNAME controller:self];
                self->viewBGForgetPassword.hidden=YES;
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

- (IBAction)btnIagreeAction:(id)sender {
    if (_btnIagree.selected) {
        _btnIagree.selected=NO;
    } else {
        _btnIagree.selected=YES;
    }
}

- (IBAction)btnPrivacyPolicyAction:(id)sender {
    PrivacyPolicyVC *ppVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PrivacyPolicyVC"];
    [self presentViewController:ppVC animated:YES completion:nil];
}
@end
