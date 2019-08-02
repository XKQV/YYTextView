//
//  ViewController.m
//  TestTextView
//
//  Created by Kaiquan on 2019/7/28.
//  Copyright © 2019 Kaiquan. All rights reserved.
//

#import "ViewController.h"
#import <YYText/YYText.h>
#import "YYLabel+ReadWriteFrame.h"
#import "Masonry.h"
#import "Son.h"

@interface TestModel : NSObject

@property (nonatomic, strong) NSString *modelString;

@end

@implementation TestModel
@end


@interface ViewController ()
@property (nonatomic, strong) YYLabel *label;
@property (nonatomic, strong) NSString *placeholderString;
@property (nonatomic, strong) NSMutableAttributedString *text;
@property (nonatomic, strong) NSString *detectedPhone;
@property (nonatomic, strong) NSString *detectedLink;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //    Father *father = [Father new];
    //    Son *son = [Son new];
    
//    NSString *test1 = @"test1";
//    NSString *test2 = test1;
//    test2 = @"test2";
//    NSLog(@"test1: %@ test2: %@",test1, test2);
    
//    TestModel *testModel1 = [TestModel new];
//    testModel1.modelString = @"1";
//    TestModel *testModel2 = testModel1;
//    NSLog(@"testModel1: %@ testModel2: %@",testModel1.modelString, testModel2.modelString);
//    testModel2.modelString = @"2";
//    NSLog(@"testModel1: %@ testModel2: %@",testModel1.modelString, testModel2.modelString);
//
//    TestModel *testModel3 = [testModel1 mutableCopy];
//    NSLog(@"testModel1: %@ testModel3: %@",testModel1.modelString, testModel3.modelString);
//    testModel3.modelString = @"3";
//    NSLog(@"testModel1: %@ testModel3: %@",testModel1.modelString, testModel3.modelString);
    
 
    __weak typeof (self) weakSelf = self;
    self.text = [NSMutableAttributedString new];
    [self.text appendAttributedString:[self image]];
    self.placeholderString = @"Phone number is: 18525500251  UILabel and UITextView API compatible. url is http://www.baidu.com High performance asynchronous text layout and rendering. Extended CoreText attributes with more text effects. Text attachments with UIImage, UIView and CALayer";
    [self detectThePlaceHolderString:self.placeholderString];
    [self.text appendAttributedString:[self showLessString]];
    
    self.text.yy_font = [UIFont systemFontOfSize:16]; ;
    self.text.yy_lineSpacing = 10;
    self.label.attributedText = self.text;
    self.label.textTapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        NSRange phoneRange = [weakSelf.placeholderString rangeOfString:weakSelf.detectedPhone ? : @""];
        NSRange LinkRange = [weakSelf.placeholderString rangeOfString:weakSelf.detectedLink ? : @""];
        if ([self containsSelectedPointLocation:range.location inRange:phoneRange] || [self containsSelectedPointLocation:range.location inRange:LinkRange]) {
            return ;
        }
        NSLog(@"Whole textview is tapped");
    };
    [self.label addObserver:self forKeyPath:NSKeyValueChangeNewKey options:NSKeyValueObservingOptionNew context:nil];
    // 添加全文
    [self addSeeMoreButton];
}

- (BOOL)containsSelectedPointLocation:(NSUInteger)location inRange:(NSRange)range {
    if (location < range.location || location > (range.location + range.length)) {
        return NO;
    } else {
        return YES;
    }
}

- (void)detectThePlaceHolderString:(NSString *)string {
    NSError *error = nil;
    NSDataDetector *dataDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink | NSTextCheckingTypePhoneNumber
                                                                   error:&error];
    NSArray *stringsToTest = @[string];
    for (NSString *string in stringsToTest) {
        [dataDetector enumerateMatchesInString:string
                                       options:0
                                         range:NSMakeRange(0, string.length)
                                    usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                                        if (result.URL) {
                                            NSLog(@"url = %@",result.URL);
                                            self.detectedLink = [result.URL absoluteString];
                                        }
                                        if (result.phoneNumber) {
                                            NSLog(@"phone = %@",result.phoneNumber);
                                            self.detectedPhone = result.phoneNumber;
                                        }
                                    }];
    }
    [self addHighlightedText];
}
- (void)addHighlightedText {
    if (self.detectedPhone.length > 0 || self.detectedLink.length > 0) {
        [self.text appendAttributedString:[self highlightDetectedInformation]];
    } else {
        NSAttributedString *temAttributedString = [[NSAttributedString alloc] initWithString:self.placeholderString];
        [self.text appendAttributedString:temAttributedString];
    }
}

