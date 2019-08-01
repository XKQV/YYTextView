//
//  UILabel+ReadWriteFrame.m
//  TestTextView
//
//  Created by Zhiwei on 2019/7/31.
//  Copyright © 2019 Zhiwei. All rights reserved.
//

#import "UILabel+ReadWriteFrame.h"

@implementation UILabel (ReadWriteFrame)

- (void)setHight:(float)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

@end
