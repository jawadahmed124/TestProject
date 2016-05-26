//
//  ViewController.m
//  Test
//
//  Created by Jawad Ahmad on 24/05/2016.
//  Copyright © 2016 Jawad Ahmad. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *strokeTextAttributes = @{NSStrokeColorAttributeName : [UIColor blueColor],
                                           NSForegroundColorAttributeName : [UIColor whiteColor],
                                           NSStrokeWidthAttributeName : @-3.0};
    
    titleLabel.attributedText = [[NSMutableAttributedString alloc] initWithString:titleLabel.text attributes:strokeTextAttributes];
    
    pageViews = [NSMutableArray new];
    imagesArray = [NSMutableArray new];
    
    for (NSInteger i=1; i<=12; i++) {
        NSString *imageName = [NSString stringWithFormat:@"image_%zd", i];
        [imagesArray addObject:[UIImage imageNamed:imageName]];
    }
    
    numberOfPages = ceilf(imagesArray.count/4.0);
    pageControl.numberOfPages = numberOfPages;
}

- (void)viewDidLayoutSubviews {
    if (!viewInitiated) {
        viewInitiated = YES;
        
        [self updateUI];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/***********************************************************************************************************************/
#pragma mark - Class Methods

- (void)updateUI {
    
    for (NSInteger i=0; i<numberOfPages; i++) {
        /**
         * If pageId == 0, then Start pageId with the last number
         * else: decrement 1 in the "i".
         */
        
        NSInteger pageId, rangeLength;
        
        if (i == 0) {
            pageId = numberOfPages-1;
            rangeLength = 4 - (imagesArray.count%4);
        }
        else {
            pageId = i-1;
            rangeLength = 4;
        }
        
        NSRange range = NSMakeRange(pageId*4, rangeLength);
        NSArray *images = [imagesArray objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
        CustomView *view = [[CustomView alloc] initWithPage:pageId andImages:images];
        view.frame = CGRectMake(scrollView_.frame.size.width * i, 0, scrollView_.frame.size.width, scrollView_.frame.size.height);
        
        [pageViews addObject:view];
        [scrollView_ addSubview:view];
    }
    
    // set contect size of scrollView
    scrollView_.contentSize = CGSizeMake(scrollView_.frame.size.width * 3, scrollView_.frame.size.height);
    
    // Scroll View now has the Pages: 3, 1, 2. So move the scroll to Page 1 by default.
    scrollView_.contentOffset = CGPointMake(scrollView_.bounds.size.width, scrollView_.contentOffset.y);
}

- (void)rotateViewsRight {
    UIView *endView = [pageViews lastObject];
    [pageViews removeLastObject];
    [pageViews insertObject:endView atIndex:0];
    [self setContentViewFrames];
}

- (void)rotateViewsLeft {
    UIView *endView = pageViews[0];
    [pageViews removeObjectAtIndex:0];
    [pageViews addObject:endView];
    [self setContentViewFrames];
}

- (void) setContentViewFrames {
    for(int i = 0; i < numberOfPages; i++) {
        CustomView * view = pageViews[i];
        [view setFrame:CGRectMake(scrollView_.frame.size.width * i, 0, scrollView_.frame.size.width, scrollView_.frame.size.height)];
    }
}

- (void)increasePageControl {
    pageControl.currentPage = (pageControl.currentPage == numberOfPages-1) ? 0 : pageControl.currentPage+1;
}

- (void)decreasePageControl {
    pageControl.currentPage = (pageControl.currentPage == 0) ? numberOfPages-1 : pageControl.currentPage-1;
}

/***********************************************************************************************************************/
#pragma mark - ScrollView Delegates

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x == 0) {
        CGPoint newOffset = CGPointMake(scrollView.bounds.size.width, scrollView.contentOffset.y);
        [scrollView setContentOffset:newOffset];
        
        [self decreasePageControl];
        [self rotateViewsRight];
    }
    else if ( scrollView.contentOffset.x == (scrollView.bounds.size.width * 2) ) {
        CGPoint newOffset = CGPointMake(scrollView.bounds.size.width, scrollView.contentOffset.y);
        [scrollView setContentOffset:newOffset];
        
        [self increasePageControl];
        [self rotateViewsLeft];
    }
}


@end
