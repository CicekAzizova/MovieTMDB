//
//  RateMovieView.swift
//  MovieTMDB
//
//  Created by Cicek on 11.09.26.
//

import SwiftUI

struct RateMovieView: View {
    let movie: Movie
    @Environment(RatingStore.self) private var ratingStore
    @Binding var isPresented: Bool

    @State private var rating: Double

    init(movie: Movie, isPresented: Binding<Bool>) {
           self.movie = movie
           _isPresented = isPresented
           _rating = State(initialValue: 5.0)
       }
    var body: some View {
        VStack(spacing: 24) {
            HStack {
                Spacer()
                Button {
                    isPresented = false
                } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(.secondary)
                }
            }

            Text("Rate this movie")
                .font(.headline)

            Text(String(format: "%.1f", rating))
                .font(.system(size: 32, weight: .semibold))

            Slider(value: $rating, in: 0...10, step: 0.5)
                .tint(.orange)

            Button {
                ratingStore.setRating(rating, for: movie.id)
                isPresented = false
            } label: {
                Text("OK")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
            }
            .buttonStyle(.borderedProminent)
            .tint(.blue)
        }
        .padding(24)
        .background(.white, in: RoundedRectangle(cornerRadius: 24))
        .padding(.horizontal, 16)
        .environment(\.colorScheme, .light)
        .onAppear {
            if let existing = ratingStore.rating(for: movie.id) {
                rating = existing
            }
        }
    }
}
