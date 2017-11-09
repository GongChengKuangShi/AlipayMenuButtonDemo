//
//  SingleView.h
//  AlipayMenuButtonDemo
//
//  Created by xrh on 2017/11/8.
//  Copyright © 2017年 xrh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SingleViewDelegate <NSObject>

- (void)clickOneViewReturnTitle:(NSString *)title;
- (void)beginMoveAction:(NSString *)tag;//开始移动
- (void)moveViewAction:(NSString *)tag gesture:(UILongPressGestureRecognizer *)gesture;//移动中
- (void)endMoveViewAction:(NSString *)tag;//结束移动

@end

@interface SingleView : UIView

@property(copy, nonatomic) NSString *title;
@property (nonatomic, assign) CGPoint viewPoint;
@property(copy, nonatomic) NSString *tagId;

@property(weak, nonatomic) id<SingleViewDelegate>  delegate;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title;

@end
