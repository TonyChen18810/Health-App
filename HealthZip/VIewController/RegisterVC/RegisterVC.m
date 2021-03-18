//
//  RegisterVC.m
//  HealthZip
//
//  Created by Tristate on 5/30/16.
//  Copyright © 2016 Tristate. All rights reserved.
//

#import "RegisterVC.h"
#import "Webservice.h"
#import "HomeVC.h"
#import "NSString+Extensions.h"
#import "PrivacyPolicyVC.h"
#import "BaseViewController.h"
@interface RegisterVC ()

@end

@implementation RegisterVC
@synthesize txtFirstName,txtLastName,txtEmail,txtPassword;
@synthesize arrayTopSpace,txtConfPassword,arrayTextFields,scrollView;


#pragma mark - VIEW LIFECYCLE METHODS - 

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"> > > > > > > > > > > >%@ > > > > > > > > >",NSStringFromClass([self class]));
    // Do any additional setup after loading the view.
    
    if (IS_IPHONE_6_OR_HIGHER) {
        self.heightViewContainer.constant =[[UIScreen mainScreen] bounds].size.height;
    }
    UIFont *regularFont = [UIFont fontWithName:@"ITCAvantGardeStd-Bk" size:12.0];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:_lblPricacyPolicy.text];
    // And before you set the bold range, set your attributed string (the whole range!) to the new attributed font name
    [attrString setAttributes:@{ NSFontAttributeName: regularFont } range:NSMakeRange(0, _lblPricacyPolicy.text.length - 1)];
    
    [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:@" "
                                                                       attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone)}]];
    
    [attrString addAttributes: @{NSForegroundColorAttributeName:[UIColor blackColor],NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]} range:NSMakeRange(29,16)];
    self.lblPricacyPolicy.attributedText = attrString;
    
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - SETUI METHOD -
-(void)setUI
{
    for (UITextField *textField in arrayTextFields) {
        [self setPadding_BorderForTextField:textField];
    }
    self.ivBtnBg.layer.cornerRadius = self.ivBtnBg.frame.size.width/2;
    self.ivBtnBg.clipsToBounds=YES;
    self.imgProfilePic.layer.cornerRadius = self.imgProfilePic.frame.size.width/2;
    self.imgProfilePic.layer.borderWidth=2.0;
    self.imgProfilePic.layer.borderColor=[UIColor whiteColor].CGColor;
    self.imgProfilePic.clipsToBounds=YES;
    
    self.txtEmail.inputAccessoryView = [self addDoneButtonToKeyBoard];
    
}

#pragma mark - BUTTON CLICK ACTION -

- (IBAction)btnBackClickAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnImageSlectClickAction:(id)sender {
    
    [self showActionSheet];

}

- (IBAction)btnSignInClickAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnSIgnUpClickAction:(id)sender {
    if ([self isValidDetail]) {
        [self callSignUpWebservice];
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
#pragma mark - ACTIONSHEET BUTTON CLICK METHOD  -
-(void) showActionSheet {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *capturePhotoAction = [UIAlertAction actionWithTitle:@"Capture a Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self TakePicture];
    }];
    
    UIAlertAction *galleryPhotoAction = [UIAlertAction actionWithTitle:@"Select from Gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self OpenGallery];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

    }];
    
    [alert addAction:capturePhotoAction];
    [alert addAction:galleryPhotoAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:true completion:nil];
}

#pragma mark - ADD PHOTO METHODS -

-(void)OpenGallery
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}

-(void)TakePicture
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:NULL];
        
    }
    else
    {
        [UIAlertController infoAlertWithMessage:@"Device has no camera" andTitle:@"Error" controller:self];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    self.imgProfilePic.image=chosenImage;
    
    UIImage *image=[self portraitImageForImage:chosenImage];
    userImageData = UIImagePNGRepresentation(image);
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        [UIAlertController infoAlertWithokAction:@"Unable to save image to Photo Album." andTitle:@"Error" controller:self completion:^(BOOL isSaved) {
             
         }];
    }
}



