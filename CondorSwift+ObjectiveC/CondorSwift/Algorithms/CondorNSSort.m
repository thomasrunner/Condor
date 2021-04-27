//
//    CondorNSSort.m
//    Condor
//
//    Created by Thomas on 2018-01-13.
//    Copyright © 2018 Thomas Lock. <thomas.lock.personal@gmail.com>
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in
//    all copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//    THE SOFTWARE.

//    Copying and distribution of this file, with or without modification,
//    are permitted in any medium without royalty provided the copyright
//    notice and this notice are preserved.
//

#import "CondorSort.h"
#import "CondorNSSort.h"

@interface CondorNSSort()
{
    NSArray* numbersNS;
    int size;
}

    @property (strong, nonatomic) CondorSort *condorSort;

@end


@implementation CondorNSSort
@synthesize condorSort;

//DESCENDING ORDER 4,3,2,1,0
//ASCENDING ORDER 0,1,2,3,4

#pragma mark - BOOLEAN
-(NSArray*) sortBooleanNSArray:(NSArray*) array orderDesc: (BOOL) descending
{
    if(array == nil) return array;
    if([array count] < 2) return array;
    numbersNS = array;
    size = (int)[numbersNS count];
    
    NSMutableArray *falseArray = [[NSMutableArray alloc]  init];
    NSMutableArray *trueArray = [[NSMutableArray alloc]  init];
    
    for (int i = 0; i < size; i++)
    {
        NSNumber *b = numbersNS[i];
        
        if ([b boolValue] == true)
        {
            [trueArray addObject:b];
        }
        else
        {
            [falseArray addObject:b];
        }
    }
    
    if(descending == true)
    {
        for(int j=0; j < [falseArray count]; j++)
        {
            NSNumber *b = falseArray[j];
            [trueArray addObject:b];
        }
        //[falseArray removeAllObjects];
        falseArray = nil;
        return trueArray;
    }
    else
    {
        for(int j=0; j < [trueArray count]; j++)
        {
            NSNumber *b = trueArray[j];
            [falseArray addObject:b];
        }
        //[trueArray removeAllObjects];
        trueArray = nil;
        return falseArray;
    }
}

#pragma mark - UNSIGNED CHAR
-(NSArray*) sortUnsignedCharNSArray:(NSArray*) array orderDesc: (BOOL) descending
{
    if(array == nil) return array;
    if([array count] < 2) return array;
    numbersNS = array;
    size = (int)[numbersNS count];
    
    int* count = (int*)calloc(256,sizeof(int));
    NSMutableArray *output = [[NSMutableArray alloc] init];
    
    //BUILD COUNTING
    for (int i = 0; i < size; i++)
    {
        NSNumber *b = numbersNS[i];
        unsigned int value = [b unsignedIntValue];
        count[value]++;
    }
    
    if(!descending)
    {
        for (int i = 0; i < 256; i++)
        {
            unsigned int j = 0;
            while (j < count[i])
            {
                NSNumber *b = [NSNumber numberWithUnsignedInt:i];
                [output addObject:b];
                j++;
            }
        }
    }
    else
    {
        for (int i = 255; i >= 0; i--)
        {
            unsigned int j = 0;
            while (j < count[i])
            {
                NSNumber *b = [NSNumber numberWithUnsignedInt:i];
                [output addObject:b];
                j++;
            }
        }
    }
    
    free(count);
    return output;
}

#pragma mark - SIGNED CHAR
-(NSArray*) sortSignedCharNSArray:(NSArray*) array orderDesc: (BOOL) descending
{
    if(array == nil) return array;
    if([array count] < 2) return array;
    numbersNS = array;
    size = (int)[numbersNS count];
    
    int* count = (int*)calloc(256,sizeof(int));
    NSMutableArray *output = [[NSMutableArray alloc] init];
    
    //BUILD COUNTING
    
    for (int i = 0; i < size; i++)
    {
        NSNumber *b = numbersNS[i];
        unsigned int value = [b intValue] + 128;
        count[value]++;
    }
    if(!descending)
    {
        for (int i = 0; i < 256; i++)
        {
            unsigned int j = 0;
            while (j < count[i])
            {
                NSNumber *b = [NSNumber numberWithInt:(i - 128)];
                [output addObject:b];
                j++;
            }
        }
    }
    else
    {
        for (int i = 255; i >= 0; i--)
        {
            signed int j = 0;
            while (j < count[i])
            {
                NSNumber *b = [NSNumber numberWithInt:(i - 128)];
                [output addObject:b];
                j++;
            }
        }
    }
    
    free(count);
    return output;
}

