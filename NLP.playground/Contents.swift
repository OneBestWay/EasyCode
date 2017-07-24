//: Playground - noun: a place where people can play

import UIKit

let tagger = NSLinguisticTagger(tagSchemes: [.language,.tokenType,.lemma,.nameType,.lexicalClass], options: 0)
let options: NSLinguisticTagger.Options = [.omitPunctuation,.omitWhitespace,]
var text = "Please click the ❤ button to get this article seen by more people."
tagger.string = text
if let language = tagger.dominantLanguage {
    print(language)
} else {
    print("can't get domainant language")
}

var range = NSRange(location: 0, length: text.utf16.count)
tagger.enumerateTags(in: range, unit: .word, scheme: .tokenType, options: options) { (tag, tokenRange, stop) in
    let token = (text as NSString).substring(with: tokenRange)
    print("\(tag!.rawValue): \(token)")
    
}
tagger.enumerateTags(in: range, unit: .word, scheme: .lemma, options: options) { (tag, tokenRange, stop) in
    if let lemma = tag?.rawValue {
        print(lemma)
    }
}

let tags: [NSLinguisticTag] = [.personalName,.placeName,.organizationName]
text = "Silicon Valley is a nickname for the southern portion of the San Francisco Bay Area, in the northern part of the U.S. state of California. In 2014, tech companies Google, Yahoo!, Facebook, Apple, and others, released corporate transparency reports that offered detailed employee breakdowns. - Wikipedia   张江微电子港"

tagger.string = text

range = NSRange(location: 0, length: text.utf16.count)

tagger.enumerateTags(in: range, unit: .word, scheme: .nameType, options: options) { (tag, tokenRange, stop) in
    
    if let tag = tag, tags.contains(tag) {
        let name = (text as NSString).substring(with: tokenRange)
        print("\(name)")
    }
}

text = "Please click the ❤ button to get this article seen by more people."
tagger.string = text

range = NSRange(location: 0, length: text.utf16.count)
tagger.enumerateTags(in: range, unit: .word, scheme: .lexicalClass, options: options) { tag, tokenRange, stop in
    let word = (text as NSString).substring(with: tokenRange)
    print("\(tag!.rawValue):\(word)")
}
