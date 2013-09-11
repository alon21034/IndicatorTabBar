//
//  ContentViewController.m
//  IndicatorTabBar
//
//  Created by MD631 on 13/9/11.
//  Copyright (c) 2013年 MD631. All rights reserved.
//

#import "ContentViewController.h"

@interface ContentViewController ()
{
    int pageNumber;
}
@end

@implementation ContentViewController

@synthesize mLabel;

- (id)initWithPageNum:(NSInteger)page {
    if (self = [super initWithNibName:@"ContentViewController" bundle:nil])
    {
        pageNumber = page;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    mLabel.text = [NSString stringWithFormat:@"page: %d", pageNumber];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
