//
//  UIViewController+NSInteger.h
//  AlipayMenuButtonDemo
//
//  Created by xrh on 2017/11/9.
//  Copyright © 2017年 xrh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (NSInteger)

+ (NSInteger)indexOfPoint:(CGPoint)point
                 withView:(UIView *)view
                singArray:(NSMutableArray *)singArray;

@end
