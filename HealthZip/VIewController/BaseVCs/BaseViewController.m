//
//  BaseViewController.m
//  iDeals
//
//  Created by Pragnesh Dixit on 08/02/16.
//  Copyright © 2016 Pragnesh Dixit. All rights reserved.
//

#import "BaseViewController.h"
#import "NetworkReachability.h"
#import "HomeVC.h"
#import "Constants.h"


@interface BaseViewController ()
{
    UITapGestureRecognizer *tap;
}
@end

@implementation BaseViewController
@synthesize spinner;
@synthesize txtFieldCheck;
@synthesize btnMenu;
@synthesize viewTopBar;
#pragma mark - UIView Lifecycle Actions -
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"> > > > > > > > > > > >%@ > > > > > > > > >",NSStringFromClass([self class]));
    [self hideSpinner];
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - NetworkReachability Actions  -

- (BOOL)isNetworkReachable{
    return [self isNetworkReachable:@"http://www.google.com"];
}
- (BOOL)isNetworkReachable:(NSString*)NetPath
{
    [[NetworkReachability sharedReachability] setHostName:[NSString stringWithFormat:@"%@",NetPath]];
    NetworkReachbilityStatus remoteHostStatus = [[NetworkReachability sharedReachability] internetConnectionStatus];
    
    if (remoteHostStatus == NetworkNotReachable)
        return NO;
    else if((remoteHostStatus == ReachableViaCarrierDataNetwork) || (remoteHostStatus == ReachableViaWiFiNetwork))
        return YES;
    return NO;
}
- (void)showHud {
    if (!HUD) {
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.labelText = @"Loading";
        [HUD show:YES];
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    }
}

- (void)hidHud {
    if (HUD) {
        [HUD show:NO];
        [HUD removeFromSuperview];
        //		[HUD release];
        HUD = nil;
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }
}
- (void)showSpinnerWithUserActionEnable:(BOOL)isEnable{
    spinner.hidden = false;
    [spinner startAnimating];
    self.view.userInteractionEnabled = isEnable;
}
- (void)hideSpinner{
    [spinner stopAnimating];
    self.view.userInteractionEnabled = YES;
}
//*-----*-----RV

-(void)addCenterGesture:(BOOL) addremoveGesture
{
   
    UIWindow *window=[[[UIApplication sharedApplication] delegate] window];
    UINavigationController *navController=(UINavigationController *)[window rootViewController];
    
    for (UIViewController *vcInner in navController.viewControllers )
    {
        if([vcInner isKindOfClass:[MFSideMenuContainerViewController class]])
        {
            MFSideMenuContainerViewController *mfVc=(MFSideMenuContainerViewController *)vcInner;
            
            if(!addremoveGesture){
                mfVc.panMode = MFSideMenuPanModeNone;
                //  [mfVc removeCenterGestureRecognizers];
            }
            else{
                mfVc.panMode =MFSideMenuPanModeDefault;
            //[mfVc addCenterGestureRecognizers];
                break;}
        }
    }
}




#pragma mark - CHECK SELECTED LANGUAGE -
-(BOOL)checkSelectedLanguageIsArabic{
    if ([USERDEFAULTS boolForKey:IS_ARABIC]) {
        return true;
    }
    else{
        return false;
    }
}

-(UIToolbar *)addDoneButtonToKeyBoard{
    UIToolbar* keyboardToolbar = [[UIToolbar alloc] init];
    [keyboardToolbar sizeToFit];
    UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                      target:nil action:nil];
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                      target:self action:@selector(doneButtonPressed)];
    keyboardToolbar.items = @[flexBarButton, doneBarButton];
    return keyboardToolbar;
}

-(void)doneButtonPressed
{
    [self.view endEditing:YES];
}

-(BOOL)checkIfUserIsLogin
{
//    UserDetail *objUserDetail = [UserDetail sharedInstance];
//    objUserDetail = [objUserDetail getDetail];
//    
//    if ([objUserDetail.str_user_id isEqualToString:@""] || objUserDetail.str_user_id == nil ) {
//        return false;
//    }
//    else{
//        return true;
//    }
    return true;
}

