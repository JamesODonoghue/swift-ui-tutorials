//
//  SpotifyController.swift
//  SpotifyQuickStart
//
//  Created by Till Hainbach on 02.04.21.
//

import SwiftUI
import SpotifyiOS
import Combine

class SpotifyController: NSObject, ObservableObject {
    @Published var isConnected: Bool = false
    @Published var isAuthorized: Bool = false
    @Published var error: Error? = nil
    @Published var sptSession: SPTSession? = nil

    let spotifyClientID = "239c098629894eeba35e71c917646d1d"
    let spotifyRedirectURL = URL(string:"swift-tutorial://")!
    
    var accessToken: String? = nil
    
    var playURI = ""
    
    private var connectCancellable: AnyCancellable?

    private var disconnectCancellable: AnyCancellable?
    
    override init() {
        super.init()
        connectCancellable = NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.connect()
            }

        disconnectCancellable = NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.disconnect()
            }

    }
        
    lazy var configuration = SPTConfiguration(
        clientID: spotifyClientID,
        redirectURL: spotifyRedirectURL
    )
    

    lazy var appRemote: SPTAppRemote = {
        debugPrint("app remote configuration")
        let appRemote = SPTAppRemote(configuration: configuration, logLevel: .debug)
        appRemote.connectionParameters.accessToken = self.accessToken
        appRemote.delegate = self
        debugPrint("app remote configuration completed")

        return appRemote
    }()
    
    func setAccessToken(from url: URL) {
        let parameters = appRemote.authorizationParameters(from: url)
        
        if let accessToken = parameters?[SPTAppRemoteAccessTokenKey] {
            debugPrint("setting access token")
            appRemote.connectionParameters.accessToken = accessToken
            self.accessToken = accessToken
        } else if let errorDescription = parameters?[SPTAppRemoteErrorDescriptionKey] {
            print(errorDescription)
        }
        
        
    }
    
    func connect() {
        debugPrint(self.appRemote.connectionParameters.accessToken)
        guard let _ = self.appRemote.connectionParameters.accessToken else {
            debugPrint("playing track")
            self.appRemote.authorizeAndPlayURI("")
            return
        }
        appRemote.connect()
    }
    
    func disconnect() {
        if appRemote.isConnected {
            appRemote.disconnect()
        }
    }
}

extension SpotifyController: SPTAppRemoteDelegate {
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        self.isConnected = true
        debugPrint("connection established")
        self.appRemote = appRemote
        self.appRemote.playerAPI?.delegate = self
        self.appRemote.playerAPI?.subscribe(toPlayerState: { (result, error) in
            debugPrint("player state changed")
            if let error = error {
                debugPrint(error.localizedDescription)
            }
            
        })
     
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        print("failed")
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        print("disconnected")
    }
}

//extension SpotifyController: SPTAppRemotePlayerStateDelegate {
//    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
//        debugPrint("Track name: %@", playerState.track.name)
//    }
//
//}

extension SpotifyController: SPTAppRemotePlayerStateDelegate {
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        debugPrint("player state did change")
    }
    
}

