
import SwiftUI
import Combine
import SpotifyiOS

struct NowPlayingDetailView: View {
    @EnvironmentObject var sdkController: SpotifyController

    var title = ""
    var artist = ""
    var trackUri = ""
    var status = ""
    var duration: UInt = 0
    var image: UIImage?
    var numFreezes: UInt = 8
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    @State private var sub: Cancellable?
    @State var startDate = Date.now
    @State private var playbackPosition: Int = 0
    @State private var currentFreezePosition: Int = 1

    func getPlayerState() {
        sdkController.appRemote.playerAPI?.getPlayerState({ result, error in
            guard let playerState = result as? SPTAppRemotePlayerState else {
                if let error = error {
                    print("Failed to get player state: \(error.localizedDescription)")
                }
                return
            }
            playbackPosition = playerState.playbackPosition
            
            guard points.indices.contains(currentFreezePosition) else {
                return
            }
           
            if(playbackPosition < points[currentFreezePosition]) {
                return
            }
            sdkController.appRemote.playerAPI?.pause()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                sdkController.appRemote.playerAPI?.play(playerState.track.uri)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    sdkController.appRemote.playerAPI?.seek(toPosition: Int(points[currentFreezePosition]), callback: nil)
                    currentFreezePosition += 1
                }
            }
        })
    }
    
    func start() {
        sdkController.appRemote.playerAPI?.play(sdkController.playerState?.track.uri ?? ""
        )
    }
    func stop() {
        sdkController.appRemote.playerAPI?.pause()
    }
    
    var gap: UInt {
        return duration / numFreezes
    }
    
    var points: [UInt] {
        return generatePoints(duration: duration, numberOfPoints: numFreezes)
    }
    
    func generatePoints(duration: UInt, numberOfPoints: UInt) -> [UInt] {
        var points: [UInt] = []
        let interval = duration / (numberOfPoints - 1)
        
        for i in 0..<numberOfPoints {
            let point = i * interval
            points.append(point)
        }
        
        return points
    }
    
    var body: some View {
        VStack(spacing: 12){
            HStack {
                Text(title).font(.largeTitle)
                Spacer()
            }
            HStack {
                Text(artist).font(.title)
                Spacer()
            }
            VStack {
                HStack {
                    Text("Duration").font(.subheadline)
                    Spacer()
                }
                HStack {
                    Text(String(duration)).font(.headline)
                    Spacer()
                }
            }
            VStack {
                HStack {
                    Text("Playback position").font(.subheadline)
                    Spacer()
                }
                HStack {
                    Text(String(playbackPosition)).font(.headline)
                    Spacer()
                }
            }
            Spacer()
            if sdkController.playerState!.isPaused {
                Button(action: start) {
                    Text("Start").frame(maxWidth: .infinity).font(.title).fontWeight(.bold)
                    
                }.buttonStyle(.borderedProminent).controlSize(.large)
            }
            if !sdkController.playerState!.isPaused {
                Button(action: stop) {
                    Text("Stop").frame(maxWidth: .infinity).font(.title).fontWeight(.bold)
                }.buttonStyle(.borderedProminent).controlSize(.large)
            }
        }.padding().onReceive(timer) { time in
            self.getPlayerState()
        }
    }
}

struct NowPlayingDetailView_Previews: PreviewProvider {
    static func onPlay(_ uri: String) {}
    static let spotify: Spotify = {
        let spotify = Spotify()
        spotify.isAuthorized = true
        return spotify
    }()
    
    static let sdkController: SpotifyController = {
        let controller = SpotifyController()
        return controller
    }()
    static var previews: some View {
        NowPlayingDetailView(title: "Water under the bridge", artist: "Adele", status: "paused", duration: 60).background(Color.black).colorScheme(ColorScheme.dark).environmentObject(sdkController)
    }
}
