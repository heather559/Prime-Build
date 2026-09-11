import Foundation

enum MockData {
    static let listings: [Listing] = [
        Listing(
            id: "1", rlsId: "RLS-10234", address: "345 E 80th St", unit: "Apt 6B",
            neighborhood: "Yorkville", listingType: .sale, price: 1_295_000, rentPerMonth: nil,
            beds: 2, baths: 1, sqft: 898, propertyType: "Condo", maintenance: 1_115,
            brokerName: "ABC Realty",
            description: "A sun-filled corner residence with oversized windows, updated kitchen, and custom closets throughout.",
            imageName: "listing1", status: nil, hasDoorman: true, isAgentPick: true
        ),
        Listing(
            id: "2", rlsId: "RLS-10235", address: "211 W 56th St", unit: "Apt 18D",
            neighborhood: "Midtown West", listingType: .sale, price: 2_850_000, rentPerMonth: nil,
            beds: 3, baths: 2, sqft: 1450, propertyType: "Condo", maintenance: 2_890,
            brokerName: "Compass",
            description: "High-floor three bedroom with sweeping skyline views, chef's kitchen, and a private balcony.",
            imageName: "listing2", status: nil, hasDoorman: true, isAgentPick: false
        ),
        Listing(
            id: "3", rlsId: "RLS-10236", address: "88 Laight St", unit: "Apt 4A",
            neighborhood: "Tribeca", listingType: .sale, price: 4_200_000, rentPerMonth: nil,
            beds: 2, baths: 2, sqft: 1620, propertyType: "Loft", maintenance: 3_200,
            brokerName: "Douglas Elliman",
            description: "Classic Tribeca loft with soaring ceilings, exposed brick, and oversized cast-iron windows.",
            imageName: "listing3", status: "Under Contract", hasDoorman: false, isAgentPick: true
        ),
        Listing(
            id: "4", rlsId: "RLS-10237", address: "425 W 53rd St", unit: "Apt 701",
            neighborhood: "Hell's Kitchen", listingType: .sale, price: 895_000, rentPerMonth: nil,
            beds: 1, baths: 1, sqft: 720, propertyType: "Condo", maintenance: 980,
            brokerName: "Corcoran",
            description: "Turn-key one bedroom with north and south exposures, in-unit washer/dryer, and a full-service building.",
            imageName: "listing4", status: nil, hasDoorman: false, isAgentPick: false
        ),
        Listing(
            id: "5", rlsId: "RLS-10238", address: "160 Riverside Blvd", unit: "Apt 12C",
            neighborhood: "Upper West Side", listingType: .rental, price: 0, rentPerMonth: 6_500,
            beds: 2, baths: 2, sqft: 1100, propertyType: "Condo", maintenance: nil,
            brokerName: "Extell Marketing",
            description: "River-facing two bedroom in a full-amenity building with pool, gym, and resident lounge.",
            imageName: "listing5", status: nil, hasDoorman: true, isAgentPick: false
        ),
        Listing(
            id: "6", rlsId: "RLS-10239", address: "55 Water St", unit: "Apt 8E",
            neighborhood: "Financial District", listingType: .rental, price: 0, rentPerMonth: 4_200,
            beds: 1, baths: 1, sqft: 780, propertyType: "Rental", maintenance: nil,
            brokerName: "Rudin Management",
            description: "Bright one bedroom with water views, hardwood floors, and a renovated bath.",
            imageName: "listing6", status: nil, hasDoorman: false, isAgentPick: false
        ),
        Listing(
            id: "7", rlsId: "RLS-10240", address: "300 W 23rd St", unit: "Apt 5F",
            neighborhood: "Chelsea", listingType: .sale, price: 1_750_000, rentPerMonth: nil,
            beds: 2, baths: 2, sqft: 1050, propertyType: "Co-op", maintenance: 2_100,
            brokerName: "Brown Harris Stevens",
            description: "Renovated two bedroom co-op steps from the High Line with a windowed kitchen.",
            imageName: "listing7", status: nil, hasDoorman: false, isAgentPick: false
        ),
        Listing(
            id: "8", rlsId: "RLS-10241", address: "19 Dutch St", unit: "Apt 32A",
            neighborhood: "FiDi", listingType: .sale, price: 3_100_000, rentPerMonth: nil,
            beds: 3, baths: 2, sqft: 1890, propertyType: "Condo", maintenance: 4_200,
            brokerName: "Sotheby's International",
            description: "Half-floor three bedroom with 270-degree views and a private keyed elevator landing.",
            imageName: "listing8", status: nil, hasDoorman: true, isAgentPick: true
        ),
        Listing(
            id: "9", rlsId: "RLS-10242", address: "245 E 54th St", unit: "Apt 15G",
            neighborhood: "Sutton Place", listingType: .rental, price: 0, rentPerMonth: 5_800,
            beds: 2, baths: 1, sqft: 950, propertyType: "Rental", maintenance: nil,
            brokerName: "Glenwood Management",
            description: "East River-facing two bedroom with floor-to-ceiling windows and 24-hour doorman.",
            imageName: "listing9", status: nil, hasDoorman: true, isAgentPick: false
        ),
    ]

    static let neighborhoods = [
        "Upper East Side", "Upper West Side", "Midtown East", "Tribeca",
        "SoHo", "West Village", "Chelsea", "Flatiron",
    ]

    static let propertyTypes = ["Condo", "Co-op", "Loft", "Rental"]
}
