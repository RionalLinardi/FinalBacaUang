//
//  ViewController.swift
//  Final Baca Uang
//
//  Created by Rional Linardi on 04/10/19.
//  Copyright © 2019 Rional Linardi. All rights reserved.
//

import UIKit
import AVKit
import Vision

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Mulai Kameranya disini
          let captureSession = AVCaptureSession()
          captureSession.sessionPreset = .photo // Fungsi baca gambar, last part from camera
          
          guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
         guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }

         
          captureSession.addInput(input)
          captureSession.startRunning()
          
          let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
          view.layer.addSublayer(previewLayer)
          previewLayer.frame = view.frame
        
          let dataOutput = AVCaptureVideoDataOutput()
          dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue (label: "videoQueue"))
          captureSession.addOutput(dataOutput)
        
    }
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
         // print( "camera bisa dan siap ", Date())
          
          guard  let pixelBuffer: CVPixelBuffer =  CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
          
          guard let model = try? VNCoreMLModel(for: ImageClassifier().model) else { return }
          let request = VNCoreMLRequest(model: model) { (finishedReq, err) in
              //check err
              //       print(finishedReq.results)
              
              guard let results = finishedReq.results as? [VNClassificationObservation] else { return }
              guard let firstObservation = results.first else { return }
              
              print(firstObservation.identifier, firstObservation.confidence)
      }
      
      
        
          
         try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
      }


}

