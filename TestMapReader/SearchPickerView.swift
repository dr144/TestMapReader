//
//  SearchPickerView.swift
//  TestMapReader
//
//  Created by Kevin Gross on 11/3/23.
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

struct SearchPickerView: View {

    @State var searchType: SearchType = .None
    @Binding var searchResults: [MKMapItem]
    
    // add a property to track the visible region
    var visibleRegion: MKCoordinateRegion?
    
    var body: some View {
        
        HStack {
            
            // Segmented Picker
            Picker("", selection: $searchType) {
                ForEach(SearchType.supportedTypes, id: \.self) { value in
                    Image(systemName: value.symbol)
                        .tag(value)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            
        } // close HStack
                
        .onChange(of: searchType) {
            switch(searchType) {
            case .None:
                let _ = print("searching for none, do nothing")
            default:
                search(for: searchType.description)
            }
        }
    
    } // close View body
    
    
    func search(for query: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.resultTypes = .pointOfInterest
        
        // if there is a visibleRegion use that, otherwise a default region
        request.region = visibleRegion ?? MKCoordinateRegion(center: .ducklings, span: MKCoordinateSpan(latitudeDelta: 0.0125, longitudeDelta: 0.0125))
                
        Task {
            let search = MKLocalSearch(request: request)
            
            // make sure the searchResults are updated on the main thread
            do {
                let response = try await search.start()
                DispatchQueue.main.async {
                    self.searchResults = response.mapItems
                }
            } catch {
                print("Error performing the search: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.searchResults = []
                }
            }
        }
    }
    
}
