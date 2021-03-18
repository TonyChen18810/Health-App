//
//  TestParameterDetail.h
//  HealthZip
//
//  Created by Tristate on 6/1/16.
//  Copyright © 2016 Tristate. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestParameterDetail : NSObject

@property (nonatomic, strong) NSString *str_test_user_id;
@property (nonatomic, strong) NSString *str_test_parameter_id;
@property (nonatomic, strong) NSString *str_test_parameter_name;
@property (nonatomic, strong) NSString *str_test_parameter_minimum_ratio;
@property (nonatomic, strong) NSString *str_test_parameter_maximum_ratio;
@property (nonatomic, strong) NSString *str_test_parameter_unit;
@property (nonatomic, strong) NSString *str_test_parameter_description;
@property (nonatomic, strong) NSString *str_test_parameter_date;
@property (nonatomic, strong) NSString *str_test_parameter_value;
@property (nonatomic) BOOL isTestReport;

+(NSMutableArray *)initWithArray:(NSMutableArray *)arrayData;

@end
