//
//  ContentView.swift
//  HomeWork5
//
//  Created by Vitaliy Voronok on 17.04.2020.
//  Copyright © 2020 Vitaliy Voronok. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ContentViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Sources", selection: $viewModel.sourceIndex) {
                    ForEach(0 ..< viewModel.sourceNames.count) { index in
                        Text(self.viewModel.sourceNames[index])
                            .tag(index)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
                List(viewModel.articles) { article in
                    RowView(viewModel: RowViewModel(contentViewModel: self.viewModel, article: article))
                        .onAppear {
                            if self.viewModel.articles.isLast(article) {
                                self.viewModel.loadPage()
                            }
                    }
                }
                .onAppear {
                    self.viewModel.loadPage()
                }
                .navigationBarTitle("Articles")
                .navigationBarItems(trailing:
                    Button("Reset DataBase") {
                        self.viewModel.resetDataBase()
                    }
                )
            }
        }
    }
}
