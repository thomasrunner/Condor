//
//    CondorDemoViewController.swift
//    CondorSwift
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

import UIKit
import Condor
import CondorS

class CondorDemoViewController: UIViewController {
    
    @IBOutlet var arraySizeLabel: UILabel!
    @IBOutlet var arraySizeTextField: UITextField!
    @IBOutlet var condorPerformanceLabel: UILabel!
    @IBOutlet var swiftPerformanceLabel: UILabel!
    
    var array:[MyDataModel] = []
    
    var arraySize : Int = 0
    
    
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
    
    func buildTestArray()
    {
        //Get Array Size no Validation in Demo
        arraySize = Int(arraySizeTextField.text!)!
        var skipper = 0
        for i in 0..<arraySize
        {
            var number : MyDataModel
            switch (skipper)
            {
                case 0:
                    number = MyDataModel.init(condor: Int(arc4random_uniform(7276800)), condorf: Float(Float(i)/1000.0));
                    break;
                case 1:
                    number = MyDataModel.init(condor: -Int(arc4random_uniform(7276800)), condorf: Float(Float(arc4random_uniform(3276800 * 2)) * Float(Double.pi)));
                    break;
                
                case 2:
                    number = MyDataModel.init(condor: Int(arc4random_uniform(256)), condorf: -Float(Float(arc4random_uniform(3276800 * 2)) * Float(Double.pi)));
                    break;
                
                default:
                    number = MyDataModel.init(condor: Int(arc4random_uniform(7276800)), condorf: Float(Float(i)/1000.0));
            }
        
            skipper += 1;
            if skipper == 3 { skipper = 0 };
        
            //ONLY ONE Thank you Oleg :)
            array.append(number)
        }
    }
    
    @IBAction func condorSortButton(_ sender: Any){
        
//        let condorSort = CondorSObjectSort<MyDataModel>()
        let condorSort = CondorObjectSortInt()
//        let condorSortFloat = CondorObjectSortFloat()
        array = []
        buildTestArray()
        
        let d1 = NSDate()
        //THIS IS AN OBJECTIVE C VERSION A NATIVE SWIFT VERSION IS ABOUT 40-60% FASTER
        let selectorString : String = "anyPropertyInt"
//
        let output = condorSort.sortSignedIntObjectArray(array, orderDesc: false, selectorNameAs: selectorString) as! [MyDataModel]
//        let output = condorSort.sort(array:array, descending: false, property: { Int32($0.condorId) })
//        let output = condorSort.sort(array: array, descending: false, property: { Int32($0.condorId) })
        
        print("Performance ",d1.timeIntervalSinceNow * -1000)
        condorPerformanceLabel.text = String(format:"%0.2f" ,d1.timeIntervalSinceNow * -1000) + "ms"
        
//        var passed : Bool = true
//        var countErrors : Int = 0
//        for i in 1..<array.count
//        {
//            if(output[i].condorId < output[i-1].condorId)
//            {
//                countErrors += 1
//                passed = false;
//                print("\(output[i].condorId) \(i) ")
//                //break;
//            }
//        }
        
//        print(countErrors)
//        if passed == true { print("In Order") }
        
    }
    
    @IBAction func swiftSortButton(_ sender: Any) {
        
        array = []
        buildTestArray()
        
        let d1 = NSDate()
        _ = array.sorted(by: { $0.anyPropertyFloat < $1.anyPropertyFloat })
//        _ = array.sort(by: { $0.condorId < $1.condorId })
        print("Performance ",d1.timeIntervalSinceNow * -1000)
        swiftPerformanceLabel.text = String(format:"%0.2f" ,d1.timeIntervalSinceNow * -1000) + "ms"
    }
}
