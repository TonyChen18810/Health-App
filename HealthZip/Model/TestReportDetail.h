//
//  TestReportDetail.h
//  HealthZip
//
//  Created by Tristate on 6/23/16.
//  Copyright © 2016 Tristate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface TestReportDetail : NSObject

@property (nonatomic, strong) NSString *str_report_test_id;
@property (nonatomic, strong) NSString *str_test_name;
@property (nonatomic, strong) NSString *str_created_date;
@property (nonatomic, strong) NSString *str_test_parameter_unit;
@property (nonatomic, strong) NSString *str_report_date;
@property (nonatomic, strong) NSString *str_report_Lab;
@property (nonatomic, strong) NSString *str_report_Description;
@property (nonatomic, strong) NSString *str_test_maximum_value;
@property (nonatomic, strong) NSString *str_test_minimum_value;
@property (nonatomic, strong) NSString *str_test_parameter_id;
@property (nonatomic, strong) NSString *str_test_parameter_value;
@property (nonatomic, strong) NSString *str_test_Color;
@property (nonatomic, strong) NSString *str_month;
@property (nonatomic, strong) NSMutableArray *array_Test_value;
@property (nonatomic, strong) NSMutableArray *array_All_Test_value;
@property (nonatomic, strong) NSString *str_Total_Test_value;
@property (assign) BOOL is_Empty_Value;

+(NSMutableArray *)initWithArray:(NSMutableArray *)arrayData;
+(NSMutableArray *)initWithArrayAverage:(NSMutableArray *)arrayData;
+(BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate;
+(NSMutableArray *)initWithAllData:(NSMutableArray *)arrayData;
@end
