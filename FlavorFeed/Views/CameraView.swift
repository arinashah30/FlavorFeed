//
//  CameraView.swift
//  FlavorFeed
//
//  Created by Nicholas Candello on 10/7/23.
//

import SwiftUI
import AVFoundation
import UIKit

struct CameraView: View {
    @ObservedObject var camera = CameraModel()
    @Binding var showCamera: Bool
    

    var body: some View {
        ZStack {
            CameraPreview(camera: camera)
                .clipShape(RoundedRectangle(cornerRadius: 25.0))
                .frame(maxHeight: .infinity)
                .edgesIgnoringSafeArea([.leading, .trailing])
            
            VStack {
                if camera.isTaken {
                    HStack {
                        Spacer()
                        Button { camera.retake_picture() } label: {
                            Image(systemName: "xmark.circle")
                        }
                    }
                }
                Spacer()
                
                if camera.isTaken {
                    Button {
                        camera.savePic()
                        showCamera = false
                    } label: {
                        Text(camera.isSaved ? "Saved" : "Save")
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .fontWeight(.semibold)
                            .foregroundStyle(.black)
                            .background(.white)
                            .clipShape(Capsule())
                            .padding()
                    }
                    
                    Button {
                        camera.retake_picture()
                    } label: {
                        Text("Try Again")
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .fontWeight(.semibold)
                            .foregroundStyle(.black)
                            .background(.white)
                            .clipShape(Capsule())
                            .padding()
                    }
                } else {
                    Button { camera.take_picture() } label: {
                        Circle()
                            .stroke(.white, lineWidth: 2)
                            .frame(width: 75, height: 75)
                            .overlay(
                                Circle()
                                    .frame(width: 65, height: 65)
                                    .foregroundStyle(.white)
                            )
                    }
                    
                }
            }
        }.onAppear() {
            camera.check_camera_permissions()
        }
    }
}

class CameraModel: NSObject,ObservableObject, AVCapturePhotoCaptureDelegate {
    enum Action {
        case sendImage(UIImage)
    }

    @Published var isTaken = false
    @Published var session = AVCaptureSession()
    @Published var alert = false
    @Published var output = AVCapturePhotoOutput()
    @Published var preview: AVCaptureVideoPreviewLayer!
    @Published var isSaved = false
    @Published var picture_data = Data(count: 0)
    @Published var image: UIImage?

    var actionHandler: (Action) -> Void = { _ in }
    
    func check_camera_permissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setup_camera()
            return
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { status in
                if status {
                    self.setup_camera()
                }
            }
        case .denied:
            self.alert.toggle()
            return
        default:
            return
        }
    }
    
    func setup_camera() {
        // setting up camera...
        
        do {
            self.session.beginConfiguration()
            
            guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
                print("Could not create AVCaptureDevice!")
                return
            }
            
            let input = try AVCaptureDeviceInput(device: device)
            
            if self.session.canAddInput(input) {
                self.session.addInput(input)
            }
            
            if self.session.canAddOutput(self.output) {
                self.session.addOutput(self.output)
            }
            
            self.session.commitConfiguration()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func take_picture() {
        DispatchQueue.global(qos: .background).async {
            self.output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.session.stopRunning()
            }

            DispatchQueue.main.async {
                withAnimation{self.isTaken = true}
            }
        }
    }

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        if let error = error {
            print("Error: \(error)")
            return
        }
        
        print("pic taken...")
        
        guard let imageData = photo.fileDataRepresentation() else { return }
        
        self.picture_data = imageData
    }
    
    func savePic() {
        self.image = UIImage(data: self.picture_data)!
        if let image = self.image {
            print()
            actionHandler(.sendImage(image))
            self.isSaved = true
        }
    }
    
    func retake_picture() {
        self.isTaken = false

        DispatchQueue.global(qos: .background).async {
            self.session.startRunning()
            
            DispatchQueue.main.async {
                withAnimation {
                    self.isTaken = false
                }
            }
        }
    }
}

struct CameraPreview: UIViewRepresentable {
    @ObservedObject var camera: CameraModel
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        
        DispatchQueue.global(qos: .userInitiated).async {
            camera.session.startRunning()
        }
        
        camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
        camera.preview.frame = view.frame
        
        camera.preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(camera.preview)
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) { }
}
