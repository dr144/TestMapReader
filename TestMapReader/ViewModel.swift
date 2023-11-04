//
//  ViewModel.swift
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

class ViewModel: ObservableObject {
    
    @Published var mapType: MapTypes = .standard
    @Published var transportType: TransitTypes = .any
    @Published var locationManager = LocationManager()
    @Published var mapCameraPosition: MapCameraPosition = .automatic
    @Published var mapVisibleRegion: MKCoordinateRegion?
    @Published var selectedMapItem: MKMapItem? // track user selected map items
    @Published var selectedMapItemTag: Int? // track user selected map items
    @Published var route: MKRoute? // a route to user's selected map item
    @Published var tappedCoordinate: CLLocationCoordinate2D?
    @Published var showLookAround: Bool = true
    @Published var searchResults: [MKMapItem] = []
    
    var userLocation: CLLocationCoordinate2D? {
        guard let daLocation = locationManager.location?.coordinate else {
            return nil
        }
        return CLLocationCoordinate2D(latitude: daLocation.latitude, longitude: daLocation.longitude)
    }
    
    func getDirections() {
        self.route = nil
        guard let selectedMapItem else { return }
        
        guard let location = userLocation else { return }
        
        let request = MKDirections.Request()
        
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: location))
        request.destination = selectedMapItem
        request.requestsAlternateRoutes = true
                
        request.transportType = transportType == .any ? .any : ( transportType == .automobile ? .automobile : ( transportType == .walking ? .walking : (transportType == .transit ? .transit : .any)))
        
        // make sure to update route on the main thread
        Task {
            let directions = MKDirections(request: request)
            do {
                let response = try await directions.calculate()
                // Ensure you update the UI on the main thread
                DispatchQueue.main.async {
                    self.route = response.routes.first
                    print("found \(response.routes.count) different routes!")
                }
            } catch {
                print("Error getting directions: \(error.localizedDescription)")
            }
        }
    }
}
