# Changelog

All notable changes to Jen Almanac's Modpack will be documented in this file.

## [30/11/2025]

### Removed

#### Repository Cleanup
- **Removed non-Jen dependency mods from repository**: Deleted Blueprint, CardSleeves, Cartomancer, Galdur, HandyBalatro, MoreFluff, MoreJokerPacks, multipack, NotJustYet, SDM_0'sStuff, and Trance mods
- **Deleted obsolete branches**: Removed `jen-almanac-dependencies` and `experimental-updates` branches

---

## [28/11/2025]

### Changed

#### Jen Almanac - Major Architecture Refactoring

**Complete modular restructuring of the Jen mod from monolithic architecture to organized module system.**

The entire mod has been refactored from a single large `Jen.lua` file (~13,000+ lines) into a clean modular structure for better maintainability, readability, and development workflow.

##### New Directory Structure

```
Jen/
├── Jen.lua                  # Lightweight entry point (module loader)
├── core/                    # Core systems (13 modules)
│   ├── init.lua             # Globals, safety patches, Jen table setup
│   ├── config.lua           # Configuration and locale colors
│   ├── utils.lua            # Helper functions (text formatting, roman numerals, credits)
│   ├── hooks.lua            # Game lifecycle hooks and overrides
│   ├── operator.lua         # Operator display system (×, ^, ^^, ^^^)
│   ├── malice.lua           # Malice/Kosmos system
│   ├── straddle.lua         # Straddle mechanics
│   ├── economy.lua          # Dollar/tension/relief system
│   ├── suits_ranks.lua      # Suit/Rank leveling UI
│   ├── ui.lua               # UI helpers and components
│   ├── safety.lua           # Safety patches and crash prevention
│   ├── bans.lua             # Card ban system
│   └── fusion.lua           # Fusion system
└── content/                 # Game content definitions (10 modules)
    ├── atlases.lua          # SMODS.Atlas definitions
    ├── sounds.lua           # SMODS.Sound definitions
    ├── consumable_types.lua # SMODS.ConsumableType definitions
    ├── editions.lua         # SMODS.Edition definitions
    ├── decks.lua            # SMODS.Back definitions
    ├── enhancements.lua     # SMODS.Enhancement definitions
    ├── jokers.lua           # SMODS.Joker definitions (~6900 lines)
    ├── consumables.lua      # SMODS.Consumable definitions (+ Boosters)
    ├── blinds.lua           # SMODS.Blind definitions
    └── vouchers.lua         # SMODS.Voucher definitions
```

##### Module Loading System

- **`Jen.lua`**: Now a lightweight ~320 line entry point that:
  - Defines `safe_load()` function using `SMODS.load_file()` API
  - Loads all core modules in dependency order
  - Loads all content modules
  - Provides configuration tab UI

##### Core Modules Breakdown

| Module | Purpose |
|--------|---------|
| `init.lua` | Jen table initialization, global constants, Incantation/Aurinko addon setup |
| `config.lua` | `Jen.config` loading, `locale_colours`, texture pack settings |
| `utils.lua` | `checkerboard_text()`, `roman()`, `faceart()`, `spriter()`, `caption()`, `lore()` helpers |
| `hooks.lua` | `Game:start_run`, `Game:init_game_object` hooks, Wondergeist job processor, UI safety patches |
| `operator.lua` | `update_operator_display()`, chip×mult operator rendering system |
| `malice.lua` | Malice/Kosmos mechanics and calculations |
| `straddle.lua` | Straddle system implementation |
| `economy.lua` | Tension/Relief economy system |
| `suits_ranks.lua` | `ui_suits_ranks()` UI, suit/rank leveling display |
| `ui.lua` | UI component helpers, pack/voucher buttons |
| `safety.lua` | `Jen.init_safety_systems()`, crash prevention, metatable patches |
| `bans.lua` | `init_cardbans()`, `Jen:delete_hardbans()` |
| `fusion.lua` | Joker fusion system |

##### Content Modules Breakdown

