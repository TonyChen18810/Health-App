//
//  UserDetail.m
//  HealthZip
//
//  Created by Tristate on 5/30/16.
//  Copyright © 2016 Tristate. All rights reserved.
//

#import "UserDetail.h"
#import "NSString+Extensions.h"

@implementation UserDetail


@synthesize str_email,str_first_name,str_last_name;
@synthesize str_password;
@synthesize str_user_id;
@synthesize str_saved_email;


+(id)sharedInstance
{
    static id sharedManager;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

-(void)encodeWithCoder:(NSCoder*)encoder{
    
    [encoder encodeObject:self.str_user_id forKey:@"str_user_id"];
    [encoder encodeObject:self.str_first_name forKey:@"str_first_name"];
    [encoder encodeObject:self.str_last_name forKey:@"str_last_name"];
    [encoder encodeObject:self.str_email forKey:@"str_email"];
    [encoder encodeObject:self.str_password forKey:@"str_password"];
    [encoder encodeObject:self.str_is_verify forKey:@"str_is_verify"];
    [encoder encodeObject:self.str_profile_pic forKey:@"str_profile_pic"];
    [encoder encodeObject:self.str_saved_email forKey:@"str_saved_email"];
    [encoder encodeObject:self.str_tutorial_status forKey:@"str_tutorial_status"];
}

-(id)initWithCoder:(NSCoder*)decoder
{
    if (self = [super init]) {
      
        self.str_user_id            = [decoder decodeObjectForKey:@"str_user_id"];
        self.str_first_name         = [decoder decodeObjectForKey:@"str_first_name"];
        self.str_last_name          = [decoder decodeObjectForKey:@"str_last_name"];
        self.str_email              = [decoder decodeObjectForKey:@"str_email"];
        self.str_password           = [decoder decodeObjectForKey:@"str_password"];
        self.str_is_verify          = [decoder decodeObjectForKey:@"str_is_verify"];
        self.str_profile_pic        = [decoder decodeObjectForKey:@"str_profile_pic"];
        self.str_saved_email        = [decoder decodeObjectForKey:@"str_saved_email"];
        self.str_tutorial_status        = [decoder decodeObjectForKey:@"str_tutorial_status"];
    }
    return self;
}

-(void)saveDetail:(UserDetail*)objDetail{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    NSString *pathForSavedFile = [NSString stringWithFormat:@"USER_DETAIL"];
    pathForSavedFile = [pathForSavedFile pathInDocumentDirectory];
    if ([[NSFileManager defaultManager] fileExistsAtPath:pathForSavedFile]) {
        [[NSFileManager defaultManager] removeItemAtPath:pathForSavedFile error:nil];
    }
    [data writeToFile:pathForSavedFile atomically:NO];
    
}
-(UserDetail*)getDetail{
    NSString *pathForSavedFile = [NSString stringWithFormat:@"USER_DETAIL"];
    pathForSavedFile = [pathForSavedFile pathInDocumentDirectory];
    NSData *dataGet = [NSData dataWithContentsOfFile:pathForSavedFile];
    return  [NSKeyedUnarchiver unarchiveObjectWithData:dataGet];
}

@end
