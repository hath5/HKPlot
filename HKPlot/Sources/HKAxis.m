//
//  HKAxis.m
//  HKPlot
//
//  Created by Tran Hoang Ha on 3/28/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "HKAxis.h"
#import "HKDefine.h"
#import <UIKit/UIKit.h>

@implementation HKTextLayer

+ (HKTextLayer*)layer
{
    HKTextLayer *layer = [[HKTextLayer alloc] init];
    layer.opaque = TRUE;
    CGFloat scale = [[UIScreen mainScreen] scale];
    layer.contentsScale = scale;
    return HKAUTORELEASE(layer);
}

// Render after enabling with anti aliasing for text

- (void)drawInContext:(CGContextRef)ctx
{
    CGRect bounds = self.bounds;
    CGContextSetFillColorWithColor(ctx, self.backgroundColor);
    CGContextFillRect(ctx, bounds);
    CGContextSetShouldSmoothFonts(ctx, TRUE);
    
    [super drawInContext:ctx];
}

@end

@interface HKAxis ()
{
    CGFloat         _axisMin;
    CGFloat         _axisMax;
    CGFloat         _tickInterval;
    NSString*       _unit;
    NSString*       _title;
    HKCoordinate    _coordinate;
    //HKAxisPosition  _axisPosition;
    BOOL            _drawTickMark;
}

@end

@implementation HKAxis

@synthesize axisMin         = _axisMin;
@synthesize axisMax         = _axisMax;
@synthesize tickInterval    = _tickInterval;
@synthesize unit            = _unit;
@synthesize title           = _title;
@synthesize coordinate      = _coordinate;
//@synthesize axisPosition    = _axisPosition;
@synthesize drawTickMark    = _drawTickMark;

- (void)dealloc
{
    HKSUPERDEALLOC();
    HKSAFERELEASE(_unit);
    HKSAFERELEASE(_title);
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super init];
    if (self)
    {
        self.frame = frame;
        self.axisMin = 0;
        self.axisMax = 0;
        self.tickInterval = 0;
        self.unit = @"";
        self.title = @"";
        self.coordinate = HKCoordinateX;
        self.backgroundColor = [[UIColor whiteColor] CGColor];
        self.masksToBounds = YES;
        //self.axisPosition = HKAxisPositionLeft;
        self.drawTickMark = NO;
    }
    return self;
}

- (void)drawLineFrom:(CGPoint)from to:(CGPoint)to context:(CGContextRef)context
{
    CGContextMoveToPoint(context, from.x, from.y);
    CGContextAddLineToPoint(context, to.x, to.y);
}

- (void)drawInContext:(CGContextRef)ctx
{
    [super drawInContext:ctx];
    
    CGContextSaveGState(ctx);
    
    //CGContextSetAllowsAntialiasing(ctx, true);
    //CGContextSetShouldAntialias(ctx, true);
    //CGContextSetShouldSmoothFonts(ctx, true);
    
    //CGContextSetShouldSubpixelPositionFonts(ctx, false);
    //CGContextSetShouldSubpixelQuantizeFonts(ctx, false);
    
    NSMutableArray* arr = [self.sublayers mutableCopy];
    for (CALayer* layer in arr)
    {
        if ([layer isKindOfClass:[HKTextLayer class]])
        {
            [layer removeFromSuperlayer];
        }
    }
    [arr removeAllObjects];
    
    UIGraphicsPushContext(ctx);
    
    CGContextSetFillColorWithColor(ctx, [[UIColor whiteColor] CGColor]);
    CGContextFillRect(ctx, self.bounds);
    
    CGContextSetShouldSmoothFonts(ctx, true);
    
    CGContextSetFillColorWithColor(ctx, [[UIColor blackColor] CGColor]);
    CGContextSetStrokeColorWithColor(ctx, [[UIColor blackColor] CGColor]);
    
    CGContextSetLineWidth(ctx, 1.0);
    
    int number = (self.axisMax - self.axisMin) / self.tickInterval;
    UIFont* font = [UIFont systemFontOfSize:10.0];
    for (int i = 0; i <= number; i++)
    {
        CGFloat val = self.axisMin + i * self.tickInterval;
        NSString* valStr = [NSString stringWithFormat:@"%0.1f", val];
        CGPoint pt = CGPointZero;
        CGSize size = [valStr sizeWithFont:font];
        
        if (self.coordinate == HKCoordinateX)
        {
            pt = CGPointMake(i*self.tickInterval, 10.0 + (i%2)*10);
            //if (self.axisPosition == HKAxisPositionBottom)
            {
                pt.y = self.frame.size.height - pt.y - size.height;
            }
            //[valStr drawAtPoint:pt forWidth:self.tickInterval withFont:font lineBreakMode:NSLineBreakByWordWrapping];
            //[valStr drawInRect:CGRectMake(pt.x, pt.y, size.width, size.height) withFont:font lineBreakMode:NSLineBreakByWordWrapping];
        }
        else if (self.coordinate == HKCoordinateY)
        {
            //with coordinate Y, we need exchange the position
            pt = CGPointMake(10.0, i*self.tickInterval);
            pt.y = self.frame.size.height - pt.y - size.height;
            //[valStr drawAtPoint:pt forWidth:100.0 withFont:font lineBreakMode:NSLineBreakByWordWrapping];
        }
        
        HKTextLayer* layer = [HKTextLayer layer];
        layer.backgroundColor = [[UIColor whiteColor] CGColor];
        layer.foregroundColor = [[UIColor blackColor] CGColor];
        layer.fontSize = 10.0;
        layer.frame = CGRectMake(pt.x, pt.y, size.width, size.height);
        layer.string = valStr;
        [self addSublayer:layer];
        
        if (self.drawTickMark && (self.coordinate == HKCoordinateX))
        {
            [self drawLineFrom:CGPointMake(pt.x, self.frame.size.height - 5) to:CGPointMake(pt.x, self.frame.size.height) context:ctx];
        }
    }
    
	CGContextStrokePath(ctx);
    
    CGContextRestoreGState(ctx);
    
    UIGraphicsPopContext();
}

- (void)redraw
{
    [self setNeedsDisplay];
}

@end











