//
//  Father.m
//  TestTextView
//
//  Created by Zhiwei on 2019/8/2.
//  Copyright © 2019 Zhiwei. All rights reserved.
//

#import "Father.h"

@interface Father ()

@property (nonatomic, assign) NSUInteger age;

@end

@implementation Father
//@synthesize occupation, age;

- (instancetype)init {
    self = [super init];
    if (self) {
        _occupation = @"Teacher";
        self.age = 40;
        NSLog(@"Father's initial age is %lu",(unsigned long)_age);
    }
    return self;
}

- (void)setOccupation:(NSString *)occupation {
    _occupation = occupation;
    self.age = 18;
    NSLog(@"Father's age is set in the occpation's setter methold at %lu",(unsigned long)_age);
}

@end
