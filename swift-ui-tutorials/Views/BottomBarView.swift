import SwiftUI

struct BottomBar: View {
    var title = ""
    var trackUri = ""
    var status = ""
    var artist = ""
    var duration: UInt = 0
    var image: UIImage?
    
    var body: some View {
        NavigationLink(destination: NowPlayingDetailView(title: title, artist: artist, status: status, duration: duration, image:image)) {
            HStack(alignment: .bottom) {
                Text(title)
                Spacer()
                if status == "paused" {
                        Image(systemName: "play.fill").font(.system(size: 32))
                }
                if status == "playing" {
                        Image(systemName: "pause.fill").font(.system(size: 32))
                    
                }
                
            }.padding(48)
        }
    }
}

struct BottomBar_Previews: PreviewProvider {
    static func onPlay(_ uri: String) {}
    static var previews: some View {
        NavigationView {
            BottomBar(title: "Water under the bridge", status: "paused", artist: "Adele", duration: 2400)
        }
       
    }
}
