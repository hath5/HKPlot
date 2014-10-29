//
//  HKGraphView.h
//  HKPlot
//
//  Created by Tran Hoang Ha on 3/28/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKAxis.h"
#import "HKXYGraph.h"

@class HKGraphView;

@protocol HKGraphViewDataSource <NSObject>

@required
/*
 + You must implement these methods
 */
- (NSInteger)numberOfRecordInGraphView:(HKGraphView*)graphView;
- (CGFloat)tickLenghtForXAxis:(HKAxis*)axis inGraphView:(HKGraphView*)graphView;
- (CGFloat)tickLenghtForYAxis:(HKAxis*)axis inGraphView:(HKGraphView*)graphView;

@end

@protocol HKGraphViewDelegate <NSObject>

@end

@interface HKGraphView : UIView
/*
 + The graph view will contains yAxis, graph container
 + Graph container contains graph
 */

@property (nonatomic, retain) HKAxis*       xAxis;
@property (nonatomic, retain) HKAxis*       yAxis;

/*
 The graph will contains xAxis and graph layer
 */
@property (nonatomic, retain) UIView*       graph;
@property (nonatomic, retain) UIScrollView* graphContainer;
@property (nonatomic, retain) HKXYGraph*    graphLayer;

/*
 Graph padding
 */
@property (assign) CGFloat  paddingLeft;
@property (assign) CGFloat  paddingRight;
@property (assign) CGFloat  paddingTop;
@property (assign) CGFloat  paddingBottom;

/*
 Graph data source
 */
@property (nonatomic, retain) id<HKGraphViewDataSource> dataSource;

/*
 Graph delegate
 */
@property (nonatomic, retain) id<HKGraphViewDelegate> delegate;

- (void)reloadData;

- (void)viewWillLayoutSubviews;

@end





