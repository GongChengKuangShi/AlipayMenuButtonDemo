//
//  UIViewController+NSInteger.m
//  AlipayMenuButtonDemo
//
//  Created by xrh on 2017/11/9.
//  Copyright © 2017年 xrh. All rights reserved.
//

#import "UIViewController+NSInteger.h"

@implementation UIViewController (NSInteger)

+ (NSInteger)indexOfPoint:(CGPoint)point
                 withView:(UIView *)view
                singArray:(NSMutableArray *)singArray {
    for (NSInteger i = 0; i < singArray.count; i++) {
        UIView *singView = [singArray objectAtIndex:i];
        if (singView != view) {
            if (CGRectContainsPoint(singView.frame, point)) {
                return i;
            }
        }
    }
    return -100;
}

@end
