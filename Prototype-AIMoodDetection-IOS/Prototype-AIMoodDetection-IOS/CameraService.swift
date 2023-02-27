//
//  CameraService.swift
//  Prototype-AIMoodDetection-IOS
//
//  Created by Reno Muijsenberg on 27/02/2023.
//

import Foundation
import AVFoundation

// Define a class named `CameraService` that provides methods for capturing photos using the device's camera
class CameraService {
    // Declare a property named `session` that is of type `AVCaptureSession` and is optional
    var session: AVCaptureSession?
    // Declare a property named `delegate` that is of type `AVCapturePhotoCaptureDelegate` and is optional
    var delegate: AVCapturePhotoCaptureDelegate?
    
    // Declare a constant named `output` that is of type `AVCapturePhotoOutput`
    let output = AVCapturePhotoOutput()
    // Declare a constant named `previewLayer` that is of type `AVCaptureVideoPreviewLayer`
    let previewLayer = AVCaptureVideoPreviewLayer()
    
    // Define a method named `start` that accepts a `delegate` parameter of type `AVCapturePhotoCaptureDelegate` and a `completion` parameter of type `(Error) -> ()`, and returns void
    func start(delegate: AVCapturePhotoCaptureDelegate, completion: @escaping (Error) -> ()) {
        // Set the value of the `delegate` property to the value of the `delegate` parameter
        self.delegate = delegate
        checkCameraPermission(completion: completion)
    }
    
    // Define a private method named `checkCameraPermission` that accepts a `completion` parameter of type `(Error) -> ()`, and returns void
    private func checkCameraPermission(completion: @escaping (Error) -> ()) {
        // Use a switch statement to check the authorization status for camera access
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            
        // If the authorization status is `notDetermined`, request access to the camera
        case .notDetermined:
            AVCaptureDevice.requestAccess(for:  .video) {
                [weak self] granted in guard granted else { return }
                // If access is granted, call the `setupCamera` method on the main thread
                DispatchQueue.main.async {
                    self?.setupCamera(completion: completion)
                }
            }
        // If the authorization status is `restricted`, do nothing
        case .restricted:
            break
        // If the authorization status is `denied`, do nothing
        case .denied:
            break
        // If the authorization status is `authorized`, call the `setupCamera` method
        case .authorized:
            setupCamera(completion: completion)
        // If the authorization status is unknown, do nothing
        @unknown default:
            break
        }
    }
    
    // Define a private method named `setupCamera` that accepts a `completion` parameter of type `(Error) -> ()`, and returns void
    private func setupCamera(completion: @escaping (Error) -> ()) {
        // Create a new `AVCaptureSession`
        let session = AVCaptureSession()
        
        // Get the front camera
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .front)
        if let device = discoverySession.devices.first {
            do {
                // Create an `AVCaptureDeviceInput` object from the front camera
                let input = try AVCaptureDeviceInput(device: device)
                // If the session can add the input, add it to the session
                if session.canAddInput(input) {
                    session.addInput(input)
                }
                
                // If the session can add the output, add it to the session
                if session.canAddOutput(output) {
                    session.addOutput(output)
                }
                // Set the video gravity of the preview layer to `resizeAspectFill`
                previewLayer.videoGravity = .resizeAspectFill
                //Set the session of the preview layer to 'session'
                previewLayer.session = session
                //Start running session
                DispatchQueue.global(qos: .userInitiated).async {
                    session.startRunning()
                }
                self.session = session
            } catch {
                completion(error)
            }
        }
    }
    
    // This function captures a photo using the device's camera with the specified settings.
    func capturePicture(with settings: AVCapturePhotoSettings = AVCapturePhotoSettings()) {
        // The delegate parameter is an instance of AVCapturePhotoCaptureDelegate that handles the completion of the photo capture process.
        output.capturePhoto(with: settings, delegate: delegate!)
    }
}
