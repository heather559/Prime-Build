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
    var saleRentalFilter: SaleRentalFilter = .sale
    var selectedNeighborhood: String? = nil
    var minPrice: Double? = nil
    var maxPrice: Double? = nil
    var minBeds: Int? = nil
    var minBaths: Int? = nil
    var boardFilter: BoardFilter = .all
    var reviewIndex: Int = 0

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
            if let minBeds {
                if minBeds == 0 {
                    if listing.beds != 0 { return false }
                } else if minBeds >= 4 {
                    if listing.beds < 4 { return false }
                } else if listing.beds != minBeds {
                    return false
                }
            }
            if let minBaths {
                if minBaths >= 3 {
                    if listing.baths < 3 { return false }
                } else if listing.baths != minBaths {
                    return false
                }
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
