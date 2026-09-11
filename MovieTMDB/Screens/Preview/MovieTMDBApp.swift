//
//  MovieTMDBApp.swift
//  MovieTMDB
//
//  Created by Cicek on 31.08.26.
//

import SwiftUI

@main
struct MovieTMDBApp: App {
    @State var genreStore = GenreStore()
    @State var watchStore = WatchStore()
    @State var ratingStore = RatingStore()
    
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .environment(genreStore)
                .environment(watchStore)
                .environment(ratingStore)
                .task {
                    await genreStore.loadNeeded()
                }
        }
    }
}
