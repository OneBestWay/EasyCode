//
//  ViewController.swift
//  SpeechDemo
//
//  Created by GK on 2017/7/11.
//  Copyright © 2017年 GK. All rights reserved.
//

import UIKit
import Speech
import AVFoundation

class ViewController: UIViewController{
   
    
    enum RecordStatus {
        case recorded
        case recording
    }
 
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var statusLabel: UILabel!
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.current)!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?  // 3
    private var recognitionTask: SFSpeechRecognitionTask?  // 4
    
    private let audioEngine = AVAudioEngine() // 5
    
    private var recordingStartTime: Date?
    private var recordingEndTime: Date?
    
    let taggerOptions: NSLinguisticTagger.Options = [.joinNames,.omitWhitespace]
    
    lazy var linguisticTagger: NSLinguisticTagger = {
        let tagSchemes = NSLinguisticTagger.availableTagSchemes(forLanguage: "en")
        
        return NSLinguisticTagger(tagSchemes: tagSchemes, options: Int(self.taggerOptions.rawValue))
    }()
    
    private var speechText = "" {
        didSet {
            if (speechText.characters.count > 0) {
                textView.text = speechText
            }
        }
    }
    private var status: RecordStatus = .recorded {
        didSet {
            switch status {
            case .recorded:
                recordingStartTime = Date.init(timeIntervalSinceNow: 0)
                statusLabel.text = "长按说话"
                break
            case .recording:
                statusLabel.text = "松开完成"
                break
            }
        }
    }
   
    
    let synth = AVSpeechSynthesizer()
    var myUtterance = AVSpeechUtterance(string: "小名正在骑小明单车")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        recordButton.addTarget(self, action: #selector(recordButtonTouchDown), for: UIControlEvents.touchDown)
        recordButton.addTarget(self, action: #selector(recordButtonRelease), for: [UIControlEvents.touchUpInside,UIControlEvents.touchUpOutside])
        recordButton.isEnabled = false
        textView.text = ""
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        speechRecognizer.delegate = self
        
        // 1 请求权限
        SFSpeechRecognizer.requestAuthorization { (authorizationStatus) in
            switch authorizationStatus {
            case .authorized:
                self.recordButton.isEnabled = true
            case .denied:
                self.recordButton.isEnabled = false
                print("User denied access to speech recogniztion")
            case .restricted:
                self.recordButton.isEnabled = false
                print("Speech recognition restricted on this device")
            case .notDetermined:
                self.recordButton.isEnabled = false
                print("Speech recognition not yet authorized")
            }
        }
    }
    
    private func startRecording()  throws {
      
        //取消当前正在运行的任务
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let inputNode = audioEngine.inputNode else {
            fatalError("Audio engine has no input node")
        }
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("SFSpeechAudioBufferRecognitionRequest 对象创建失败")
        }
        
        recognitionRequest.shouldReportPartialResults = true  //是否实时显示结果
        
        // 6  每次recognition engine 接收到输入之后，会调用resultHandler方法，返回一个最终的复本
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest, resultHandler: { [weak self] (result, error) in
            
            var isFinal = false
            
            if let result = result {
                self?.speechText = result.bestTranscription.formattedString
                isFinal = result.isFinal
            }
            
            if error != nil || isFinal {
                
                //self?.recordButtonRelease()
                self?.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
    
                self?.recognitionRequest = nil
                self?.recognitionTask = nil
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when:AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine start error")
        }
    }
    
    @IBAction func recordButtonClicked(_ sender: UIButton) {
        recordButtonTouchDown()
    }
    
    
    func recordButtonTouchDown() {
    
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
        }
        
        do {
            try startRecording()
        } catch {
            print("startRecording error")
            status = .recorded
        }
        
        status = .recording
    }
    
    @IBAction func textToSpeech(_ sender: UIButton) {
        myUtterance.rate = 0.3
        synth.speak(myUtterance)
    }
    func recordButtonRelease() {
        status = .recorded;
        audioEngine.stop()
        recognitionRequest?.endAudio()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
           self.separateTextToWords(text: self.speechText)
        }
        
    }
    func separateTextToWords(text: String) {
        let range = NSRange(location: 0, length: (text as NSString).length)
        self.linguisticTagger.string = text
        self.linguisticTagger.enumerateTags(in: range, scheme: NSLinguisticTagSchemeNameTypeOrLexicalClass, options: self.taggerOptions, using: { (tag, tokenRange, stop, _) in
            let token = (text as NSString).substring(with: tokenRange)
            print("\(tag): \(token)")
        })
    }
}
extension ViewController: SFSpeechRecognizerDelegate {
    
    //当创建了一个recognitiontask之后检查speech recognization是否可用，当speech recognization 的可用性改变时会调用该方法
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        
        if available {
            recordButton.isEnabled = true
        }else {
            recordButton.isEnabled = false
            print("Recognition not available")
        }
    }
}
//  2 infoList中设置请求权限的文字 
//  NSMicrophoneUsageDescription  请求audio麦克风的授权
//  NSSpeechRecognitionUsageDescription 请求语音识别的授权

//  3 recognition request ,provide audio input to the speech recognizer

//  4 recognition task给出请求结果，用这个对象，可以取消或停止语音识别的请求

//  5 提供给你audio input



