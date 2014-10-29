//
//  HKDefine.h
//  HKPlot
//
//  Created by Tran Hoang Ha on 3/28/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#ifndef HKPlot_HKDefine_h
#define HKPlot_HKDefine_h

#if !__has_feature(objc_arc)

#define HKAUTORELEASE(a)    [a autorelease]
#define HKRELEASE(a)        [a release]
#define HKRETAIN(a)         [a retain]

#define HKSAFERELEASE(a)    if (a)              \
{                   \
    HKRELEASE(a);   \
    a = nil;        \
}                   \

#define HKSUPERDEALLOC()    [super dealloc]

#else

#define HKAUTORELEASE(a)    a
#define HKRELEASE(a)
#define HKRETAIN(a)         a

#define HKSAFERELEASE(a)

#define HKSUPERDEALLOC()

#endif

#define DEGREES_TO_RADIANS(x) (3.14159265358979323846 * x / 180.0)
#define RANDOM_FLOAT_BETWEEN(x, y) (((float) rand() / RAND_MAX) * (y - x) + x)

#endif
