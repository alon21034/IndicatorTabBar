//
//  IndicatorViewController.m
//  IndicatorTabBar
//
//  Created by MD631 on 13/9/11.
//  Copyright (c) 2013年 MD631. All rights reserved.
//

#import "IndicatorViewController.h"
#import "ContentViewController.h"

@interface IndicatorViewController ()

@end

@implementation IndicatorViewController

@synthesize mControllerArray;
@synthesize mScrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < 4; i++)
    {
		[controllers addObject:[NSNull null]];
    }
    self.mControllerArray = controllers;
    
    // a page is the width of the scroll view
    self.mScrollView.pagingEnabled = YES;
    self.mScrollView.contentSize =
    CGSizeMake(280 * 4, 420);
    NSLog(@"%lf %lf",mScrollView.contentSize.width, mScrollView.contentSize.height);
    self.mScrollView.showsHorizontalScrollIndicator = YES;
    self.mScrollView.showsVerticalScrollIndicator = NO;
    self.mScrollView.scrollsToTop = NO;
    self.mScrollView.delegate = self;
    
//    self.mPageControl.numberOfPages = 4;
//    self.mPageControl.currentPage = 0;
    
    // pages are created on demand
    // load the visible page
    // load the page on either side to avoid flashes when the user starts scrolling
    //
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadScrollViewWithPage:(NSUInteger)page
{
    if (page >= 4)
        return;
    
    // replace the placeholder if necessary
    ContentViewController *controller = [self.mControllerArray objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null])
    {
        controller = [[ContentViewController alloc] initWithPageNum:page];
        [self.mControllerArray replaceObjectAtIndex:page withObject:controller];
    }
    
    // add the controller's view to the scroll view
    if (controller.view.superview == nil)
    {
        CGRect frame = self.mScrollView.frame;
        frame.origin.x = 280 * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        
        [self addChildViewController:controller];
        [self.mScrollView addSubview:controller.view];
        [controller didMoveToParentViewController:self];
        
        //controller.mLabel.text = [NSString stringWithFormat:@"PAGE %d", page];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = CGRectGetWidth(self.mScrollView.frame);
    NSUInteger page = floor((self.mScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
//    self.mPageControl.currentPage = page;
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
    // a possible optimization would be to unload the views+controllers which are no longer visible
}

@end
