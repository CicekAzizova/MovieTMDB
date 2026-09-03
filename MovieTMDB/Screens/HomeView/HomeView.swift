//
//  HomeView.swift
//  MovieTMDB
//
//  Created by Cicek on 02.09.26.
//

import SwiftUI

struct HomeView: View {
    var viewModel: HomeViewModel
    
    @State private var searchText = ""
    
    
    private var searchField: some View {
        HStack {
            TextField(text: $searchText, prompt: Text("Search")
                .foregroundStyle(.searchIcon))
            {
            }
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.searchIcon)
                .frame(width: 15.81, height: 16)
        }
        .padding(.horizontal, 13)
        .frame(height: 42)
        .background(.searchTextpPaceholder)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
    
    private var popularCarousel: some View {
        LazyHStack {
            ForEach(viewModel.movies){ movie in
                MovieCardView(path: movie.posterPath ?? "", size: .backdropSmall)
                    .task {
                        await viewModel.fetchMovie()
                    }
            }
        }
    }
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("What do you want to watch?")
                searchField
                
                popularCarousel
            }
        }
        
        .padding(.horizontal, 24)
    }
}

#Preview {
    HomeView(viewModel: HomeViewModel())
}
