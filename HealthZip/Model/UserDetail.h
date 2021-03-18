//
//  UserDetail.h
//  HealthZip
//
//  Created by Tristate on 5/30/16.
//  Copyright © 2016 Tristate. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDetail : NSObject


//----As per new design required only bellow fields data ----//
@property (nonatomic, strong) NSString *str_user_id;
@property (nonatomic, strong) NSString *str_first_name;
@property (nonatomic, strong) NSString *str_last_name;
@property (nonatomic, strong) NSString *str_email;
@property (nonatomic, strong) NSString *str_password;
@property (nonatomic, strong) NSString *str_is_verify;
@property (nonatomic, strong) NSString *str_saved_email;
@property (nonatomic, strong) NSString *str_tutorial_status; //0 false 1 true
@property (nonatomic, strong) NSString *str_profile_pic;

+(id)sharedInstance;
-(void)saveDetail:(UserDetail*)objDetail;
-(UserDetail*)getDetail;

@end
