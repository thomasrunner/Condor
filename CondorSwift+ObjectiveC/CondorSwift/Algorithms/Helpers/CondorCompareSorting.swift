//
//    CondorCompareSorting.swift
//    CondorSwift
//
//  Created by Thomas on 2021-05-02.
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

import Foundation

class CondorCompareSorting<T: Comparable>{
    var items:[T] = []
    
    func condorSort(_ input: [T]) -> [T]
    {
        items = input
        condor(start: 0, end: items.count - 1)
        return items
    }

    func condor(start: Int, end:Int) {
        var i = start
        var j = end
        if abs(j - i) < 1 { return }
        if j - i < 10 {
            inlineInsertionSort(low: i, high: j )
            return
        }

        //Select landmarks using any method you like and select as many sample as you like
        var landmarks:[T] = []
        landmarks.append(items[start + (end - start)/4])
        landmarks.append(items[start + (end - start)/2])
        landmarks.append(items[start + (end - start) * (3/4)])
        landmarks = insertionSort(landmarks, by: >)
        
        var q = start
        var k = end
        while q <= k {
            //Moving from the start of array inward
            if self.items[q] <= landmarks[0] {
                let val = items[i]
                items[i] = items[q]
                items[q] = val
                i += 1
                q += 1
            } else if items[q] >= landmarks[2] {
                let val = items[j]
                items[j] = items[q]
                items[q] = val
                j -= 1
                k = k > j ? j : k
            } else {
                q += 1
            }
            
            //Moving from end of array inwards
            if self.items[k] <= landmarks[0] {
                let val = items[i]
                items[i] = items[k]
                items[k] = val
                i += 1
                q = q < i ? i : q
            } else if items[k] >= landmarks[2] {
                let val = items[j]
                items[j] = items[k]
                items[k] = val
                j -= 1
                k -= 1
            } else {
                k -= 1
            }
        }

        //Repeat until done.
        if i <= j {
            condor(start: start, end: i - 1)
            condor(start: i, end: j)
            condor(start: j + 1, end: end)
        }
        
        return
    }
    
    func inlineInsertionSort(low:Int, high:Int) {
        if low < high {
            for i in (low + 1)...high {
                let key = items[i]
                var j = i - 1
                while j >= 0 {
                    if key < items[j] {
                        items[j + 1] = items[j]
                        j -= 1
                    } else {
                        break
                    }
                }
                items[j + 1] = key;
            }
        }
    }
    
    func insertionSort<T: Comparable>(_ input: [T], by comparison: (T, T) -> Bool) -> [T]
    {
        var items = input

        for index in 1..<items.count
        {
            let value = items[index]
            var position = index
     
            while position > 0 && comparison(items[position - 1], value) {
                items[position] = items[position - 1]
                position -= 1
            }
     
            items[position] = value
        }

        return items
    }
}


