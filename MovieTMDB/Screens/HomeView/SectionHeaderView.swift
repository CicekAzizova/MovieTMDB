//
//  SectionHeaderView.swift
//  MovieTMDB
//
//  Created by Cicek on 07.09.26.
//

import SwiftUI

struct SectionHeaderView: View {
    let title: String
    var onSeeAll: () -> Void
    var body: some View {
        HStack {
            Text(title)
                .font(.title)
                .bold()
            Spacer()
            Button {
                onSeeAll()
            } label: {
                Text("See All")
            }

        }
    }
}
