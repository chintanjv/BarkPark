# BarkPark — Complete Setup Guide
## Dog Park Discovery & Rating App for iOS

> **Your Xcode version:** 14.2 (14C18) · **Target:** iOS 16.0 · **Language:** Swift + SwiftUI

This guide walks you through every click and keystroke. Follow it exactly and you'll have a working app in ~20 minutes.

---

## STEP 1: Create the Xcode Project

1. **Open Xcode** (double-click the Xcode icon in your Applications folder).
2. From the Welcome screen, click **"Create a new Xcode project"**.
   - If you don't see the Welcome screen, go to **File → New → Project** in the menu bar.
3. Make sure **iOS** is selected at the top.
4. Choose **"App"** and click **Next**.
5. Fill in the settings exactly like this:

| Setting             | Value             |
|---------------------|-------------------|
| Product Name        | `BarkPark`        |
| Team                | Your Personal Team (or "None") |
| Organization Identifier | `com.yourname` |
| Interface           | **SwiftUI**       |
| Language            | **Swift**         |
| Use Core Data       | **Unchecked** ☐   |
| Include Tests       | **Unchecked** ☐   |

6. Click **Next**, choose where to save it (Desktop is fine), and click **Create**.

> **What just happened?** Xcode created a project with two files: `BarkParkApp.swift` and `ContentView.swift`. We're going to replace both and add more.

---

## STEP 2: Set the Deployment Target

1. In the left sidebar (the **Project Navigator**), click the top item — the blue `BarkPark` project icon.
2. In the center panel, under **Targets**, click `BarkPark`.
3. Go to the **General** tab.
4. Under **Minimum Deployments**, set iOS to **16.0**.

---

## STEP 3: Add Location Permission

The app uses MapKit to show the user's location. iOS requires you to explain why.

1. In the Project Navigator (left sidebar), find the file called **`Info.plist`**.
   - If you don't see `Info.plist`, click on the `BarkPark` target → **Info** tab instead.
2. You need to add a row for location permission. There are two ways:

### Option A: Via Info Tab (Easier)
1. Click the `BarkPark` **target** → **Info** tab.
2. Under "Custom iOS Target Properties", hover over any row and click the **+** button.
3. From the dropdown, choose: **"Privacy - Location When In Use Usage Description"**
4. In the **Value** column, type: `BarkPark needs your location to show nearby dog parks.`

### Option B: Via Info.plist File
1. Open `Info.plist`.
2. Right-click anywhere → **Add Row**.
3. Key: `NSLocationWhenInUseUsageDescription`
4. Value: `BarkPark needs your location to show nearby dog parks.`

---

## STEP 4: Create the File Structure

Now we'll add all the Swift files. Here's what we're building:

```
BarkPark/
├── BarkParkApp.swift          ← App entry point (already exists, we'll replace it)
├── Theme.swift                ← Colors & design tokens
├── Models/
│   ├── Models.swift           ← Data structures
│   └── MockData.swift         ← Sample park data
├── ViewModels/
│   └── ParkStore.swift        ← App state management
└── Views/
    ├── ContentView.swift      ← Tab bar (already exists, we'll replace it)
    ├── MapExploreView.swift   ← Map screen
    ├── ParkDetailView.swift   ← Park details
    ├── RatingView.swift       ← Rating flow
    ├── FilterView.swift       ← Filter sheet
    ├── FavoritesView.swift    ← Favorites list
    └── Components/
        ├── StarRatingView.swift   ← Star rating widget
        └── ParkCardView.swift     ← Map floating card
```

### How to Create Groups (Folders) in Xcode:

1. In the **Project Navigator** (left sidebar), **right-click** on the yellow `BarkPark` folder.
2. Choose **"New Group"**.
3. Name it `Models`. Press Enter.
4. Repeat: right-click `BarkPark` → New Group → name it `ViewModels`.
5. Repeat: right-click `BarkPark` → New Group → name it `Views`.
6. Right-click the `Views` group → New Group → name it `Components`.

### How to Create a New Swift File:

1. **Right-click** on the group (folder) where the file belongs.
2. Choose **"New File..."**
3. Select **"Swift File"** and click **Next**.
4. Type the filename (e.g., `Theme`) and click **Create**.
5. **Delete everything** in the new file, then **paste** the code from below.

---

## STEP 5: Add the Code — File by File

### Order matters! Create files in this order:

---

### File 1: `Theme.swift`
📍 **Location:** Right-click on `BarkPark` (root group) → New File → Swift File → name it `Theme`

**What to paste:** Copy the entire contents of the file `Theme.swift` from the provided files.

