//
//  HKAxis.h
//  HKPlot
//
//  Created by Tran Hoang Ha on 3/28/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

enum
{
    HKCoordinateX   = 0,
    HKCoordinateY,
    HKCoordinateZ,          //how to
};

typedef NSUInteger  HKCoordinate;

enum
{
    HKAxisPositionLeft  = 0,
    HKAxisPositionRight,
    HKAxisPositionTop,
    HKAxisPositionBottom,
};

typedef NSUInteger HKAxisPosition;

@interface HKTextLayer : CATextLayer

+ (HKTextLayer*)layer;

@end

@interface HKAxis : CALayer
{
    
}

@property (assign) CGFloat              axisMin;
@property (assign) CGFloat              axisMax;
@property (assign) CGFloat              tickInterval;
@property (nonatomic, retain) NSString* unit;
@property (nonatomic, retain) NSString* title;
@property (assign) HKCoordinate         coordinate;
//@property (assign) HKAxisPosition       axisPosition;
@property (assign) BOOL                 drawTickMark;

- (id)initWithFrame:(CGRect)frame;

- (void)redraw;

@end
