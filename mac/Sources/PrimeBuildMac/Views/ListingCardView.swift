import SwiftUI

struct ListingCardView: View {
    @Environment(AppState.self) private var appState
    let listing: Listing
    let showFullDetails: Bool

    var body: some View {
        Button {
            appState.navigate(to: .listingDetail(listing.id))
        } label: {
            VStack(alignment: .leading, spacing: 10) {
                ZStack(alignment: .bottomLeading) {
                    PlaceholderPhoto(seed: listing.id)

                    Text(listing.neighborhood)
                        .font(.system(size: 11, weight: .semibold))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(.black.opacity(0.55))
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                        .padding(10)

                    if let status = listing.status {
                        Text(status)
                            .font(.system(size: 11, weight: .semibold))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(.gray.opacity(0.85))
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                            .frame(maxWidth: .infinity, alignment: .topTrailing)
                            .padding(10)
                    }
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text(listing.displayPrice)
                        .font(Theme.cardPrice)
                        .foregroundStyle(.black)

                    Text("\(listing.beds == 0 ? "Studio" : "\(listing.beds) Bed") · \(listing.baths) Bath")
                        .font(Theme.body)
                        .foregroundStyle(Theme.mutedText)

                    if showFullDetails {
                        Text(listing.fullAddress)
                            .font(Theme.body)
                            .foregroundStyle(.black)
                        Text("\(listing.sqft) sq ft · Listing Courtesy of \(listing.brokerName)")
                            .font(Theme.small)
                            .foregroundStyle(Theme.mutedText)

                        HStack(spacing: 14) {
                            reactionButton(.love, systemImage: "heart.fill")
                            reactionButton(.maybe, systemImage: "clock.fill")
                            reactionButton(.pass, systemImage: "xmark")
                            Spacer()
                            Button(listing.onBoard ? "On Board ✓" : "Add to Board") {
                                appState.toggleBoard(for: listing.id)
                            }
                            .buttonStyle(.plain)
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundStyle(listing.onBoard ? Theme.mutedText : Theme.gold)
                        }
                        .padding(.top, 4)
                    } else {
                        Text(listing.rlsId)
                            .font(Theme.small)
                            .foregroundStyle(Theme.mutedText)
                        Text("Register to see full details →")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(Theme.gold)
                    }
                }
                .padding(.horizontal, 12)
                .padding(.bottom, 12)
            }
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.black.opacity(0.08), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.plain)
    }

    private func reactionButton(_ reaction: Reaction, systemImage: String) -> some View {
        Button {
            appState.setReaction(reaction, for: listing.id)
        } label: {
            Image(systemName: systemImage)
                .font(.system(size: 13))
                .foregroundStyle(listing.reaction == reaction ? Theme.gold : Theme.mutedText)
        }
        .buttonStyle(.plain)
    }
}
