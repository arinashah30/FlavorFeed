//
//  CameraView.swift
//  FlavorFeed
//
//  Created by Nicholas Candello on 10/7/23.
//

import SwiftUI
import AVFoundation

struct CameraView: View {
    @ObservedObject var camera: CameraModel
    var body: some View {
        ZStack {
            //camera will go here
            CameraPreview(camera: camera)
                .edgesIgnoringSafeArea(.all)
            
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
                    Button { if !camera.isSaved { camera.savePic()} } label: {
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
                        camera.isTaken = false
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
    @Published var isTaken = false
    
    @Published var session = AVCaptureSession()
    
    @Published var alert = false
    
    @Published var output = AVCapturePhotoOutput()
    
    @Published var preview: AVCaptureVideoPreviewLayer!
    
    @Published var isSaved = false
    @Published var picture_data = Data(count: 0)
    
    func check_camera_permissions() {
        //first check camera has permission
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            // Setting Up Session
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
            //setting configs
            self.session.beginConfiguration()
            
            guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
                print("Could not create AVCaptureDevice!")
                return
            }
            
            let input = try AVCaptureDeviceInput(device: device)
            
            // checking and adding to session
            if self.session.canAddInput(input) {
                self.session.addInput(input)
            }
            
            //same for output
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
        let image = UIImage(data: self.picture_data)!
        
        //saving image...
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        
        self.isSaved = true
    }
    
    func retake_picture() {
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
    
    @ObservedObject var camera : CameraModel
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        
        camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
        camera.preview.frame = view.frame
        
        // your own properties
        camera.preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(camera.preview)
        
        DispatchQueue.global(qos: .background).async {
            camera.session.startRunning()
        }
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) { }
}

#Preview {
    CameraView(camera: CameraModel())
}
