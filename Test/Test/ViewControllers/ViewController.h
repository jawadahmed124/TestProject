//
//  ViewController.h
//  Test
//
//  Created by Jawad Ahmad on 24/05/2016.
//  Copyright © 2016 Jawad Ahmad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomView.h"

@interface ViewController : UIViewController <UIScrollViewDelegate>
{
    IBOutlet UILabel *titleLabel;
    IBOutlet UIScrollView *scrollView_;
    IBOutlet UIPageControl *pageControl;
    
    NSMutableArray *imagesArray;
    NSInteger numberOfPages;
    
    BOOL viewInitiated;
    NSMutableArray *pageViews;
}


@end

