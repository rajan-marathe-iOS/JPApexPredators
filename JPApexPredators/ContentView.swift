//
//  ContentView.swift
//  JPApexPredators
//
//  Created by Rajan Marathe on 08/09/25.
//

import SwiftUI
import MapKit

struct ContentView: View {
    let predators = Predators()
    
    @State var searchText = ""
    @State var alphabetical = false
    @State var currentSelection = APType.all
    @State var currentMovie = "All"
    
    var filteredDinos: [ApexPredator] {
//        predators.filter(by: currentSelection)
        predators.filter(by: currentMovie)
        
        predators.sort(by: alphabetical)
        
        return predators.search(for: searchText)
    }
    
    var body: some View {
        NavigationStack {
            
            List {
                ForEach(filteredDinos) { predator in
                    NavigationLink {
                        PredatorDetail(predator: predator, position: .camera(
                            MapCamera(centerCoordinate: predator.location,
                                      distance: 30000
                                     )))
                    } label: {
                        
                        HStack() {
                            // Dinosaur image
                            Image(predator.image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .shadow(color: .white, radius: 1)
                            
                            VStack(alignment: .leading) {
                                // Name
                                Text(predator.name)
                                    .fontWeight(.bold)
                                
                                // Type
                                Text(predator.type.rawValue.capitalized)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .padding(.horizontal, 15)
                                    .padding(.vertical, 5)
                                    .background(predator.type.background)
                                    .clipShape(.capsule)
                            }
                        }
                    }
                }
                .onDelete{ offsets in
                    predators.removePredators(at: offsets, from: filteredDinos)
                }
            }
            .navigationTitle("Apex Predators")
            .searchable(text: $searchText)
            .autocorrectionDisabled()
            .animation(.default, value: searchText)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        withAnimation {
                            alphabetical.toggle()
                        }
                    } label: {
                        Image(systemName: alphabetical ? "film" : "textformat")
                            .symbolEffect(.bounce, value: alphabetical)
                    }
                }
                
//                ToolbarItem(placement: .topBarTrailing) {
//                    Menu {
//                        Picker("Filter By", selection: $currentSelection.animation()) {
//                            ForEach(APType.allCases) { type in
//                                Label(type.rawValue.capitalized, systemImage: type.icon)
//                            }
//                        }
//                        
//                    } label: {
//                       Image(systemName: "slider.horizontal.3")
//                    }
//                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Picker("Filter By", selection: $currentMovie.animation()) {
                            ForEach(predators.allMovies, id: \.self) { movie in
                                Label(movie, systemImage: "movieclapper")
                            }
                        }
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
