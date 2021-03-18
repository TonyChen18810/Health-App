//
//  TestReportDetail.m
//  HealthZip
//
//  Created by Tristate on 6/23/16.
//  Copyright © 2016 Tristate. All rights reserved.
//

#import "TestReportDetail.h"
#import "Constants.h"

@implementation TestReportDetail

@synthesize str_test_parameter_id;
@synthesize str_report_test_id;
@synthesize str_created_date,str_report_date;
@synthesize str_test_name,str_test_parameter_value;
@synthesize str_test_maximum_value,str_test_minimum_value,str_test_parameter_unit;


+(NSMutableArray *)initWithArray:(NSMutableArray *)arrayData
{
    NSMutableArray *arrayDetail = [NSMutableArray array];
    
    for (NSMutableDictionary *dict in arrayData) {
        TestReportDetail *obj     = [[TestReportDetail alloc] init];
        
        obj.str_test_name           = SAFESTRING([dict objectForKey:@"test_name"]);
        obj.str_test_minimum_value  = SAFESTRING([dict objectForKey:@"test_minimum_value"]);
        obj.str_test_maximum_value  = SAFESTRING([dict objectForKey:@"test_maximum_value"]);
        obj.str_test_parameter_unit = SAFESTRING([dict objectForKey:@"test_parameter_unit"]);
        
        obj.array_Test_value=[[NSMutableArray alloc] init];
        
        NSString *strCondition=@"";
        long temp=0;
        NSArray *arrTestvalue =[dict objectForKey:@"test_value"];
        for (NSMutableDictionary *dictTest in arrTestvalue) {
            
            TestReportDetail *objTest      = [[TestReportDetail alloc] init];
            
            objTest.str_created_date          = SAFESTRING([dict objectForKey:@"created_date"]);
            objTest.str_report_test_id        = SAFESTRING([dictTest objectForKey:@"report_test_id"]);
            objTest.str_test_parameter_id     = SAFESTRING([dictTest objectForKey:@"test_parameter_id"]);
            objTest.str_report_date           = SAFESTRING([dictTest objectForKey:@"report_date"]);
            objTest.str_report_Lab            = SAFESTRING([dictTest objectForKey:@"report_lab"]);
            objTest.str_report_Description    = SAFESTRING([dictTest objectForKey:@"report_description"]);
            objTest.str_test_parameter_value  = SAFESTRING([dictTest objectForKey:@"test_parameter_value"]);
            objTest.str_test_name             = SAFESTRING([dict objectForKey:@"test_name"]);
            
            
            temp= temp + [[dictTest objectForKey:@"test_parameter_value"] integerValue]; //integer Value color add
            [obj.array_Test_value addObject:objTest];
        }
        
        if (temp > 0) { //Get The Average From The Test_parameter_value Average
            strCondition = [NSString stringWithFormat:@"%lu",temp/arrTestvalue.count]; //Int / arrcount
            if ([strCondition floatValue]>= [[dict objectForKey:@"test_minimum_value"] floatValue] && [strCondition floatValue]<= [[dict objectForKey:@"test_maximum_value"] floatValue]) {
                obj.str_test_Color=@"GREEN"; ////>=Min <=Max
            }else if ([strCondition floatValue] < [dict[@"test_minimum_value"] floatValue]){
                obj.str_test_Color=@"RED"; ////<Min
            }else{
                obj.str_test_Color=@"RED"; //> max
            }
        }else{
            obj.str_test_Color=@"RED"; //temp = 0
        }
        [arrayDetail addObject:obj];
    }
    return arrayDetail;
}
+(NSMutableArray *)initWithArrayAverage:(NSMutableArray *)arrayData
{
    NSMutableArray *arrayDetail = [NSMutableArray array];
    
    for (NSMutableDictionary *dict in arrayData) {
        TestReportDetail *obj     = [[TestReportDetail alloc] init];
        
        obj.str_test_name           = SAFESTRING([dict objectForKey:@"test_name"]);
        obj.str_test_minimum_value  = SAFESTRING([dict objectForKey:@"test_minimum_value"]);
        obj.str_test_maximum_value  = SAFESTRING([dict objectForKey:@"test_maximum_value"]);
        obj.str_test_parameter_unit = SAFESTRING([dict objectForKey:@"test_parameter_unit"]);
        
        
        obj.array_Test_value=[[NSMutableArray alloc] init];
        
        obj.str_Total_Test_value = [NSString stringWithFormat:@"%lu",(unsigned long)[self findtotalMonths:dict]];
        
        NSString *strCondition=@"";
        float temp=0;
        NSArray *arrTestvalue =[dict objectForKey:@"test_value"];
        NSArray *filterArray = [self arrayFilter:arrTestvalue];
        
        int testCount = 0; //test_Value Array Count
        for (NSMutableDictionary *dictTest in filterArray) { //Array Data For Last Three Months From Today
            TestReportDetail *objTest     = [[TestReportDetail alloc] init];
            
            objTest.str_created_date          = SAFESTRING([dict objectForKey:@"created_date"]);
            objTest.str_report_test_id        = SAFESTRING([dictTest objectForKey:@"report_test_id"]);
            objTest.str_test_parameter_id     = SAFESTRING([dictTest objectForKey:@"test_parameter_id"]);
            objTest.str_report_date           = SAFESTRING([dictTest objectForKey:@"report_date"]);
            objTest.str_report_Lab            = SAFESTRING([dictTest objectForKey:@"report_lab"]);
            objTest.str_report_Description    = SAFESTRING([dictTest objectForKey:@"report_description"]);
            objTest.str_test_parameter_value  = SAFESTRING([dictTest objectForKey:@"test_parameter_value"]);
            objTest.str_month                 = SAFESTRING([dictTest objectForKey:@"month"]);
            objTest.is_Empty_Value            = NO;
            
            
            temp= temp + [[dictTest objectForKey:@"test_parameter_value"] floatValue]; //Get total from filter array
            [obj.array_Test_value addObject:objTest];
        }
        
        if (temp > 0) { //Average From test_parameter_value
            
            int i;
            float sum = 0;
            
            for (i = 0; i < [arrTestvalue count]; i++) {
                NSString *str = [[arrTestvalue valueForKey:@"test_parameter_value"]objectAtIndex:i];
                
                if ([str isEqualToString:@""]) {
                    obj.is_Empty_Value = YES;
                }
                
                sum = sum + [[[arrTestvalue valueForKey:@"test_parameter_value"]objectAtIndex:i]floatValue]; //Float Value Color add
                testCount +=1;
            }
            strCondition = [NSString stringWithFormat:@"%.1f",sum/arrTestvalue.count]; //Get total from parameter_value and average //Float / arrCount
            if ([strCondition floatValue] >= [[dict objectForKey:@"test_minimum_value"] floatValue] && [strCondition floatValue]<= [[dict objectForKey:@"test_maximum_value"] floatValue]) {
                obj.str_test_Color=@"GREEN"; // Min=> <=Max //GREEN
            }else if ([strCondition floatValue] < [[dict objectForKey:@"test_minimum_value"] floatValue]){
                obj.str_test_Color=@"GREEN"; ////<Min
            }else{
                obj.str_test_Color=@"RED";  // Min< >Max //RED
            }
        }else{
            obj.is_Empty_Value = YES;
            obj.str_test_Color=@"RED"; ////temp < 0 //Avg
        }
        [arrayDetail addObject:obj];
    }
    return arrayDetail;
}
+(BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate
{
    if ([date compare:beginDate] == NSOrderedDescending)
        return NO;
    
    if ([date compare:endDate] == NSOrderedAscending)
        return NO;
    
    return YES;
}

+(NSMutableArray *)arrayFilter:(NSArray*)arrValue{
    NSMutableArray *arrFirst = [NSMutableArray array];
    NSMutableArray *arrSecond = [NSMutableArray array];
    NSMutableArray *arrThird = [NSMutableArray array];
    NSMutableArray *arrReturn = [NSMutableArray array];
    
    bool isYear = false;
    long currentMonth = 0;
    
    
    for (NSDictionary *dict in arrValue) {
        NSString *timeStamp = [dict objectForKey:@"report_date"]; //report_date
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStamp doubleValue]];
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDate *currentDate = [NSDate date];
        
        NSDateComponents *componentsCurrent = [calendar components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:currentDate];
        NSDateComponents *componentsCompare = [calendar components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:date];
        
        NSDateComponents *comps1 = [NSDateComponents new];
        comps1.month = -1;
        
        NSDateComponents *comps2 = [NSDateComponents new];
        comps2.month = -2;
        
        currentMonth = componentsCurrent.month;
        long current = [calendar components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:currentDate].month + 12;
        long compare = [calendar components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:date].month;
        isYear = false;
        if (componentsCurrent.year != componentsCompare.year) {
            isYear = true;
            
            if (current > compare) {
                if ((current - 2) > compare){
                    
                }else{
                    if (currentMonth == 1){
                        if (compare == (current - 1)){
                            [arrSecond addObject:dict];
                        }else if (compare == (current - 2)){
                            [arrFirst addObject:dict];
                        }
                    }else if (currentMonth == 2){
                        [arrFirst addObject:dict];
                    }
                }
            }else{
            }
        }else{
            if (isYear == false) {
                if (componentsCurrent.month == componentsCompare.month && componentsCurrent.year==componentsCompare.year) {
                    [arrFirst addObject:dict];
                }
                componentsCurrent.month = componentsCurrent.month - 1;
                if (componentsCurrent.month == componentsCompare.month && componentsCurrent.year==componentsCompare.year) { //
                    [arrSecond addObject:dict];
                }
                componentsCurrent.month = componentsCurrent.month - 1;
                if (componentsCurrent.month == componentsCompare.month && componentsCurrent.year ==componentsCompare.year ) { //
                    [arrThird addObject:dict];
                }
            }else{
                if (currentMonth == 1) {
                    if (compare == 1){
                        [arrThird addObject:dict];
                    }
                }else if (currentMonth == 2){
                    if (compare == 1){
                        [arrSecond addObject:dict];
                    }else if (compare == 2){
                        [arrThird addObject:dict];
                    }
                }
            }
        }
    }
    
    
    float total = 0;
    NSMutableDictionary *dictThird = [NSMutableDictionary dictionary];
    total = 0;
    for(NSDictionary *dict in arrThird){
        NSString *strValue=[dict objectForKey:@"test_parameter_value"];
        total+=[strValue floatValue];
        [dictThird addEntriesFromDictionary:dict];
    }
    if (dictThird.allKeys.count >0) {
        [dictThird setObject:[NSString stringWithFormat:@"%.2f",total/arrThird.count] forKey:@"test_parameter_value"];
        [arrReturn addObject:dictThird];
    }
    NSMutableDictionary *dictSecond = [NSMutableDictionary dictionary];
    total = 0;
    for(NSDictionary *dict in arrSecond){
        NSString *strValue=[dict objectForKey:@"test_parameter_value"];
        total+=[strValue floatValue];
        [dictSecond addEntriesFromDictionary:dict];
    }
    if (dictSecond.allKeys.count >0) {
        [dictSecond setObject:[NSString stringWithFormat:@"%.2f",total/arrSecond.count] forKey:@"test_parameter_value"];
        [arrReturn addObject:dictSecond];
    }
    
    NSMutableDictionary *dictFirst = [NSMutableDictionary dictionary];
    total = 0;
    for(NSDictionary *dict in arrFirst){
        NSString *strValue=[dict objectForKey:@"test_parameter_value"];
        total+=[strValue floatValue];
        [dictFirst addEntriesFromDictionary:dict];
    }
    if (dictFirst.allKeys.count >0) {
        [dictFirst setObject:[NSString stringWithFormat:@"%.2f",total/arrFirst.count] forKey:@"test_parameter_value"];
        [arrReturn addObject:dictFirst];
    }
    
    return arrReturn; //Get Data from current month to last three month and add to filter array.
}


