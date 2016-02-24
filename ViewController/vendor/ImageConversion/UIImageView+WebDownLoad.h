//
//  UIImageView+WebDownLoad.h
//  MyBook
//
//  Created by zq liu on 13-12-29.
//  Copyright (c) 2013年 zq liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#include "UIViewExt.h"

@interface UIImageView (WebDownLoad)
- (void)setImageWithURL:(NSString *)url placeholderImage:(UIImage *)placeholder cacheName:(NSString*)fileName;
@end
