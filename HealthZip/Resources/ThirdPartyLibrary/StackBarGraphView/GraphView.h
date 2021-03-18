//
//  GraphView.h
//  CorePlotBarChartExample
//
//  Created by Anthony Perozzo on 8/06/12.
//  Copyright (c) 2012 Gilthonwe Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"

@protocol BurnGraphDelegate <NSObject>
-(void)userClickedOnBurnGraphBarIndex:(NSInteger)barIndex;

@end
@interface GraphView : CPTGraphHostingView <CPTPlotDataSource, CPTPlotSpaceDelegate,CPTBarPlotDelegate,CPTAnimationDelegate>
{
    CPTXYGraph *graph;
    NSMutableDictionary *data;
}
@property (nonatomic,strong) NSMutableArray *dates;
@property (nonatomic,strong) NSMutableDictionary *sets;
@property (nonatomic,strong) NSMutableArray *arrayActivityValues;
@property (nonatomic,strong) NSMutableArray *arrayStepsEnergyValues;
@property (nonatomic,strong) NSMutableArray *arrayGraphValues;
@property (nonatomic) id<BurnGraphDelegate> delegate;
@property (nonatomic)  float iGraphMinValue;
@property (nonatomic)  float iGraphMaxValue;

- (void)createGraph;

@end