-(NSString*)setPriceWithCommaOperator:(NSString *)strPrice
{
    NSNumberFormatter *indCurrencyFormatter = [[NSNumberFormatter alloc] init];
    [indCurrencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [indCurrencyFormatter setCurrencySymbol:@""];
    [indCurrencyFormatter setMaximumFractionDigits:0];
    //        [indCurrencyFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_IN"]];

    NSString *formattedString = [indCurrencyFormatter stringFromNumber:[NSNumber numberWithInteger:strPrice.floatValue]];
    
//    formattedString = [formattedString stringByReplacingOccurrencesOfString:@"$" withString:@""];
    return formattedString;
}
-(id)predicateOnArray:(NSMutableArray *)arrayData withPredicateFormateString:(NSString*)strPredicateFormate
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:strPredicateFormate];
    NSArray *arrMatchs = [arrayData filteredArrayUsingPredicate:predicate];
    if (arrMatchs.count) {
        return arrMatchs[0];
    }
    return nil;
}
#pragma mark - Get Height For Dynamic Text Action -
-(CGFloat)getDescriptionHeight:(NSString *)strDescription withLabelFrame:(CGRect)framelabel withFont:(UIFont *)font
{
    CGFloat height = [SAFESTRING(strDescription) boundingRectWithSize:CGSizeMake(framelabel.size.width, MAXFLOAT) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil] context:nil].size.height;
    
    return height;
}

-(void)addTapGestureToView:(UIView*)view
{
//    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboardAction:)];
//    [view addGestureRecognizer:tap];
}

-(void)removeTapGestureToView:(UIView*)view
{
    //[view removeGestureRecognizer:tap];
}

#pragma mark - UIBUTTON : SET TITLE LABEL CENTER -


-(void)setButtonTextAlignmentCenter:(UIButton*)button
{
    [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
}


#pragma mark - UIButton menu Action -
- (void)btnShowLeftMenuAction:(id)sender {
    //[self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
}

#pragma mark - UIButton back Action -

- (IBAction)btnBackAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark - GET LISTING PER PAGE -

-(NSString *)getListingPerPage
{
     NSString *strPages;
    NSInteger intIndexPaging;
    NSArray *arrayPageListing;
     arrayPageListing = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@",@"6"],[NSString stringWithFormat:@"%@",@"8"],[NSString stringWithFormat:@"%@",@"10"],[NSString stringWithFormat:@"%@",@"12"], nil];
    if (![USERDEFAULTS valueForKey:LISTING_PAGE]) {
        strPages = [NSString stringWithFormat:@"%@",@"10"];
        intIndexPaging = [arrayPageListing indexOfObject:strPages];
        [USERDEFAULTS setValue:[NSString stringWithFormat:@"%d",(int)intIndexPaging] forKey:LISTING_PAGE];
        [USERDEFAULTS synchronize];
    }
    else{
        intIndexPaging = [[USERDEFAULTS valueForKey:LISTING_PAGE] integerValue];
        strPages = arrayPageListing[intIndexPaging];
    }
 
    return strPages;
}

#pragma mark - UITextField Padding and Border -

-(void)setPadding_BorderForTextField:(UITextField *)textField
{
    textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textField.layer.borderWidth = 1.0;
    textField.layer.cornerRadius = 3.0;
    textField.layer.masksToBounds = true;
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    textField.leftView = paddingView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *rightPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    textField.rightView = rightPaddingView;
    textField.rightViewMode = UITextFieldViewModeAlways;
  
}

#pragma mark - TEXTFILED PLACEHOLDER COLOR SETTING -
-(void)setPlaceHolder:(NSString *)strPlaceholder forTextFiled:(UITextField *)textFiled withColor:(UIColor*)color
{
    textFiled.attributedPlaceholder = [[NSAttributedString alloc] initWithString:strPlaceholder attributes:@{NSForegroundColorAttributeName: color}];
}

#pragma  mark - SET UILABEL TEXT WITH FONT AND STYLE -

-(NSMutableAttributedString *)applystringColor_FONT_STYLE:(NSString*)strMessage withWord:(NSString *)searchedString withFont:(UIFont*)font withTextAlignment:(NSTextAlignment)alignment
{
    
    NSRange   searchedRange = NSMakeRange(0, [strMessage length]);
    NSString *strText = strMessage;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:searchedString options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init] ;
    
    [paragraphStyle setAlignment:alignment];
    
    NSMutableAttributedString *mutAttrTextString = [[NSMutableAttributedString alloc] initWithString:strText];
    
    [mutAttrTextString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [strText length])];
    
    
    NSArray* matches = [regex matchesInString:strMessage options:0 range: searchedRange];
    for (NSTextCheckingResult *match in matches) {
        UIFont *fontText = font;
        NSDictionary *dictBoldText = [NSDictionary dictionaryWithObjectsAndKeys:fontText, NSFontAttributeName, nil];
        [mutAttrTextString setAttributes:dictBoldText range:match.range];
    }
    return mutAttrTextString;
}


-(NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding withString:(NSString*)strPath {
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                 (CFStringRef)strPath,
                                                                                 NULL,
                                                                                 (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                                 CFStringConvertNSStringEncodingToEncoding(encoding)));
}


