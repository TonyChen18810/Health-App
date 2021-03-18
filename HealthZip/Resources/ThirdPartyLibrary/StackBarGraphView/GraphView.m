//
//  GraphView.m
//  CorePlotBarChartExample
//
//  Created by Anthony Perozzo on 8/06/12.
//  Copyright (c) 2012 Gilthonwe Apps. All rights reserved.
//

#import "GraphView.h"
#import "Constants.h"


#define CURRENT_SYSYTEM_VERSION [[UIDevice currentDevice]systemVersion].floatValue


@implementation GraphView
@synthesize dates,sets;

- (void)generateData
{
    //Array containing all the dates that will be displayed on the X axis
    //    dates = [NSMutableArray arrayWithObjects:@"sun", @"mon", @"tue",
    //             @"wed",@"thu", nil];
    //call bellow method if you want to modify dates array
    // [self setArrayDates];
    
    UIColor *yellowColor =[UIColor yellowColor];
    UIColor *greenColor =[UIColor greenColor];
    UIColor *redColor =[UIColor redColor];
    UIColor *blackColor =[UIColor blackColor];
    UIColor *clearColor =[UIColor clearColor];
    
    
    sets = [NSMutableDictionary dictionaryWithObjectsAndKeys:blackColor, @"pExtra",redColor,@"minimum",
            greenColor, @"currentValue",
            redColor, @"maximum", nil];
    
    //Generate random data for each set of data that will be displayed for each day
    //Numbers between 1 and 10
    data = [[NSMutableDictionary alloc] init];
    for (int i = 0; i <self.arrayGraphValues.count; i++) {
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        float value = [[_arrayGraphValues objectAtIndex:i] floatValue];
        for (NSString *set in sets) {
            NSNumber *num;
             num = [NSNumber numberWithFloat:0.0];
            if ([set isEqualToString:@"minimum"]) {
                if (value < _iGraphMinValue) {
                    num = [NSNumber numberWithFloat:value];
                }
                else if(value >= _iGraphMinValue && value <= _iGraphMaxValue) {
                    num = [NSNumber numberWithFloat:0.0];
                }
                else if(value > _iGraphMaxValue)
                {
                    num = [NSNumber numberWithFloat:0.0];
                }            }
            else if ([set isEqualToString:@"currentValue"])
            {
                if (value < _iGraphMinValue) {
                    num = [NSNumber numberWithFloat:0.0];
                }
                else if(value >= _iGraphMinValue && value <= _iGraphMaxValue) {
                    num = [NSNumber numberWithFloat:value];
                }
                else if(value > _iGraphMaxValue)
                {
                    num = [NSNumber numberWithFloat:0.0];
                }
            }
            else if ([set isEqualToString:@"maximum"])
            {
                if (value < _iGraphMinValue) {
                    num = [NSNumber numberWithFloat:0.0];
                }
                else if(value >= _iGraphMinValue && value <= _iGraphMaxValue) {
                    num = [NSNumber numberWithFloat:0.0];
                }
                else if(value > _iGraphMaxValue)
                {
                    num = [NSNumber numberWithFloat:value - (value - _iGraphMaxValue)];
                }
            }
            else if ([set isEqualToString:@"pExtra"])
            {
                
               /* if (value < _iGraphMinValue) {
                    num = [NSNumber numberWithFloat:_iGraphMinValue - value];
                }
                else if(value >= _iGraphMinValue && value <= _iGraphMaxValue) {
                    num = [NSNumber numberWithFloat:0.0];
                }
                else if(value > _iGraphMaxValue)
                {
                    num = [NSNumber numberWithFloat:value - _iGraphMaxValue];
                }*/
            }
            
            [dict setObject:num forKey:set];
        }
        [data setObject:dict forKey:[dates objectAtIndex:i]];
    }
    //NSLog(@"%@", data);
}

