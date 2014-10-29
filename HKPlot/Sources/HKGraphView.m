//
//  HKGraphView.m
//  HKPlot
//
//  Created by Tran Hoang Ha on 3/28/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "HKGraphView.h"
#import "HKXYGraph.h"
#import "HKAxis.h"
#import "HKDefine.h"

#define kGraphContainerPaddingLeft  100.0f

@interface HKGraphView ()
{
    CGFloat         _paddingLeft;
    CGFloat         _paddingRight;
    CGFloat         _paddingTop;
    CGFloat         _paddingBottom;
}

@end

@implementation HKGraphView

@synthesize xAxis           = _xAxis;
@synthesize yAxis           = _yAxis;
@synthesize graphContainer  = _graphContainer;
@synthesize graph           = _graph;
@synthesize graphLayer      = _graphLayer;

@synthesize paddingLeft     = _paddingLeft;
@synthesize paddingRight    = _paddingRight;
@synthesize paddingTop      = _paddingTop;
@synthesize paddingBottom   = _paddingBottom;

@synthesize dataSource      = _dataSource;
@synthesize delegate        = _delegate;

- (void)dealloc
{
    HKSAFERELEASE(self.dataSource);
    HKSAFERELEASE(self.delegate);
    HKSAFERELEASE(self.graphLayer);
    HKSAFERELEASE(self.graph);
    HKSAFERELEASE(self.graphContainer);
    HKSAFERELEASE(self.xAxis);
    HKSAFERELEASE(self.yAxis);
    
    HKSUPERDEALLOC();
}

- (void)initialize
{
    self.paddingLeft = 0;
    self.paddingRight = 0;
    self.paddingTop = 0;
    self.paddingBottom = 0;
    
    self.yAxis = HKAUTORELEASE([[HKAxis alloc] initWithFrame:self.bounds]);
    self.yAxis.coordinate = HKCoordinateY;
    //self.yAxis.axisPosition = HKAxisPositionLeft;
    [self.layer addSublayer:self.yAxis];
    
    self.graphContainer = HKAUTORELEASE([[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height)]);
    self.graphContainer.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.graphContainer];
    
    self.graph = HKAUTORELEASE([[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.graphContainer.frame.size.width, self.graphContainer.frame.size.height)]);
    self.graph.backgroundColor = [UIColor whiteColor];
    [self.graphContainer addSubview:self.graph];
    
    self.xAxis = HKAUTORELEASE([[HKAxis alloc] initWithFrame:self.graph.bounds]);
    self.xAxis.coordinate = HKCoordinateX;
    //self.xAxis.axisPosition = HKAxisPositionBottom;
    [self.graph.layer addSublayer:self.xAxis];
    
    self.graphLayer = HKAUTORELEASE([[HKXYGraph alloc] initWithFrame:self.graph.bounds]);
    [self.graph addSubview:self.graphLayer];
    self.graphLayer.axisSet.xAxis = self.xAxis;
    self.graphLayer.axisSet.yAxis = self.yAxis;
}

- (void)viewWillLayoutSubviews
{
    //this function is under investigation, please don't use
    
    self.yAxis.frame = self.bounds;
    self.graphContainer.frame = CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height);
    self.graph.frame = CGRectMake(0.0, 0.0, self.graphContainer.frame.size.width, self.graphContainer.frame.size.height);
    self.xAxis.frame = self.graph.bounds;
    self.graphLayer.frame = self.graph.bounds;
    
    [self setPaddingLeft:_paddingLeft];
    [self setPaddingRight:_paddingRight];
    [self setPaddingTop:_paddingTop];
    [self setPaddingBottom:_paddingBottom];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initialize];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (CGFloat)paddingLeft
{
    return _paddingLeft;
}

- (void)setPaddingLeft:(CGFloat)paddingLeft
{
    _paddingLeft = paddingLeft;
    
    CGRect graphContainerFrame = self.graphContainer.frame;
    graphContainerFrame.origin.x = _paddingLeft;
    graphContainerFrame.size.width -= paddingLeft;
    self.graphContainer.frame = graphContainerFrame;
}

- (CGFloat)paddingBottom
{
    return _paddingBottom;
}

- (void)setPaddingBottom:(CGFloat)paddingBottom
{
    _paddingBottom = paddingBottom;
    
    CGRect rect = self.graphLayer.frame;
    rect.size.height = rect.size.height - paddingBottom;
    self.graphLayer.frame = rect;
    
    rect = self.yAxis.frame;
    rect.size.height -= paddingBottom;
    self.yAxis.frame = rect;
}

- (void)reloadData
{
    CGFloat tickXLength = [self.dataSource tickLenghtForXAxis:self.xAxis inGraphView:self];
    NSInteger numberOfRecords = [self.dataSource numberOfRecordInGraphView:self];
    CGFloat graphWidth = tickXLength * numberOfRecords;
    
    CGRect graphRect = self.graph.frame;
    graphRect.size.width = graphWidth;
    self.graph.frame = graphRect;
    
    graphRect = self.graphLayer.frame;
    graphRect.size.width = graphWidth;
    self.graphLayer.frame = graphRect;
    
    self.graphContainer.contentSize = CGSizeMake(graphWidth, graphRect.size.height);
    
    CGRect xAxisRect = self.xAxis.frame;
    xAxisRect.size.width = graphWidth;
    self.xAxis.frame = xAxisRect;
    self.xAxis.tickInterval = tickXLength;
    self.xAxis.axisMin = 0.0;
    self.xAxis.axisMax = graphWidth;
    [self.xAxis redraw];
    
    CGFloat tickYLength = [self.dataSource tickLenghtForYAxis:self.yAxis inGraphView:self];
    self.yAxis.tickInterval = tickYLength;
    self.yAxis.axisMin = 0.0;
    self.yAxis.axisMax = self.frame.size.height;
    
    [self.yAxis redraw];
    
    [self.graph setNeedsDisplay];
}

@end












