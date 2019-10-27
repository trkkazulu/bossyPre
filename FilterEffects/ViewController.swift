//
//  ViewController.swift
//  FilterEffectsMoogy
//
/*
 
 It appears that the problem has something to do with the distortion code. So i've fixed it by rewriting the dist. This works now. Test this in the amp to see what tweaks need to be made so that it sounds good.
 
 
 */


import AudioKit
import AudioKitUI
import UIKit

class ViewController: UIViewController {
    
    var delay: AKVariableDelay!
    var delayMixer: AKDryWetMixer!
    var reverb: AKCostelloReverb!
    var reverbMixer: AKDryWetMixer!
    var booster: AKBooster!
    var dist: AKDistortion!
    var distMixer: AKDryWetMixer!
    var filter: AKMoogLadder!
    var filterMixer: AKDryWetMixer!
    var input = AKMicrophone()
    var player: AKPlayer!
    var startButton = AKButton()
    var wha: AKAutoWah!
    var whaMixer: AKDryWetMixer!
    var loOct: AKPitchShifter!
    var loOctMixer: AKDryWetMixer!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: Create the player for testing
        
//        if let file = try? AKAudioFile(readFileName: "bassClipCR.wav") {
//
//            player = AKPlayer(audioFile: file)
//            player.completionHandler = { Swift.print("completion callback has been triggered!")
//
//            }
//
//            player.isLooping = true
//
//        }
        
    
        
        
        //MARK: PROCESSES
        
        filter = AKMoogLadder(input, cutoffFrequency: 630.0, resonance: 0.5)
//        filterMixer = AKDryWetMixer(filter, filter)
//        filterMixer.balance = 0.5

        wha = AKAutoWah(filter, wah: 1.0, mix: 0.5, amplitude: 10.0)
        whaMixer = AKDryWetMixer(filter, wha)
        whaMixer.balance = 0.5
        
//        dist = AKDistortion(whaMixer)
//        dist.linearTerm = 1.0
//        dist.squaredTerm = 0.0
//        dist.cubicTerm = 0.0
//        dist.softClipGain = 3.0
        
        loOct = AKPitchShifter(whaMixer, shift: -12.0, windowSize: 1024, crossfade: 512)
        
        loOctMixer = AKDryWetMixer(whaMixer,loOct)
        loOctMixer.balance = 0.0
        
//        distMixer = AKDryWetMixer(whaMixer, dist)
//
//        distMixer.balance = 0.5
        
        booster = AKBooster(loOctMixer)
        
        
        booster.gain = 0.0
        
        AudioKit.output = booster
        
          do {
                 try AudioKit.start()
            
             } catch {
                
                 AKLog("AudioKit did not start!")
             }
        
        //MARK: AB section
        
        Audiobus.start()
        
        //MARK: GUI section calls GUI code
        
        setupUI()
    }
    
    
    //MARK: UI SETUP
    
    func setupUI() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        
        stackView.addArrangedSubview(AKSlider(
            property: "Filter Frequency",
            value: self.filter.cutoffFrequency,
            range: 0 ... 630,
            format: "%0.2f hz") { sliderValue in
                self.filter.cutoffFrequency = sliderValue
        })

        stackView.addArrangedSubview(AKSlider(
            property: "Filter Resonance",
            value: self.filter.resonance,
            range: 0 ... 0.99,
            format: "%0.2f") { sliderValue in
                self.filter.resonance = sliderValue
        })

        stackView.addArrangedSubview(AKSlider(
            property: "Wha Mix",
            value: self.whaMixer.balance,
            range: 0 ... 1.0,
            format: "%0.2f") { sliderValue in
                self.whaMixer.balance = sliderValue
        })
        
//        stackView.addArrangedSubview(AKSlider(
//            property: "Distortion",
//            value: self.dist.linearTerm,
//            range: 0 ... 1,
//            format: "%0.2f") { sliderValue in
//                self.dist.linearTerm = sliderValue
//        })
//
        stackView.addArrangedSubview(AKSlider(
            property: "Lo Octav Mix",
            value: self.loOctMixer.balance,
            range: 0 ... 0.99,
            format: "%0.2f") { sliderValue in
                self.loOctMixer.balance = sliderValue
        })
        
        stackView.addArrangedSubview(AKSlider(
            property: "Output Volume",
            value: self.booster.gain,
            range: 0 ... 1,
            format: "%0.2f") { sliderValue in
                self.booster.gain = sliderValue
        })
        
        stackView.addArrangedSubview(AKButton(title: "Player Start"){ (startButton) in
            self.player.play()
            
            if startButton.color != .green {
                startButton.color = .green
                startButton.textColor = .black
            }
        })
    
              stackView.addArrangedSubview(AKButton(title: "Player Stop")
              {(button) in
                  self.player.stop()
              })
        
        //MARK: Add Views
        
        view.addSubview(stackView)
        
        stackView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.9).isActive = true
        stackView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.9).isActive = true
        
        stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
}




