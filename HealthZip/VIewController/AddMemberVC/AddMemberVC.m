//
//  AddMemberVC.m
//  HealthZip
//
//  Created by Tristate on 5/31/16.
//  Copyright © 2016 Tristate. All rights reserved.
//

#import "AddMemberVC.h"
#import "Constants.h"
#import "Webservice.h"
#import "UserDetail.h"
#import "UIImageView+WebCache.h"
#import "HomeVC.h"


@interface AddMemberVC ()

@end

@implementation AddMemberVC

@synthesize scrollView,txtFirstName,txtLastName;
@synthesize btnDelete,viewForEditButtons,btnSave,btnCameraIcon,txtEmail;


#pragma mark - VIEW LIFECYCLE METHODS -

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"> > > > > > > > > > > >%@ > > > > > > > > >",NSStringFromClass([self class]));
    // Do any additional setup after loading the view.
    objUserDetail=[UserDetail sharedInstance];
    objUserDetail=[objUserDetail getDetail];
     [USERDEFAULTS setObject:@"0" forKey:@"DASHBOARD"];
    [self setUI];
}

-(void)viewDidAppear:(BOOL)animated
{
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUI
{
   self.txtEmail.hidden = YES;
    self.ivBtnBg.layer.cornerRadius = self.ivBtnBg.frame.size.width/2;
    self.ivBtnBg.clipsToBounds=YES;
    
    if (self.isEdit) {
    
        viewForEditButtons.hidden = NO;
        btnSave.hidden=YES;
        self.lblTitleTopBar.text = @"Edit Profile";
        NSString  *strImageName =@"";
        
        if (self.isMainUser) {
            self.topSpaceOfViewEdit.constant = 100;
            self.txtEmail.hidden = NO;
            btnDelete.enabled = NO;
            
            strImageName =[objUserDetail.str_profile_pic  stringByRemovingPercentEncoding];
            
            txtFirstName.text = objUserDetail.str_first_name;
            txtLastName.text = objUserDetail.str_last_name;
            txtEmail.text = objUserDetail.str_email;
        }
        else{
            
            self.topSpaceOfViewEdit.constant = 60;
            self.txtEmail.hidden = YES;
             btnDelete.enabled = YES;
            
            strImageName =[self.objMemberDetail.str_profile_pic stringByRemovingPercentEncoding];
            
            txtFirstName.text = self.objMemberDetail.str_first_name;
            txtLastName.text = self.objMemberDetail.str_last_name;
        }
        
        [btnCameraIcon setImage:[UIImage imageNamed:IMG_CAMERA_ICON] forState:UIControlStateNormal];
        for (UIButton *btn in self.arrayButtons) {
            btn.layer.cornerRadius = 3.0;
        }
     
    
        if ([strImageName length] > 0) {
            
            NSString *strPhotoUrl = [NSString stringWithFormat:@"%@%@",URL_IMGS,strImageName];
            NSURL *urlPhoto = [NSURL URLWithString:strPhotoUrl];
            
            [self.imgProfilePic sd_setImageWithURL:urlPhoto placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (image == nil) {
                    //display default image
                    
                }
                
            }];
        }
    }
    
    else{
        viewForEditButtons.hidden = YES;
        btnSave.hidden=NO;
        
        [btnCameraIcon setImage:[UIImage imageNamed:IMG_CAMERA_ICON] forState:UIControlStateNormal];
    }
    
    self.imgProfilePic.layer.cornerRadius = self.imgProfilePic.frame.size.width/2;
    self.imgProfilePic.layer.borderWidth=2.0;
    self.imgProfilePic.layer.borderColor=[UIColor whiteColor].CGColor;
    self.imgProfilePic.clipsToBounds=YES;
    
    [self setPadding_BorderForTextField:txtFirstName];
    [self setPadding_BorderForTextField:txtLastName];
    [self setPadding_BorderForTextField:txtEmail];
    
    
}


#pragma mark - BUTTON CLICK ACTION -
- (IBAction)btnCloseClickAction:(id)sender {
     if (self.isEdit) {
        [self dismissViewControllerAnimated:YES completion:nil];
     }else{
         [self.navigationController popViewControllerAnimated:YES];
     }
}

- (IBAction)btnEditSaveClickAction:(id)sender {
    
    if ([sender tag] == 1) {
        //save button action
        
        if ([self isValidDetail]) {
            [self callAddMemberWebservice];
        }
    }
    else{
        //delete button action
        
        [UIAlertController infoAlertWithokCancelAction:ALERT_REMOVE_USER andTitle:APPNAME controller:self completion:^(BOOL isDelete) {
            if (isDelete) {
                if ([self.objMemberDetail.str_user_id trimSpaces].length > 0) {
                    [self callDeleteMemberWebservice];
                }
            }else{
                
            }
        }];
    }
    
}

- (IBAction)btnImageSlectClickAction:(id)sender {
    [self showActionSheet];
}

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

- (IBAction)btnAddMemberClickAction:(id)sender {
    if ([self isValidDetail]) {
        [self callAddMemberWebservice];
    }
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
    
    self.imgProfilePic.layer.cornerRadius = self.imgProfilePic.frame.size.width/2;
    self.imgProfilePic.layer.borderWidth=2.0;
    self.imgProfilePic.layer.borderColor=[UIColor whiteColor].CGColor;
    self.imgProfilePic.clipsToBounds=YES;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error)
    {
        [UIAlertController infoAlertWithMessage:@"Unable to save image to Photo Album." andTitle:@"Error" controller:self];
    }
    
    
}