#pragma mark - SIGNED SHORT
-(NSArray*) sortSignedShortNSArray:(NSArray*) array orderDesc: (BOOL) descending
{
    if(array == nil) return array;
    if([array count] < 2) return array;
    self.condorSort = [[CondorSort alloc] init];
    numbersNS = array;
    size = (int)[numbersNS count];
    NSMutableArray *output = nil;
    if(size > 131000)
    {
        int* count = (int*)calloc(65536,sizeof(int));
        output = [[NSMutableArray alloc] init];
        
        //BUILD COUNTING
        for (int i = 0; i < size; i++)
        {
            NSNumber *b = numbersNS[i];
            unsigned int value = [b intValue] + 32768;
            count[value]++;
        }
        if(!descending)
        {
            for (int i = 0; i < 65536; i++)
            {
                int j = 0;
                while (j < count[i])
                {
                    NSNumber *b = [NSNumber numberWithShort:(i - 32768)];
                    [output addObject:b];
                    j++;
                }
            }
        }
        else
        {
            for (int i = 65535; i >= 0; i--)
            {
                int j = 0;
                while (j < count[i])
                {
                    NSNumber *b = [NSNumber numberWithShort:(i - 32768)];
                    [output addObject:b];
                    j++;
                }
            }
        }
        
        free(count);
    }
    else
    {
        signed short* sortingArray = (signed short*)calloc(size,sizeof(signed short));
        output = [[NSMutableArray alloc] init];
        int arrayPosition = 0;
        for (int i = 0; i < size; i++)
        {
            NSNumber *b = numbersNS[i];
            signed short value = [b intValue];
            sortingArray[arrayPosition] = value;
            arrayPosition++;
        }
        [self.condorSort sortSignedShortArray:sortingArray withLength:(int)size];
        if(descending)
        {
            [self.condorSort reverseOrderOfSignedShortArray:sortingArray withLow:0 andHigh:(int)size-1];
        }
        for (int i = 0; i < size; i++)
        {
            NSNumber *b = [NSNumber numberWithShort:sortingArray[i]];
            [output addObject:b];
        }
        free(sortingArray);
    }
    return output;
}

#pragma mark - UNSIGNED SHORT
-(NSArray*) sortUnsignedShortNSArray:(NSArray*) array orderDesc: (BOOL) descending
{
    if(array == nil) return array;
    if([array count] < 2) return array;
    self.condorSort = [[CondorSort alloc] init];
    numbersNS = array;
    size = (int)[numbersNS count];
    NSMutableArray *output = nil;
    if(size > 131000)
    {
        int* count = (int*)calloc(65536,sizeof(int));
        output = [[NSMutableArray alloc] init];
        
        //BUILD COUNTING
        for (int i = 0; i < size; i++)
        {
            NSNumber *b = numbersNS[i];
            unsigned int value = [b intValue];
            count[value]++;
        }
        if(!descending)
        {
            for (int i = 0; i < 65536; i++)
            {
                int j = 0;
                while (j < count[i])
                {
                    NSNumber *b = [NSNumber numberWithUnsignedShort:i];
                    [output addObject:b];
                    j++;
                }
            }
        }
        else
        {
            for (int i = 65535; i >= 0; i--)
            {
                int j = 0;
                while (j < count[i])
                {
                    NSNumber *b = [NSNumber numberWithUnsignedShort:i];
                    [output addObject:b];
                    j++;
                }
            }
        }
        
        free(count);
    }
    else
    {
        unsigned short* sortingArray = (unsigned short*)calloc(size,sizeof(unsigned short));
        output = [[NSMutableArray alloc] init];
        int arrayPosition = 0;
        for (int i = 0; i < size; i++)
        {
            NSNumber *b = numbersNS[i];
            unsigned int value = [b unsignedIntValue];
            sortingArray[arrayPosition] = value;
            arrayPosition++;
        }
        [self.condorSort sortUnsignedShortArray:sortingArray withLength:(int)size];
        if(descending)
        {
            [self.condorSort reverseOrderOfUnsignedShortArray:sortingArray withLow:0 andHigh:(int)size-1];
        }
        
        for (int i = 0; i < size; i++)
        {
            NSNumber *b = [NSNumber numberWithUnsignedShort:sortingArray[i]];
            [output addObject:b];
        }
        free(sortingArray);
    }
    return output;
}