+(NSUInteger)findtotalMonths:(NSMutableDictionary *)dictTestData{
//    NSLog(@"Dictionary Data of Total Months are %@",dictTestData);
    
    NSDateFormatter *formater =[[NSDateFormatter alloc] init];
    [formater setDateFormat:@"dd-MMM-yyyy"];
    //Value of parameter and report date
    
    
    NSMutableArray *arrMonthData = [NSMutableArray array];
    
    NSArray *arrMonths = [dictTestData objectForKey:@"test_value"];
       
    arrMonthData = [NSMutableArray array];
    for (NSDictionary *dict in arrMonths){
        
        NSDate *date1 =[NSDate dateWithTimeIntervalSince1970:[dict[@"report_date"] floatValue]];
        NSString *timeStamp = [dict objectForKey:@"report_date"]; //report_date
        NSString *test_Param = [dict objectForKey:@"test_parameter_value"]; //report_date
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStamp doubleValue]];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *componentsCompare = [calendar components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:date];
        NSNumber *val = [NSNumber numberWithInteger:componentsCompare.month];
        
        if ([test_Param isEqualToString:@""]) {
            
        }else{
            [arrMonthData addObject:val];
        }
    }
    return arrMonthData.count;
}

+(NSMutableArray *)appendToArray: (NSDictionary *)arrayData{
    
    NSMutableArray *arrData = [[NSMutableArray alloc]init];
    
    for (NSMutableDictionary *dictTest in arrayData) {
        TestReportDetail *objTest          = [[TestReportDetail alloc] init];
        
        objTest.str_created_date           = SAFESTRING([dictTest objectForKey:@"created_date"]);
        objTest.str_report_test_id         = SAFESTRING([dictTest objectForKey:@"report_test_id"]);
        objTest.str_test_parameter_id      = SAFESTRING([dictTest objectForKey:@"test_parameter_id"]);
        objTest.str_report_date            = SAFESTRING([dictTest objectForKey:@"report_date"]);
        objTest.str_report_Lab             = SAFESTRING([dictTest objectForKey:@"report_lab"]);
        objTest.str_report_Description     = SAFESTRING([dictTest objectForKey:@"report_description"]);
        objTest.str_test_parameter_value   = SAFESTRING([dictTest objectForKey:@"test_parameter_value"]);
        objTest.str_month                  = SAFESTRING([dictTest objectForKey:@"month"]);
        
        if ([objTest.str_test_parameter_value isEqualToString:@""]) {
            
        }else{
            [arrData addObject:objTest];
        }
    }
    
    return arrData;
}

