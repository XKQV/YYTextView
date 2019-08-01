//
//  Son.m
//  TestTextView
//
//  Created by Zhiwei on 2019/8/2.
//  Copyright © 2019 Zhiwei. All rights reserved.
//

#import "Son.h"

@implementation Son
//@synthesize occupation;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.occupation = @"Student";
        NSLog(@"Son set father's occupation is %@",self.occupation);
    }
    return self;
}

@end
