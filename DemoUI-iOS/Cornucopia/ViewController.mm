//
//  ViewController.mm
//  Cornucopia
//
//  Created by Josh Gargus on 4/19/15.
//  Copyright (c) 2015 Foo. All rights reserved.
//

#import "ViewController.h"
#include "SimpleAPI.h"
#include "Cornucopia.h"

#include <iostream>
#include <memory>
#include <vector>

@interface ViewController () {

@private
CALayer* layer;
std::vector<CGPoint> points;
std::vector<Cornu::BasicBezier> beziers;
}
@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    layer = [CALayer layer];
    layer.delegate = self;
    layer.backgroundColor = [UIColor blackColor].CGColor;
    layer.frame = self.view.bounds;
    layer.masksToBounds = YES;
    [self.view.layer addSublayer:layer];
    [layer setNeedsDisplay];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // TODO: need to release layer?
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    points.clear();
    beziers.clear();
    for (UITouch* touch in touches) {
        points.push_back([touch locationInView: self.view]);
        break;  // only look look at one touch
    }
    [layer setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch* touch in touches) {
        points.push_back([touch locationInView: self.view]);
        break;  // only look look at one touch
    }
    [layer setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch* touch in touches) {
        points.push_back([touch locationInView: self.view]);
        break;  // only look look at one touch
    }

    Cornu::Parameters params; //default values
    std::vector<Cornu::Point> cpts;
    for (auto pt : points) {
        cpts.push_back(Cornu::Point(pt.x, pt.y));
    }

    std::vector<Cornu::BasicPrimitive> result = Cornu::fit(cpts, params);
    beziers = Cornu::toBezierSpline(result, 1.);

    [layer setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {

}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)context {
    if (points.size() >= 2) {
        CGContextSetStrokeColorWithColor(context, [[UIColor blueColor] CGColor]);
        CGContextSetLineWidth(context, 1.0);
        CGContextMoveToPoint(context, points[0].x, points[0].y);
        for (int i = 1; i < points.size(); ++i) {
            CGContextAddLineToPoint(context, points[i].x, points[i].y);
        }
    }
    CGContextStrokePath(context);

    if (!beziers.empty()) {
        CGContextSetStrokeColorWithColor(context, [[UIColor redColor] CGColor]);
        CGContextSetLineWidth(context, 3.0);
        CGContextMoveToPoint(context, beziers[0].controlPoint[0].x, beziers[0].controlPoint[0].y);
        for (int i = 0; i < beziers.size(); ++i) {
            Cornu::Point* ctrl = beziers[i].controlPoint;
            CGContextAddCurveToPoint(context,
                                     ctrl[1].x, ctrl[1].y,
                                     ctrl[2].x, ctrl[2].y,
                                     ctrl[3].x, ctrl[3].y);
        }
    }
    CGContextStrokePath(context);

    CGContextFlush(context);
}

@end
