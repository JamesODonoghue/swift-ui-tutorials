////
////  ContentView.swift
////  swift-ui-tutorials
////
////  Created by James O'Donoghue on 3/25/23.
////
//
//import SwiftUI
//
//struct ContentView: View {
//    @EnvironmentObject var spotifyController: SpotifyController
//
//    var body: some View {
//        ZStack {
//            VStack {
//                VStack{
//                    VStack{
//                        if (spotifyController.albumArtImageView != nil) {
//                            Image(uiImage: spotifyController.albumArtImageView ?? UIImage())
//                                .resizable()
//                                .scaledToFit()
//
//                        }
//                    }
////                    VStack {
////                        Text(spotifyController.playerState?.track.name ?? "No track playing").font(.largeTitle)
////                        HStack {
////                            if(spotifyController.playerState.isPaused) {
////                                Button {
////                                    print("Play button clicked")
////                                } label: {
////                                    Image(systemName: "play.circle.fill").font(.system(size: 96))
////                                }.controlSize(.large)
////                            }
////
////                        }
////                    }
//                }
//                Spacer()
//                VStack{
//                    Button {
//                        if (spotifyController.isConnected) {
//                            spotifyController.appRemote.disconnect()
//                        }
//                        else {
//                            spotifyController.connect()
//                        }
//                    } label: {
//                        Text(spotifyController.isConnected ? "Disconnect":"Connect")
//                    }.font(.largeTitle)
//                }
//            }
//        }
//       
//        
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    @StateObject static var spotifyController = SpotifyController()
//
//    static var previews: some View {
//        ContentView().environmentObject(spotifyController)
//    }
//}
