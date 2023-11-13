//
//  Enums.swift
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

enum SearchType: String, Equatable, CaseIterable, Codable {
    
    case None = "None"
    case Playground = "Playground"
    case Park = "Park"
    case Beach = "Beach"
    case DogPark = "Dog Park"
    case BikeShop = "Bike Shop"
    case CoffeeShop = "Coffee Shop"
    case Restaurant = "Restaurants"
    case Bar = "Bars"
    case Theater = "Theaters, Playhouses and Performing Arts Venues"
    case Museum = "Museums and Art Galleries"
    
    static let supportedTypes: [SearchType] = [.Playground, .Park, .Beach, .DogPark, .BikeShop, .CoffeeShop, .Restaurant, .Bar, .Theater, .Museum]
    
    var localizedName: LocalizedStringKey { LocalizedStringKey(rawValue) }
    
    var description: String {
        switch self {
        case .None: return "none"
        case .Playground: return "playground"
        case .Park: return "park"
        case .Beach: return "beach"
        case .DogPark: return "dog park"
        case .BikeShop: return "bike shop"
        case .CoffeeShop: return "coffee shop"
        case .Restaurant: return "restaurants"
        case .Bar: return "bars"
        case .Theater: return "theaters"
        case .Museum: return "museums"
        }
    }
    
    var symbol: String {
        switch self {
        case .None: return "slash.circle"
        case .Playground: return "figure.and.child.holdinghands"
        case .Park: return "tree"
        case .Beach: return "beach.umbrella"
        case .DogPark: return "dog"
        case .BikeShop: return "bicycle"
        case .CoffeeShop: return "mug"
        case .Restaurant: return "fork.knife"
        case .Bar: return "wineglass"
        case .Theater: return "theatermasks"
        case .Museum: return "paintpalette"
        }
    }
}


enum MapTypes: Int, Equatable, CaseIterable, Codable, Identifiable {
    
    case standard = 0
    case hybrid = 1
    case image = 2
    
    static let supportedTypes: [MapTypes] = [.standard, .hybrid, .image]
    
    var localizedName: LocalizedStringKey { LocalizedStringKey(String(describing: self.rawValue)) }
    
    var id: Int {
        return self.rawValue
    }
    
    var description: String {
        switch self {
        case .standard: return "Standard"
        case .hybrid: return "Hybrid"
        case .image: return "Image"
        }
    }
    
    var symbol: String {
        switch self {
        case .standard: return "map"
        case .hybrid: return "mappin.and.ellipse"
        case .image: return "photo"
        }
    }
}

enum TransitTypes: Int, Equatable, CaseIterable, Codable, Identifiable {
    
    case any = 0
    case automobile = 1
    case walking = 2
    case transit = 3
    
    static let supportedTypes: [TransitTypes] = [.any, .automobile, .walking, .transit]
    
    var localizedName: LocalizedStringKey { LocalizedStringKey(String(describing: self.rawValue)) }
    
    var id: Int {
        return self.rawValue
    }
    
    var description: String {
        switch self {
        case .any: return "Any"
        case .automobile: return "Automobile"
        case .walking: return "Walking"
        case .transit: return "Transit"
        }
    }
    
    var symbol: String {
        switch self {
        case .any: return "bird"
        case .automobile: return "car"
        case .walking: return "figure.walk"
        case .transit: return "tram"
        }
    }
}
