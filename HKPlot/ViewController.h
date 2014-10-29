//
//  ViewController.h
//  HKPlot
//
//  Created by Tran Hoang Ha on 3/28/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKGraphView.h"
#import "HKMultiGraphView.h"

@interface ViewController : UIViewController<HKMultiGraphViewDelegate, HKMultiGraphViewDataSource>
{
    
}
@property (nonatomic, retain) HKMultiGraphView* multiGraphView;
@end
