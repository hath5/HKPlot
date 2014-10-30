HKPlot
======

Draw plot type line or bar

How to use?

1.
#import "HKMultiGraphView.h"

2.
add <HKMultiGraphViewDelegate, HKMultiGraphViewDataSource> to your view controller

3.
@property (nonatomic, retain) HKMultiGraphView* multiGraphView;

4.
implementation in viewDidLoad
self.multiGraphView = [[HKMultiGraphView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 100)];
self.multiGraphView.backgroundColor = [UIColor whiteColor];
[self.view addSubview:self.multiGraphView];
    
self.multiGraphView.dataSource = self;
self.multiGraphView.delegate = self;
    
self.multiGraphView.paddingLeft = 50;
self.multiGraphView.paddingBottom = 70.0;
    
[self.multiGraphView reloadData];

5.
implementation method in datasource
- (NSInteger)numberOfRecordInGraphView:(HKGraphView *)graphView
{
    return 100;
}

- (CGFloat)tickLenghtForXAxisAtIndex:(int)index inGraphView:(HKMultiGraphView *)graphView
{
    return 30.0f;
}

- (NSInteger)numberOfPlotInGraph:(HKXYGraph*)graph inGraphView:(HKMultiGraphView*)graphView
{
    return 2; //i have two graphView 
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

- (HKPlotType)plotTypeForPlotAtIndex:(int)index inGraph:(HKXYGraph*)graph inGraphView:(HKMultiGraphView*)graphView
{
    if (index == 0)
    {
        return HKPlotType_Line; //firstGraph is Line type
    } 
    return HKPlotType_Bar; //secondGraph is Bar type
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
    return arr; // return an array of CGPoint
}
