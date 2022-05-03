import SwiftUI

struct GiftView: View {
    
    @State var scale: CGFloat = 0.1
    var imageName: String
    
    var body: some View {
        
        Image(imageName)
            .frame(width: 200, height: 200)
            .scaleEffect(scale)
            .onAppear {
                let baseAnimation = Animation.easeInOut(duration: 1)
                let repeated = baseAnimation.repeatForever(autoreverses: true)
                
                withAnimation(repeated) {
                    scale = 1
                }
                
            }
    }
}
//
//struct GiftView_Previews: PreviewProvider {
//    static var previews: some View {
//        GiftView()
//    }
//}