- (void)generateLayout
{
    //Create graph from theme
    graph                               = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    [graph applyTheme:[CPTTheme themeNamed:kCPTPlainWhiteTheme]];
    self.hostedGraph                    = graph;
    graph.plotAreaFrame.masksToBorder   = NO;
    graph.paddingLeft                   = 0.0f;
    graph.paddingTop                    = 0.0f;
    graph.paddingRight                  = 0.0f;
    graph.paddingBottom                 = 0.0f;
    
    CPTMutableLineStyle *borderLineStyle    = [CPTMutableLineStyle lineStyle];
    borderLineStyle.lineColor               = [CPTColor whiteColor];
    borderLineStyle.lineWidth               = 0.0f;
    graph.plotAreaFrame.borderLineStyle     = borderLineStyle;
    graph.plotAreaFrame.paddingTop          = 10.0;
    graph.plotAreaFrame.paddingRight        = 10.0;
    graph.plotAreaFrame.paddingBottom       = 50.0;
    graph.plotAreaFrame.paddingLeft         = 50.0;//70.0;
    
    //Change By Pankaj :-
    //    NSMutableArray *arrayMaxPlots = [NSMutableArray array];
    //    NSArray *arrtempValue = data.allValues;
    //    for (NSMutableDictionary *dict in arrtempValue) {
    //        NSNumber *sumPlots = [[dict allValues] valueForKeyPath:@"@sum.self"];
    //        [arrayMaxPlots addObject:sumPlots];
    //    }
    //  int maxNum = ceil([[arrayMaxPlots valueForKeyPath:@"@max.self"] intValue]);
    int tempMax = 0;
    for (int i = 0; i<_arrayGraphValues.count; i++) {
        int value = [[_arrayGraphValues objectAtIndex:i] intValue];
        if (tempMax == 0){
            if (value <= self.iGraphMaxValue){
                tempMax = self.iGraphMaxValue;
            }else{
                tempMax = value;
            }
        }else{
            if (value > tempMax){
                tempMax = value;
            }
        }
    }
    int maxNum = tempMax;
    int maxPlot = 10 * ceil((maxNum/10)+0.5);
    
    //Add plot space
    CPTXYPlotSpace *plotSpace       = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    plotSpace.delegate              = self;
    plotSpace.yRange                = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(0) length:CPTDecimalFromInt(maxPlot)];
    plotSpace.xRange                = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(-1) length:CPTDecimalFromInt((int)dates.count+1)];
    
    //Grid line styles
    CPTMutableLineStyle *majorGridLineStyle = [CPTMutableLineStyle lineStyle];
    majorGridLineStyle.lineWidth            = 0.10;
    majorGridLineStyle.lineColor            = [[CPTColor whiteColor] colorWithAlphaComponent:0.1];
    CPTMutableLineStyle *minorGridLineStyle = [CPTMutableLineStyle lineStyle];
    minorGridLineStyle.lineWidth            = 0.25;
    minorGridLineStyle.lineColor            = [[CPTColor whiteColor] colorWithAlphaComponent:0.1];
    
    //Axes
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    
    //X axis
    CPTXYAxis *x                    = axisSet.xAxis;
    x.orthogonalCoordinateDecimal   = CPTDecimalFromInt(0);
    x.majorIntervalLength           = CPTDecimalFromInt(0.75);
    x.minorTicksPerInterval         = 0;
    x.labelingPolicy                = CPTAxisLabelingPolicyNone;
    x.majorGridLineStyle            = majorGridLineStyle;
    x.axisConstraints               = [CPTConstraints constraintWithLowerOffset:0.0];
    
    //X labels
    int labelLocations = 0;
    NSMutableArray *customXLabels = [NSMutableArray array];
    for (NSString *day in dates) {
        CPTAxisLabel *newLabel;
        
        CPTMutableTextStyle *textStyle =[[CPTMutableTextStyle alloc] init];
        textStyle.fontName =@"Roboto-Regular";
        textStyle.fontSize = 12.0;
        textStyle.textAlignment = NSTextAlignmentCenter;
        
        if ([day isEqualToString:@"Today"]) {
            textStyle.color =[CPTColor colorWithCGColor:COLORCODE_GREEN.CGColor];
        }
        else{
            textStyle.color =[CPTColor blackColor];
        }
        
        newLabel = [[CPTAxisLabel alloc] initWithText:day textStyle:textStyle];
        // }
        
        newLabel.tickLocation   = [[NSNumber numberWithInt:labelLocations] decimalValue];
        newLabel.offset         = x.labelOffset + x.majorTickLength;
        //        newLabel.rotation       = M_PI / 4;
        [customXLabels addObject:newLabel];
        labelLocations++;
        
    }
    x.axisLabels                    = [NSSet setWithArray:customXLabels];
    
    //Y axis
    CPTXYAxis *y            = axisSet.yAxis;
    //	y.title                 = @"Value";
    //	y.titleOffset           = 10.0f;
    y.labelingPolicy        = CPTAxisLabelingPolicyAutomatic;
    y.majorGridLineStyle    = majorGridLineStyle;
    y.minorGridLineStyle    = minorGridLineStyle;
    y.axisConstraints       = [CPTConstraints constraintWithLowerOffset:0];
    
    //Create a bar line style
    CPTMutableLineStyle *barLineStyle   = [[CPTMutableLineStyle alloc] init] ;
    barLineStyle.lineWidth              = 1.0;
    barLineStyle.lineColor              = [CPTColor whiteColor];
    CPTMutableTextStyle *whiteTextStyle = [CPTMutableTextStyle textStyle];
    whiteTextStyle.color                = [CPTColor blackColor];
    
    
    
    //Plot
    BOOL firstPlot = YES;
    for (NSString *set in [[sets allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]) {
        CPTBarPlot *plot        = [CPTBarPlot tubularBarPlotWithColor:[CPTColor blueColor] horizontalBars:NO];
        plot.lineStyle          = barLineStyle;
        CGColorRef color        = ((UIColor *)[sets objectForKey:set]).CGColor;
        plot.fill               = [CPTFill fillWithColor:[CPTColor colorWithCGColor:color]];
        if (firstPlot) {
            plot.barBasesVary   = NO;
            firstPlot           = NO;
        } else {
            plot.barBasesVary   = YES;
        }
        plot.barWidth           = CPTDecimalFromFloat(0.4f);
        plot.barsAreHorizontal  = NO;
        plot.dataSource         = self;
        plot.identifier         = set;
        plot.delegate           = self;
        [graph addPlot:plot toPlotSpace:plotSpace];
        
//        NSLog(@"all plots == %@",graph.allPlots);
//        
//        NSLog(@"all PlotSpaces == %@",graph.allPlotSpaces);

        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
        [anim setDuration:1.0f];
        
        anim.toValue = [NSNumber numberWithFloat:1.0f];
        anim.fromValue = [NSNumber numberWithFloat:0.0f];
        anim.removedOnCompletion = NO;
        anim.delegate = self;
        anim.fillMode = kCAFillModeForwards;
        
        plot.anchorPoint = CGPointMake(0.0, 0.0);
        
        [plot addAnimation:anim forKey:@"grow"];
        
        [graph addPlot:plot ];
    }
    
    //Add legend
    //	CPTLegend *theLegend      = [CPTLegend legendWithGraph:graph];
    //	theLegend.numberOfRows	  = sets.count;
    //	theLegend.fill			  = [CPTFill fillWithColor:[CPTColor colorWithGenericGray:0.15]];
    //	theLegend.borderLineStyle = barLineStyle;
    //	theLegend.cornerRadius	  = 10.0;
    //	theLegend.swatchSize	  = CGSizeMake(15.0, 15.0);
    //	whiteTextStyle.fontSize	  = 13.0;
    //	theLegend.textStyle		  = whiteTextStyle;
    //	theLegend.rowMargin		  = 5.0;
    //	theLegend.paddingLeft	  = 10.0;
    //	theLegend.paddingTop	  = 10.0;
    //	theLegend.paddingRight	  = 10.0;
    //	theLegend.paddingBottom	  = 10.0;
    //	graph.legend              = theLegend;
    //    graph.legendAnchor        = CPTRectAnchorTopLeft;
    //    graph.legendDisplacement  = CGPointMake(80.0, -10.0);
    
}

