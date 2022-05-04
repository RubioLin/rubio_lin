import SwiftUI

struct FireworkView: View {
    var body: some View {
            ZStack {
                
                Circle()
                    .fill(Color.blue)
                    .frame(width: 20, height: 20)
                    .modifier(ParticlesModifier())
                    .offset(x: -100, y : -50)
                
                Circle()
                    .fill(Color.red)
                    .frame(width: 20, height: 20)
                    .modifier(ParticlesModifier())
                    .offset(x: 60, y : 70)
                
                Circle()
                    .fill(Color.green)
                    .frame(width: 20, height: 20)
                    .modifier(ParticlesModifier())
                    .offset(x: 20, y : 20)
                
                Circle()
                    .fill(Color.yellow)
                    .frame(width: 20, height: 20)
                    .modifier(ParticlesModifier())
                    .offset(x: 130, y : 200)
                
            }
        }
}

// MARK: - 定義幾何效果
// 要實作 effectValue 函式，需遵從 GeometryEffect
struct FireworkParticlesGeometryEffect : GeometryEffect {
    // 定義擴散煙火的時間、速度、方向
    var time : Double
    var speed = Double.random(in: 20 ... 200) // 速度間距要訂大一點，設太小會造成擴散得不夠劇烈且不太分散
    var direction = Double.random(in: -Double.pi ...  Double.pi) // 設 -pi ~ pi 會讓煙火成圓形散開，0 ~ pi 會向下散開，-pi ~ 0 會向上散開
    // 用此變數來增加時間的數值
    var animatableData: Double {
        get { time }
        set { time = newValue }
    }
    func effectValue(size: CGSize) -> ProjectionTransform {
        let xTranslation = speed * cos(direction) * time
        let yTranslation = speed * sin(direction) * time
        let affineTranslation =  CGAffineTransform(translationX: xTranslation, y: yTranslation) // 移動煙火的位置
        return ProjectionTransform(affineTranslation)
    }
}

// MARK: - 定義 視圖修飾符 (view modifier)
// 可以在此添加要給煙火的任何 modifier 一定要記得添加 .modifier 自己客製的幾何效果
struct ParticlesModifier: ViewModifier {
    @State var time = 0.0
    @State var scale = 0.1
    let duration = 2.0
    
    func body(content: Content) -> some View {
        ZStack {
            ForEach(0..<120, id: \.self) { index in
                content
                    .hueRotation(Angle(degrees: time * 80))
                    .scaleEffect(scale)
                    .modifier(FireworkParticlesGeometryEffect(time: time))
                    .opacity(((duration-time) / duration))
            }
        }
        .onAppear {
            withAnimation (.easeOut(duration: duration)) {
                self.time = duration
                self.scale = 1.0
            }
        }
    }
}

//struct FireworkView_Previews: PreviewProvider {
//    static var previews: some View {
//        FireworkView()
//    }
//}
