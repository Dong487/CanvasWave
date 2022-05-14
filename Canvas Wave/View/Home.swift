//
//  Home.swift
//  Canvas Wave
//
//  Created by DONG SHENG on 2021/7/12.
//

//
import SwiftUI

struct Home: View {
    
    @State var toggle = false
    var body: some View {
        ZStack{
            
            if #available(iOS 15.0, *) {
                WaveForm(color: .cyan.opacity(0.8),amplity: 150, isReversed: true)
            } else {
                // Fallback on earlier versions
            }
            
            if #available(iOS 15.0, *) {
                WaveForm(color: (toggle ? Color.purple : Color.cyan).opacity(0.6),amplity: 150, isReversed: false)
            } else {
                // Fallback on earlier versions
            }
            
            VStack{
                
                HStack{
                    Text("Wave's")
                        .font(.largeTitle.bold())
                    Spacer()
                    
                    if #available(iOS 15.0, *) {
                        Toggle(isOn: $toggle) {
                            Image(systemName: "eyedropper.halffull")
                                .font(.title2)
                        }
                        .toggleStyle(.button)
                        .tint(.purple)
                    } else {
                        // Fallback on earlier versions
                    }
                }
            }
            .padding()
            .frame(maxHeight: .infinity, alignment: .top)
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}


struct WaveForm:View {
    
    var color : Color
    var amplity: CGFloat
    
    var isReversed : Bool
    var body: some View{
        
        if #available(iOS 15.0, *) {
            TimelineView(.animation) { timeLine in
                
                //123123
                
                Canvas{ context, size in
                    
                    let timeNow = timeLine.date.timeIntervalSinceReferenceDate
                    
                    let angle = timeNow.remainder(dividingBy: 2)
                    
                    let offset = angle * size.width
                    
//                    context.draw(Text("\(offset)"), at: CGPoint(x: size.width / 2, y: 100))
                    
                    context.translateBy(x: isReversed ? -offset : offset, y:  0)
                    
                    context.fill(getPath(size: size), with: .color(color))
                    
                    context.translateBy(x: -size.width, y: 0)
                    
                    context.fill(getPath(size: size), with: .color(color))
                    
                    context.translateBy(x: size.width * 2 , y: 0)
                    
                    context.fill(getPath(size: size), with: .color(color))
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    func getPath(size: CGSize)-> Path{
        
        Path{ path in
            
            let midHeight = size.height / 2
            
            let width = size.width
            
            path.move(to: CGPoint(x: 0, y: midHeight))
    
            // 頂端 波的形狀
            path.addCurve(to: CGPoint(x: width, y: midHeight),
                          control1: CGPoint(x: width * 0.4, y: midHeight + amplity),
                          control2: CGPoint(x: width * 0.65 , y: midHeight - amplity))
            
            // 下面的填充
            path.addLine(to: CGPoint(x: width, y: size.height))
            path.addLine(to: CGPoint(x: 0, y: size.height))         //填滿
        }
    }
}
