//
//    Condor.h
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
//    notice and tUIKithis notice are preserved.
//

#import <Foundation/Foundation.h>

//! Project version number for Condor.
FOUNDATION_EXPORT double CondorVersionNumber;

//! Project version string for Condor.
FOUNDATION_EXPORT const unsigned char CondorVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <Condor/PublicHeader.h>

#import "CondorSort.h"
#import "CondorNSSort.h"
#import "CondorObjectSort.h"

#import "CondorObjectSortInt.h"
#import "CondorObjectSortInt64.h"

#import "CondorObjectSortFloat.h"
#import "CondorObjectSortDouble.h"
