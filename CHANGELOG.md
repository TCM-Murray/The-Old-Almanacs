# Changelog

All notable changes to Jen Almanac's Modpack will be documented in this file.

## [Unreleased]

### Fixed

#### Jen Almanac (`Jen/Jen.lua`)
- **Retrigger Edition repetitions field typo**: Fixed Retrigger Edition returning `retriggers` instead of `repetitions` field in effect table, preventing log warnings during retrigger checks.
- **The Saint double trigger on Gateway**: Added `_saint_karma_done` flag check to prevent The Saint from triggering twice per Gateway consumable use, matching the pattern used by other Jokers like P03.

---

## [0.0.8-v4]

### Fixed

#### Steamodded Core (`smods/src/overrides.lua`)
- **HUD_blind_debuff assertion crash on save load**: Added early guard check to `HUD_blind_debuff` callback to safely skip execution when `G.HUD_blind` is not yet initialized. This prevents crashes when loading saved runs during UI initialization phase.
- **Removed overly strict HUD_blind equality assertion**: The assertion that checked `G.HUD_blind == e.UIBox` could fail during legitimate UI states. The early guard at the function entry is now sufficient to prevent initialization issues.

#### Jen Almanac (`Jen/Jen.lua`)
- **Ban system crash on nil center objects**: Wrapped `Jen:delete_hardbans()` with proper error handling using `pcall` to safely handle cases where `SMODS.Center:get_obj()` returns nil or an object without a `delete` method.
- **Type checking for center deletion**: Added type validation to verify that center objects exist and have a `delete` method before invoking it, preventing nil method call errors.
- **Graceful degradation on deletion failure**: Failed card deletions now log a warning instead of crashing, allowing the banning system to continue functioning even if individual card deletions fail.

### Technical Details

**Root Causes Addressed:**
1. During save load initialization, the HUD_blind UI callback could be triggered before `G.HUD_blind` was fully initialized in the global state, causing assertion failures.
2. The ban system attempted to delete center objects (cards, consumables, blinds) that were in Jen's ban configuration but either didn't exist or weren't properly registered in Steamodded's registry.

**Impact:**
- Saves now load without crashing
- Banned cards are correctly removed from the game pool
- Game remains stable even if edge cases occur during card deletion

---

## [0.0.8-v3]

### Added

#### Jen.lua
- **Optimized Black Hole performance with immediate processing and reduced delays** - Eliminates multi-second freezes when using Black Holes, especially with Wondergeist
- **Exponential batch processing for Wondergeist operations** - Power of 2 for `^^2`, power of 3 for `^^^3`
- **Skipped expensive operations during Black Hole processing** - Reduces computational overhead
- **Fixed circular reference in `level_up_hand`** - Prevents event queue buildup
- **Global `lvcol` function for Cryptid compatibility** - Patch from `lovely.toml` ported to Jen.lua
- **Hand-level color system initialization** - Patch from `lovely.toml` ported to Jen.lua
- **Screen wipe initialization flag management** - Patch from `lovely.toml` ported to Jen.lua
- **Highlight guard for extra scoring** - Prevents highlighting non-play cards during extra scoring, fixes bugs with moving cards during scoring transitions
- **Gateway destruction flag for "The Saint" protection** - Fixes issue where The Saint Joker wasn't protecting jokers from Gateway destruction
- **Removed infinite recursions** - Cleaned up intentional slowdown code
- **Fixed score intensity calculation crashes** - Falls back gracefully on infinite or NaN values
- **Safety checks in `check_malice()` and `add_malice()` functions** - Prevents massive value increases with Epic Blind "Ahneharka"
- **Refactored code to use `Q` instead of `G.E_MANAGER:add_event`** - Standardizes event queue management
- **`ease_ante` Function Overhaul** - Completely rewrote for handling astronomical values safely with aggressive memory cleanup and error handling
- **Game Update Optimization** - Implemented per-tick cache (`G.GAME._jen_tick_cache`) to avoid repeated joker searches every frame
- **UI Color Safety Patch** - Added validation to `UIElement:draw_self` to prevent crashes from misconfigured UI components
- **Wrapped `Card.update_alert`** - Prevents crashes when card ability is missing

#### JenLib.lua
- **Crash monitoring system** - Detects and prevents crashes to desktop (CTDs) due to insufficient memory after Boss/Epic Blinds
  - `jl.crash_monitor` object with comprehensive monitoring
  - Memory spike detection with warnings at 200MB+
  - Event Manager protection with queue size monitoring
  - Thread error interception and protection
- **Card metatable safety system** - Prevents crashes during card destruction
  - Safe `can_calculate` method provision
  - Metatable patching for Boss Blind "The Scorch" compatibility
  - Function override conflict prevention
- **Comprehensive Utility Function Library (`jl.*`)** - Standardized helper functions including:
  - UI text and announcement functions (`jl.h`, `jl.a`)
  - Card finding functions (`jl.fc`)
  - Scoring context checking (`jl.scj`, `jl.sc`)
  - Event queue management (`Q`, `QR`)
  - Real-time delay creation (`jl.rd`)

#### lovely.toml
- **Centralized patches into Jen.lua** - Moved lovely.toml patches directly into Jen.lua for easier management and reduced file dependencies

