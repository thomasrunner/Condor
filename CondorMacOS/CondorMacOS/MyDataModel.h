//
//  MyDataModel.h
//  CondorMacOS
//
//  Created by Thomas on 2018-01-27.
//  Copyright © 2018 Thomas Lock. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyDataModel : NSObject

//Any Property that is returns a long long is valid
@property (nonatomic) long long anyPropertyInt64;

//Any Property that is returns a int is valid
@property (atomic) int anyPropertyInt;

//Any Property that is returns a float is valid
@property (atomic) float anyPropertyFloat;

//Any Property that is returns a double is valid
@property (nonatomic) double anyPropertyDouble;

@end
