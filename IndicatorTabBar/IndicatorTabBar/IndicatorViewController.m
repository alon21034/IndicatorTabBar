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
{
    int mTabButtonWidth;
    int mTabButtonHeight;
    int mTabButtonNum;
}
@end

@implementation IndicatorViewController

@synthesize mControllerArray;
@synthesize mScrollView;
@synthesize lineView;
@synthesize mTabButtonArray;
@synthesize mDelegate;
@synthesize mPageControl;

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
	// Do any additional setup after loading 
    
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    mTabButtonArray = [[NSMutableArray alloc] init];
    
    mTabButtonNum = 4;
    for (NSUInteger i = 0; i < mTabButtonNum; i++)
    {
		[controllers addObject:[NSNull null]];
        [mTabButtonArray addObject:[NSNull null]];
    }
    self.mControllerArray = controllers;
    
    // a page is the width of the scroll view
    self.mScrollView.pagingEnabled = YES;
    
    // (TODO) shouldn't use const here.
    self.mScrollView.contentSize = CGSizeMake(280 * 4, 420);
    mTabButtonWidth = 80;
    mTabButtonHeight = 30;
    
    self.mScrollView.showsHorizontalScrollIndicator = YES;
    self.mScrollView.showsVerticalScrollIndicator = NO;
    self.mScrollView.scrollsToTop = NO;
    self.mScrollView.delegate = self;
    
    self.mPageControl.numberOfPages = 4;
    self.mPageControl.currentPage = 0;
    
    // pages are created on demand
    // load the visible page
    // load the page on either side to avoid flashes when the user starts scrolling
    //
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
    
    for (int i = 0 ; i < mTabButtonNum ; i++) {
        [self addButton:[NSString stringWithFormat:@"title:%d", i]
                       :PADDING+i*(mTabButtonWidth + PADDING) :PADDING
                       :mTabButtonWidth :mTabButtonHeight :i];
    }
    
    lineView = [[UIView alloc] initWithFrame:
                CGRectMake(PADDING, mTabButtonHeight, mTabButtonWidth, PADDING)];
    lineView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:lineView];
}

- (void)addButton:(NSString*)title :(float)x :(float)y :(float)width :(float)height :(int)index{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self action:@selector(onTabButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [button setTitle:title forState:UIControlStateNormal];
    button.frame = CGRectMake(x, y, width, height);
    button.tag = index;
    
    [self.view addSubview:button];
    [mTabButtonArray replaceObjectAtIndex:index withObject:button];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) onTabButtonClicked:(UIButton*)button {
    NSLog(@"on clicked: %d", button.tag);
}

- (void)gotoPage:(BOOL)animated
{
    NSInteger page = self.mPageControl.currentPage;
    
    //[self highlightButton:page];
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
	// update the scroll view to the appropriate page
    CGRect bounds = self.mScrollView.bounds;
    bounds.origin.x = 280 * page;
    bounds.origin.y = 0;
    [self.mScrollView scrollRectToVisible:bounds animated:animated];
}

- (IBAction)changePage:(id)sender
{
    [self gotoPage:YES];    // YES = animate
}

#pragma mark ScrollViewDelegate

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

#pragma mark LineView

#define CGRectSetPos( r, x, y ) CGRectMake( x, y, r.size.width, r.size.height )

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [scrollView setContentOffset:
        CGPointMake(scrollView.contentOffset.x,
                    -scrollView.frame.origin.y + scrollView.contentSize.height - scrollView.frame.size.height)];
    
    lineView.frame = CGRectSetPos(lineView.frame,
                                  PADDING+scrollView.contentOffset.x*(mTabButtonWidth + PADDING)/280,
                                  mTabButtonHeight);
}

@end
