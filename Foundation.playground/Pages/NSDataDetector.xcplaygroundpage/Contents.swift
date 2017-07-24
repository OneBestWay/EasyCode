//: [Previous](@previous)

/*:
  NSDateDetector 是NSRegularExpression的子类，用它能够检测dates,address,links, phoneNumber
 */
import Foundation

var str = "Hello, playground"

var testString: NSString = "你可以打我的电话，13671625756，访问www.baidu.com,下周来上海市浦东新区碧波路690号找我，时间是明天1：30"

let types: NSTextCheckingResult.CheckingType = [.address,.date,.phoneNumber,.link]
let dataDetector: NSDataDetector? = try? NSDataDetector(types: types.rawValue)

dataDetector?.enumerateMatches(in: testString as String, options: [], range: NSMakeRange(0,testString.length), using: { (match, flags, _) in
    
    let matchString = testString.substring(with: (match?.range)!)
    print("\(match?.resultType)\(matchString)")
    
})



//: [Next](@next)