//Get All Array Data For Home VC
+(NSMutableArray *)initWithAllData:(NSMutableArray *)arrayData //For Get All Data
{
    NSMutableArray *arrayDetail = [NSMutableArray array];
    
    for (NSMutableDictionary *dict in arrayData) {
        TestReportDetail *obj     = [[TestReportDetail alloc] init];
        
        obj.str_test_name           = SAFESTRING([dict objectForKey:@"test_name"]);
        obj.str_test_minimum_value  = SAFESTRING([dict objectForKey:@"test_minimum_value"]);
        obj.str_test_maximum_value  = SAFESTRING([dict objectForKey:@"test_maximum_value"]);
        obj.str_test_parameter_unit = SAFESTRING([dict objectForKey:@"test_parameter_unit"]);
        
        obj.array_Test_value=[[NSMutableArray alloc] init];
        obj.str_Total_Test_value = [NSString stringWithFormat:@"%lu",(unsigned long)[self findtotalMonths:dict]];
        
        NSString *strCondition=@"";
        float temp=0;
        NSArray *arrTestvalue =[dict objectForKey:@"test_value"];
        obj.array_All_Test_value = [self appendToArray:arrTestvalue];
        
        int testCount = 0; //test_Value Array Count
        for (NSMutableDictionary *dictTest in arrTestvalue) { //Array Data For Last Three Months From Today
            TestReportDetail *objTest          = [[TestReportDetail alloc] init];
               
            objTest.str_created_date           = SAFESTRING([dict objectForKey:@"created_date"]);
            objTest.str_report_test_id         = SAFESTRING([dictTest objectForKey:@"report_test_id"]);
            objTest.str_test_parameter_id      = SAFESTRING([dictTest objectForKey:@"test_parameter_id"]);
            objTest.str_report_date            = SAFESTRING([dictTest objectForKey:@"report_date"]);
            objTest.str_report_Lab             = SAFESTRING([dictTest objectForKey:@"report_lab"]);
            objTest.str_report_Description     = SAFESTRING([dictTest objectForKey:@"report_description"]);
            objTest.str_test_parameter_value   = SAFESTRING([dictTest objectForKey:@"test_parameter_value"]);
            objTest.str_month                  = SAFESTRING([dictTest objectForKey:@"month"]);
            obj.is_Empty_Value                 = NO;
            
            temp= temp + [[dictTest objectForKey:@"test_parameter_value"] floatValue]; //Get total from filter array
            
            [obj.array_Test_value addObject:objTest];
        }
        if (temp > 0) { //Average From test_parameter_value
            
            int i;
            float sum = 0;
            
            for (i = 0; i < [arrTestvalue count]; i++) {
                sum = sum + [[[arrTestvalue valueForKey:@"test_parameter_value"]objectAtIndex:i]floatValue]; //Float Value Color add
                testCount +=1;
                
                NSString *str = [[arrTestvalue valueForKey:@"test_parameter_value"]objectAtIndex:i];
                if ([str isEqualToString:@""]) {
                    obj.is_Empty_Value = YES;
                }
            }
            
            strCondition = [NSString stringWithFormat:@"%.1f",sum/arrTestvalue.count]; //Get total from parameter_value and average //Float / arrCount
            if ([strCondition floatValue] >= [[dict objectForKey:@"test_minimum_value"] floatValue] && [strCondition floatValue]<= [[dict objectForKey:@"test_maximum_value"] floatValue]) {
                obj.str_test_Color=@"GREEN"; // Min=> <=Max //GREEN
            }else if ([strCondition floatValue] < [[dict objectForKey:@"test_minimum_value"] floatValue]){
                obj.str_test_Color=@"RED"; ////<Min
            }else{
                obj.str_test_Color=@"RED";  // Min< >Max //RED
            }
        }else{
            obj.str_test_Color=@"RED"; ////temp < 0 //Avg
            obj.is_Empty_Value = YES;
        }
        [arrayDetail addObject:obj];
    }
    return arrayDetail;
}

@end
