//
//    CondorSort.h
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

#import <Foundation/Foundation.h>
#import "Condor.h"

@interface CondorSort : NSObject

    #pragma mark - Sorting Methods

    //Boolean
    -(void) sortBooleanArray:(Boolean*) array withLength:(int)length;

    //Char
    -(void) sortUnsignedCharArray:(unsigned char *)array withLength:(int) length;
    -(void) sortSignedCharArray:(signed char *) array withLength:(int) length;

    //Short
    -(void) sortUnsignedShortArray:(unsigned short *) array withLength:(int) length;
    -(void) sortSignedShortArray:(signed short *) array withLength:(int) length;

    //Int
    -(void) sortUnsignedIntArray:(unsigned int*) array withLength:(int) length;
    -(void) sortSignedIntArray:(signed int*) array withLength:(int) length;

    //Float
    -(void) sortFloatArray:(float*) array withLength:(int) length;


    #pragma mark - Reverse Order Of Array Methods
    -(void) reverseOrderOfBooleanArray:(Boolean*) array withLow:( int) low andHigh:(int) high;
    -(void) reverseOrderOfSignedCharArray:(signed char*) array withLow:( int) low andHigh:(int) high;
    -(void) reverseOrderOfUnsignedCharArray:(unsigned char*) array withLow:( int) low andHigh:(int) high;
    -(void) reverseOrderOfSignedShortArray:(signed short*) array withLow:( int) low andHigh:(int) high;
    -(void) reverseOrderOfUnsignedShortArray:(unsigned short*) array withLow:( int) low andHigh:(int) high;
    -(void) reverseOrderOfSignedIntArray:(signed int*) array withLow:( int) low andHigh:(int) high;
    -(void) reverseOrderOfUnsignedIntArray:(unsigned int*) array withLow:( int) low andHigh:(int) high;
    -(void) reverseOrderOfSignedLongArray:(signed long*) array withLow:( int) low andHigh:(int) high;
    -(void) reverseOrderOfUnsignedLongArray:(unsigned long*) array withLow:( int) low andHigh:(int) high;
    -(void) reverseOrderOfFloatArray:(float*) array withLow:( int) low andHigh:(int) high;
    -(void) reverseOrderOfDoubleArray:(double*) array withLow:( int) low andHigh:(int) high;
    -(void) reverseOrderOfLongDoubleArray:(long double*) array withLow:( int) low andHigh:(int) high;

@end
