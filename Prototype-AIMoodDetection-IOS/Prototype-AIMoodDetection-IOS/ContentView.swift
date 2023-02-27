//
//  ContentView.swift
//  Prototype-AIMoodDetection-IOS
//
//  Created by Reno Muijsenberg on 23/02/2023.
//

import SwiftUI

struct ContentView: View {
    
    @State private var capturedImage: UIImage? = nil
    @State private var isCustomCameraViewPresentent = false
     
    
    
    var body: some View {
        ZStack {
            if (capturedImage != nil) {
                Image(uiImage: capturedImage!).resizable().scaledToFill().ignoresSafeArea()
            } else {
                Color(UIColor.systemBackground)
            }
            
            VStack {
                Spacer()
                Button(
                    action: {
                        isCustomCameraViewPresentent.toggle()
                    },
                    label: {
                        Image(systemName: "camera.fill").font(.largeTitle).padding().background(.black).foregroundColor(.white).clipShape(Circle())
                    }
                ).padding(.bottom)
                .fullScreenCover(isPresented: $isCustomCameraViewPresentent, content: {
                    CustomCameraView(capturedImage: $capturedImage).ignoresSafeArea()
                    Button("Back to Main") {
                        isCustomCameraViewPresentent = false

                    }
                })
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