| Module | Purpose |
|--------|---------|
| `atlases.lua` | All `SMODS.Atlas` definitions for sprites |
| `sounds.lua` | All `SMODS.Sound` definitions |
| `consumable_types.lua` | Custom consumable types: `jen_ability`, `jen_omegaconsumable`, `jen_tokens`, `jen_uno` |
| `editions.lua` | All `SMODS.Edition` definitions (Wee, Jumbo, Bismuth, etc.) |
| `decks.lua` | All `SMODS.Back` definitions |
| `enhancements.lua` | All `SMODS.Enhancement` definitions |
| `jokers.lua` | All `SMODS.Joker` definitions (largest file, ~6900 lines) |
| `consumables.lua` | All `SMODS.Consumable` definitions + Booster packs |
| `blinds.lua` | All `SMODS.Blind` definitions (Boss/Epic blinds) |
| `vouchers.lua` | All `SMODS.Voucher` definitions |

### Removed

#### Jen Almanac
- **`JenRevision.lua`**: Deleted - revision tracking no longer needed with git
- **`OLD FILES/` directory**: Deleted - legacy backups (`Jen v2 copy.lua`, old `Jen.lua`, old `lovely.toml`)

**Migration Notes:**
- All functionality preserved (As far as I know)- no gameplay changes yet
- Load order carefully managed via `safe_load()` sequence
- Global functions remain global for content file compatibility
- Configuration tab moved to main `Jen.lua` entry point
- Someone end me.

---

## [22/11/2025]

### Fixed

#### Jen Almanac (`Jen/Jen.lua`)
- **Token consumable crash prevention and Cryptid integration**: Fixed crash when using Token consumables (Double, Triple, Quadruple, Quintuple, etc...) immediately after loading a save. The issue occurred because modded tag definitions (from Cryptid) weren't fully initialized, causing `tag.lua:537` to crash with "attempt to index nil with key 'atlas'".
  - Added `G.P_TAGS` existence checks before creating tags in both `use()` and `bulk_use()` functions
  - Implemented deferred tag creation fallback: if tag definitions aren't ready, tag creation is delayed to the next event frame when mods are fully loaded
  - Prevents game freeze and cascade errors in Cryptid voucher system that occurred after the initial crash
- **Token consumable pool integration with Cryptid gameset system**: Token consumables now respect Cryptid's tag enable/disable settings
  - Added `in_pool()` function to all Token consumables that checks if the corresponding Cryptid tag is available
  - Tokens for disabled tags (e.g., Triple, Quadruple, Quintuple) no longer appear in shops or packs when Cryptid has disabled those tags
  - Prevents user confusion from obtaining unusable consumables when tags are disabled via Cryptid settings

#### JenLib (`JenLib/JenLib.lua`)
- **Cleaned up debug output**: Removed verbose debug print statement from Card metatable patching

### Changed

#### JenLib (`JenLib/JenLib.lua`)
- **Added attribution comment**: Added NOTE crediting TCM Murray for library modifications

---

## [17/11/2025]

### Added

#### CryptidAlmanacCompat Integration
- **Integrated all CryptidAlmanacCompat functionality into Jen and JenLib** - The separate compatibility mod is no longer needed
  - **Cryptid Encoded Deck Support** (`JenLib.lua`): Modified encoded deck behavior to spawn only Code Joker, removing the banned Copy/Paste joker
  - **POINTER:// Blacklist System** (`JenLib.lua`): Prevents creation of Jen's custom rarities and OMEGA consumables via POINTER://
  - **P03 Dynamic Exotic Control** (`Jen.lua`): P03 joker now dynamically enables/disables Exotic joker creation in POINTER:// when added/removed from deck
  - **Gameset Override** (`JenLib.lua`): Forces "madness" gameset for all Jen cards and disables gameset selector UI
  - **Safety Wrappers** (`JenLib.lua`): Added `update_hand_text` color safety wrapper to prevent crashes

