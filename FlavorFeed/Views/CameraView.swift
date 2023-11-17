//
//  ContentView.swift
//  DemoApp
//
//  Created by Rolando Rodriguez on 8/25/22.
//

import SwiftUI
import Combine
import Camera_SwiftUI
import AVFoundation

struct CameraView: View {
    @StateObject var model = CameraModel()
    @ObservedObject var vm: ViewModel
    
    @Binding var showCameraViewSheet: Bool
    
    @State var currentZoomFactor: CGFloat = 1.0
    
    
    var captureButton: some View {
        Button(action: {
            Task {
                model.capturePhoto()
            }
        }, label: {
            Circle()
                .foregroundColor(.ffSecondary)
                .frame(width: 75, height: 75, alignment: .center)
        })
    }
    
    var capturedPhotoThumbnail: some View {
        Group {
            if model.photo != nil {
                Image(uiImage: (model.photo!.image!))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .animation(.spring())
                
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 60, height: 60, alignment: .center)
                    .foregroundColor(.black)
            }
        }
    }
    
    var flipCameraButton: some View {
        Button(action: {
            model.flipCamera()
        }, label: {
            Image("flip_camera")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 35)
        })
    }
    
    var body: some View {
        if vm.bothImagesCaptured {
            PublishPostView(vm: vm, showCameraViewSheet: $showCameraViewSheet)
        } else {
            NavigationView {
                GeometryReader { geo in
                    ZStack {
                        Color.white.edgesIgnoringSafeArea(.all)
                        
                        VStack {
                            
                            ZStack {
                                VStack {
                                    CameraPreview(session: model.session)
                                        .gesture(
                                            DragGesture().onChanged({ (val) in
                                                //  Only accept vertical drag
                                                if abs(val.translation.height) > abs(val.translation.width) {
                                                    //  Get the percentage of vertical screen space covered by drag
                                                    let percentage: CGFloat = -(val.translation.height / geo.size.height)
                                                    //  Calculate new zoom factor
                                                    let calc = currentZoomFactor + percentage
                                                    //  Limit zoom factor to a maximum of 5x and a minimum of 1x
                                                    let zoomFactor: CGFloat = min(max(calc, 1), 5)
                                                    //  Store the newly calculated zoom factor
                                                    currentZoomFactor = zoomFactor
                                                    //  Sets the zoom factor to the capture device session
                                                    model.zoom(with: zoomFactor)
                                                }
                                            })
                                        )
                                        .onAppear {
                                            model.configure()
                                        }
                                        .alert(isPresented: $model.showAlertError, content: {
                                            Alert(title: Text(model.alertError.title), message: Text(model.alertError.message), dismissButton: .default(Text(model.alertError.primaryButtonTitle), action: {
                                                model.alertError.primaryAction?()
                                            }))
                                        })
                                        .frame(width: geo.size.width, height: geo.size.height * 0.75)
                                        .clipShape(RoundedRectangle(cornerRadius: 20))
                                        .animation(.easeInOut)
                                    
                                }
                                
                                VStack {
                                    ZStack(alignment: .center) {
                                        HStack {
                                            Button(action: {
                                                self.showCameraViewSheet = false
                                            }, label: {
                                                Image(systemName: "chevron.left")
                                                    .frame(width: 15.07, height: 8.64)
                                                    .foregroundColor(.ffPrimary)
                                            })
                                            Spacer()
                                        }
                                        Image("flavorfeed_logo")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(height: 18.32)
                                    }.padding()
                                    .frame(width: geo.size.width, height: geo.size.height * 0.15)
                                    .background(.white)

                                    
                                    Spacer()
                                    HStack {
                                        Button(action: {
                                            model.switchFlash()
                                        }, label: {
                                            Image(model.isFlashOn ? "flash_on" : "flash_off")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 35)
                                                .foregroundColor(.ffPrimary)
                                        })
                                        Spacer()
                                        
                                        captureButton
                                        
                                        Spacer()
                                        
                                        flipCameraButton
                                        
                                    }.padding(.horizontal, 20)
                                        .frame(width: geo.size.width, height: geo.size.height * 0.2)
                                        .background(Color.ffTertiary)
                                }
                            }
                        }
                    }
                }
            }.onChange(of: model.photo, perform: { value in
                // do something
                if let val = value {
                    
                    if vm.photo_1 == nil {
                        // if photo 1 is empty
                        vm.photo_1 = val.image!
                        model.flipCamera()
                    } else if vm.photo_2 == nil {
                        // if photo 2 is empty
                        vm.photo_2 = val.image!
                        vm.bothImagesCaptured = true
                    }
                }
            })
        }
    }
}
