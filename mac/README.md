# Prime-Build — macOS

Native SwiftUI macOS app for Heather Domi | Buyer Search. This is an isolated Swift Package — no dependency on the `ios/`, `android/`, or `windows/` builds in this repo.

## Requirements

- Xcode 16+ / Swift 6 toolchain
- macOS 14+

## Run

```sh
swift run PrimeBuildMac
```

Or open `Package.swift` in Xcode and run the `PrimeBuildMac` scheme.

## Status

All 7 screens from the original product spec are implemented against local mock data, restyled to match `domi-nyc-search-design-spec.md` (the current live app's design system — cream/olive/champagne palette, IvyMode + DM Sans typography, square-corner cards, monochrome olive reaction system):

- Search results — `PublicListingCard` (logged-out) and `FullListingCard` (authenticated) variants, pill-based multi-select Beds/Baths filters, Doorman 3-way toggle, Property Type multi-select
- Listing detail — asymmetric 1.7fr/1fr layout, sticky reaction/tour sidebar
- Register / Login — Google OAuth button, password eye-toggle, "Why we ask" disclosure
- Buyer board — review mode (drag-physics swipe with keyboard ←/→/↑ support) and board mode (`BoardCardView` with Agent Pick / On Tour badges and status overlay)

**Typography note:** IvyMode is embedded and registered at runtime (see `Design/CustomFonts.swift`). DM Sans is *not* bundled — the system sans font stands in for it, since it isn't available locally. The `.uppercase` small-caps override is approximated (lowercase + wide tracking) rather than a true OpenType small-caps feature.

Reactions (Love/Maybe/Pass), "Add to Board," and "Add to Tour List" are wired to local app state. All filters are live.

**Not yet wired:** real Supabase auth/data. Login and Register currently just flip a local `isAuthenticated` flag — no network calls are made, so nothing is written to the production Supabase project. Listing photos are colored placeholders, not real images.

## Packaging a release build

```sh
swift build -c release
# assemble .app manually (see repo history for the packaging script):
#   Contents/MacOS/PrimeBuildMac        <- release binary
#   Contents/Resources/PrimeBuildMac_PrimeBuildMac.bundle  <- SPM resource bundle (font)
#   Contents/Info.plist
codesign --force --deep --sign - dist/PrimeBuildMac.app
hdiutil create -volname "Heather Domi Buyer Search" -srcfolder <staged-folder> -ov -format UDZO output.dmg
```

The app is ad-hoc signed only (not notarized) — first launch requires right-click → Open to bypass Gatekeeper.
