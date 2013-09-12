//
//  IndicatorViewController.h
//  IndicatorTabBar
//
//  Created by MD631 on 13/9/11.
//  Copyright (c) 2013年 MD631. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PADDING 5

@protocol IndicatorViewDelegate <NSObject>

-(void) onTabSelected:(int)page;

@end

@interface IndicatorViewController : UIViewController<UIScrollViewDelegate>

@property (assign, nonatomic) id<IndicatorViewDelegate> mDelegate;

@property (strong, nonatomic) IBOutlet UIScrollView *mScrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *mPageControl;
@property (strong, nonatomic) NSMutableArray *mControllerArray;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) NSMutableArray *mTabButtonArray;

@end
