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
    @State var flash = false
    

    var body: some View {
        VStack(spacing: 0) {
            CameraPreview(camera: camera)
                .clipShape(RoundedRectangle(cornerRadius: 15.0))
                .frame(maxHeight: .infinity)
                .padding(.bottom, 0)
                .background(LinearGradient(gradient: Gradient(colors: [Color.white, Color.ffTertiary]), startPoint: .top, endPoint: .bottom))
                .edgesIgnoringSafeArea([.leading, .trailing, .bottom])
            
            VStack {
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
                    Button { camera.take_picture(flashIsEnabled: flash) } label: {
                        Circle()
                            .fill(Color.ffSecondary)
                            .frame(width: 75, height: 75)
                    }
                    
                    Button { flash.toggle() } label: {
                        flash ?
                        Image(systemName: "flashlight.on.circle.fill").resizable().foregroundStyle(Color.ffPrimary).frame(width: 35, height: 35)
                        : Image(systemName: "flashlight.slash.circle.fill").resizable().foregroundStyle(Color.ffPrimary).frame(width: 35, height: 35)
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.ffTertiary)
        }
        .onAppear() {
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
    
    func take_picture(flashIsEnabled: Bool) {
        DispatchQueue.global(qos: .background).async {
            var settings = AVCapturePhotoSettings()
            settings.flashMode = flashIsEnabled ? AVCaptureDevice.FlashMode.on : AVCaptureDevice.FlashMode.off
            
            self.output.capturePhoto(with: settings, delegate: self)
            
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