> **What this does:** Defines all the colors (Leaf Green, Sky Blue, surfaces) and design tokens (spacing, radius, shadows) from the design system.

---

### File 2: `Models/Models.swift`
📍 **Location:** Right-click on `Models` group → New File → Swift File → name it `Models`

**What to paste:** Copy the entire contents of `Models/Models.swift`.

> **What this does:** Defines the data structures — `DogPark`, `Amenity`, `AmenityVote`, `ParkFilter`, and supporting types.

---

### File 3: `Models/MockData.swift`
📍 **Location:** Right-click on `Models` group → New File → Swift File → name it `MockData`

**What to paste:** Copy the entire contents of `Models/MockData.swift`.

> **What this does:** Creates 6 sample dog parks near San Jose with realistic data.

---

### File 4: `ViewModels/ParkStore.swift`
📍 **Location:** Right-click on `ViewModels` group → New File → Swift File → name it `ParkStore`

**What to paste:** Copy the entire contents of `ViewModels/ParkStore.swift`.

> **What this does:** The "brain" of the app. Manages all state — parks, filters, ratings, favorites, photos. Saves data to UserDefaults.

---

### File 5: `Views/Components/StarRatingView.swift`
📍 **Location:** Right-click on `Components` group → New File → Swift File → name it `StarRatingView`

**What to paste:** Copy the entire contents of `Views/Components/StarRatingView.swift`.

> **What this does:** A reusable star rating widget — both interactive (for rating) and display-only (for showing ratings).

---

### File 6: `Views/Components/ParkCardView.swift`
📍 **Location:** Right-click on `Components` group → New File → Swift File → name it `ParkCardView`

**What to paste:** Copy the entire contents of `Views/Components/ParkCardView.swift`.

> **What this does:** The floating card that shows park info on the map, plus helper components (MiniChip, ParkPlaceholderImage).

---

### File 7: `Views/MapExploreView.swift`
📍 **Location:** Right-click on `Views` group → New File → Swift File → name it `MapExploreView`

**What to paste:** Copy the entire contents of `Views/MapExploreView.swift`.

> **What this does:** The main map screen with pins, search bar, and floating park card.

---

### File 8: `Views/ParkDetailView.swift`
📍 **Location:** Right-click on `Views` group → New File → Swift File → name it `ParkDetailView`

**What to paste:** Copy the entire contents of `Views/ParkDetailView.swift`.

> **What this does:** The full park detail screen with photo gallery, amenities grid, highlights, about section, and action buttons.

---

### File 9: `Views/RatingView.swift`
📍 **Location:** Right-click on `Views` group → New File → Swift File → name it `RatingView`

**What to paste:** Copy the entire contents of `Views/RatingView.swift`.

> **What this does:** The rating flow — star selection, vibe tags, quick check votes, notes, and submit.

---

### File 10: `Views/FilterView.swift`
📍 **Location:** Right-click on `Views` group → New File → Swift File → name it `FilterView`

**What to paste:** Copy the entire contents of `Views/FilterView.swift`.

> **What this does:** The filter bottom sheet with distance slider, amenity chips, and dog size selector.

---

### File 11: `Views/FavoritesView.swift`
📍 **Location:** Right-click on `Views` group → New File → Swift File → name it `FavoritesView`

**What to paste:** Copy the entire contents of `Views/FavoritesView.swift`.

> **What this does:** Shows the user's favorited parks in a clean list view.

---

### File 12: Replace `ContentView.swift`
📍 **Location:** This file already exists. Click on it in the Project Navigator.

**What to do:** Select all (⌘A), delete, then paste the contents of `Views/ContentView.swift`.

> **What this does:** The root tab bar with Explore, Search, Favorites, and Profile tabs.

---

### File 13: Replace `BarkParkApp.swift`
📍 **Location:** This file already exists. Click on it in the Project Navigator.

**What to do:** Select all (⌘A), delete, then paste the contents of `BarkParkApp.swift`.

> **What this does:** The app entry point — just launches ContentView.

---

## STEP 6: Build and Check for Errors

1. Press **⌘B** (Command + B) to build the project.
2. If you see errors:
   - **"Cannot find type..."** → A file wasn't added correctly. Check that all 11 files exist.
   - **"No such module..."** → Check that `import MapKit`, `import PhotosUI` etc. are at the top of relevant files.
   - **Red file icon** → The file isn't in the right target. Click the file → in the right panel, check the **Target Membership** box for `BarkPark`.

---

## STEP 7: Run on Simulator

