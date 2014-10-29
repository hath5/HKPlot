//
//  HKMultiGraphView.m
//  SMBG
//
//  Created by Hung Nguyen on 4/7/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "HKMultiGraphView.h"

@interface HKMultiGraphView () <HKXYGraphDataSource>
{
    CGFloat         _paddingLeft;
    CGFloat         _paddingRight;
    CGFloat         _paddingTop;
    CGFloat         _paddingBottom;
    
    id<HKMultiGraphViewDataSource>  _dataSource;
    id<HKMultiGraphViewDelegate>    _delegate;
    
    NSMutableArray* _yAxises;
    NSMutableArray* _graphs;
}

@property (nonatomic, retain) NSMutableArray*   yAxises;
@property (nonatomic, retain) NSMutableArray*   graphs;

@end

@implementation HKMultiGraphView

@synthesize dataSource = _dataSource;
@synthesize delegate = _delegate;
@synthesize paddingLeft = _paddingLeft;
@synthesize paddingRight = _paddingRight;
@synthesize paddingBottom = _paddingBottom;
@synthesize paddingTop = _paddingTop;

@synthesize yAxises = _yAxises;
@synthesize xAxis = _xAxis;
@synthesize graphContainer = _graphContainer;
@synthesize graphView = _graphView;
@synthesize graphs = _graphs;

- (void)dealloc
{
    self.dataSource = nil;
    self.delegate = nil;
    self.yAxises = nil;
    self.xAxis = nil;
    self.graphContainer = nil;
    self.graphView = nil;
    self.graphs = nil;
    HKSUPERDEALLOC();
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

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    self.paddingLeft = 0;
    self.paddingRight = 0;
    self.paddingTop = 0;
    self.paddingBottom = 0;
    
    //default, we have one yAxis, this axis can't be removed
    HKAxis* yAxis = HKAUTORELEASE([[HKAxis alloc] initWithFrame:self.bounds]);
    yAxis.coordinate = HKCoordinateY;
    [self.layer addSublayer:yAxis];
    self.yAxises = [NSMutableArray arrayWithCapacity:0];
    [self.yAxises addObject:yAxis];
    //yAxis.axisPosition = HKAxisPositionLeft;
    
    self.graphContainer = HKAUTORELEASE([[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height)]);
    self.graphContainer.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.graphContainer];
    
    self.graphView = HKAUTORELEASE([[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.graphContainer.frame.size.width, self.graphContainer.frame.size.height)]);
    self.graphView.backgroundColor = [UIColor whiteColor];
    [self.graphContainer addSubview:self.graphView];
    
    self.xAxis = HKAUTORELEASE([[HKAxis alloc] initWithFrame:self.graphView.bounds]);
    self.xAxis.coordinate = HKCoordinateX;
    [self.graphView.layer addSublayer:self.xAxis];
    //self.xAxis.axisPosition = HKAxisPositionBottom;
    
    HKXYGraph* graphLayer = HKAUTORELEASE([[HKXYGraph alloc] initWithFrame:self.graphView.bounds]);
    [self.graphView addSubview:graphLayer];
    graphLayer.axisSet.xAxis = self.xAxis;
    graphLayer.axisSet.yAxis = yAxis;
    self.graphs = [NSMutableArray arrayWithCapacity:0];
    [self.graphs addObject:graphLayer];
    graphLayer.dataSource = self;
}

- (void)addYAxis
{
    HKAxis* yAxis = HKAUTORELEASE([[HKAxis alloc] initWithFrame:self.bounds]);
    yAxis.coordinate = HKCoordinateY;
    [self.layer insertSublayer:yAxis atIndex:self.yAxises.count];
    [self.yAxises addObject:yAxis];
    //yAxis.axisPosition = HKAxisPositionLeft;
    
    HKXYGraph* graphLayer = HKAUTORELEASE([[HKXYGraph alloc] initWithFrame:self.graphView.bounds]);
    [self.graphView addSubview:graphLayer];
    graphLayer.axisSet.xAxis = self.xAxis;
    graphLayer.axisSet.yAxis = yAxis;
    [self.graphs addObject:graphLayer];
    graphLayer.dataSource = self;
    
    [self updateAxises];
}