#### JenLib (`JenLib.lua`) - v0.4.1
- **Cryptid Compatibility System** - New module with comprehensive Cryptid integration functions:
  - `jl.init_cryptid_compat()` - Gameset override and config modifications
  - `jl.setup_encoded_deck()` - Takes ownership of Cryptid's Encoded deck with existence checks
  - `jl.setup_pointer_blacklist()` - Blacklists Jen custom rarities and OMEGA consumables (NOT exotics - handled by P03)
  - `jl.setup_pointer_aliases()` - Registers 40+ card name shortcuts for easy POINTER:// creation
  - `jl.wrap_update_hand_text()` - Safety wrapper for hand text updates
  - `jl.get_table_keys()` - Debug utility for inspecting table contents
- **Existence checks for Cryptid objects** - All compatibility functions gracefully skip if Cryptid isn't installed or objects don't exist yet

#### Jen Almanac (`Jen.lua`)
- **P03 Joker Enhancement** - Implemented dynamic exotic control:
  - `add_to_deck()` - Removes `cry_exotic` from POINTER:// blacklist when P03 is obtained
  - `remove_from_deck()` - Re-adds `cry_exotic` to blacklist when P03 is sold/removed
  - Makes P03's description text ("can now create Exotic Jokers") actually functional
- **Module-level Cryptid initialization** - Pointer blacklist and aliases setup runs immediately at mod load time for proper timing
- **process_loc_text integration** - Calls Encoded deck setup after all mods are loaded
- **Early compatibility init** - Gameset override and safety wrappers init during safety systems setup

#### Jen (`lovely.toml`)
- **Cryptid Compatibility Patches** - Added 3 patches for Cryptid integration:
  - **Code card fallback patch**: Changes default crash recovery card from `c_cry_crash` to `c_cry_oboe` (prevents crashes since crash card is banned)
  - **Profile prefix patch**: Changes Cryptid save profile prefix from "M" to "J" for Jen
  - **Tutorial auto-skip patch**: Automatically completes Cryptid intro and sets gameset to "madness"

#### lua_patcher
- **Added lua_patcher mod** - A utility mod that prevents common Lua errors by redefining Lua operations to return safe values instead of throwing errors.

### Changed

#### Load Order Optimization
- **Separated early and late initialization** - Gameset/safety wrappers run early, deck ownership runs late after all mods load
- **Module-level vs function-level execution** - Pointer setup runs at module load time instead of inside `process_loc_text()` for proper timing

### Fixed

#### Cryptid Encoded Deck
- **Crash on deck ownership before Cryptid loads** - Added existence check for `SMODS.Back.obj_buffer["b_cry_encoded"]` before attempting take_ownership
- **Copy/Paste joker spawning on Encoded deck** - Properly overrides deck behavior to only spawn Code Joker

#### POINTER:// System
- **Exotic joker control** - Cryptid handles exotic blacklist natively, P03 joker dynamically enables/disables exotic creation
- **Pointer functions not running** - Moved setup from `process_loc_text()` to module-level execution at file load time
- **Module availability timing** - Added comprehensive debug logging and checks for Cryptid function existence
- **P03 functional enhancement** - Original compat mod had non-functional P03 description; now actually controls exotic availability
- **P03 save load persistence** - Hooked into `Game.start_run` to check for P03 presence on save load and restore exotic creation state accordingly

### Removed

- **CryptidAlmanacCompat mod dependency** - All functionality successfully integrated into Jen/JenLib
---

## [16/11/2025]

### Fixed

#### Jen Almanac (`Jen/Jen.lua`, `lovely.toml`)
- **Retrigger Edition repetitions field typo**: Fixed Retrigger Edition returning `retriggers` instead of `repetitions` field in effect table, preventing log warnings during retrigger checks.
- **The Saint double trigger on Gateway**: Added `_saint_karma_done` flag check to prevent The Saint from triggering twice per Gateway consumable use, matching the pattern used by other Jokers like P03.
- **Ban system ignoring `disable_bans` config on save load**: Fixed save load patch in `lovely.toml` unconditionally calling `Jen:delete_hardbans()`, which deleted banned jokers from the pool regardless of the `disable_bans` config setting. Now correctly calls `init_cardbans()` which respects the config option.

---

## [15/11/2025]

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

## [10/11/2025]

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