#pragma mark - UITEXFIELD DELEGATE METHODS -

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - VALIDATION METHODS -
-(BOOL)isValidDetail{
    
    if ([txtFirstName.text trimSpaces].length <= 0) {
        [UIAlertController infoAlertWithMessage:ALERT_FirstName_Required andTitle:APPNAME controller:self];
        return NO;
    }
    else if ([txtLastName.text trimSpaces].length <= 0) {
        [UIAlertController infoAlertWithMessage:ALERT_LastName_Required andTitle:APPNAME controller:self];
        return NO;
    }
    if ([txtEmail.text trimSpaces].length <= 0) {
        [UIAlertController infoAlertWithMessage:ALERT_EmailId_required andTitle:APPNAME controller:self];
        return NO;
    }
    else if (![self NSStringIsValidEmail:SAFESTRING(txtEmail.text)]){
        [UIAlertController infoAlertWithMessage:ALERT_Invalid_EmailId andTitle:APPNAME controller:self];
        return NO;
    }
//    else if ([txtPassword.text trimSpaces].length <= 0 ) {
//        [UIAlertController infoAlertWithMessage:ALERT_Contact_No_required andTitle:APPNAME controller:self];
//        return NO;
//    }
    else if (txtPassword.text.length <= 0) {
        [UIAlertController infoAlertWithMessage:ALERT_Password_Required andTitle:APPNAME controller:self];
        return NO;
    }
    else if (txtPassword.text.length < 6) {
        [UIAlertController infoAlertWithMessage:ALERT_Password_too_small andTitle:APPNAME controller:self];
        return NO;
    }
    else if (![txtConfPassword.text isEqualToString:txtPassword.text] ) {
        [UIAlertController infoAlertWithMessage:ALERT_Confirm_Password_Mismatch andTitle:APPNAME controller:self];
        return NO;
    }
    else
    {
        return YES;
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

#pragma mark - WEBSERVICE CALL : For Register -

-(void)callSignUpWebservice
{
    if (_btnIagree.selected) {
        
    }else{
        [UIAlertController infoAlertWithMessage:ALERT_PRIVACY_POLICY_SIGNUP andTitle:APPNAME controller:self];
        return;
    }

    if ([self isNetworkReachable]) {
        [self showSpinnerWithUserActionEnable:false];
        
        Webservice *webserviceObj = [[Webservice alloc]init];
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        
        [dictParam setObject:SAFESTRING([txtFirstName.text trimSpaces]) forKey:@"first_name"];
        [dictParam setObject:SAFESTRING([txtLastName.text trimSpaces]) forKey:@"last_name"];
        [dictParam setObject:SAFESTRING([txtEmail.text trimSpaces]) forKey:@"email_id"];
        [dictParam setObject:SAFESTRING([[txtPassword.text trimSpaces] MD5]) forKey:@"password"];
        
        [dictParam setObject:@"" forKey:@"mobile_no"];
        [dictParam setObject:@"" forKey:@"address"];
        [dictParam setObject:@"" forKey:@"gender"];
        
        [dictParam setObject:@"pi_uploaded_image" forKey:@"imagePath"];
             
        
        [webserviceObj callJSONMethod:@"sign_up" withImage:userImageData andParams:dictParam isEncrpyted:NO onSuccessfulResponse:^(NSMutableDictionary *dict) {
            
            [self hideSpinner];
            NSString *strMsg=[dict valueForKey:@"message"];
            
            if ([[dict valueForKey:@"status"] integerValue] == 1 ) {
                [UIAlertController infoAlertWithMessage:[dict valueForKey:@"message"] andTitle:APPNAME controller:self];
                
                self->objUserDetail = [UserDetail sharedInstance];
                NSMutableDictionary *dictData               = [[dict objectForKey:@"data"] objectAtIndex:0];
                
                self->objUserDetail.str_user_id     = SAFESTRING([dictData objectForKey:@"user_id"]);
                self->objUserDetail.str_first_name  = SAFESTRING([dictData objectForKey:@"first_name"]);
                self->objUserDetail.str_last_name   = SAFESTRING([dictData objectForKey:@"last_name"]);
                self->objUserDetail.str_email       = SAFESTRING([dictData objectForKey:@"email_id"]);
                self->objUserDetail.str_password    = SAFESTRING([dictData objectForKey:@"password"]);
                self->objUserDetail.str_profile_pic = SAFESTRING([dictData objectForKey:@"profile_pic"]);
                self->objUserDetail.str_is_verify     = SAFESTRING([dictData objectForKey:@"is_verify"]);
                
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
            
        } onProgress:^(float progressInPercent) {
            
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
    container.leftMenuWidth=200;
    [container setLeftMenuViewController:menuVC];
    UINavigationController *navControllerOfMfMenu=[[UINavigationController alloc] init];
    navControllerOfMfMenu.navigationBarHidden=YES;
    [navControllerOfMfMenu setViewControllers:[NSArray arrayWithObject:homeVC] animated:YES];
    [container setCenterViewController:navControllerOfMfMenu];
    [USERDEFAULTS setObject:@"1" forKey:@"DASHBOARD"];
    [self.navigationController pushViewController:container animated:YES];
}

@end
