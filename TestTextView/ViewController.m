//
//  ViewController.m
//  TestTextView
//
//  Created by Kaiquan on 2019/7/28.
//  Copyright © 2019 Kaiquan. All rights reserved.
//

#import "ViewController.h"
#import <YYText/YYText.h>

@interface ViewController ()
@property (nonatomic, strong) YYLabel *label;
@property (nonatomic, strong) NSString *placeholderString;
@property (nonatomic, strong) NSMutableAttributedString *text;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.text = [NSMutableAttributedString new];
    UIFont *font = [UIFont systemFontOfSize:16];
    
    //    [text appendAttributedString:[self phone]];
    [self.text appendAttributedString:[self image]];
    //    [text appendAttributedString:[self url]];
    self.placeholderString = @"Phone number is: 18525555555 UILabel and UITextView API compatible. url is: www.baidu.com High performance asynchronous text layout and rendering. Extended CoreText attributes with more text effects. Text attachments with UIImage, UIView and CALayer";
    [self detectThePlaceHolderString:self.placeholderString withHandler:^(NSAttributedString *sortedString) {
        [self.text appendAttributedString:sortedString];
    }];
    
    [self.text appendAttributedString:[self showLessString]];
    
    self.text.yy_font= font ;
    self.text.yy_lineSpacing = 10;
    self.label.attributedText = self.text;
    self.label.textTapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        NSLog(@"Whole textview is tapped");
    };
    
    // 添加全文
    [self addSeeMoreButton];
}

- (YYLabel *)label {
    if (!_label) {
        _label= [YYLabel new];
        _label.userInteractionEnabled = YES;
        _label.numberOfLines = 0;
        _label.textVerticalAlignment = YYTextVerticalAlignmentTop;
        _label.frame = CGRectMake(40,60, self.view.frame.size.width-80,120);
        [self.view addSubview:_label];
        _label.layer.borderWidth = 0.5;
        _label.layer.borderColor = [UIColor colorWithRed:0.000 green:0.463 blue:1.000 alpha:1.000].CGColor;
    }
    return _label;
}


- (void)detectThePlaceHolderString:(NSString *)string withHandler:(void(^)(NSAttributedString *))handler{
    
    __weak typeof(self) weakSelf = self;
    [self detectKeyValueWithRawString:string andNSTextCheckingType:NSTextCheckingTypePhoneNumber handler:^(NSString *phone) {
        if (handler) {
            handler([weakSelf highlighWithPhone:phone].copy);
        }
    }];
    //    [self detectKeyValueWithRawString:string andNSTextCheckingType:NSTextCheckingTypeLink handler:^(NSString *link) {
    //        [weakSelf :phone];
    //    }];
    
}

- (void)detectKeyValueWithRawString:(NSString *)string andNSTextCheckingType:(NSTextCheckingType)type handler:(void(^)(NSString *))handler {
    NSError *error = nil;
    NSDataDetector *dataDetector = [NSDataDetector dataDetectorWithTypes:type
                                                                   error:&error];
    
    NSArray *stringsToTest = @[
                               string
                               ];
    
    for (NSString *string in stringsToTest)
    {
        [dataDetector enumerateMatchesInString:string
                                       options:0
                                         range:NSMakeRange(0, string.length)
                                    usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop)
         {
             NSString *numberWithExtra = result.phoneNumber;
             NSCharacterSet *toRemove = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
             NSString *trimmed = [[numberWithExtra componentsSeparatedByCharactersInSet:toRemove] componentsJoinedByString:@""];
             if(trimmed && trimmed.length)
             {
                 if (handler) {
                     handler(trimmed);
                 }
             }
             else
             {
                 NSLog(@"No phone number");
                 if (handler) {
                     handler(@"");
                 }
             }
         }];
    }
    
}

- (NSMutableAttributedString *)highlighWithPhone:(NSString *)phone {
    NSMutableAttributedString *temString = [[NSMutableAttributedString alloc] initWithString:self.placeholderString attributes:nil];
    [temString yy_setColor:[UIColor greenColor] range:[temString.string rangeOfString:phone]];
    YYTextHighlight *highlight = [YYTextHighlight new];
    [highlight setColor:[UIColor colorWithRed:0 green:1 blue:0 alpha:0.5]];
    highlight.tapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        NSLog(@"phone tapped");
    };
    [temString yy_setTextHighlight:highlight range:[temString.string rangeOfString:phone]];
    return temString;
}

- (NSAttributedString *)url {
    NSString *url = @"www.baidu.com";
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"url is: www.baidu.com "];
    [text yy_setColor:[UIColor redColor] range:[text.string rangeOfString:url]];
    YYTextHighlight *highlight = [YYTextHighlight new];
    [highlight setColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:0.5]];
    highlight.tapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        NSLog(@"phone tapped");
    };
    [text yy_setTextHighlight:highlight range:[text.string rangeOfString:url]];
    return text;
}

- (NSAttributedString *)image {
    NSMutableAttributedString *attachment = nil;
    UIImage *image = [self imageWithImageSample:[UIImage imageNamed:@"photo"] scaledToSize:CGSizeMake(20, 20)];
    
    attachment = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:image.size alignToFont:[UIFont systemFontOfSize:16] alignment:YYTextVerticalAlignmentCenter];
    return attachment;
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
        [label sizeToFit];
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
        CGRect frame = label.frame;
        frame.size.height = 120;
        label.frame = frame;
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
