//
//  MyDataModel.m
//  CondorMacOS
//
//  Created by Thomas on 2018-01-27.
//  Copyright © 2018 Thomas Lock. All rights reserved.
//

#import "MyDataModel.h"
@interface MyDataModel()
{
    NSString *payload;
}
@end


@implementation MyDataModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        payload = @"12345678912345678912345678912345678912345678911234567891234567891234567891234567891234567891";
    }
    return self;
}

@end
