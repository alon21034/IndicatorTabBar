//
//  ContentViewController.h
//  IndicatorTabBar
//
//  Created by MD631 on 13/9/11.
//  Copyright (c) 2013年 MD631. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *mLabel;

-(id) initWithPageNum:(NSInteger)page;

@end
