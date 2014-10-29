//
//  HKXYGraph.m
//  HKPlot
//
//  Created by Tran Hoang Ha on 3/28/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "HKXYGraph.h"
#import "HKDefine.h"
#import <GLKit/GLKit.h>

@implementation HKAxisSet

@synthesize xAxis = _xAxis;
@synthesize yAxis = _yAxis;

- (id)init
{
    self = [super init];
    if (self)
    {
        self.xAxis = nil;
        self.yAxis = nil;
    }
    return self;
}

- (void)dealloc
{
    self.xAxis = nil;
    self.yAxis = nil;
    HKSUPERDEALLOC();
}

@end

@interface HKXYGraph ()
{

}

@end

@implementation HKXYGraph

@synthesize axisSet = _axisSet;
@synthesize dataSource = _dataSource;

static CGColorRef gridForegroundColor()
{
	static CGColorRef c = NULL;
	
	if(c == NULL) {
		c = [[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1] CGColor];
        //c = [[UIColor lightGrayColor] CGColor];
		CFRetain(c);
	}
	
	return c;
}

- (void)dealloc
{
    self.axisSet = nil;
    self.dataSource = nil;
    HKSUPERDEALLOC();
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = [[UIColor blackColor] CGColor];
        self.layer.backgroundColor = [[UIColor whiteColor] CGColor];
        self.backgroundColor = [UIColor whiteColor];
        self.axisSet = HKAUTORELEASE([[HKAxisSet alloc] init]);
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = [[UIColor blackColor] CGColor];
        self.layer.backgroundColor = [[UIColor whiteColor] CGColor];
        self.backgroundColor = [UIColor whiteColor];
        self.axisSet = HKAUTORELEASE([[HKAxisSet alloc] init]);
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    //Make sure the remove the anti-alias effect from circle
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetShouldAntialias(context, true);
    
    //grid line
    [self drawGridlines:context];
    
    //draw plot
    if (self.dataSource)
    {
        NSInteger numberOfPlot = [self.dataSource numberOfPlotInGraph:self];
        if (numberOfPlot > 0)
        {
            for (int i = 0; i < numberOfPlot; i++)
            {
                HKPlotType plotType = [self.dataSource plotTypeForPlotAtIndex:i inGraph:self];
                NSArray* dataList = [self.dataSource dataForPlotAtIndex:i inGraph:self];
                if (dataList && dataList.count)
                {
                    switch (plotType) {
                        case HKPlotType_Line:
                        {
                            CGContextSetLineWidth(context, 1.0);
                            
                            //draw lines
                            for (int j = 0; j < dataList.count-1; j++)
                            {
                                NSValue* val = [dataList objectAtIndex:j];
                                
                                CGPoint pt1 = [val CGPointValue];
                                val = [dataList objectAtIndex:j+1];
                                
                                CGPoint pt2 = [val CGPointValue];
                                [self drawLineFrom:pt1 to:pt2 context:context];
                            }
                            
                            CGContextSetStrokeColorWithColor(context, [[UIColor redColor] CGColor]);
                            CGContextSetFillColorWithColor(context, [[UIColor redColor] CGColor]);//maybe add datasource
                            CGContextStrokePath(context);
                            
                            for (int j = 0; j < dataList.count; j++)
                            {
                                NSValue* val = [dataList objectAtIndex:j];
                                CGPoint pt = [val CGPointValue];
                                [self fillCircleAtPoint:pt radius:2 context:context];
                            }
                            
                            CGContextFillPath(context);
                            break;
                        }
                        case HKPlotType_Bar:
                        {
                            CGContextSetFillColorWithColor(context, [[UIColor blueColor] CGColor]);//maybe add datasource
                            
                            for (int j = 0; j < dataList.count; j++)
                            {
                                NSValue* val = [dataList objectAtIndex:j];
                                CGPoint pt = [val CGPointValue];
                                [self drawBarAtPoint:pt context:context];
                            }
                            
                            CGContextFillPath(context);
                            break;
                        }
                            
                        default:
                            break;
                    }
                }
            }
        }
    }
}

- (void)drawLineFrom:(CGPoint)from to:(CGPoint)to context:(CGContextRef)context
{
    CGContextMoveToPoint(context, from.x, self.frame.size.height - from.y);
    CGContextAddLineToPoint(context, to.x, self.frame.size.height - to.y);
}

- (void)fillCircleAtPoint:(CGPoint)pt radius:(CGFloat)radius context:(CGContextRef)context
{
    CGRect circle = CGRectMake(pt.x - radius, self.frame.size.height - pt.y - radius, 2*radius, 2*radius);
    CGContextAddEllipseInRect(context, circle);
}

- (void)drawBarAtPoint:(CGPoint)pt context:(CGContextRef)context
{
    CGRect rect = CGRectZero;
    rect.origin.x = pt.x - self.axisSet.xAxis.tickInterval / 4;
    rect.size.width = self.axisSet.xAxis.tickInterval / 2;
    rect.origin.y = self.frame.size.height - pt.y;
    rect.size.height = pt.y;
    CGContextAddRect(context, rect);
}

- (void)drawGridlines:(CGContextRef)context
{
    CGContextSetLineWidth(context, 0.2);
    
    if (self.axisSet.xAxis)
    {
        HKAxis* xAxis = self.axisSet.xAxis;
        for (CGFloat x = xAxis.axisMin; x < xAxis.axisMax; x += xAxis.tickInterval)
        {
            CGFloat xPt = x - xAxis.axisMin;
            CGPoint fromPoint = CGPointMake(xPt, 0.0);
            CGPoint toPoint = CGPointMake(xPt, self.frame.size.height);
            
            [self drawLineFrom:fromPoint to:toPoint context:context];
        }
    }
    
    if (self.axisSet.yAxis)
    {
        HKAxis* yAxis = self.axisSet.yAxis;
        for (CGFloat y = yAxis.axisMin; y < yAxis.axisMax; y += yAxis.tickInterval)
        {
            CGFloat yPt = y - yAxis.axisMin;
            
            CGPoint fromPoint = CGPointMake(0.0, yPt);
            CGPoint toPoint = CGPointMake(self.frame.size.width, yPt);
            
            [self drawLineFrom:fromPoint to:toPoint context:context];
        }
    }
	
	CGContextSetStrokeColorWithColor(context, gridForegroundColor());
	CGContextStrokePath(context);
}

@end







