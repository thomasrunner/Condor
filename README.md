# Condor - Upto 9x Faster than ObjC (Scalable Big Data Sorting)
Apple's built-in sorting algorithm implementation is far too slow. Condor is a new Sorting Framework available for both Objective C and Swift in a super easy to use ULTRA LIGHT Framework. Since this Framework was written in ObjC it runs much much slower in SWIFT than ObjC but is still able to outperforms SWIFT. A Native Swift version is presently in the works and should be available shortly!

This Framework is ideal for any sorting methods but really shines when it comes to Big Data Sets in the billions by not only being extremely fast, it also utilizes less than 4MB of memory (average more like < 1MB in addition to the sorting array) regardless of data set format or size. 

Space O(k) where k is less 4MB  (Object sorting requires an output Array but C arrays don't and are sorted in place)

Time of O(k*N) where k is between 2 and 16.

Condor supports System Types, NSNumber, and Object with using a specific properties that returns an Int32, Int64, Float or Double.

**YOU CAN FIND THE FRAMEWORK LOCATED IN THE PROJECT**

UPDATE v1.3.2
- Added support for upto 64 CPU's

UPDATE v1.3.1
- Added RADIX to Apple's side of Algorithms and it still loses.
- Added Object Int64 and Double sorting
- Updated C Arrays (Int32, UInt32, Float, Double) and Object (Int32, UInt32, Int64, Float, Double) to be about 25% faster on average  with the most gains visible in Double and UInt64 sorting methods.

UPDATE v1.3.0
- Added Quicksort to Apple's side of Algorithms and it still loses.

UPDATE v1.2.9 b
- Added Quicksort to Apple's side of Algorithms and it still loses.

UPDATE v1.2.9
- Minor performance boosts for Object Sort, UInt32, Int32 and Float

UPDATE v1.2.8
- Minor performance boost for Object Int Property Sort

UPDATE v1.2.7
- New Float Tests in Objective C and Swift
- Removed Protocol requirements, now ANY Int or Float property in SWIFT and ANY int or float property in ObjC
- As amazing as this will sound, Condor is now upto 9x FASTER than ObjC sort
- Minor UI Tweaks
- Cleaned up the code a little for readability
- Restructured header files
- Added bitcode support making it Production Ready for any project type.

UPDATE v1.2.5
- Merged all project into a single Project which has Swift and Objective C ViewControllers and Tests
- Fixed UInt32*, UInt*, and float* array bugs

UPDATE v1.2.4
- Fixed over optimization bugs on Object Sort

UPDATE v1.2.2
- Fixed not sorting last value of Int Object Sort
- Updated System Type algorithms with additional tweaks already in Object Sort

UPDATE v1.2.1
- Fixed decending bug for Object Sort
- New float Object Sort using CondorObject protocol condorIdf
- More than 10% performance increase for Int Object Sort

UPDATED v1.0.1
- New Object Sort using CondorObject protocol

# Screenshot of GitHub App

<img src="https://thomaslockblog.files.wordpress.com/2018/01/img_1840.png" alt="IMG_1840" width="382" height="679" />

<img src="https://thomaslockblog.files.wordpress.com/2018/01/img_1842.png" alt="IMG_1842" width="382" height="679" />

# Screenshot Comparing other Sorting Algorithms

These results are based on version 1, so performance results now are significantly faster (built in C#)
<img src="https://thomaslockblog.files.wordpress.com/2018/01/condor_results2.png" alt="condor_results2" width="365" height="434" />

# Sample Code

It comes with  specific classes:

     // CondorSort.h for system types (Boolean, unsigned char, signed char, unsigned short, signed short, unsigned int, signed int and float)
     
     // CondorNSSort.h for NSArray's with NSNumbers of types listed in CondorSort.
     
     // CondorObjectSort.h for reverse sort ANY Object.
     
     // CondorObjectSortInt.h will sort any Object using an Int return selector property
     
     // CondorObjectSortInt64.h will sort any Object using an Int64 return selector property
    
     // CondorObjectSortFloat.h will sort any Object using an Float return selector property
   
     // CondorObjectSortDouble.h will sort any Object using an Double return selector property
     
     EXAMPLE #1 (CondorNSSort)
     
     //PROPERTY
     CondorNSSort *condorNSSort = [[CCondorNSSort alloc] init];
     
     //TEST METHOD
     NSMutableArray *nsmarray = [[NSMutableArray alloc] init];
     for (int i = 0; i < 10000000; i++)
     {
        unsigned short value = (unsigned short)arc4random_uniform(USHRT_MAX + 1);
        NSNumber *number = [NSNumber numberWithUnsignedShort:value];
        [nsmarray addObject:number];
     }
     //FEEL FREE TO RUN QUICK BENCHMARK AGAINST "sortedArrayUsingSelector"
     //NSDate *date = [NSDate date];
     
     //CONDOR SORT METHOD
     NSArray *nsarray = [self.condorNSSort sortUnsignedShortNSArray:nsmarray orderDesc:true];
     
     //APPLE SORT METHOD
     //NSArray *nsarray = [nsmarray sortedArrayUsingSelector: @selector(compare:)];
     
     //PERFORMANCE RESULTS
     //double timePassed_ms = [date timeIntervalSinceNow] * -1000.0;
     //NSLog(@"Performance: %f", timePassed_ms);

     [nsmarray removeAllObjects];
     nsmarray = nil;
     
     EXAMPLE #2 (CondorSort)
     
     //PROPERTY
     CondorSort *condorSort = [[CCondorSort alloc] init];
     
     //TEST METHOD
     signed int* array = (signed int*)calloc(10000000, 2);
     
     NSLog(@"Array Size 10000000");
     for(int i = 0; i < 10000000; i++)
     {
        signed int value = ((signed int)arc4random_uniform(21474836 * 2) - 21474836 );
        array[i] = (signed int)(value);
     }
     
     //FEEL FREE TO RUN QUICK BENCHMARK AGAINST "sortedArrayUsingSelector"
     
     //BUILD NSARRAY FOR APPLE METHOD
     //NSMutableArray *nsmarray = [[NSMutableArray alloc] init];
     //for (int i = 0; i < 10000000; i++) {
     //   NSNumber *number = [NSNumber numberWithInteger:array[i]];
     //   [nsmarray addObject:number];
     //}
     //NSArray *nsarray = nsmarray;
     
     //START TIME CHECK
     //NSDate *date = [NSDate date];
     
     //APPLE SORT METHOD
     //nsarray = [nsarray sortedArrayUsingSelector: @selector(compare:)];
     
     //CONDOR SORT METHOD
     [self.condorSort sortSignedIntArray:array withLength:10000000];
     
     //WRITE PERFORMANCE RESULT
     //double timePassed_ms = [date timeIntervalSinceNow] * -1000.0;
     //NSLog(@"Performance: %f", timePassed_ms);
     
     free(array);