- (void)removeYAxisAtIndex:(int)axisIndex
{
    //don't remove object at index 0
    if (axisIndex > 0 && axisIndex < self.yAxises.count)
    {
        HKAxis* axis = [self.yAxises objectAtIndex:axisIndex];
        [axis removeFromSuperlayer];
        [self.yAxises removeObjectAtIndex:axisIndex];
    }
    if (axisIndex > 0 && axisIndex < self.graphs.count)
    {
        HKXYGraph* graph = [self.graphs objectAtIndex:axisIndex];
        graph.dataSource = nil;
        [graph removeFromSuperview];
        [self.graphs removeObjectAtIndex:axisIndex];
    }
    [self updateAxises];
}

- (void)updateAxises
{
    int count = self.graphs.count + 1; //we added 1 for graph at index 0 (this graph is higher than others)
    CGRect rect = self.graphView.frame;
    
    CGFloat graphPadding = 5.0;
    
    CGFloat height = (rect.size.height - (self.graphs.count - 1)*graphPadding - _paddingBottom) / count;
    
    CGFloat currentY = 0.0;
    
    for (int i = self.graphs.count - 1; i >= 0; i--)
    {
        HKXYGraph* graph = [self.graphs objectAtIndex:i];
        CGRect currentRect = graph.frame;
        if (i == 0)
        {
            currentRect.size.height = 2*height;
        }
        else
        {
            currentRect.size.height = height;
        }
        graph.frame = CGRectMake(currentRect.origin.x, currentY, currentRect.size.width, currentRect.size.height);
        currentY += currentRect.size.height + graphPadding;
    }
    
    [self.graphView setNeedsDisplay];
    
    currentY = 0.0;
    
    for (int i = self.yAxises.count - 1; i >= 0; i--)
    {
        HKAxis* axis = [self.yAxises objectAtIndex:i];
        CGRect currentRect = axis.frame;
        if (i == 0)
        {
            currentRect.size.height = 2*height;
        }
        else
        {
            currentRect.size.height = height;
        }
        axis.frame = CGRectMake(currentRect.origin.x, currentY, currentRect.size.width, currentRect.size.height);
        currentY += currentRect.size.height + graphPadding;
        
        [axis redraw];
    }
}

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
    
    [self updateAxises];
}

- (void)reloadData
{
    CGFloat tickXLength = [self.dataSource tickLenghtForXAxisAtIndex:0 inGraphView:self];
    NSInteger numberOfRecords = [self.dataSource numberOfRecordInGraphView:self];
    CGFloat graphWidth = tickXLength * numberOfRecords;
    
    CGRect graphRect = self.graphView.frame;
    graphRect.size.width = graphWidth;
    self.graphView.frame = graphRect;
    
    for (HKXYGraph* graph in self.graphs)
    {
        CGRect rect = graph.frame;
        rect.size.width = graphWidth;
        graph.frame = rect;
    }
    
    self.graphContainer.contentSize = CGSizeMake(graphWidth, graphRect.size.height);
    
    CGRect xAxisRect = self.xAxis.frame;
    xAxisRect.size.width = graphWidth;
    self.xAxis.frame = xAxisRect;
    self.xAxis.tickInterval = tickXLength;
    self.xAxis.axisMin = 0.0;
    self.xAxis.axisMax = graphWidth;
    [self.xAxis redraw];
    
    for (int i = 0; i < self.yAxises.count; i++)
    {
        HKAxis* y = [self.yAxises objectAtIndex:i];
        CGFloat tickYLength = [self.dataSource tickLenghtForYAxisAtIndex:i inGraphView:self];
        y.tickInterval = tickYLength;
        y.axisMin = 0.0;
        y.axisMax = y.frame.size.height;
        
        [y redraw];
    }
    
    [self.graphView setNeedsDisplay];
}

- (NSInteger)numberOfPlotInGraph:(HKXYGraph*)graph
{
    return [self.dataSource numberOfPlotInGraph:graph inGraphView:self];
}

- (HKPlotType)plotTypeForPlotAtIndex:(int)index inGraph:(HKXYGraph*)graph
{
    return [self.dataSource plotTypeForPlotAtIndex:index inGraph:graph inGraphView:self];
}

- (NSArray*)dataForPlotAtIndex:(int)index inGraph:(HKXYGraph*)graph
{
    return [self.dataSource dataForPlotAtIndex:index inGraph:graph inGraphView:self];
}

@end











