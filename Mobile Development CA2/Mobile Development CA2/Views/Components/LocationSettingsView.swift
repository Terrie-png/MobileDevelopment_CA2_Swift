import SwiftUI
import MapKit

struct MapLocationPicker: View {
    @State private var position: MapCameraPosition = .automatic
    @State private var selectedLocation: CLLocationCoordinate2D?
    @State private var searchText = ""
    @State private var showSearchResults = false
    @State private var mapSelection: MKMapItem?
    @State private var lookAroundScene: MKLookAroundScene?
    @State private var isConfirming = false
    @Binding var selectedLocationName: String
    @Environment(\.colorScheme) private var colorScheme
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
            ZStack(alignment: .bottom) {
                // Main Map View
                Map(position: $position, selection: $mapSelection) {
                    if let selectedLocation {
                        Marker("Selected Location", coordinate: selectedLocation)
                            .tint(.blue)
                    }
                    
                    UserAnnotation()
                }
                .mapControls {
                    MapUserLocationButton()
                    MapCompass()
                    MapScaleView()
                }
                .mapStyle(.standard)
                .onChange(of: mapSelection) {
                    if let mapSelection {
                        selectedLocation = mapSelection.placemark.coordinate
                        Task {
                            await fetchLookAroundScene()
                        }
                    }
                }
                
                // Search Bar
                VStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        
                        TextField("Search location", text: $searchText)
                            .textFieldStyle(.plain)
                            .autocorrectionDisabled()
                            .onSubmit {
                                Task {
                                    await searchLocations()
                                    showSearchResults = true
                                }
                            }
                        
                        if !searchText.isEmpty {
                            Button {
                                searchText = ""
                                showSearchResults = false
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(12)
                    .background(colorScheme == .dark ? Color(.systemGray5) : Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(radius: 5)
                    .padding()
                    
                    Spacer()
                    
                    // Location Preview Card
                    if let selectedLocation, let lookAroundScene {
                        LocationPreviewCard(scene: lookAroundScene) {
                            isConfirming = true
                        }
                        .transition(.move(edge: .bottom))
                    }
                }
                
                // Search Results
                if showSearchResults {
                    SearchResultsView(
                        searchText: $searchText,
                        mapSelection: $mapSelection,
                        position: $position,
                        showSearchResults: $showSearchResults,
                        selectedLocationName: $selectedLocationName
                    )
                    .background(colorScheme == .dark ? Color(.systemGray6) : Color(.systemBackground))
                }
            }
            .overlay(alignment: .topTrailing) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            .confirmationDialog("Confirm Location", isPresented: $isConfirming) {
                Button("Confirm") {
                    if let mapSelection {
                        selectedLocationName = mapSelection.name ?? "Selected Location"
                        dismiss()
                    }
                }
                Button("Cancel", role: .cancel) {}
            }
        }
    
    private func searchLocations() async {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.resultTypes = .pointOfInterest
        
        do {
            let search = MKLocalSearch(request: request)
            let response = try await search.start()
            SearchResultsView.searchResults = response.mapItems
        } catch {
            print("Search error: \(error.localizedDescription)")
        }
    }
    
    private func fetchLookAroundScene() async {
        if let mapSelection {
            lookAroundScene = try? await MKLookAroundSceneRequest(mapItem: mapSelection).scene
        } else {
            lookAroundScene = nil
        }
    }
}

struct SearchResultsView: View {
    @Binding var searchText: String
    @Binding var mapSelection: MKMapItem?
    @Binding var position: MapCameraPosition
    @Binding var showSearchResults: Bool
    @Binding var selectedLocationName: String
    @Environment(\.colorScheme) private var colorScheme
    
    static var searchResults: [MKMapItem] = []
    
    var body: some View {
        VStack {
            if searchText.isEmpty {
                Text("Recent Searches")
                    .font(.headline)
                    .padding(.top)
                // You could add recent searches here
            } else {
                List {
                    ForEach(Self.searchResults, id: \.self) { item in
                        Button {
                            mapSelection = item
                            position = .item(item)
                            showSearchResults = false
                            selectedLocationName = item.name ?? "Selected Location"
                        } label: {
                            VStack(alignment: .leading) {
                                Text(item.name ?? "Unknown")
                                    .font(.headline)
                                Text(item.placemark.title ?? "")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
        .frame(maxHeight: 300)
        .background(colorScheme == .dark ? Color(.systemGray6) : Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(radius: 5)
        .padding()
    }
}

struct LocationPreviewCard: View {
    let scene: MKLookAroundScene?
    var confirmAction: () -> Void
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack {
            if let scene {
                LookAroundPreview(initialScene: scene)
                    .frame(height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
            Button(action: confirmAction) {
                Text("Confirm Location")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.blue)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .padding()
        .background(colorScheme == .dark ? Color(.systemGray6) : Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(radius: 10)
        .padding()
    }
}

// Usage Example:
struct LocationSettingsView: View {
    @State private var currentLocation = "Select Location"
    @State private var showMapPicker = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Current Location Display
                HStack {
                    Image(systemName: "location.fill")
                        .foregroundColor(.blue)
                    
                    VStack(alignment: .leading) {
                        Text("Current Location")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text(currentLocation)
                            .font(.title3.bold())
                    }
                    
                    Spacer()
                    
                    Button {
                        showMapPicker = true
                    } label: {
                        Text("Change")
                            .foregroundColor(.blue)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.blue.opacity(0.1))
                            .clipShape(Capsule())
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                .padding(.horizontal)
                
                Spacer()
            }
            .padding(.top)
        
            .sheet(isPresented: $showMapPicker) {
                MapLocationPicker(selectedLocationName: $currentLocation)
                    .edgesIgnoringSafeArea(.bottom)
            }
        }
    }
}

// Preview
struct LocationSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSettingsView()
    }
}
