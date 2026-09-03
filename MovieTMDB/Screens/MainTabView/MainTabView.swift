//
//  MainTabView.swift
//  MovieTMDB
//
//  Created by Cicek on 02.09.26.
//

import SwiftUI

struct MainTabView: View {
    
   @State private var homeViewModel = HomeViewModel()
    
    var body: some View {
        TabView {
            Tab {
                NavigationStack {
                    HomeView(viewModel: homeViewModel)
                }
            }label: {
                Image(.home)
                    .renderingMode(.template)
                Text("Home")
            }
            
            Tab {
                NavigationStack {
                    
                }
            }label: {
                Image(.search)
                    .renderingMode(.template)
                Text("Home")
            }
            
            Tab {
                NavigationStack {
                    
                }
            }label: {
                Image(.save)
                    .renderingMode(.template)
                Text("Home")
            }
        }
        .tint(.icon)
        
    }
}

#Preview {
    MainTabView()
}
