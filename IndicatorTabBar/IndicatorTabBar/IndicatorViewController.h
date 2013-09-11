//
//  IndicatorViewController.h
//  IndicatorTabBar
//
//  Created by MD631 on 13/9/11.
//  Copyright (c) 2013年 MD631. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IndicatorViewController : UIViewController<UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *mScrollView;
@property (strong, nonatomic) NSMutableArray *mControllerArray;

@end
