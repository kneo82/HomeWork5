//
//  RowView.swift
//  HomeWork5
//
//  Created by Vitaliy Voronok on 17.04.2020.
//  Copyright © 2020 Vitaliy Voronok. All rights reserved.
//

import SwiftUI

struct RowView: View {
    @ObservedObject var viewModel: RowViewModel
    
    var body: some View {
        VStack {
            HStack {
                if !viewModel.urlToImage.isEmpty {
                    URLImage(imageUrl: viewModel.urlToImage)
                        .frame(width: 40.0, height: 40.0, alignment: .center)
                }
                
                VStack(alignment: .leading) {
                    Text(viewModel.title)
                        .font(.headline)
                    
                    Text(viewModel.description)
                        .font(.subheadline)
                }
            }
            
            if viewModel.isPageLoading && viewModel.isLast {
                Divider()
                Text("Loading...")
                    .padding(.vertical)
            }
        }
    }
}
