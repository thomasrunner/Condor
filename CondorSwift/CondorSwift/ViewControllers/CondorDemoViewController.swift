//
//  CondorDemoViewController.swift
//  CondorSwift
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

import UIKit
import Condor

class CondorDemoViewController: UIViewController {
    
    @IBOutlet var arraySizeLabel: UILabel!
    @IBOutlet var arraySizeTextField: UITextField!
    @IBOutlet var condorPerformanceLabel: UILabel!
    @IBOutlet var swiftPerformanceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func releaseKeyboard(_ sender: Any) {
        arraySizeTextField.resignFirstResponder()
    }
    
    @IBAction func condorSortButton(_ sender: Any){
        
        let condorSort = CondorObjectSort()
        let n = Int(arraySizeTextField.text!)
        
        var array:[MyDataModel] = []
        var output:[MyDataModel] = []
        var i = 0
        
        while (i < n! ) {
            let myData = MyDataModel()
            myData.condorId = Int32(arc4random_uniform(10))
            array.append(myData)
            i = i + 1
        }
        i = 0
//        while (i < 100 ) {
//            print(array[i].condorId)
//            i = i + 1
//        }
//        print("sorted")
        
        let d1 = NSDate()
        
        output =  condorSort.sortSignedIntObjectArray(array, orderDesc: false) as! [MyDataModel]

        print("Performance ",d1.timeIntervalSinceNow * -1000)
        i = 0
//        while (i < 100 ) {
//            print(output[i].condorId)
//            i = i + 1
//        }
        
        condorPerformanceLabel.text = String(format:"%0.2f" ,d1.timeIntervalSinceNow * -1000) + "ms"
    }
    
    @IBAction func swiftSortButton(_ sender: Any) {
        
        let n = Int(arraySizeTextField.text!)

        var array:[MyDataModel] = []
        var i = 0
        while (i < n! ) {
            let myData = MyDataModel()
            myData.condorId = Int32(arc4random_uniform(1000000))
            array.append(myData)
            i = i + 1
        }
        
        let d1 = NSDate()
        _ = array.sorted(by: { $0.condorId < $1.condorId })
        print("Performance ",d1.timeIntervalSinceNow * -1000)
        swiftPerformanceLabel.text = String(format:"%0.2f" ,d1.timeIntervalSinceNow * -1000) + "ms"
    }
}
