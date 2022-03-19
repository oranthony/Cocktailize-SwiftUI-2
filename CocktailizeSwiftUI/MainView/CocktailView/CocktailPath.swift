//
//  CocktailPath.swift
//  CocktailizeSwiftUI
//
//  Created by anthony loroscio on 19/04/2020.
//  Copyright © 2020 anthony loroscio. All rights reserved.
//

import SwiftUI

struct CocktailPath: View {
    var center = 300.0
    @State var show = false
    
    var body: some View {
        ZStack{
            Path { path in
                path.move(to: CGPoint(x: 0, y: 80))
                path.addLine(to: CGPoint(x: 50, y: 80))
                path.addLine(to: CGPoint(x: 70, y: 0))
                path.addLine(to: CGPoint(x: 85, y: 0))
                path.addLine(to: CGPoint(x: 65, y: 80))
                path.addLine(to: CGPoint(x: 105, y: 80))
                path.addLine(to: CGPoint(x: 105, y: 370))
                path.addLine(to: CGPoint(x: 0, y: 370))
                path.closeSubpath()
            }
            .foregroundColor(.gray)
            .frame(width: 100)
            .cornerRadius(10)
            
            Path { path in
                path.move(to: CGPoint(x: 0, y: 80))
                path.addLine(to: CGPoint(x: 50, y: 80))
                path.addLine(to: CGPoint(x: 70, y: 0))
                path.addLine(to: CGPoint(x: 85, y: 0))
                path.addLine(to: CGPoint(x: 65, y: 80))
                path.addLine(to: CGPoint(x: 105, y: 80))
                path.addArc(center: CGPoint(x: 105, y: 370), radius: 20,
                startAngle: Angle(degrees: -90), endAngle: Angle(degrees: -90), clockwise: false)

                path.addLine(to: CGPoint(x: 0, y: 370))
                path.closeSubpath()
            }
            .foregroundColor(.white)
            .frame(width: 100)
            .cornerRadius(20)
            .mask(
                Rectangle()
                .fill(
                    LinearGradient(gradient: .init(colors: [.clear,Color.white.opacity(0.3),.clear]), startPoint: .top, endPoint: .bottom)
                )
                .rotationEffect(.init(degrees: 30))
                    .offset(x: CGFloat(self.show ? center : -center))
            )
        }
        .onAppear {
            /*print("reverse bool")*/
            withAnimation(Animation.default.speed(0.30).delay(0).repeatForever(autoreverses: false)){
                self.show.toggle()
            }
        }
    }
}

struct CocktailPath_Previews: PreviewProvider {
    static var previews: some View {
        CocktailPath()
    }
}
