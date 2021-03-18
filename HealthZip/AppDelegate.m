//
//  AppDelegate.m
//  HealthZip
//
//  Created by Tristate on 5/30/16.
//  Copyright © 2016 Tristate. All rights reserved.
//

#import "AppDelegate.h"
#import "Constants.h"
#import "HomeVC.h"
#import "LoginVC.h"
#import "IQKeyboardManager.h"
#import <Fabric/Fabric.h>
@import Firebase;


@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize navController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [FIRApp configure];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [USERDEFAULTS setObject:@"1" forKey:@"DASHBOARD"];
   
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"IntroductionScreen1"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"IntroductionScreen1"];
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"IntroductionScreen2"];
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"IntroductionScreen3"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge
                                                                                             |UIRemoteNotificationTypeSound
                                                                                             |UIRemoteNotificationTypeAlert) categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    else
    {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [application registerForRemoteNotificationTypes:myTypes];
    }
    
    
    //Check FontFamily name
    NSArray *fontFamilies = [UIFont familyNames];
    
    for (int i = 0; i < [fontFamilies count]; i++)
    {
        NSString *fontFamily = [fontFamilies objectAtIndex:i];
        NSArray *fontNames = [UIFont fontNamesForFamilyName:[fontFamilies objectAtIndex:i]];
        NSLog (@"%@: %@", fontFamily, fontNames);
    }
     [Fabric with:@[[Crashlytics class]]];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}


#pragma mark - for push notifications
#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
    NSLog(@"%@",[USERDEFAULTS valueForKey:USERDEFAULT_DEVICE_TOKEN]);
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}
#endif

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken{
    NSString *deviceToken = [self convertTokenToDeviceID:devToken];
    
    if(deviceToken!=nil)
    {
        [USERDEFAULTS setObject:deviceToken forKey:USERDEFAULT_DEVICE_TOKEN];
        [USERDEFAULTS synchronize];
    }
}

#pragma mark - convertTokenToDeviceID for 64 and 32 bit devices -
-(NSString *)convertTokenToDeviceID:(NSData *)token
{
    
    NSString *dToken = [[token description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    dToken = [dToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    return dToken;
    
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Fail to register for push notification with error : %@", error);
}

+ (UIViewController*) topMostController
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;

    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }

    return topController;
}

@end
