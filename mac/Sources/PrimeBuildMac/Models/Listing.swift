import Foundation

enum ListingType: String {
    case sale = "Sale"
    case rental = "Rental"
}

enum Reaction: String {
    case love = "Love"
    case maybe = "Maybe"
    case pass = "Pass"
}

struct Listing: Identifiable, Hashable {
    let id: String
    let rlsId: String
    let address: String
    let unit: String
    let neighborhood: String
    let listingType: ListingType
    let price: Double
    let rentPerMonth: Double?
    let beds: Int
    let baths: Int
    let sqft: Int
    let propertyType: String
    let maintenance: Double?
    let brokerName: String
    let description: String
    let imageName: String
    let status: String?
    var reaction: Reaction?
    var onBoard: Bool = false
    var tourListed: Bool = false

    var displayPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        switch listingType {
        case .sale:
            return formatter.string(from: NSNumber(value: price)) ?? "$0"
        case .rental:
            let rent = formatter.string(from: NSNumber(value: rentPerMonth ?? 0)) ?? "$0"
            return "\(rent)/mo"
        }
    }

    var fullAddress: String {
        "\(address), \(unit) — \(neighborhood)"
    }
}
