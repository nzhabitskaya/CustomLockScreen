//
//  BluredScreen.swift
//  CustomPinScreen
//
//  Created by Natalia on 11/15/24.
//

import SwiftUI

struct BluredScreen: View {
    
    let screenSize = UIScreen.main.bounds

    @State private var rectPosition = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)//CGPoint(x: 150, y: 150)
    
    @State private var cutout: UIImage?

    let image: UIImage

    var body: some View {
        
        ZStack {
            Image(uiImage: cutout ?? image)
            Image(uiImage: cutout ?? image)
                .frame(width: screenSize.width, height: screenSize.height)
                .blur(radius: 5)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .onAppear(perform: {
                    processImage()
                })
                .position(rectPosition)
            
            Rectangle()
                .fill(.black)
                .frame(width: screenSize.width, height:screenSize.height)
                .opacity(0.5)
        }
    }
    
    func processImage() {
        cutout = croppedImage(from: image, croppedTo: CGRect(x: rectPosition.x, y: rectPosition.y, width: screenSize.width, height: screenSize.height))
    }
}

func croppedImage(from image: UIImage, croppedTo rect: CGRect) -> UIImage {
    
    UIGraphicsBeginImageContext(rect.size)
    let context = UIGraphicsGetCurrentContext()
    
    let drawRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
    
    context?.clip(to: CGRect(x: 0, y: 0, width: rect.size.width, height: rect.size.height))
    
    image.draw(in: drawRect)
    
    let subImage = UIGraphicsGetImageFromCurrentImageContext()
    
    UIGraphicsEndImageContext()
    return subImage!
}
