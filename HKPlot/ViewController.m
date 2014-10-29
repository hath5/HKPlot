//
//  ViewController.m
//  HKPlot
//
//  Created by Tran Hoang Ha on 3/28/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "ViewController.h"
#import "HKMultiGraphView.h"

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.multiGraphView = [[HKMultiGraphView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 100)];
    self.multiGraphView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.multiGraphView];
    
    self.multiGraphView.dataSource = self;
    self.multiGraphView.delegate = self;
    
    self.multiGraphView.paddingLeft = 50;
    self.multiGraphView.paddingBottom = 70.0;
    
    [self.multiGraphView reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfRecordInGraphView:(HKGraphView *)graphView
{
    return 100;
}

- (CGFloat)tickLenghtForXAxisAtIndex:(int)index inGraphView:(HKMultiGraphView *)graphView
{
    return 30.0f;
}

- (CGFloat)tickLenghtForYAxisAtIndex:(int)index inGraphView:(HKMultiGraphView *)graphView
{
    if (index == 0)
    {
        return 50.0f;
    }
    else
        return 20.0;
}

- (NSInteger)numberOfPlotInGraph:(HKXYGraph*)graph inGraphView:(HKMultiGraphView*)graphView
{
    return 2;
}

- (HKPlotType)plotTypeForPlotAtIndex:(int)index inGraph:(HKXYGraph*)graph inGraphView:(HKMultiGraphView*)graphView
{
    if (index == 0)
    {
        return HKPlotType_Line;
    }
    return HKPlotType_Bar;
}

- (NSArray*)dataForPlotAtIndex:(int)index inGraph:(HKXYGraph*)graph inGraphView:(HKMultiGraphView*)graphView
{
    NSMutableArray* arr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < 3000; i += 30)
    {
        CGPoint pt = CGPointZero;
        pt.x = i;
        pt.y = arc4random() % 200;
        
        [arr addObject:[NSValue valueWithCGPoint:pt]];
    }
    return arr;
}
@end