#pragma mark - SIGNED INT
-(NSArray*) sortSignedIntNSArray:(NSArray*) array orderDesc: (BOOL) descending
{
    if(array == nil) return array;
    if([array count] < 2) return array;
    self.condorSort = [[CondorSort alloc] init];
    numbersNS = array;
    size = (int)[numbersNS count];
    NSMutableArray *output = nil;
    
    int* sortingArray = (int*)calloc(size,sizeof(int));
    output = [[NSMutableArray alloc] init];
    int arrayPosition = 0;
    for (int i = 0; i < size; i++)
    {
        NSNumber *b = numbersNS[i];
        signed int value = [b intValue];
        sortingArray[arrayPosition] = value;
        arrayPosition++;
    }
    [self.condorSort sortSignedIntArray:sortingArray withLength:(int)size];
    if(descending)
    {
        [self.condorSort reverseOrderOfSignedIntArray:sortingArray withLow:0 andHigh:(int)size-1];
    }
    for (int i = 0; i < size; i++)
    {
        NSNumber *b = [NSNumber numberWithInt:sortingArray[i]];
        [output addObject:b];
    }
    free(sortingArray);
    return output;
}

#pragma mark - UNSIGNED INT
-(NSArray*) sortUnsignedIntNSArray:(NSArray*) array orderDesc: (BOOL) descending
{
    if(array == nil) return array;
    if([array count] < 2) return array;
    self.condorSort = [[CondorSort alloc] init];
    numbersNS = array;
    size = (int)[numbersNS count];
    NSMutableArray *output = nil;
    
    unsigned int* sortingArray = (unsigned int*)calloc(size,sizeof(unsigned int));
    output = [[NSMutableArray alloc] init];
    int arrayPosition = 0;
    for (int i = 0; i < size; i++)
    {
        NSNumber *b = numbersNS[i];
        unsigned int value = [b unsignedIntValue];
        sortingArray[arrayPosition] = value;
        arrayPosition++;
    }
    [self.condorSort sortUnsignedIntArray:sortingArray withLength:(int)size];
    if(descending)
    {
        [self.condorSort reverseOrderOfUnsignedIntArray:sortingArray withLow:0 andHigh:(int)size-1];
    }
    for (int i = 0; i < size; i++)
    {
        NSNumber *b = [NSNumber numberWithUnsignedInt:sortingArray[i]];
        [output addObject:b];
    }
    free(sortingArray);
    return output;
}

#pragma mark - FLOAT
-(NSArray*) sortFloatNSArray:(NSArray*) array orderDesc: (BOOL) descending
{
    if(array == nil) return array;
    if([array count] < 2) return array;
    self.condorSort = [[CondorSort alloc] init];
    numbersNS = array;
    size = (int)[numbersNS count];
    NSMutableArray *output = nil;
    
    float* sortingArray = (float*)calloc(size,sizeof(float));
    output = [[NSMutableArray alloc] init];
    int arrayPosition = 0;
    for (int i = 0; i < size; i++)
    {
        NSNumber *b = numbersNS[i];
        float value = [b floatValue];
        sortingArray[arrayPosition] = value;
        arrayPosition++;
    }
    [self.condorSort sortFloatArray:sortingArray withLength:(int)size];
    if(descending)
    {
        [self.condorSort reverseOrderOfFloatArray:sortingArray withLow:0 andHigh:(int)size-1];
    }
    for (int i = 0; i < size; i++)
    {
        NSNumber *b = [NSNumber numberWithFloat:sortingArray[i]];
        [output addObject:b];
    }
    
    free(sortingArray);
    return output;
}

@end
