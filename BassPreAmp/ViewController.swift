//
//  ViewController.swift
//  BossyPre
//
//  Created by Jair-Rohm Wells on 9/27/19.
//  Copyright © 2019 Jair-Rohm Wells. All rights reserved.

// Add Audiobus code


import UIKit
import AudioKit
import AudioKitUI


class ViewController: UIViewController {
    
    @IBOutlet weak var outputVolume: UISlider!
    @IBOutlet weak var delayMixSlider: UISlider!
    @IBOutlet weak var delaySlider: UISlider!
    @IBOutlet weak var resSlider: UISlider!
    @IBOutlet weak var cfSlider: UISlider!
    
    var input = AKMicrophone()
    var loFilter: AKMoogLadder?
    var distMixer: AKDryWetMixer?
    var callousness: AKDistortion?
    var filterBand2: AKEqualizerFilter?
    var filterBand3: AKEqualizerFilter?
    var filterBand7: AKEqualizerFilter?
    var filterBand4: AKEqualizerFilter?
    var filterBand6: AKEqualizerFilter?
    var filterBand5: AKEqualizerFilter?
    var booster: AKBooster?
    var silence: AKBooster?
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
                
        
        //    //MARK: - Eq settings
        //    /***************************************************************/
        //
        
        filterBand2 = AKEqualizerFilter(input, centerFrequency: 35, bandwidth: 44.7, gain: 0.0)
        filterBand3 = AKEqualizerFilter(filterBand2, centerFrequency: 65, bandwidth: 70.8, gain: 0.0)
        filterBand4 = AKEqualizerFilter(filterBand3, centerFrequency: 125, bandwidth: 141.0, gain: 0.825)
        filterBand5 = AKEqualizerFilter(filterBand4, centerFrequency: 250, bandwidth: 32.0, gain: 0.225)
        filterBand6 = AKEqualizerFilter(filterBand5, centerFrequency: 550, bandwidth: 50.0, gain: 0.0)
        filterBand7 = AKEqualizerFilter(filterBand6, centerFrequency: 10_200, bandwidth: 82.0, gain: 0.0)
        
        //    //MARK: - Dist settings
        //    /***************************************************************/
        //
        
        let grunt = AKTanhDistortion(input, pregain: 13.0, postgain: 1.822, positiveShapeParameter: 0.75, negativeShapeParameter: 0.60)
        
        let gruntSmooth = AKKorgLowPassFilter(grunt, cutoffFrequency: 660, resonance: 0.5, saturation: 3.0)
        
        let gruntPress = AKCompressor(gruntSmooth, threshold: 25.0, headRoom: 1.0, attackDuration: 0.20, releaseDuration: 0.5, masterGain: 4.0)
        
        let filterPress = AKCompressor(filterBand7, threshold: 25, headRoom: 1.0, attackDuration: 0.10, releaseDuration: 0.5, masterGain: 3.5)
        
        
        distMixer = AKDryWetMixer(filterPress, gruntPress, balance: 0.0)
        
        //    //MARK: - Output
        //    /***************************************************************/
        //
        
        booster = AKBooster(distMixer)
        
        booster?.gain = 0.0
        
        AudioKit.output = booster
        
        try! AudioKit.start()
    }
    
    
    
    //    //MARK: - Button and slider methods
    //    /***************************************************************/
    //
    
    @IBAction func cfSliderMoved(_ sender: UISlider) {
        
        var loCutOffVal = filterBand2?.gain = Double(sender.value)
        print("loCutoffVal \(sender.value)")
    }
    
    @IBAction func resSliderMoved(_ sender: UISlider) {
        
        let loResVal = filterBand3?.gain = Double(sender.value)
        filterBand4?.gain = Double(sender.value / 2)
        filterBand5?.gain = Double(sender.value / 8)
        print(sender.value)
    }
    
    @IBAction func outputVolChanged(_ sender: UISlider) {
        let boosterVal =  booster!.gain = Double(sender.value)
        print("Output \(sender.value)")
    }
    
    
    @IBAction func callousSliderMoved(_ sender: UISlider) {
        let distVal = distMixer!.balance = Double(sender.value / 8)
        print("Callous \(sender.value)")
    }
    
    
    
    @IBAction func edgeSliderMoved(_ sender: UISlider) {
        var edgeVal = filterBand7?.gain = Double(sender.value * 4)
        filterBand6!.gain = Double(sender.value / 2)
        print("Edge value \(edgeVal)")
    }
}
