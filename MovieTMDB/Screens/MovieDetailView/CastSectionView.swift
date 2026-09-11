//
//  CastSectionView.swift
//  MovieTMDB
//
//  Created by Cicek on 09.09.26.
//

//
//  CastSectionView.swift
//  MovieTMDB
//

import SwiftUI

struct CastSectionView: View {
    let cast: [CastMember]

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 24) {
            ForEach(cast) { member in
                VStack(spacing: 8) {
                    MovieCardView(path: member.profilePath, size: .profile)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())

                    Text(member.name)
                        .font(.subheadline)
                        .lineLimit(1)
                }
            }
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    CastSectionView(cast: [
        CastMember(id: 1, name: "Tom Holland", character: "Peter Parker", profilePath: nil, order: 0),
        CastMember(id: 2, name: "Zendaya", character: "MJ", profilePath: nil, order: 1)
    ])
}
