//
//  ContentView.swift
//  TestMapReader
//
//  Created by Kevin Gross on 8/22/23.
//
//  Copyright © 2023 Locus Focus LLP. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import SwiftUI
import MapKit

struct ContentView: View {
    
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            MapView(viewModel: viewModel)
                .edgesIgnoringSafeArea(.all)
        }
        
        .overlay(alignment: .center) {
            VStack{
                
                HStack {
                    Picker("", selection: $viewModel.mapType) {
                        ForEach(MapTypes.allCases, id: \.self) { value in
                            //                            Text(value.description)
                            Image(systemName: value.symbol)
                                .tag(value)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    Picker("", selection: $viewModel.transportType) {
                        ForEach(TransitTypes.allCases, id: \.self) { value in
                            Image(systemName: value.symbol)
                                .tag(value)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                } // close HStack
                .fixedSize(horizontal: true, vertical: false)
                .padding([.top, .bottom], 10)
                .padding([.trailing], 12)
                .padding([.leading], 3)
                .background(.ultraThinMaterial)
                .cornerRadius(12)
                
                
                Spacer()
                
                
                HStack {
                    Spacer()
                    VStack(spacing: 0) {
                        if let selectedMapItem = viewModel.selectedMapItem {
                            DisclosureGroup("", isExpanded: $viewModel.showLookAround) {
                                ItemInfoView(selectedResult: selectedMapItem, route: viewModel.route)
                                    .frame(maxWidth: .infinity)
                                    .frame(width: 16/9*256, height: 256)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .padding([.horizontal])
                            }
                        }

                        ZStack {
                            SearchPickerView(searchResults: $viewModel.searchResults, visibleRegion: viewModel.mapVisibleRegion)
                                .fixedSize(horizontal: true, vertical: false)
                                .padding([.top], topPadding() )
                                .padding([.trailing], 4)
                                .padding([.leading], -2)
                        }
                        .padding([.bottom],10)
                    }
                    Spacer()
                }
                .fixedSize(horizontal: true, vertical: false)
                .background(.ultraThinMaterial)
                .cornerRadius(12)
                
            }
            .padding()
        } // close overlay
        
        
        
        
    } // close View body
    
    func topPadding() -> Double {
        if viewModel.showLookAround {
            return 10
        } else {
            return -10
        }
    }
    
}

