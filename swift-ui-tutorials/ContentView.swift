//
//  ContentView.swift
//  swift-ui-tutorials
//
//  Created by James O'Donoghue on 3/25/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var spotifyController: SpotifyController

    var body: some View {
        VStack {
            Button {
                if (spotifyController.isConnected) {
                    spotifyController.appRemote.disconnect()
                }
                else {
                    spotifyController.connect()
                }
            } label: {
                Text(spotifyController.isConnected ? "Disconnect":"Connect")
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
