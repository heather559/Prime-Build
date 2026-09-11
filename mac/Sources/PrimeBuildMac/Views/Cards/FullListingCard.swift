import SwiftUI

/// §3: authenticated buyer card (non-board contexts) — full address, sqft,
/// maintenance/rent, broker + RLS ID line, reaction row + "Request Tour" on a
/// bordered top-divider footer.
struct FullListingCard: View {
    @Environment(AppState.self) private var appState
    let listing: Listing

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                appState.navigate(to: .listingDetail(listing.id))
            } label: {
                ZStack(alignment: .bottomLeading) {
                    PlaceholderPhoto(seed: listing.id)
                    Pill(text: listing.neighborhood)
                        .padding(10)
                }
            }
            .buttonStyle(.plain)

            Button {
                appState.navigate(to: .listingDetail(listing.id))
            } label: {
                VStack(alignment: .leading, spacing: 6) {
                    Text(listing.displayPrice)
                        .font(Theme.display(19))
                        .tracking(19 * Theme.priceTracking)
                        .foregroundStyle(Theme.ink)

                    Text(listing.fullAddress)
                        .font(Theme.sans(13, weight: .medium))
                        .foregroundStyle(Theme.ink)
                        .lineLimit(1)

                    Text("\(listing.beds == 0 ? "Studio" : "\(listing.beds) Bed") · \(listing.baths) Bath · \(listing.sqft) sq ft")
                        .font(Theme.sans(12))
                        .foregroundStyle(Theme.mutedForeground)

                    if let maintenance = listing.maintenance {
                        Text("\(currency(maintenance))/mo maintenance")
                            .font(Theme.sans(11))
                            .foregroundStyle(Theme.mutedForeground)
                    }

                    Text("Listing Courtesy of \(listing.brokerName) · \(listing.rlsId)")
                        .font(Theme.sans(10))
                        .foregroundStyle(Theme.ash)
                        .padding(.top, 2)
                }
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .buttonStyle(.plain)

            Divider().overlay(Theme.line)

            HStack(spacing: 10) {
                ReactionButton(systemImage: "heart.fill", isActive: listing.reaction == .love, size: 28) {
                    appState.setReaction(.love, for: listing.id)
                }
                ReactionButton(systemImage: "clock.fill", isActive: listing.reaction == .maybe, size: 28) {
                    appState.setReaction(.maybe, for: listing.id)
                }
                ReactionButton(systemImage: "xmark", isActive: listing.reaction == .pass, size: 28) {
                    appState.setReaction(.pass, for: listing.id)
                }

                Spacer()

                Button {
                    appState.toggleTour(for: listing.id)
                } label: {
                    SmallCapsText(listing.tourListed ? "Tour Requested" : "Request Tour", size: 10, weight: .semibold)
                        .foregroundStyle(listing.tourListed ? Theme.mutedForeground : Theme.olive)
                }
                .buttonStyle(.plain)
            }
            .padding(14)
        }
        .cardShell()
    }

    private func currency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "$0"
    }
}