- (void)createGraph
{
    //Generate data
//    self.arrayGraphValues = [[NSMutableArray alloc] initWithObjects:@"11",@"8.6",@"15",nil];
//    dates = [NSMutableArray arrayWithObjects:@"jan", @"fab", @"march", nil];
//    self.iGraphMinValue = 8.4;
//    self.iGraphMaxValue = 10.5;
    [self generateData];
    //Generate layout
    [self generateLayout];
}

-(void)setArrayDates
{
    dates = [NSMutableArray array];
    NSString *strDay;
    for (int i = 0; i <self.arrayGraphValues.count; i++) {
        if (i == self.arrayGraphValues.count -1) {
            strDay=@"Today";
        }
        else{
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            [dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
            NSDate *date = [dateFormatter dateFromString:[[self.arrayGraphValues objectAtIndex:i] valueForKey:@"date"]];
            
            [dateFormatter setDateFormat:@"EEE"];
            strDay = [dateFormatter stringFromDate:date];
        }
        [dates addObject:strDay];
    }
}



//- (void)dealloc
//{
//    [data release];
//    [super dealloc];
//}

#pragma mark - CPTPlotDataSource methods

- (NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return dates.count;
}

- (double)doubleForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    double num = NAN;
    
    //X Value
    if (fieldEnum == 0) {
        num = index;
    } else {
        double offset = 0;
        if (((CPTBarPlot *)plot).barBasesVary) {
            for (NSString *set in [[sets allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]) {
                if ([plot.identifier isEqual:set]) {
                    break;
                }
                offset += [[[data objectForKey:[dates objectAtIndex:index]] objectForKey:set] doubleValue];
            }
        }
        
        //Y Value
        if (fieldEnum == 1) {
            num = [[[data objectForKey:[dates objectAtIndex:index]] objectForKey:plot.identifier] doubleValue] + offset;
        }
        
        //Offset for stacked bar
        else {
            num = offset;
        }
    }
    //    if (fieldEnum != 0){
    //        if (![plot.identifier isEqual:@"currentValue"]){
    //            NSLog(@"my custom == %@ - %d - %d - %f", plot.identifier, (int)index, (int)fieldEnum, num);
    //            int value = [[_arrayGraphValues objectAtIndex:index] intValue];
    //
    //            if([plot.identifier isEqual:@"minimum"]){
    //                if (value >= _iGraphMinValue){
    //                    CPTBarPlot *barPlot  = (CPTBarPlot *)plot;
    //                    CGColorRef color  = [UIColor greenColor].CGColor;
    //                    barPlot.fill          = [CPTFill fillWithColor:[CPTColor colorWithCGColor:color]];
    //                    [graph removePlot:plot];
    ////                    [graph insertPlot:plot atIndex:fieldEnum];
    //                    [graph addPlot:plot];
    //                }else{
    //                    CPTBarPlot *barPlot  = (CPTBarPlot *)plot;
    //                    CGColorRef color  = [UIColor yellowColor].CGColor;
    //                    barPlot.fill          = [CPTFill fillWithColor:[CPTColor colorWithCGColor:color]];
    //                     [graph removePlot:plot];
    //                    [graph addPlot:plot];
    //                }
    //            }else{
    //                if (value >= _iGraphMaxValue){
    //                    CPTBarPlot *barPlot  = (CPTBarPlot *)plot;
    //                    CGColorRef color  = [UIColor redColor].CGColor;
    //                    barPlot.fill          = [CPTFill fillWithColor:[CPTColor colorWithCGColor:color]];
    //                     [graph removePlot:plot];
    //                    [graph addPlot:plot];
    //                }else{
    //                    CPTBarPlot *barPlot  = (CPTBarPlot *)plot;
    //                    CGColorRef color  = [UIColor clearColor].CGColor;
    //                    barPlot.fill       = [CPTFill fillWithColor:[CPTColor colorWithCGColor:color]];
    //                     [graph removePlot:plot];
    //                    [graph addPlot:plot];
    //                }
    //            }
    //        }
    //    }else{
    //        NSLog(@"=====");
    //    }
    
//    NSLog(@"%@ - %d - %d - %f", plot.identifier, (int)index, (int)fieldEnum, num);
    return num;
}


-(void)barPlot:(CPTBarPlot *)plot barWasSelectedAtRecordIndex:(NSUInteger)index
{
    if ([self.delegate respondsToSelector:@selector(userClickedOnBurnGraphBarIndex:)]) {
        [self.delegate userClickedOnBurnGraphBarIndex:index];
        CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
        CPTXYAxis *x          = axisSet.xAxis;
        int labelLocations = 0;
        NSMutableArray *customXLabels = [NSMutableArray array];
        
        for (int i=0; i<dates.count; i++) {
            NSString *day =[dates objectAtIndex:i];
            
            CPTAxisLabel *newLabel;
            
            CPTMutableTextStyle *textStyle =[[CPTMutableTextStyle alloc] init];
            textStyle.fontName =@"Roboto-Regular";
            textStyle.fontSize = 12.0;
            textStyle.textAlignment = NSTextAlignmentCenter;
            
            if (index == i) {
                textStyle.color =[CPTColor colorWithCGColor:COLORCODE_GREEN.CGColor];
            }
            else{
                textStyle.color =[CPTColor blackColor];
            }
            
            newLabel = [[CPTAxisLabel alloc] initWithText:day textStyle:textStyle];
            // }
            
            newLabel.tickLocation   = [[NSNumber numberWithInt:labelLocations] decimalValue];
            newLabel.offset         = x.labelOffset + x.majorTickLength;
            //        newLabel.rotation       = M_PI / 4;
            [customXLabels addObject:newLabel];
            labelLocations++;
            
        }
        x.axisLabels                    = [NSSet setWithArray:customXLabels];
        
    }
    
    
    //graph.title = [NSString stringWithFormat:@"Bar Plot :%ld",(long)index];
}

@end
