//
//  CustomView.m
//  Test
//
//  Created by Jawad Ahmad on 24/05/2016.
//  Copyright © 2016 Jawad Ahmad. All rights reserved.
//

#import "CustomView.h"
#import "MaskImage.h"

@implementation CustomView

- (instancetype)initWithPage:(NSInteger)page andImages:(NSArray *)images {
    self = [[NSBundle mainBundle] loadNibNamed:@"CustomView" owner:self options:nil].firstObject;
    [self loadPage:page andImages:images];
    
    return self;
}

- (void)loadPage:(NSInteger)pageNumber andImages:(NSArray *)images
{
    for (NSInteger i=1; i<=images.count; i++)
    {
        UIImageView *imageView = [self viewWithTag:900+i];
        UIImage *mask = [MaskImage getMaskImage];
        imageView.image = [MaskImage maskImage:images[i-1] withMask:mask];
        imageView.hidden = NO;
        
        UIImageView *frame = [self viewWithTag:700+i];
        frame.hidden = NO;

        UILabel *label = [self viewWithTag:800+i];
        NSDictionary *strokeTextAttributes = @{NSStrokeColorAttributeName : [UIColor redColor],
                                               NSForegroundColorAttributeName : [UIColor whiteColor],
                                               NSStrokeWidthAttributeName : @-2.0};
        
        NSString *string = [NSString stringWithFormat:@"%zd", (4 * pageNumber) + i];
        label.attributedText = [[NSMutableAttributedString alloc] initWithString:string attributes:strokeTextAttributes];
        label.hidden = NO;
    }
}

@end