- (NSAttributedString *)highlightDetectedInformation {
    NSMutableAttributedString *temString = [[NSMutableAttributedString alloc] initWithString:self.placeholderString attributes:nil];
    if (self.detectedPhone.length > 0) {
        [temString yy_setColor:[UIColor greenColor] range:[temString.string rangeOfString:self.detectedPhone]];
        YYTextHighlight *highlight = [YYTextHighlight new];
        [highlight setColor:[UIColor colorWithRed:0 green:1 blue:0 alpha:0.5]];
        highlight.tapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            NSLog(@"phone tapped");
        };
        [temString yy_setTextHighlight:highlight range:[temString.string rangeOfString:self.detectedPhone]];
    }
    
    if (self.detectedLink.length > 0) {
        [temString yy_setTextHighlightRange:[temString.string rangeOfString:self.detectedLink] color:[UIColor blueColor] backgroundColor:[UIColor colorWithRed:0 green:0 blue:1 alpha:0.5] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            NSLog(@"Link tapped");
        }];
    }
    return temString.copy;
}


- (NSAttributedString *)image {
    NSMutableAttributedString *attachment = nil;
    UIImage *image = [self imageWithImageSample:[UIImage imageNamed:@"photo"] scaledToSize:CGSizeMake(20, 20)];
    
    attachment = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:image.size alignToFont:[UIFont systemFontOfSize:16] alignment:YYTextVerticalAlignmentCenter];
    return attachment;
}

- (YYLabel *)label {
    if (!_label) {
        _label= [[YYLabel alloc] initWithFrame:CGRectMake(50, 100, 200, 120)];
        _label.numberOfLines = 0;
        _label.textVerticalAlignment = YYTextVerticalAlignmentTop;
        [self.view addSubview:_label];
        _label.layer.borderWidth = 0.5;
        _label.layer.borderColor = [UIColor colorWithRed:0.000 green:0.463 blue:1.000 alpha:1.000].CGColor;
    }
    return _label;
}

#pragma mark - 添加全文

- (void)addSeeMoreButton {
    __weak __typeof(self) weakSelf = self;
    NSString *more = @"More";
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"...More"];
    YYTextHighlight *highlight = [YYTextHighlight new];
    [highlight setColor:[UIColor colorWithRed:0 green:0 blue:1.000 alpha:0.5]];
    highlight.tapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        YYLabel *label = weakSelf.label;
        label.numberOfLines = 0;
                [label sizeToFit];
        //计算文本尺寸
        YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(200, CGFLOAT_MAX) text:self.text];
        CGFloat introHeight = layout.textBoundingSize.height;
        [label setHight:introHeight];
    };
    [text yy_setColor:[UIColor colorWithRed:0.000 green:0 blue:1.000 alpha:1.000] range:[text.string rangeOfString:more]];
    [text yy_setTextHighlight:highlight range:[text.string rangeOfString:more]];
    text.yy_font=_label.font;
    YYLabel *seeMore = [YYLabel new];
    seeMore.attributedText= text;
    [seeMore sizeToFit];
    NSAttributedString *truncationToken = [NSAttributedString yy_attachmentStringWithContent:seeMore contentMode:UIViewContentModeCenter attachmentSize:seeMore.frame.size alignToFont:text.yy_font alignment:YYTextVerticalAlignmentCenter];
    _label.truncationToken= truncationToken;
}

- (NSAttributedString *)showLessString {
    __weak __typeof(self) weakSelf = self;
    NSString *showLess = @"Show Less";
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"\rShow Less"];
    text.yy_lineBreakMode = kCTParagraphStyleSpecifierParagraphSpacing;
    YYTextHighlight *hi = [YYTextHighlight new];
    [hi setColor:[UIColor colorWithRed:0 green:0 blue:1.000 alpha:0.5]];
    hi.tapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        YYLabel *label = weakSelf.label;
        [label setHight:120];
        [label updateConstraints];
    };
    [text yy_setColor:[UIColor colorWithRed:0.000 green:0 blue:1.000 alpha:1.000] range:[text.string rangeOfString:showLess]];
    [text yy_setTextHighlight:hi range:[text.string rangeOfString:showLess]];
    text.yy_font=_label.font;
    return text;
}

- ( UIImage *)imageWithImageSample:( UIImage *)image scaledToSize:( CGSize )newSize {
    // Create a graphics image context
    UIGraphicsBeginImageContext (newSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect : CGRectMake ( 0 , 0 ,newSize.width, newSize.height)];
    // Get the new image from the contex
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext ();
    // Return the new image.
    return newImage;
}

@end
