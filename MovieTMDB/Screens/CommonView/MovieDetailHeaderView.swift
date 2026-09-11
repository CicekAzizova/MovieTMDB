//
//  MovieDetailHeaderView.swift
//  MovieTMDB
//
//  Created by Cicek on 09.09.26.
//

import SwiftUI

struct MovieDetailHeaderView: View {
    var path: String?
    var title: String
    var voteAverage: Double
    var genres: String
    var releaseDate: String
    var runtime: Int? = nil

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            MovieCardView(path: path, size: .posterLarge)
                .frame(width: 120, height: 180)
                .clipShape(RoundedRectangle(cornerRadius: 16))

            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .lineLimit(2)
                
                
                    movieInfo(iconName: .star, title: String(format: "%.1f", voteAverage))
                if !genres.isEmpty {
                    
                    movieInfo(iconName: .ticket, title: genres )
                }
                
                if !releaseDate.isEmpty {
                    movieInfo(iconName: .calendarBlank, title: String(releaseDate.prefix(4)))
                }
                
                if let runtime {
                    movieInfo(iconName: .clock, title: "\(runtime) minutes")
                }
            }
        }
    }
    @ViewBuilder
    private func movieInfo(iconName: ImageResource, title: String) -> some View {
        HStack(spacing: 8) {
            Image(iconName)
            Text(title)
        }
    }
}
#Preview {
    MovieDetailHeaderView(
        path: "/qJ2tW6WMUDux911r6m7haRef0WH.jpg",
        title: "Spiderman",
        voteAverage: 9.5,
        genres: "Action",
        releaseDate: "2019-06-28",
        runtime: 139
    )
}
