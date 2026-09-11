//
//  SplashScreenView.swift
//  MovieTMDB
//
//  Created by Cicek on 02.09.26.
//
import SwiftUI

struct SplashScreenView: View {
    
    @State private var isFinished = false
    var body: some View {
       if isFinished {
            MainTabView()
       }else {
           Image(.popcorn)
           
               .task {
                   try? await Task.sleep(for: .seconds(3))
                   isFinished = true
               }
       }
        
    }
        
    
}