#pragma mark - TEXTFIELD DELEGATE METHODS -

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
   else if (self.isMainUser) {
       
        if ([txtEmail.text trimSpaces].length <= 0) {
            [UIAlertController infoAlertWithMessage:ALERT_EmailId_required andTitle:APPNAME controller:self];
            return NO;
        }
       else
       {
           return YES;
       }
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

-(void)callAddMemberWebservice
{
    if ([self isNetworkReachable]) {
        [self showSpinnerWithUserActionEnable:false];
        
        Webservice *webserviceObj = [[Webservice alloc]init];
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        
        [dictParam setObject:SAFESTRING([txtFirstName.text trimSpaces]) forKey:@"first_name"];
        [dictParam setObject:SAFESTRING([txtLastName.text trimSpaces]) forKey:@"last_name"];
        NSString *strEmail=@"";
        if (self.isMainUser) {
            strEmail= txtEmail.text;
        }
        
        [dictParam setObject:strEmail forKey:@"email_id"];
        [dictParam setObject:@"" forKey:@"mobile_no"];
        [dictParam setObject:@"" forKey:@"gender"];
        [dictParam setObject:@"" forKey:@"address"];
        
        NSString *strImagepath = @"";
        if (userImageData) {
            strImagepath = @"pi_uploaded_image";
        }
        [dictParam setObject:strImagepath forKey:@"imagePath"];
        
        NSString *strMethodName = @"insert_member";
        
        if (self.isEdit) {
            strMethodName = @"update_profile";
            if (self.isMainUser) {
                [dictParam setObject:SAFESTRING([objUserDetail.str_user_id trimSpaces]) forKey:@"user_id"];
            }
            else{
                [dictParam setObject:SAFESTRING([self.objMemberDetail.str_user_id trimSpaces]) forKey:@"user_id"];
            }
            
           
        }
        else{
              [dictParam setObject:SAFESTRING([objUserDetail.str_user_id trimSpaces]) forKey:@"from_user_id"];
        }
        
        [webserviceObj callJSONMethod:strMethodName withImage:userImageData andParams:dictParam isEncrpyted:NO onSuccessfulResponse:^(NSMutableDictionary *dict) {
            
            [self hideSpinner];
            NSString *strMsg=[dict valueForKey:@"message"];
            
            if ([[dict valueForKey:@"status"] integerValue] == 1 ) {
                
                if (self.isMainUser) {
                    
                    self->objUserDetail = [UserDetail sharedInstance];
                    NSMutableDictionary *dictData = [[dict objectForKey:@"data"] objectAtIndex:0];
                    
                    self->objUserDetail.str_user_id     = SAFESTRING([dictData objectForKey:@"user_id"]);
                    self->objUserDetail.str_first_name  = SAFESTRING([dictData objectForKey:@"first_name"]);
                    self->objUserDetail.str_last_name   = SAFESTRING([dictData objectForKey:@"last_name"]);
                    self->objUserDetail.str_email       = SAFESTRING([dictData objectForKey:@"email_id"]);
                    self->objUserDetail.str_password    = SAFESTRING([dictData objectForKey:@"password"]);
                    self->objUserDetail.str_profile_pic = SAFESTRING([dictData objectForKey:@"profile_pic"]);
                    self->objUserDetail.str_is_verify    = SAFESTRING([dictData objectForKey:@"is_verify"]);
                    
                  
                    [self->objUserDetail saveDetail:self->objUserDetail];
                }
                [UIAlertController infoAlertWithokAction:[dict valueForKey:@"message"] andTitle:APPNAME controller:self completion:^(BOOL isDelete) {
                    [USERDEFAULTS setObject:@"1" forKey:@"DASHBOARD"];
                    if (self.isEdit) {
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }else{
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }];
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

-(void)callDeleteMemberWebservice
{
    if ([self isNetworkReachable]) {
        [self showSpinnerWithUserActionEnable:false];
        
        Webservice *webserviceObj = [[Webservice alloc]init];
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        
        [dictParam setObject:SAFESTRING([self.objMemberDetail.str_user_id trimSpaces]) forKey:@"user_id"];
        
       [webserviceObj callJSONMethod:@"delete_user" withParameters:dictParam isEncrpyted:NO onSuccessfulResponse:^(NSMutableDictionary *dict) {
           
           [self hideSpinner];
           NSString *strMsg=[dict valueForKey:@"message"];
           
           if ([[dict valueForKey:@"status"] integerValue] == 1 ) {
               [UIAlertController infoAlertWithokAction:[dict valueForKey:@"message"] andTitle:APPNAME controller:self completion:^(BOOL isDelete) {
                   [USERDEFAULTS setObject:@"1" forKey:@"DASHBOARD"];
                   if (self.isEdit) {
                       self->_callListAPI(YES);
                       [self dismissViewControllerAnimated:YES completion:nil];
                   }else{
                       [self.navigationController popViewControllerAnimated:YES];
                   }
               }];
           }
           else{
               [UIAlertController infoAlertWithMessage:strMsg andTitle:APPNAME controller:self];
           }
           
       } onFailure:^(NSError *error) {
           [UIAlertController infoAlertWithMessage:[error localizedDescription] andTitle:APPNAME controller:self];
           [self hideSpinner];
           
       } ];
        
    }
    else{
        [UIAlertController infoAlertWithMessage:ALERT_NO_INTERNET andTitle:APPNAME controller:self];
    }
}
@end
