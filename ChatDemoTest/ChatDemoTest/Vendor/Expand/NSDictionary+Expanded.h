//
//  NSDictionary+Expanded.h
//  Engineer_iOS
//
//  Created by plus on 15/10/8.
//  Copyright © 2015年 DF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Expanded)

- (id)valueForKeyExceptNull:(NSString *)key;
- (NSString *)valueForKeyToStringExceptNull:(NSString *)key;

@end
