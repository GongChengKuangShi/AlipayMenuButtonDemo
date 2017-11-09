//
//  ViewController.m
//  AlipayMenuButtonDemo
//
//  Created by xrh on 2017/11/8.
//  Copyright © 2017年 xrh. All rights reserved.
//

#import "ViewController.h"
#import "Common.h"

@interface ViewController ()<SingleViewDelegate>

@property(assign, nonatomic) CGPoint rects;
@property(assign, nonatomic) BOOL isMove;
@property(strong, nonatomic) SingleView *singView;
@property(strong, nonatomic) UIScrollView *scrollView;
@property(strong, nonatomic) NSMutableArray *singTag;
@property(strong, nonatomic) NSMutableArray *titleArr;
@property(strong, nonatomic) NSMutableArray *singArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.titleArr = [NSMutableArray arrayWithObjects:
                     @{@"title": @"生活缴费"},
                     @{@"title": @"淘票票"},
                     @{@"title": @"股票"},
                     @{@"title": @"滴滴出行"},
                     @{@"title": @"红包"},
                     @{@"title": @"亲密付"},
                     @{@"title": @"生超市惠"},
                     @{@"title": @"我的快递"},
                     @{@"title": @"游戏中心"},
                     @{@"title": @"我的客服"},
                     @{@"title": @"爱心捐赠"},
                     @{@"title": @"亲情账户"},
                     @{@"title": @"淘宝"},
                     @{@"title": @"天猫"},
                     @{@"title": @"天猫超市"},
                     @{@"title": @"城市服务"},
                     @{@"title": @"保险服务"},
                     @{@"title": @"飞机票"}, nil];
    self.singTag = [NSMutableArray arrayWithObjects:@"100", @"101", @"102", @"103", @"104", @"105", @"106", @"107", @"108", @"109", @"110", @"111", @"112", @"113", @"114", @"115", @"116", @"117", nil];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.900 alpha:1.0];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    scrollView.backgroundColor = [UIColor colorWithWhite:0.900 alpha:0.100];
    scrollView.scrollEnabled = YES;
    [self.view addSubview:scrollView];
    _scrollView = scrollView;
    [self initWithSingleView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"支付宝";
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.400 green:0.800 blue:1.000 alpha:1.000]];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIColor whiteColor], NSForegroundColorAttributeName,
                                [UIFont boldSystemFontOfSize:21], NSFontAttributeName,
                                nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
}

#pragma mark -- 创建九宫格
- (void)initWithSingleView {
    self.singArray = [[NSMutableArray alloc]init];
    
    CGFloat widthX;
    CGFloat heightY;
    widthX  = 0;
    heightY = 10;
    for (int i = 0; i < self.titleArr.count; i++) {
        
        NSString *title = [self.titleArr objectAtIndex:i][@"title"];
        
        SingleView *singleView = [[SingleView alloc] initWithFrame:CGRectMake(widthX, heightY, kMarginWidth - 1, kMarginWidth - 1) title:title];
        singleView.delegate = self;
        [_scrollView addSubview:singleView];
        
//        widthX = 0 + kMarginWidth * (i % 5);
//        heightY = 10 + (kMarginWidth) * (i / 5);
        widthX = widthX + kMarginWidth;
        if (widthX == SCREEN_WIDTH) {
            widthX = 0;
            heightY += kMarginWidth;
        }
        singleView.tagId = [self.singTag objectAtIndex:i];
        singleView.viewPoint = singleView.center;
        [self.singArray addObject:singleView];
    }
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, heightY);
}

#pragma mark -- singleView的代理
- (void)beginMoveAction:(NSString *)tag {
    SingleView *singleView;
    for (int i = 0; i < self.singArray.count; i++) {
        singleView = self.singArray[i];
        if (tag == singleView.tagId) {
            break;
        }
    }
    
    [_scrollView bringSubviewToFront:singleView];
    _rects = singleView.viewPoint;
    singleView.transform = CGAffineTransformMakeScale(1.1, 1.1);
    _singView = singleView;
}

- (void)moveViewAction:(NSString *)tag gesture:(UILongPressGestureRecognizer *)gesture {
    
    //移动前的tagid值
    NSInteger fromtag = [_singView.tagId integerValue];
    
    /*
     locationInView:获取到的是手指点击屏幕实时的坐标点；
     translationInView：获取到的是手指移动后，在相对坐标中的偏移量
     */
    //移动后的新坐标
    CGPoint newPoint = [gesture locationInView:_scrollView];
    
    //移动后的X坐标差值
    CGFloat moveX = newPoint.x - _singView.frame.origin.x;
    //移动后的Y坐标差值
    CGFloat moveY = newPoint.y - _singView.frame.origin.y;
    //跟随手势移动
    _singView.center = CGPointMake(_singView.center.x + moveX - kMarginWidth/2, _singView.center.y + moveY - kMarginWidth/2);
    
    //目标位置
    NSInteger toIndex = [ViewController indexOfPoint:_singView.center withView:_singView singArray:_singArray];
    
    //从后向前移动
    if (toIndex < fromtag-100 && toIndex >= 0) {
        _isMove = YES;
        NSInteger beginIndex = fromtag - 100;
        SingleView *toView = self.singArray[toIndex];
        _singView.center = toView.viewPoint;
        _rects = toView.viewPoint;
        for (NSInteger j = beginIndex; j > toIndex; j--) {
            SingleView *singView1 = self.singArray[j];
            SingleView *singView2 = self.singArray[j - 1];
            
            [UIView animateWithDuration:0.5 animations:^{
                singView2.center = singView1.viewPoint;
            }];
        }
        
        //处理数组
        [_singArray removeObject:_singView];
        [_singArray insertObject:_singView atIndex:toIndex];
        
        [self manageTagAndCenter];
    }
    
    //从前向后拖动
    if (toIndex > fromtag - 100 && toIndex < _singArray.count) {
        _isMove = YES;
        NSInteger beginIndex = fromtag - 100;
        SingleView *toView = self.singArray[toIndex];
        _singView.center = toView.viewPoint;
        _rects = toView.viewPoint;
        for (NSInteger j = beginIndex; j < toIndex; j++) {
            SingleView *singView1 = self.singArray[j];
            SingleView *singView2 = self.singArray[j + 1];
            
            [UIView animateWithDuration:0.5 animations:^{
                singView2.center = singView1.viewPoint;
            }];
        }
        
        [_singArray removeObject:_singView];
        [_singArray insertObject:_singView atIndex:toIndex];
        [self manageTagAndCenter];
    }
}

- (void)endMoveViewAction:(NSString *)tag {
    _singView.center = _rects;
    _singView.transform = CGAffineTransformIdentity;
}

- (void)clickOneViewReturnTitle:(NSString *)title {
    
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    detailVC.title = title;
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

- (void)manageTagAndCenter {
    
    //处理tagId的值和中心
    for (NSInteger i = 0; i < _singArray.count; i++) {
        SingleView *gridItem = [_singArray objectAtIndex:i];
        gridItem.tagId = _singTag[i];
        gridItem.viewPoint = gridItem.center;
    }
}

@end
