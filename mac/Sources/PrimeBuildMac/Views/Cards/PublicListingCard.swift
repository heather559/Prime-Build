import SwiftUI

/// §3: logged-out card — price + beds/baths only, address/sqft hidden behind
/// a lock icon + em-dash placeholder, footer strip in olive text.
struct PublicListingCard: View {
    @Environment(AppState.self) private var appState
    let listing: Listing

    var body: some View {
        Button {
            appState.navigate(to: .listingDetail(listing.id))
        } label: {
            VStack(alignment: .leading, spacing: 0) {
                ZStack(alignment: .bottomLeading) {
                    PlaceholderPhoto(seed: listing.id)
                    Pill(text: listing.neighborhood)
                        .padding(10)
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text(listing.displayPrice)
                        .font(Theme.display(19))
                        .tracking(19 * Theme.priceTracking)
                        .foregroundStyle(Theme.ink)

                    Text("\(listing.beds == 0 ? "Studio" : "\(listing.beds) Bed") · \(listing.baths) Bath")
                        .font(Theme.sans(12))
                        .foregroundStyle(Theme.mutedForeground)

                    HStack(spacing: 6) {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 10))
                        Text("— — — — — —")
                            .font(Theme.sans(12))
                    }
                    .foregroundStyle(Theme.ash)
                    .padding(.top, 2)

                    Text(listing.rlsId)
                        .font(Theme.sans(10))
                        .foregroundStyle(Theme.mutedForeground)
                        .padding(.top, 4)
                }
                .padding(14)

                Divider().overlay(Theme.line)

                HStack {
                    Text("Register to see full details →")
                        .font(Theme.sans(11, weight: .medium))
                        .foregroundStyle(Theme.olive)
                    Spacer()
                }
                .padding(14)
            }
        }
        .buttonStyle(.plain)
        .cardShell()
    }
}
