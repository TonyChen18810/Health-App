//
//  AddNewTestVC.m
//  OneTrackHealth
//
//  Created by Pragnesh Dixit on 19/09/16.
//  Copyright © 2016 Tristate. All rights reserved.
//

#import "AddNewTestVC.h"
#import "Webservice.h"
@interface AddNewTestVC ()

@end

@implementation AddNewTestVC
@synthesize btnBack,btnSave;
@synthesize objMemberDetail;
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"> > > > > > > > > > > >%@ > > > > > > > > >",NSStringFromClass([self class]));
    [USERDEFAULTS setObject:@"0" forKey:@"DASHBOARD"];
    // Do any additional setup after loading the view.
    for (UIView *tempview in _arrViewBorder) {
        
        tempview.layer.borderColor = [UIColor lightGrayColor].CGColor;
        tempview.layer.borderWidth = 1.0;
        tempview.layer.cornerRadius = 3.0;
        tempview.layer.masksToBounds = true;
    }
    [_txtUnit setInputAccessoryView:self.toolbarView];
    [_txtMinRatio setInputAccessoryView:self.toolbarView];
    [_txtMaxRatio setInputAccessoryView:self.toolbarView];
    [_txttestDescription setInputAccessoryView:self.toolbarView];
    objUserDetail=[UserDetail sharedInstance];
    objUserDetail=[objUserDetail getDetail];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnSaveAction:(id)sender {
    if ([[_txtMinRatio.text trimSpaces] intValue] > [[_txtMaxRatio.text trimSpaces] intValue]) {
        [UIAlertController infoAlertWithMessage:@"Test minimum ratio must be less than Test maximum ratio." andTitle:APPNAME controller:self];
        return;
    }
    if ([self validateTextField]==YES) {
        if ([self isNetworkReachable]) {
            [self showSpinnerWithUserActionEnable:false];
            
            Webservice *webserviceObj = [[Webservice alloc]init];
            NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
            [dictParam setObject:SAFESTRING([_strUserId trimSpaces]) forKey:@"userId"];
            [dictParam setObject:SAFESTRING(_txtTestName.text) forKey:@"testName"];
            [dictParam setObject:SAFESTRING(_txtMinRatio.text) forKey:@"minRatio"];
            [dictParam setObject:SAFESTRING(_txtMaxRatio.text) forKey:@"maxRatio"];
            [dictParam setObject:SAFESTRING(_txtUnit.text) forKey:@"unit"];
            [dictParam setObject:SAFESTRING(_txttestDescription.text) forKey:@"description"];
            
            [webserviceObj callJSONMethod:@"test_parameter" withParameters:dictParam isEncrpyted:NO onSuccessfulResponse:^(NSMutableDictionary *dict) {
                NSLog(@"Dict of Reponse Is %@",dict);
                [self hideSpinner];
                // NSString *strMsg=[dict valueForKey:@"message"];
                 [USERDEFAULTS setObject:@"0" forKey:@"DASHBOARD"];
                if ([[dict valueForKey:@"status"] integerValue] == 1 ) {
                    dispatch_async (dispatch_get_main_queue(), ^{
                        if ([self.delegate respondsToSelector:@selector(addNewTest:)]) {
                            NSString *userID = [dictParam objectForKey:@"userId"];
                            [self.delegate addNewTest:userID];
                        }
                        [self.navigationController popViewControllerAnimated:YES];
                    });
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

- (IBAction)btnBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnDoneTextViewAction:(id)sender {
    [self.view endEditing:YES];
}

#pragma mark - UITextField Delegate Methods
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    
    if (textField.tag == 2 || textField.tag == 3) {
        if ([textField.text containsString:@"."] && [string containsString:@"."]) {
            return NO;
        } else {
            
            char *x = (char*)[string UTF8String];
            //NSLog(@"char index is %i",x[0]);
            if( [string isEqualToString:@"0"] || [string isEqualToString:@"1"] ||  [string isEqualToString:@"2"] ||  [string isEqualToString:@"3"] ||  [string isEqualToString:@"4"] ||  [string isEqualToString:@"5"] ||  [string isEqualToString:@"6"] ||  [string isEqualToString:@"7"] ||  [string isEqualToString:@"8"] ||  [string isEqualToString:@"9"] || x[0]==0 || [string isEqualToString:@"."]) {
                
                NSUInteger newLength = [textField.text length] + [string length] - range.length;
                return (newLength > 18) ? NO : YES;
            }else{
                return NO;
            }
        }
    }else{
        return YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - UITextView Delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
  
   [textView resignFirstResponder];
    return YES;
}
-(BOOL)validateTextField
{
    float maxValue = [_txtMaxRatio.text floatValue];
    float minValue = [_txtMinRatio.text floatValue];
    
    NSLog(@"Float Min %.2f",minValue);
    NSLog(@"Float Max %.2f",maxValue);
    
    if ([self.txtTestName.text trimSpaces].length == 0) {
        [UIAlertController infoAlertWithMessage:@"Please enter Test name." andTitle:APPNAME controller:self];
        return NO;
    }
    else if ([self.txtMinRatio.text trimSpaces].length == 0) {
        [UIAlertController infoAlertWithMessage:@"Please enter Test minimum ratio." andTitle:APPNAME controller:self];
        return NO;
    }
    else if (minValue == 0.00) {
        [UIAlertController infoAlertWithMessage:@"Please enter minimum ratio greater than zero." andTitle:APPNAME controller:self];
        return NO;
    }
    else if ([self.txtMaxRatio.text trimSpaces].length == 0) {
        [UIAlertController infoAlertWithMessage:@"Please enter Test maximum ratio." andTitle:APPNAME controller:self];
        return NO;
    }else if ([self.txtUnit.text trimSpaces].length == 0) {
        [UIAlertController infoAlertWithMessage:@"Please enter Test unit." andTitle:APPNAME controller:self];
        return NO;
    }else if ([self.txttestDescription.text trimSpaces].length == 0) {
        [UIAlertController infoAlertWithMessage:@"Please enter Test description." andTitle:APPNAME controller:self];
        return NO;
    }else{
        return YES;
    }
}
@end
