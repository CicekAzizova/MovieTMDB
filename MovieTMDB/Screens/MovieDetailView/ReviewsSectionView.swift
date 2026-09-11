//
//  ReviewsSectionView.swift
//  MovieTMDB
//
//  Created by Cicek on 09.09.26.
//

import SwiftUI

struct ReviewsSectionView: View {
    let reviews: [Review]

    var body: some View {
        if reviews.isEmpty {
            ContentUnavailableView(
                "No Reviews",
                systemImage: "text.bubble",
                description: Text("Be the first to review this movie")
            )
        } else {
            VStack(spacing: 16) {
                ForEach(reviews) { review in
                    ReviewRow(review: review)
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

private struct ReviewRow: View {
    let review: Review

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            avatar

            VStack(alignment: .leading, spacing: 4) {
                Text(review.author)
                    .font(.subheadline)
                    .fontWeight(.semibold)

                Text(review.content)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(3)

                if let rating = review.authorDetails.rating {
                    Text(String(format: "%.1f", rating))
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(.blue)
                }
            }
        }
    }
    private var avatar: some View {
        MovieCardView(
            path: review.authorDetails.avatarPath,
            size: .profile
        )
        .frame(width: 44, height: 44)
        .clipShape(Circle())
    }
}

#Preview {
    ReviewsSectionView(reviews: [
        Review(
            id: "1",
            author: "Iqbal Shafiq Rozaan",
            content: "From DC Comics comes the Suicide Squad, an antihero team of incarcerated supervillains.",
            authorDetails: AuthorDetails(rating: 6.3, avatarPath: nil)
        )
    ])
}
