//
//  GSCountDownButton.m
//  GlassStore
//
//  Created by noname on 15/1/26.
//  Copyright (c) 2015年 ORead. All rights reserved.
//

#import "GSCountDownButton.h"

@interface GSCountDownButton()
{
    int remainTime;
}

@property (nonatomic, strong) NSTimer *countDownTimer;

@end

@implementation GSCountDownButton

- (void)commonInit
{
    
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

-(void)dealloc
{
    
}

-(void)startCountDown
{
    [self cancelTimer];
    self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    remainTime = self.countDownDuration;
}

-(void)cancelTimer
{
    if (self.countDownTimer) {
        [self.countDownTimer invalidate];
        [self setCountDownTimer:nil];
    }
}

-(void)onTimer
{
    remainTime -= 1;
    if (remainTime <= 0) {
        [self cancelTimer];
        self.enabled = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setTitle:@"重发" forState:UIControlStateNormal];
        });
        
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setTitle:[NSString stringWithFormat:@"%d秒后重发", remainTime] forState:UIControlStateNormal];
        });
        
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    self.enabled = NO;
    [self startCountDown];
}
@end
