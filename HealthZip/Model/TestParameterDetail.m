//
//  TestParameterDetail.m
//  HealthZip
//
//  Created by Tristate on 6/1/16.
//  Copyright © 2016 Tristate. All rights reserved.
//

#import "TestParameterDetail.h"
#import "Constants.h"

@implementation TestParameterDetail

@synthesize str_test_parameter_id;
@synthesize str_test_parameter_name;
@synthesize str_test_parameter_minimum_ratio;
@synthesize str_test_parameter_maximum_ratio;
@synthesize str_test_parameter_description;
@synthesize str_test_parameter_date;
@synthesize str_test_parameter_value;

+(NSMutableArray *)initWithArray:(NSMutableArray *)arrayData
{
    NSMutableArray *arrayDetail = [NSMutableArray array];
    for (NSMutableDictionary *dict in arrayData) {
        TestParameterDetail *obj     = [[TestParameterDetail alloc] init];
        
        obj.str_test_user_id                  = SAFESTRING([dict objectForKey:@"user_id"]);
        obj.str_test_parameter_id             = SAFESTRING([dict objectForKey:@"test_parameter_id"]);
        obj.str_test_parameter_name           = SAFESTRING([dict objectForKey:@"test_parameter_name"]);
        obj.str_test_parameter_minimum_ratio  = SAFESTRING([dict objectForKey:@"test_parameter_minimum_ratio"]);
        obj.str_test_parameter_maximum_ratio  = SAFESTRING([dict objectForKey:@"test_parameter_maximum_ratio"]);
        obj.str_test_parameter_description    = SAFESTRING([dict objectForKey:@"test_parameter_description"]);
        obj.str_test_parameter_unit           = SAFESTRING([dict objectForKey:@"test_parameter_unit"]);
        obj.str_test_parameter_date           = SAFESTRING([dict objectForKey:@"modifiedDate"]);
        obj.str_test_parameter_value          = SAFESTRING([dict objectForKey:@"test_parameter_value"]);
        [arrayDetail addObject:obj];
    }
    return arrayDetail;
}

@end
