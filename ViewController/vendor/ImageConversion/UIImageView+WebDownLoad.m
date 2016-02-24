//
//  UIImageView+WebDownLoad.m
//  MyBook
//
//  Created by zq liu on 13-12-29.
//  Copyright (c) 2013年 zq liu. All rights reserved.
//

#import "UIImageView+WebDownLoad.h"

@implementation UIImageView (WebDownLoad)
- (void)setImageWithURL:(NSString *)urlString placeholderImage:(UIImage *)placeholder cacheName:(NSString*)fileName
{
    self.image = placeholder;
 NSLog(@"+++++++++++++++++++++++++3");
    
    if (urlString)
    {
        NSString *tmpDir=NSTemporaryDirectory();
        NSString *imagePath=nil;
        NSData* data=nil;
        
        if (fileName) {
            imagePath=[tmpDir stringByAppendingString:fileName];
            data = [NSData dataWithContentsOfFile:imagePath];
        }
        
        if (data.length>0) {
            UIImage *img=[UIImage imageWithData:data];
            self.image = img;
        }
        else {
            NSURL *url = [NSURL URLWithString:urlString];
            NSURLRequest *urlRequest = [NSURLRequest
                                        requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0f];
            NSOperationQueue *queue = [[[NSOperationQueue alloc] init]autorelease];
            
            [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response,NSData *data, NSError *error) {
                if ([data length] >0 && error == nil){
                    UIImage *img=[UIImage imageWithData:data];
                    
//                    self.image = img;
                    //主线程更新界面
                    [self performSelectorOnMainThread:@selector(updateImage:) withObject:img waitUntilDone:NO];
                    if (imagePath) {
                        [data writeToFile:imagePath atomically:YES];
                    }
                }
                else if ([data length] == 0 && error == nil){
                     NSLog(@"+++++++++++++++++++++++++1");
                    NSLog(@"Nothing was downloaded.");
                }
                else if (error != nil){
                    NSLog(@"+++++++++++++++++++++++++2");
                    NSLog(@"Error happened = %@", error);} }];
        }

    }
}

-(void)updateImage:(UIImage *)image
{
    self.image = image;
//    [self setNeedsDisplay];
}
@end
