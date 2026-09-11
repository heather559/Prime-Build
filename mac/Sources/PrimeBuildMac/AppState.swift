import Foundation
import SwiftUI

enum Route: Hashable {
    case search
    case listingDetail(String)
    case register
    case login
    case boardReview
    case boardMode
}

enum SaleRentalFilter: String, CaseIterable {
    case sale = "Sale"
    case rental = "Rental"
}

enum DoormanFilter: String, CaseIterable, Identifiable {
    case any = "Any"
    case doorman = "Doorman"
    case nonDoorman = "Non-Doorman"

    var id: String { rawValue }
}

enum BoardFilter: String, CaseIterable, Identifiable {
    case all = "All"
    case loved = "Loved"
    case maybe = "Maybe"
    case passed = "Passed"
    case tourSelected = "Tour Selected"
    case unreviewed = "Unreviewed"

    var id: String { rawValue }
}

@Observable
final class AppState {
    var isAuthenticated: Bool = false
    var route: Route = .search
    var listings: [Listing] = MockData.listings

    // Filter bar state (design spec §"Filter bar")
    var saleRentalFilter: SaleRentalFilter = .sale
    var selectedNeighborhood: String? = nil
    var minPrice: Double? = nil
    var maxPrice: Double? = nil
    var selectedBeds: Set<Int> = [] // multi-select pills; empty = any
    var selectedBaths: Set<Int> = [] // multi-select pills; empty = any
    var selectedPropertyTypes: Set<String> = [] // multi-check; empty = any
    var doormanFilter: DoormanFilter = .any

    var boardFilter: BoardFilter = .all
    var userName: String = "Sarah"

    func listing(id: String) -> Listing? {
        listings.first { $0.id == id }
    }

    func setReaction(_ reaction: Reaction, for id: String) {
        guard let index = listings.firstIndex(where: { $0.id == id }) else { return }
        listings[index].reaction = reaction
    }

    func toggleBoard(for id: String) {
        guard let index = listings.firstIndex(where: { $0.id == id }) else { return }
        listings[index].onBoard.toggle()
    }

    func toggleTour(for id: String) {
        guard let index = listings.firstIndex(where: { $0.id == id }) else { return }
        listings[index].tourListed.toggle()
    }

    var filteredSearchResults: [Listing] {
        listings.filter { listing in
            guard listing.listingType.rawValue == saleRentalFilter.rawValue else { return false }
            if let neighborhood = selectedNeighborhood, listing.neighborhood != neighborhood {
                return false
            }
            let effectivePrice = listing.listingType == .rental ? (listing.rentPerMonth ?? 0) : listing.price
            if let minPrice, effectivePrice < minPrice { return false }
            if let maxPrice, effectivePrice > maxPrice { return false }

            if !selectedBeds.isEmpty {
                let matches = selectedBeds.contains { bedOption in
                    bedOption >= 4 ? listing.beds >= 4 : listing.beds == bedOption
                }
                if !matches { return false }
            }
            if !selectedBaths.isEmpty {
                let matches = selectedBaths.contains { bathOption in
                    bathOption >= 3 ? listing.baths >= 3 : listing.baths == bathOption
                }
                if !matches { return false }
            }
            if !selectedPropertyTypes.isEmpty, !selectedPropertyTypes.contains(listing.propertyType) {
                return false
            }
            switch doormanFilter {
            case .any: break
            case .doorman: if !listing.hasDoorman { return false }
            case .nonDoorman: if listing.hasDoorman { return false }
            }
            return true
        }
    }

    var unreviewedListings: [Listing] {
        listings.filter { $0.reaction == nil }
    }

    var reviewedCount: Int { listings.count - unreviewedListings.count }

    func navigate(to route: Route) {
        self.route = route
    }
}
