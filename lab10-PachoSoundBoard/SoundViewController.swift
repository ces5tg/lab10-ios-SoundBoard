//
//  SoundViewController.swift
//  lab10-PachoSoundBoard
//
//  Created by cesar on 10/29/23.
//  Copyright © 2023 cesar. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

class SoundViewController: UIViewController {

    @IBOutlet weak var grabarButton: UIButton!
    @IBOutlet weak var grabarReproducir: UIButton!
    @IBOutlet weak var lblTiempo: UILabel!
    
    @IBOutlet weak var nombreTextField: UITextField!
    @IBOutlet weak var agregarButton: UIButton!
    @IBAction func grabarTapped(_ sender: Any) {
//        if isTimerRunning {
//            stopTimer()
//        } else {
//            startTimer()
//        }

        if grabarAudio!.isRecording{
            grabarAudio?.stop()
            grabarButton.setTitle("GRABAR", for: .normal)
            grabarReproducir.isEnabled  = true
            agregarButton.isEnabled = true
            
            print("\(startTime!) + aa \(tiempoTranscurrido)")
            stopTimer()
            
           
            
        } else {
            

            grabarAudio?.record()
            grabarButton.setTitle("Detener", for: .normal)
            grabarReproducir.isEnabled  = false
            startTimer()
        }
    }
    @IBAction func reproducirTapped(_ sender: Any) {
        do {
            //audio2.play()
            try reproducirAudio = AVAudioPlayer(contentsOf: audioURL!)
            reproducirAudio!.play()
            print("reproduciendo ... ")
        }catch {
            
        }
    }
    
    @IBAction func agregarTapped(_ sender: Any) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let grabacion = Grabacion(context:context)
        grabacion.nombre = nombreTextField.text
        grabacion.audio = NSData(contentsOf: audioURL!)! as Data
        grabacion.duracion = self.tiempoTranscurrido
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        navigationController!.popViewController(animated: true)
        
    }
    @IBAction func volumeSlider(_ sender: UISlider) {
        print(sender.value)
  
        reproducirAudio?.volume = sender.value
    }
    var grabarAudio: AVAudioRecorder?
    var reproducirAudio:AVAudioPlayer?
    var audio2 = AVAudioPlayer()
    var audioURL:URL?
    
     var startTime: Date?
       var timer: Timer?
    var tiempoTranscurrido : String = ""
var isTimerRunning = false
    override func viewDidLoad() {
        super.viewDidLoad()
        configurarGrabacion()
        grabarReproducir.isEnabled  = false
        agregarButton.isEnabled = false
        // Do any additional setup after loading the view.
        
        let audioPath = Bundle.main.path(forResource: "tono", ofType: "mp3")
        do{
            try audio2 = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath!))
        }catch{
            print("errores")
        }
    }
    func startTimer() {
        startTime = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            guard let startTime = self.startTime else { return }
            let currentTime = Date().timeIntervalSince(startTime)
            let minutes = Int(currentTime) / 60
            let seconds = Int(currentTime) % 60
            self.lblTiempo?.text = String(format: "%02d:%02d", minutes, seconds)
            self.tiempoTranscurrido = String(format: "%02d:%02d", minutes, seconds)
        }
        isTimerRunning = true
    }

    func stopTimer() {
        
            timer?.invalidate() // Detiene el temporizador
            timer = nil
            isTimerRunning = false
        

    }

    func configurarGrabacion(){
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSession.Category.playAndRecord , mode :AVAudioSession.Mode.default , options:[])
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)
            
            let basePath:String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let pathComponents = [basePath , "audio.m4a"]
            audioURL = NSURL.fileURL(withPathComponents: pathComponents)!
            
            print("*******+")
            print(audioURL!)
            print("*******+")
            
            var settings:[String:AnyObject] = [:]
            settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC) as AnyObject?
            settings[AVSampleRateKey] = 44100.0 as AnyObject?
            settings[AVNumberOfChannelsKey] = 2 as AnyObject?
            
//            var settings: [String: Any] = [
//                AVFormatIDKey: kAudioFormatMPEG4AAC,
//                AVSampleRateKey: 44100.0,
//                AVNumberOfChannelsKey: 2,
//                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
//            ]

            grabarAudio = try AVAudioRecorder(url:audioURL! , settings:settings)
            grabarAudio!.prepareToRecord()
            
            
        }catch let error as NSError{
            print(error)
        }
    }
    
    /*
    
     
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