#pragma mark - SET LABEL TEXT -
-(NSAttributedString*)setLabelText:(NSString *)strMessage withFontSize:(CGFloat)fontSize
{
    NSAttributedString *message = [self applystringColor_Font_Style:strMessage withWord:@"\\*" withFont:[UIFont fontWithName:FONT_ITCAVANTGARDESTD_BK size:fontSize] color:[UIColor redColor]];
    return message;
}


-(NSMutableAttributedString *)applystringColor_Font_Style:(NSString*)strMessage withWord:(NSString *)searchedString withFont:(UIFont *)font color: (UIColor *)color
{
    
    NSRange   searchedRange = NSMakeRange(0, [strMessage length]);
    NSString *strTextView = strMessage;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:searchedString
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    
    NSMutableAttributedString *mutAttrTextViewString = [[NSMutableAttributedString alloc] initWithString:strTextView];
    
    
    NSArray* matches = [regex matchesInString:strMessage options:0 range: searchedRange];
    for (NSTextCheckingResult *match in matches) {
        
        if (font) {
            NSDictionary *dictBoldText = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
            [mutAttrTextViewString setAttributes:dictBoldText range:match.range];
        }
        if (color) {
            NSDictionary *dictBoldText = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor redColor], NSForegroundColorAttributeName, nil];
            [mutAttrTextViewString setAttributes:dictBoldText range:match.range];
        }
    }
    return mutAttrTextViewString;
}


- (UIImage *)portraitImageForImage:(UIImage *)image
{
    int kMaxResolution = 500; // Or whatever
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = roundf(bounds.size.width / ratio);
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = roundf(bounds.size.height * ratio);
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

#pragma mark - VIEW ANIMATION METHODS -

-(void)showViewAnimation:(UIView *)view animationPos:(int)position isXpos:(BOOL)direction duratineTime:(float)Duration andDelay:(float)delay
{
    CGRect frameleft = view.frame;
    if (direction) {
        frameleft.origin.x = position;
    }
    else
    {
       frameleft.origin.y = position;
    }
    
    [UIView animateWithDuration:Duration delay:delay options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{ view.frame = frameleft; } completion:^(BOOL finished){
        
    }];
}

//Get Current Time
- (NSString *) getCurrentTime
{
    NSDate *date = [[NSDate alloc]init];
    NSDateFormatter *dt = [[NSDateFormatter alloc]init];
    [dt setDateFormat:@" HH:mm:ss"];
    [dt setLocale:[NSLocale currentLocale]];
    //    [dt stringFromDate:date];
    return [dt stringFromDate:date];
}

//local Time to UTC
-(void)getDateString:(NSString*)strSelectedDate{
    NSDateFormatter *dt = [[NSDateFormatter alloc]init];
    [dt setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss Z"];
    [dt setTimeZone:[NSTimeZone defaultTimeZone]];
    
    [dt setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dt setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss Z"];
}

//Append Time And Date
-(NSDate *)appendTimeandDate:(NSString *)selectedDate{
    NSString *time = [self getCurrentTime]; //Get Current Time
    NSString *strCurrentDate = [selectedDate stringByAppendingString:time];
    
    
    NSDateFormatter *dt = [[NSDateFormatter alloc]init];
    [dt setDateFormat:@"dd-MMM-yyyy HH:mm:ss"];
    [dt setLocale:[NSLocale currentLocale]];
    
    NSDate *dateFromString = [dt dateFromString:strCurrentDate];
    NSLog(@"Date From String Is %@",dateFromString);
    
    return dateFromString;
}

#pragma mark - POPUP VIEW ANIMATION METHODS -

-(void)popUpAnimation:(UIView *)view
{
    //    UIView *popUp =[[UIView alloc] initWithFrame:CGRectMake(10, 100, 300, 200)];
    //   viewForgetPassword.backgroundColor=[UIColor redColor];
   view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    
    //[self.view addSubview:popUp];
    
    [UIView animateWithDuration:0.3/1.5 animations:^{
        view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3/2 animations:^{
            view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3/2 animations:^{
                view.transform = CGAffineTransformIdentity;
            }];
        }];
    }];
}

-(void)showEmailAlert:(MFMailComposeViewController*)mailComposer objUserDetail :(UserDetail *) userDetail  completion :(void(^)(NSString *))okCompletion{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:APPNAME message:@"Please enter Email ID." preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"%@",alertController.textFields[0].text);
        
        okCompletion(alertController.textFields[0].text);
    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        if ([SAFESTRING(userDetail.str_saved_email) isEqualToString:@""]){
            textField.placeholder = @"Please enter email Id";
        }else{
            textField.text = SAFESTRING(userDetail.str_saved_email);
        }
    }];
    
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:true completion:nil];
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

@end
