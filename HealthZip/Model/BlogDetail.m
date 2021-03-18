//
//  BlogDetail.m
//  HealthZip
//
//  Created by Tristate on 6/14/16.
//  Copyright © 2016 Tristate. All rights reserved.
//

#import "BlogDetail.h"
#import "Constants.h"

@implementation BlogDetail
@synthesize str_blog_id,str_blog_title,str_blog_url;
@synthesize str_blog_date,str_blog_description;


+(NSMutableArray *)initWithArray:(NSMutableArray *)arrayData
{
    NSMutableArray *arrayDetail = [NSMutableArray array];
    for (NSMutableDictionary *dict in arrayData) {
        BlogDetail *obj     = [[BlogDetail alloc] init];
        
        obj.str_blog_id             = SAFESTRING([dict objectForKey:@"blog_id "]);
        obj.str_blog_title          = SAFESTRING([dict objectForKey:@"blog_title"]);
        obj.str_blog_description    = SAFESTRING([dict objectForKey:@"blog_description"]);
        obj.str_blog_url            = SAFESTRING([dict objectForKey:@"blog_url"]);
        obj.str_blog_date           = SAFESTRING([dict objectForKey:@"blog_date"]);
        obj.str_blogImg             = SAFESTRING([dict objectForKey:@"blogImg"]);
        [arrayDetail addObject:obj];
    }
    return arrayDetail;
}

+(NSMutableArray *)initWithArrayBookAppointment:(NSMutableArray *)arrayData
{
    NSMutableArray *arrayDetail = [NSMutableArray array];
    for (NSMutableDictionary *dict in arrayData) {
        BlogDetail *obj     = [[BlogDetail alloc] init];
        
        obj.str_blog_id             = SAFESTRING([dict objectForKey:@"appointment_id"]);
        obj.str_blog_title          = SAFESTRING([dict objectForKey:@"title"]);
        obj.str_blog_description    = SAFESTRING([dict objectForKey:@"description"]);
        obj.str_blog_url            = SAFESTRING([dict objectForKey:@"blog_url"]);
        obj.str_blog_date           = SAFESTRING([dict objectForKey:@"appointment_time"]);
        obj.str_blogImg             = SAFESTRING([dict objectForKey:@"blogImg"]);
        [arrayDetail addObject:obj];
    }
    return arrayDetail;
}
@end
