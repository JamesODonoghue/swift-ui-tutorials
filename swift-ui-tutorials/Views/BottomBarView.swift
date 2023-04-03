import SwiftUI

struct BottomBar: View {
    var title = ""
    var trackUri = ""
    var status = ""
    var onPause: (String) -> Void
    var onPlay: (String) -> Void
    
    var body: some View {
        HStack(alignment: .bottom) {
            Text(title)
            Spacer()
            if status == "paused" {
                Button(action: {onPlay(trackUri)}) {
                    Image(systemName: "play.fill").font(.system(size: 32))
                }
            }
            if status == "playing" {
                Button(action:{ onPause(trackUri)}) {
                    Image(systemName: "pause.fill").font(.system(size: 32))
                }
            }
            
        }.padding(48)
    }
}

struct BottomBar_Previews: PreviewProvider {
    static func onPlay(_ uri: String) {
        debugPrint("clicked")
    }
    static var previews: some View {
        BottomBar(title: "Some title", status: "paused", onPause: onPlay, onPlay: onPlay)
    }
}
