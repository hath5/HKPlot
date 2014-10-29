//
//  HKXYGraph.h
//  HKPlot
//
//  Created by Tran Hoang Ha on 3/28/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "HKAxis.h"

enum
{
    HKPlotType_Line = 0,
    HKPlotType_Bar,
};

typedef NSUInteger HKPlotType;

@interface HKAxisSet : NSObject
{
    HKAxis*     _xAxis;
    HKAxis*     _yAxis;
}

@property (nonatomic, retain) HKAxis* xAxis;
@property (nonatomic, retain) HKAxis* yAxis;

@end

@class HKXYGraph;

@protocol HKXYGraphDataSource <NSObject>

@required
/*
 + You must implement these methods
 */
- (NSInteger)numberOfPlotInGraph:(HKXYGraph*)graph;
- (HKPlotType)plotTypeForPlotAtIndex:(int)index inGraph:(HKXYGraph*)graph;
- (NSArray*)dataForPlotAtIndex:(int)index inGraph:(HKXYGraph*)graph;

@end

@interface HKXYGraph : UIView
{
}

@property (nonatomic, retain) HKAxisSet*    axisSet;
@property (nonatomic, retain) id<HKXYGraphDataSource> dataSource;

- (id)initWithFrame:(CGRect)frame;

@end
