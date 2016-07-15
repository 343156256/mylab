//
//  NSData+Object.m
//  
//
//  Created by iecd on 15/9/8.
//
//

#import "NSData+Object.h"

@implementation NSData (Object)

- (id)getObject
{
    if(self){
        NSError *err = nil;
        id obj = [NSJSONSerialization JSONObjectWithData:self
                                                            options:NSJSONReadingMutableContainers
                                                                           error:&err];
        return obj;
    }
    
    return nil;
}

@end
