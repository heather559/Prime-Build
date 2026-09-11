import SwiftUI

struct BoardReviewView: View {
    @Environment(AppState.self) private var appState

    var queue: [Listing] { appState.unreviewedListings }

    var body: some View {
        ZStack {
            if let listing = queue.first {
                VStack(spacing: 0) {
                    HStack {
                        Button("← View Details") {
                            appState.navigate(to: .listingDetail(listing.id))
                        }
                        .buttonStyle(.plain)
                        .font(Theme.small)
                        .foregroundStyle(Theme.mutedText)

                        Spacer()

                        Text("\(appState.reviewedCount + 1) / \(appState.listings.count) · \(queue.count) new")
                            .font(Theme.small)
                            .foregroundStyle(Theme.mutedText)
                    }
                    .padding(20)

                    ZStack(alignment: .bottom) {
                        PlaceholderPhoto(seed: listing.id, height: 520)

                        VStack(alignment: .leading, spacing: 6) {
                            Text(listing.fullAddress)
                                .font(.system(size: 20, weight: .bold))
                                .foregroundStyle(.white)
                            Text(listing.displayPrice)
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(Theme.gold)
                            Text("\(listing.beds == 0 ? "Studio" : "\(listing.beds) Bed") · \(listing.baths) Bath · \(listing.neighborhood)")
                                .font(Theme.body)
                                .foregroundStyle(.white.opacity(0.85))
                        }
                        .padding(20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            LinearGradient(colors: [.black.opacity(0.75), .clear], startPoint: .bottom, endPoint: .top)
                        )
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal, 40)

                    HStack(spacing: 40) {
                        actionButton("Pass", "xmark", .pass, tint: .red)
                        actionButton("Maybe", "clock.fill", .maybe, tint: .gray)
                        actionButton("Love", "heart.fill", .love, tint: Theme.gold)
                    }
                    .padding(.vertical, 28)
                }
            } else {
                VStack(spacing: 12) {
                    Text("All caught up")
                        .font(.system(size: 20, weight: .bold))
                    Text("You've reviewed every new listing. Check the Board for a full summary.")
                        .font(Theme.body)
                        .foregroundStyle(Theme.mutedText)
                    Button("Go to Board") { appState.navigate(to: .boardMode) }
                        .buttonStyle(.plain)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Theme.gold)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(white: 0.98))
        .animation(.easeInOut, value: queue.first?.id)
    }

    private func actionButton(_ label: String, _ systemImage: String, _ reaction: Reaction, tint: Color) -> some View {
        Button {
            if let listing = queue.first {
                appState.setReaction(reaction, for: listing.id)
            }
        } label: {
            VStack(spacing: 6) {
                Image(systemName: systemImage)
                    .font(.system(size: 22))
                    .frame(width: 56, height: 56)
                    .background(Color.white)
                    .foregroundStyle(tint)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(tint.opacity(0.4), lineWidth: 1))
                Text(label)
                    .font(Theme.small)
                    .foregroundStyle(Theme.mutedText)
            }
        }
        .buttonStyle(.plain)
    }
}
