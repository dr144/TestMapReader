//
//  MapView.swift
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

struct MapView: View {
    
    @ObservedObject var viewModel: ViewModel
    
    let gradient = LinearGradient(colors: [.red, .pink], startPoint: .bottom, endPoint: .top)
    let stroke = StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round)//, dash: [10, 25])
    let initialDistance = 10000.0
    let initialHeading = 0.0
    let initialPitch = 0.0

    var body: some View {
        
        VStack {
            
            MapReader { mapProxy in
            
                Map(position: $viewModel.mapCameraPosition, selection: $viewModel.selectedMapItem) {
                    
                    // show user location
                    UserAnnotation()
                    
                    // if the user has tapped on the map, show the location of the tap
                    if let coordinate = viewModel.tappedCoordinate {
                        Marker("", systemImage: "pin.fill", coordinate: coordinate)
                            .tint(.purple)
                    }
                    
                    // show search results, if they exist
                    ForEach(viewModel.searchResults, id: \.self) { result in
                        Marker(item: result)
                    }
                    .annotationTitles(.hidden) // this cleans up the map a bit
                    
                    // show the route, if it exists
                    if let route = viewModel.route {
                        MapPolyline(route)
                            .stroke(gradient, style: stroke)
                            .mapOverlayLevel(level: .aboveRoads)
                    }
                    
                } // close MapBuilder
                .mapStyle(viewModel.mapType == .standard ? .standard(elevation: .realistic, pointsOfInterest: .excluding([])) : (viewModel.mapType == .image ? .imagery(elevation: .realistic) : .hybrid(elevation: .realistic, pointsOfInterest: .excluding([]))  ) )
                
                
                .onTapGesture(coordinateSpace: .local) { location in

                    if let coordinate: CLLocationCoordinate2D = mapProxy.convert(location, from: .local) {

                        viewModel.tappedCoordinate = coordinate

                        var minDistance = CLLocationDistance(10000000)
                        var minIndex: Int?

                        // find the closest search result and make it active
                        for (someIndex, someMKMapItem) in viewModel.searchResults.enumerated() {
                            if coordinate.distance(from: someMKMapItem.placemark.coordinate) < minDistance {
                                minDistance = coordinate.distance(from: someMKMapItem.placemark.coordinate)
                                minIndex = someIndex
                            }
                        }

                        // set the selected map item, this will trigger calling getDirections via the onChange:selectedMapItem
                        if let daMinIndex = minIndex {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                withAnimation(.easeInOut(duration: 1.0)) {
                                    viewModel.selectedMapItem = viewModel.searchResults[daMinIndex]
                                }
                            }
                        }
                    }
                } // close onTapGesture

            } // close MapReader
            
            .onChange(of: viewModel.searchResults) {
                // if we have new searchResults, invalidate existing route
                viewModel.route = nil
                viewModel.mapCameraPosition = .automatic
            }
            
            .onChange(of: viewModel.selectedMapItem) {
                viewModel.getDirections()
            }
            
            .onChange(of: viewModel.transportType) {
                if viewModel.selectedMapItem != nil {
                    viewModel.getDirections()
                }
            }
            
            .onMapCameraChange { context in
                viewModel.mapVisibleRegion = context.region
            }
            
            .onAppear {
                if let currentLocation = viewModel.userLocation {
                    viewModel.mapCameraPosition = MapCameraPosition.camera(MapCamera(centerCoordinate: currentLocation, distance: initialDistance, heading: initialHeading, pitch: initialPitch))
                }
            }
            
        } // close VStack
    } // close body
} // close View
