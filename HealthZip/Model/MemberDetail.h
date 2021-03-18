//
//  MemberDetail.h
//  HealthZip
//
//  Created by Tristate on 5/31/16.
//  Copyright © 2016 Tristate. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MemberDetail : NSObject

@property (nonatomic, strong) NSString *str_user_id;
@property (nonatomic, strong) NSString *str_from_user_id;
@property (nonatomic, strong) NSString *str_first_name;
@property (nonatomic, strong) NSString *str_last_name;
@property (nonatomic, strong) NSString *str_email;
@property (nonatomic, strong) NSString *str_password;
@property (nonatomic, strong) NSString *str_is_verify;

@property (nonatomic, strong) NSString *str_gender;
@property (nonatomic, strong) NSString *str_profile_pic;
@property (nonatomic, strong) NSString *str_user_role;
@property (nonatomic, strong) NSString *str_mobile_no;
@property (nonatomic, strong) NSString *str_address;

@property (nonatomic, strong) NSString *str_device_type;
@property (nonatomic, strong) NSString *str_device_token;
@property (nonatomic, strong) NSString *str_guid;
@property (nonatomic, strong) NSString *str_created_date;

+(NSMutableArray *)initWithArray:(NSMutableArray *)arrayData;
@end
