//
//  BlogDetail.h
//  HealthZip
//
//  Created by Tristate on 6/14/16.
//  Copyright © 2016 Tristate. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlogDetail : NSObject

@property (nonatomic, strong) NSString *str_blog_id;
@property (nonatomic, strong) NSString *str_blog_url;
@property (nonatomic, strong) NSString *str_blog_title;
@property (nonatomic, strong) NSString *str_blog_description;
@property (nonatomic, strong) NSString *str_blog_date;
@property (nonatomic, strong) NSString *str_blogImg;

+(NSMutableArray *)initWithArray:(NSMutableArray *)arrayData;
+(NSMutableArray *)initWithArrayBookAppointment:(NSMutableArray *)arrayData;
@end
