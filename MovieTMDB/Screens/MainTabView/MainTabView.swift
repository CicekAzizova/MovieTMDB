//
//  MainTabView.swift
//  MovieTMDB
//
//  Created by Cicek on 02.09.26.
//

import SwiftUI

struct MainTabView: View {
    @Environment(GenreStore.self) private var genreStore
    @State private var homeViewModel = HomeViewModel()
    @State private var searchViewModel = SearchViewModel()
    @State private var selectedTab = 0
    @State private var path = NavigationPath()
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab(value: 0) {
                NavigationStack(path: $path) {
                    HomeView(viewModel: homeViewModel,path: $path, selectedTab: $selectedTab)
                        .navigationDestination(for: Route.self) { route in
                            switch route {
                            case .category(let category):
                                SeeAllView(category: category)
                            case .detail(let movie):
                                MovieDetailView(movie: movie)
                                    .navigationTitle(movie.title)
                            }
                        }
                }
            }label: {
                Image(.home)
                    .renderingMode(.template)
                Text("Home")
            }
            
            Tab(value: 1) {
                NavigationStack {
                    SearchView(viewModel: searchViewModel)
                        .navigationDestination(for: Route.self) { route in
                            switch route {
                            case .category(let category):
                                SeeAllView(category: category)
                            case .detail(let movie):
                                MovieDetailView(movie: movie)
                                    .navigationTitle(movie.title)
                            }
                        }
                }
            }label: {
                Image(.search)
                    .renderingMode(.template)
                Text("Search")
            }
            
            Tab (value: 2){
                NavigationStack {
                    WatchListView()
                }
            }label: {
                Image(.save)
                    .renderingMode(.template)
                Text("Watch list")
            }
        }
        .tint(.icon)
        
    }
}

#Preview {
    MainTabView()
}
