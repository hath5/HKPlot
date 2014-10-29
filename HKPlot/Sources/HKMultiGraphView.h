//
//  HKMultiGraphView.h
//  SMBG
//
//  Created by Hung Nguyen on 4/7/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKAxis.h"
#import "HKXYGraph.h"

@class HKMultiGraphView;

@protocol HKMultiGraphViewDataSource <NSObject>

@required
/*
 + You must implement these methods
 */
- (NSInteger)numberOfRecordInGraphView:(HKMultiGraphView*)graphView;
- (CGFloat)tickLenghtForXAxisAtIndex:(int)index inGraphView:(HKMultiGraphView*)graphView;
- (CGFloat)tickLenghtForYAxisAtIndex:(int)index inGraphView:(HKMultiGraphView*)graphView;

- (NSInteger)numberOfPlotInGraph:(HKXYGraph*)graph inGraphView:(HKMultiGraphView*)graphView;
- (HKPlotType)plotTypeForPlotAtIndex:(int)index inGraph:(HKXYGraph*)graph inGraphView:(HKMultiGraphView*)graphView;
- (NSArray*)dataForPlotAtIndex:(int)index inGraph:(HKXYGraph*)graph inGraphView:(HKMultiGraphView*)graphView;

@end

@protocol HKMultiGraphViewDelegate <NSObject>

@end

@interface HKMultiGraphView : UIView

/*
 Graph data source
 */
@property (nonatomic, retain) id<HKMultiGraphViewDataSource>    dataSource;

/*
 Graph delegate
 */
@property (nonatomic, retain) id<HKMultiGraphViewDelegate>      delegate;

/*
 + The graph view will contains yAxis, graph container
 + Graph container contains graph
 */

//we have only one xAxis, but many yAxis
@property (nonatomic, retain) HKAxis*       xAxis;

/*
 The graph will contains xAxis and graph layer
 */
@property (nonatomic, retain) UIScrollView* graphContainer;
@property (nonatomic, retain) UIView*       graphView;

/*
 Graph padding
 */
@property (assign) CGFloat  paddingLeft;
@property (assign) CGFloat  paddingRight;
@property (assign) CGFloat  paddingTop;
@property (assign) CGFloat  paddingBottom;

//we only can add y axis
//default, we have one
- (void)addYAxis;

//we can't remove yAxis at index 0
- (void)removeYAxisAtIndex:(int)axisIndex;

//reload graph view
- (void)reloadData;

@end





