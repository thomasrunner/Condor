//
//  CondorObjectSort.m
//  Condor
//
//  Created by Thomas on 2018-01-19.
//  Copyright © 2018 Thomas Lock. All rights reserved.
//

#import "CondorObjectSort.h"

@interface CondorObjectSort()
{
    void **numbersObject;
    int size;
    int sizeInsertion;
    UInt32 correction;
    long min;
}
@end

@implementation CondorObjectSort

-(void) reverseOrderOfObjectArray:(void**) array withLow:( int) low andHigh:(int) high
{
    if(array == nil) return;
    if(high - low < 2) return;
    int i = low;
    int j = high;
    
    while (i < j)
    {
        void *temp = array[i];
        array[i] = array[j];
        array[j] = temp;
        i++;
        j--;
    }
}

@end
