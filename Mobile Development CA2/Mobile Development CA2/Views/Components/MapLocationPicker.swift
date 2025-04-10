////
////  mapview.swift
////  Mobile Development CA2
////
////  Created by Student on 10/04/2025.
////
//
//import SwiftUI
//
//
//struct MapLocationPicker: View {
//    @State private var position: MapCameraPosition = .automatic
//    @State private var selectedLocation: CLLocationCoordinate2D?
//    @State private var searchText = ""
//    @State private var showSearchResults = false
//    @State private var mapSelection: MKMapItem?
//    @State private var lookAroundScene: MKLookAroundScene?
//    @State private var isConfirming = false
//    @Binding var selectedLocationName: String
//    @Environment(\.colorScheme) private var colorScheme
//    
//    @Environment(\.dismiss) private var dismiss
//    
//    var body: some View {
//            ZStack(alignment: .bottom) {
//                // Main Map View
//                Map(position: $position, selection: $mapSelection) {
//                    if let selectedLocation {
//                        Marker("Selected Location", coordinate: selectedLocation)
//                            .tint(.blue)
//                    }
//                    
//                    UserAnnotation()
//                }
//                .mapControls {
//                    MapUserLocationButton()
//                    MapCompass()
//                    MapScaleView()
//                }
//                .mapStyle(.standard)
//                .onChange(of: mapSelection) {
//                    if let mapSelection {
//                        selectedLocation = mapSelection.placemark.coordinate
//                        Task {
//                            await fetchLookAroundScene()
//                        }
//                    }
//                }
//                
//                // Search Bar
//                VStack {
//                    HStack {
//                        Image(systemName: "magnifyingglass")
//                            .foregroundColor(.gray)
//                        
//                        TextField("Search location", text: $searchText)
//                            .textFieldStyle(.plain)
//                            .frame(maxWidth: .infinity)
//                            .autocorrectionDisabled()
//                            .onSubmit {
//                                Task {
//                                    await searchLocations()
//                                    showSearchResults = true
//                                }
//                            }
//                        
//                        if !searchText.isEmpty {
//                            Button {
//                                searchText = ""
//                                showSearchResults = false
//                            } label: {
//                                Image(systemName: "xmark.circle.fill")
//                                    .foregroundColor(.gray)
//                            }
//                        }
//                    }
//                    .padding(12)
//        
//
//                    .background(colorScheme == .dark ? Color(.systemGray5) : Color(.systemBackground))
//                    .clipShape(RoundedRectangle(cornerRadius: 10))
//                    .shadow(radius: 5)
//                    .padding()
//                    
//                    Spacer()
//                    
//                    // Location Preview Card
//                    if let selectedLocation, let lookAroundScene {
//                        LocationPreviewCard(scene: lookAroundScene) {
//                            isConfirming = true
//                        }
//                        .transition(.move(edge: .bottom))
//                    }
//                }
//                
//                // Search Results
//                if showSearchResults {
//                    SearchResultsView(
//                        searchText: $searchText,
//                        mapSelection: $mapSelection,
//                        position: $position,
//                        showSearchResults: $showSearchResults,
//                        selectedLocationName: $selectedLocationName
//                    )
//                    .background(colorScheme == .dark ? Color(.systemGray6) : Color(.systemBackground))
//                }
//            }
//            .overlay(alignment: .topTrailing) {
//                Button {
//                    dismiss()
//                } label: {
//                    Image(systemName: "xmark.circle.fill")
//                        .font(.title2)
//                        .foregroundColor(.gray)
//                        .padding()
//                }
//            }
//            .confirmationDialog("Confirm Location", isPresented: $isConfirming) {
//                Button("Confirm") {
//                    if let mapSelection {
//                        selectedLocationName = mapSelection.name ?? "Selected Location"
//                        dismiss()
//                    }
//                }
//                Button("Cancel", role: .cancel) {}
//            }
//        }
//    
//    private func searchLocations() async {
//        let request = MKLocalSearch.Request()
//        request.naturalLanguageQuery = searchText
//        request.resultTypes = .pointOfInterest
//        
//        do {
//            let search = MKLocalSearch(request: request)
//            let response = try await search.start()
//            SearchResultsView.searchResults = response.mapItems
//        } catch {
//            print("Search error: \(error.localizedDescription)")
//        }
//    }
//    
//    private func fetchLookAroundScene() async {
//        if let mapSelection {
//            lookAroundScene = try? await MKLookAroundSceneRequest(mapItem: mapSelection).scene
//        } else {
//            lookAroundScene = nil
//        }
//    }
//}
