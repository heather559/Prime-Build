import SwiftUI

/// §3 Board Review Mode: Tinder-style swipe. Drag physics (translate + rotate
/// proportional to drag distance), a color tint that ramps in as you approach
/// the ±80pt commit threshold, and full keyboard support (←/→/↑ = pass/love/maybe).
struct BoardReviewView: View {
    @Environment(AppState.self) private var appState
    @State private var dragOffset: CGSize = .zero
    @State private var exitOffset: CGSize? = nil
    @State private var exitRotation: Double = 0
    @FocusState private var isFocused: Bool

    private let commitThreshold: CGFloat = 80

    var queue: [Listing] { appState.unreviewedListings }

    var body: some View {
        ZStack {
            if let listing = queue.first {
                VStack(spacing: 0) {
                    HStack {
                        Button {
                            appState.navigate(to: .listingDetail(listing.id))
                        } label: {
                            HStack(spacing: 4) {
                                Image(systemName: "chevron.left").font(.system(size: 10))
                                Text("View Details").font(Theme.sans(11))
                            }
                            .foregroundStyle(Theme.mutedForeground)
                        }
                        .buttonStyle(.plain)

                        Spacer()

                        Text("\(appState.reviewedCount + 1) / \(appState.listings.count) · \(queue.count) new")
                            .font(Theme.sans(11))
                            .foregroundStyle(Theme.mutedForeground)
                    }
                    .padding(20)

                    ZStack(alignment: .bottom) {
                        ZStack(alignment: .bottom) {
                            PlaceholderPhoto(seed: listing.id, aspectRatio: nil, fixedHeight: 460)

                            tintOverlay

                            VStack(alignment: .leading, spacing: 6) {
                                Text(listing.fullAddress)
                                    .font(Theme.display(20))
                                    .tracking(20 * Theme.headingTracking)
                                    .foregroundStyle(.white)
                                Text(listing.displayPrice)
                                    .font(Theme.display(17))
                                    .tracking(17 * Theme.priceTracking)
                                    .foregroundStyle(Theme.champagne)
                                Text("\(listing.beds == 0 ? "Studio" : "\(listing.beds) Bed") · \(listing.baths) Bath · \(listing.neighborhood)")
                                    .font(Theme.sans(13))
                                    .foregroundStyle(.white.opacity(0.9))
                            }
                            .padding(20)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                LinearGradient(colors: [.black.opacity(0.75), .clear], startPoint: .bottom, endPoint: .top)
                            )
                        }
                        .offset(x: exitOffset?.width ?? dragOffset.width, y: exitOffset?.height ?? dragOffset.height)
                        .rotationEffect(.degrees(exitOffset != nil ? exitRotation : Double(dragOffset.width / 20)))
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    guard exitOffset == nil else { return }
                                    dragOffset = value.translation
                                }
                                .onEnded { value in
                                    guard exitOffset == nil else { return }
                                    handleRelease(value.translation, for: listing)
                                }
                        )
                        .animation(.interactiveSpring(), value: dragOffset)
                    }
                    .clipShape(Rectangle())
                    .padding(.horizontal, 40)

                    HStack(spacing: 32) {
                        InkOutlineButton(title: "Pass", height: 48) { commit(.pass, for: listing) }
                            .frame(width: 130)
                        OliveButton(title: "Love", height: 56) { commit(.love, for: listing) }
                            .frame(width: 170)
                        InkOutlineButton(title: "Maybe", height: 48) { commit(.maybe, for: listing) }
                            .frame(width: 130)
                    }
                    .padding(.vertical, 28)
                }
                .focusable()
                .focusEffectDisabled()
                .focused($isFocused)
                .onAppear { isFocused = true }
                .onKeyPress(.leftArrow) { commit(.pass, for: listing); return .handled }
                .onKeyPress(.rightArrow) { commit(.love, for: listing); return .handled }
                .onKeyPress(.upArrow) { commit(.maybe, for: listing); return .handled }
            } else {
                VStack(spacing: 12) {
                    Text("All caught up")
                        .font(Theme.display(20))
                        .foregroundStyle(Theme.ink)
                    Text("You've reviewed every new listing. Check the Board for a full summary.")
                        .font(Theme.sans(13))
                        .foregroundStyle(Theme.mutedForeground)
                    OliveButton(title: "Go to Board") { appState.navigate(to: .boardMode) }
                        .frame(width: 180)
                        .padding(.top, 8)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.cream)
    }

    private var tintOverlay: some View {
        let progress = min(abs(dragOffset.width) / commitThreshold, 1)
        let isMaybe = abs(dragOffset.height) > abs(dragOffset.width) && dragOffset.height < -20
        let color: Color = isMaybe ? Theme.ash : (dragOffset.width > 0 ? Theme.olive : Theme.taupe)
        return Rectangle()
            .fill(color)
            .opacity(exitOffset == nil ? Double(progress) * 0.35 : 0)
    }

    private func handleRelease(_ translation: CGSize, for listing: Listing) {
        if translation.height < -commitThreshold, abs(translation.height) > abs(translation.width) {
            commit(.maybe, for: listing)
        } else if translation.width > commitThreshold {
            commit(.love, for: listing)
        } else if translation.width < -commitThreshold {
            commit(.pass, for: listing)
        } else {
            withAnimation(Theme.standardEase) { dragOffset = .zero }
        }
    }

    private func commit(_ reaction: Reaction, for listing: Listing) {
        let width: CGFloat = 900
        withAnimation(.easeIn(duration: 0.3)) {
            switch reaction {
            case .love:
                exitOffset = CGSize(width: width * 1.2, height: 0)
                exitRotation = 8
            case .pass:
                exitOffset = CGSize(width: -width * 1.2, height: 0)
                exitRotation = -8
            case .maybe:
                exitOffset = CGSize(width: 0, height: -900)
                exitRotation = 0
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            appState.setReaction(reaction, for: listing.id)
            dragOffset = .zero
            exitOffset = nil
            exitRotation = 0
        }
    }
}
