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

// ViewModel is the central store for all data needed by the views.
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
    
    // Computed property to get the user's current location.
    var userLocation: CLLocationCoordinate2D? {
        guard let daLocation = locationManager.location?.coordinate else {
            return nil
        }
        return CLLocationCoordinate2D(latitude: daLocation.latitude, longitude: daLocation.longitude)
    }
    
    // Function to retrieve directions from the user's location to a selected map item.
    func getDirections() {
        self.route = nil
        
        // Ensure that there is a selected map item to get directions to.
        guard let selectedMapItem else { return }

        // Ensure the user's location is available.
        guard let location = userLocation else { return }
        
        // Prepare a directions request using the user's location and selected map item.
        let request = MKDirections.Request()
        
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: location))
        request.destination = selectedMapItem
        request.requestsAlternateRoutes = true
        
        // Choose the appropriate transport type based on the user selection.
        request.transportType = transportType == .any ? .any : ( transportType == .automobile ? .automobile : ( transportType == .walking ? .walking : (transportType == .transit ? .transit : .any)))
        
        // Perform the directions request asynchronously.
        Task {
            let directions = MKDirections(request: request)
            do {
                // Await the response from the directions request.
                let response = try await directions.calculate()
                // Update the UI on the main thread with the first received route.
                DispatchQueue.main.async {
                    self.route = response.routes.first
                    print("found \(response.routes.count) different routes!")
                }
            } catch {
                // Handle any errors during the directions request.
                print("Error getting directions: \(error.localizedDescription)")
            }
        }
    }
}