1. At the top of Xcode, click the **device selector** (next to the play button).
2. Choose **"iPhone 14"** or **"iPhone 14 Pro"** (any iPhone works).
3. Press **▶ (Play)** or **⌘R** to build and run.
4. The Simulator will open and your app will appear!

### What you'll see:
- **Explore tab:** A map centered on San Jose with 6 green paw-print pins
- **Tap a pin:** A floating card appears with park info and a "Details" button
- **Tap Details:** Opens the full park detail view
- **Tap "Rate This Park":** Opens the rating flow
- **Tap "Add Photo":** Opens the photo picker (simulator has sample photos)
- **Search tab:** A list of all parks with search
- **Favorites tab:** Shows parks you've hearted
- **Profile tab:** A placeholder profile screen

---

## STEP 8: Run on Your Real iPhone (Free)

You can run this on your iPhone for free (no $99 developer account needed).

1. **Connect your iPhone** to your Mac with a USB cable.
2. On your iPhone, go to **Settings → Privacy & Security → Developer Mode** → Turn it ON.
   - (On iOS 16, this may be under Settings → Privacy & Security)
3. In Xcode, click the device selector and choose your iPhone.
4. In Xcode, go to **BarkPark target → Signing & Capabilities**:
   - Check **"Automatically manage signing"**
   - Team: Select your **Personal Team** (sign in with your Apple ID if needed)
5. Press **▶ Play**.
6. On your iPhone, you may see **"Untrusted Developer"**:
   - Go to **Settings → General → VPN & Device Management**
   - Tap your developer name → **Trust**
7. Run again. The app will launch on your phone!

> **Note:** Free provisioning expires after 7 days. Just re-run from Xcode to refresh it.

---

## STEP 9: Test the Features

### ✅ Map Discovery
- Open the Explore tab
- Pinch to zoom the map around San Jose
- Tap different pins to see park cards
- Tap "Details" to open a park

### ✅ Park Detail
- Scroll through the detail view
- See the photo gallery, amenities, highlights, about section
- Tap the heart icon to favorite

### ✅ Rating
- Tap "Rate This Park"
- Tap stars (1-5)
- Select vibe tags (Clean, Spacious, etc.)
- Vote on Quick Check items (thumbs up/down)
- Type a note
- Tap "Submit Rating"
- Go back — the rating count updates!

### ✅ Photo Upload
- Tap "Add Photo" on any park detail
- Choose an image from your photo library
- It appears in the photo gallery scroll

### ✅ Filters
- On the map, tap the filter icon (sliders) in the search bar
- Adjust distance, select amenities, choose dog size
- Tap "Show Parks" — the map updates

### ✅ Favorites
- Heart some parks from their detail views
- Switch to the Favorites tab
- See your saved parks

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| Map is blank | The simulator doesn't have real location. Go to Simulator menu → Features → Location → Custom Location → enter `37.3382, -121.8863` |
| "No such module 'PhotosUI'" | Make sure deployment target is iOS 16.0+ |
| Build errors about missing types | Check that all 11 Swift files are added and have `BarkPark` checked in Target Membership |
| App crashes on launch | Check that `BarkParkApp.swift` has `@main` and launches `ContentView()` |
| Photos don't persist | This is expected — user photos are stored in memory only for the MVP. Ratings and favorites DO persist via UserDefaults. |

---

## What Each Screen Looks Like

| Screen | Description |
|--------|-------------|
| **Explore** | Full-screen map with green pins, floating search bar, park card overlay |
| **Park Detail** | Large title, photo scroll, feature chips, amenity grid, highlights, about text, action buttons |
| **Filter Sheet** | Gradient header, distance slider, amenity chips, dog size pills, fenced toggle, "Show Parks" CTA |
| **Rating Flow** | Dog avatar, star rating, vibe tags, quick check thumbs, note field, gradient submit button |
| **Search** | Scrollable list of park cards with images, ratings, tags |
| **Favorites** | List of hearted parks with quick info |
| **Profile** | Avatar, stats bubbles, placeholder |

---

## Design System Summary

This app follows the **"Liquid Sanctuary"** design spec:

- ✅ **No 1px borders** — separation via background color shifts
- ✅ **Gradient primary buttons** — Leaf Green → Leaf Green Light at 135°
- ✅ **Ambient shadows** — 6% opacity, 40px blur, 12px Y offset
- ✅ **Pill-shaped everything** — buttons, chips, search bar
- ✅ **20px+ border radius** on all major containers
- ✅ **Editorial typography** — large bold titles with tight tracking
- ✅ **SF Symbols** with medium/semibold weights
- ✅ **No pure black (#000)** — using #1A1C1F instead

---

**You're done! 🎉** You now have a fully working iOS dog park discovery app.
