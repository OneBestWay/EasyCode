//: [Previous](@previous)

import Foundation

let testString: NSString = "我是一个人"
let taggerOptions: NSLinguisticTagger.Options = [.joinNames,.omitWhitespace]

let tagSchemes = NSLinguisticTagger.availableTagSchemes(forLanguage: "en")
var linguisticTagger: NSLinguisticTagger = NSLinguisticTagger(tagSchemes: tagSchemes, options: Int(taggerOptions.rawValue))


let range = NSRange(location: 0, length: testString.length)
linguisticTagger.string = testString as String

linguisticTagger.enumerateTags(in: range, scheme: NSLinguisticTagSchemeNameTypeOrLexicalClass, options: taggerOptions, using: { (tag, tokenRange, stop, _) in
    let token = (testString as NSString).substring(with: tokenRange)
    print("\(tag): \(token)")
})

//: [Next](@next)
