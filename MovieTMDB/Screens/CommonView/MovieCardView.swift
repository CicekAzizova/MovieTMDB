//
//  MovieCardView.swift
//  MovieTMDB
//
//  Created by Cicek on 02.09.26.
//

import SwiftUI

struct MovieCardView: View {
    
    var path: String?
    var size: ImageSize
    
    @ViewBuilder
    private var movieImage: some View {
        if let url = ImageURLBuilder.url(
            path: path,
            size: size
        ) {
            CachedRemoteImage(url: url) { phase in
                switch phase {
                case .empty:
                    Color.gray.opacity(0.1)
                        .overlay {
                            ProgressView()
                        }
                    
                case let .success(image):
                    image
                        .resizable()
                        .scaledToFill()
                    
                case .failure:
                    Color.gray.opacity(0.1)
                        .overlay {
                            Image(systemName: "film")
                                .font(.system(size: 45))
                                .foregroundStyle(.secondary)
                    }
                }
            }
        } else {
            Color.gray.opacity(0.1)
                .overlay {
                    Image(systemName: "film")
                        .font(.system(size: 45))
                        .foregroundStyle(.secondary)
            }
        }
    }
    
    var body: some View {
        HStack {
            movieImage
                
            }
        }
    }
//#Preview {
//    MovieCardView(movie: )
//}
