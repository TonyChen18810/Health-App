//
//  MemberDetail.m
//  HealthZip
//
//  Created by Tristate on 5/31/16.
//  Copyright © 2016 Tristate. All rights reserved.
//

#import "MemberDetail.h"
#import "Constants.h"

@implementation MemberDetail

@synthesize str_user_id;
@synthesize str_first_name,str_last_name;
@synthesize str_user_role;
@synthesize str_from_user_id;

@synthesize str_email;
@synthesize str_password;

@synthesize str_is_verify;
@synthesize str_address;
@synthesize str_gender;
@synthesize str_mobile_no;
@synthesize str_profile_pic;

@synthesize str_created_date;
@synthesize str_device_token;
@synthesize str_device_type;
@synthesize str_guid;


+(NSMutableArray *)initWithArray:(NSMutableArray *)arrayData
{
    NSMutableArray *arrayDetail = [NSMutableArray array];
    for (NSMutableDictionary *dict in arrayData) {
        MemberDetail *obj     = [[MemberDetail alloc] init];
        
        obj.str_user_id          = SAFESTRING([dict objectForKey:@"user_id"]);
        obj.str_first_name        = SAFESTRING([dict objectForKey:@"first_name"]);
        obj.str_last_name        = SAFESTRING([dict objectForKey:@"last_name"]);
        obj.str_user_role        = SAFESTRING([dict objectForKey:@"user_role"]);
        obj.str_from_user_id     = SAFESTRING([dict objectForKey:@"from_user_id"]);
        obj.str_email            = SAFESTRING([dict objectForKey:@"email_id"]);
        obj.str_gender           = SAFESTRING([dict objectForKey:@"gender"]);
        obj.str_mobile_no        = SAFESTRING([dict objectForKey:@"mobile_no"]);
        obj.str_password         = SAFESTRING([dict objectForKey:@"password"]);
        obj.str_profile_pic      = SAFESTRING([dict objectForKey:@"profile_pic"]);
        obj.str_is_verify        = SAFESTRING([dict objectForKey:@"is_verify"]);
        
        [arrayDetail addObject:obj];
    }
    return arrayDetail;
}

@end
