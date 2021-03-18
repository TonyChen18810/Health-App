//
//  HealthBlogVC.m
//  HealthZip
//
//  Created by Tristate on 6/13/16.
//  Copyright © 2016 Tristate. All rights reserved.
//

#import "HealthBlogVC.h"
#import "HealthBlogCell.h"
#import "Webservice.h"
#import "BlogDetail.h"
#import "DisplayWebviewVC.h"
#import "UIImageView+WebCache.h"

@interface HealthBlogVC ()

@end

@implementation HealthBlogVC
@synthesize tblHealthBlog;



- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"> > > > > > > > > > > >%@ > > > > > > > > >",NSStringFromClass([self class]));
    // Do any additional setup after loading the view.
    [USERDEFAULTS setObject:@"0" forKey:@"DASHBOARD"];
    [tblHealthBlog registerNib:[UINib nibWithNibName:@"HealthBlogCell" bundle:nil] forCellReuseIdentifier:@"HealthBlogCell"];
    objUserDetail =[UserDetail sharedInstance];
    objUserDetail = [objUserDetail getDetail];
    
    tblHealthBlog.separatorStyle = UITableViewCellSeparatorStyleNone;
    arrayBlogList = [[NSMutableArray alloc] init];
    [self callGetBlogDataWebservice];
    self.btnGotIt.layer.cornerRadius = 5;
    //     self.btnGotIt.hidden = YES;
    self.btnGotIt.alpha = 0.0;
    [self fadeIn:self.viewStap10 withDuration:0.5 andWait:1.0];
    self.btnGotIt.layer.borderWidth = 1;
   self.btnGotIt.layer.borderColor = [UIColor whiteColor].CGColor;
    
    NSString *startUpView=[[NSUserDefaults standardUserDefaults] objectForKey:@"IntroductionScreen3"];
    if ([startUpView isEqualToString:@"YES"]) {
        self.viewIntro.hidden = NO;
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"IntroductionScreen3"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else{
        self.viewIntro.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) fadeIn:(UIView*)viewToFadeIn withDuration:(NSTimeInterval)duration andWait:(NSTimeInterval)wait

{
    [UIView beginAnimations: @"Fade In" context:nil];
    
    // wait for time before begin
    [UIView setAnimationDelay:wait];
    
    // druation of animation
    [UIView setAnimationDuration:duration];
    viewToFadeIn.alpha = 1;
    self.btnGotIt.alpha = 1.0;
    
    [UIView commitAnimations];
}

#pragma mark - TABLEVIEW DATA SOURCE AND DELEGATE METHODS -

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrayBlogList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 108.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HealthBlogCell *cell =[tblHealthBlog dequeueReusableCellWithIdentifier:@"HealthBlogCell" forIndexPath:indexPath];

    if (indexPath.row % 2 == 1) {
        cell.contentView.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:1];
    }
    else{
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    
    BlogDetail *objBlogDetail = [arrayBlogList objectAtIndex:indexPath.row];
    cell.lblTitle.text = objBlogDetail.str_blog_title;
    cell.lblDescription.text = objBlogDetail.str_blog_description;
    
    NSDateFormatter *formater =[[NSDateFormatter alloc] init];
    [formater setDateFormat:@"dd-MMM-yyyy"];
    NSDate *date =[NSDate dateWithTimeIntervalSince1970:[objBlogDetail.str_blog_date floatValue]];
    NSString *strDate = [formater stringFromDate:date];
    cell.lblDate.text = strDate;
    
    NSString *strPhotoURL=nil;
    NSString *urlFromDict=objBlogDetail.str_blogImg;
    if(urlFromDict!=nil && ![[urlFromDict trimSpaces] isEqualToString:@""]) {
        strPhotoURL=[URL_IMGS stringByAppendingPathComponent:urlFromDict];
    }
    
    [cell.ivBlog setIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [cell.ivBlog setShowActivityIndicatorView:YES];
    
    [cell.ivBlog sd_setImageWithURL:[NSURL URLWithString:strPhotoURL] placeholderImage:[UIImage imageNamed:@"placeHolder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (image) {
            cell.ivBlog.image = image;
        }
    }];
    cell.ivBlog.layer.cornerRadius=3;
    cell.ivBlog.clipsToBounds=YES;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BlogDetail *objBlogDetail = [arrayBlogList objectAtIndex:indexPath.row];
   
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DisplayWebviewVC *webviewVC =[storyboard instantiateViewControllerWithIdentifier:@"DisplayWebviewVC"];
    webviewVC.strUrl = SAFESTRING(objBlogDetail.str_blog_url);
    [self.navigationController pushViewController:webviewVC animated:YES];
}


#pragma mark - WEBSERVICE CALL : For Health Blog -

-(void)callGetBlogDataWebservice
{
    if ([self isNetworkReachable]) {
        [self showSpinnerWithUserActionEnable:false];
        
        Webservice *webserviceObj = [[Webservice alloc]init];
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        
        [dictParam setObject:SAFESTRING([objUserDetail.str_user_id trimSpaces]) forKey:@"user_id"];
        [webserviceObj callJSONMethod:@"get_blogurl" withParameters:dictParam isEncrpyted:NO onSuccessfulResponse:^(NSMutableDictionary *dict) {
            
            [self hideSpinner];
            NSString *strMsg=[dict valueForKey:@"message"];
            
            if ([[dict valueForKey:@"status"] integerValue] == 1 ) {
                
                //[UIAlertController infoAlertWithMessage:[dict valueForKey:@"message"] andTitle:APPNAME controller:self];
                
                self->arrayBlogList=[BlogDetail initWithArray:[dict valueForKey:@"data"] ];
                [self->tblHealthBlog reloadData];
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

#pragma mark - BUTTON CLICK ACTION -

- (IBAction)btnTabButtonClickAction:(id)sender {
    if ([sender tag] == 1) {
        [self.navigationController popViewControllerAnimated:NO];
    }
}
- (IBAction)btnGotItAction:(id)sender {
    self.viewIntro.hidden = YES;
}

@end
