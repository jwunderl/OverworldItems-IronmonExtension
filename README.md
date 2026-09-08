# Overworld Items

A FireRed/LeafGreen extension for [Ironmon Tracker](https://github.com/besteon/Ironmon-Tracker)
that adds an **Items** tab beside the trainer list. Track item balls and hidden
pickups by floor or across an entire dungeon, including rooms you have not visited.

## Install

Copy [OverworldItems.lua](./OverworldItems.lua) into the tracker's `extensions`
folder, then enable **Overworld Items** under **Settings -> Extensions**. Refresh
the extension list if it has not appeared yet.

Open the trainer list and select **Items**. The extension's **Options** button
also opens the current area's checklist, including locations without trainers.
See the [Tracker add-ons guide](https://github.com/besteon/Ironmon-Tracker/wiki/Tracker-Add-ons)
for general extension setup.

## Checklist

- **Area** includes all floors in the dungeon group; uncheck it for the current
  floor. S.S. Anne's kitchen is included alongside its rooms and exterior.
- **Missing** filters out collected locations without changing the area's total.
- Item names stay hidden until collected unless **Reveal names** is enabled.
- Select a row for its map, zero-based tile coordinates, and pickup details.
- Ordinary item status follows the game's live save flags, including pickups
  made before installing the extension.

### Run Restrictions

The checklist implements these run-specific restrictions, not every Ironmon ruleset:

## Validation and Coverage

Item locations and dungeon counts were checked against:

- [Ironmon FR/LG Walkthrough by Bit_Rot](https://docs.google.com/document/d/1QvS0VQcgsh0Mos3XTDKanagsJeNVjMneqEwpgHGWMyw/edit?tab=t.0#heading=h.250ydcfi1cj5)
- [FRLG IronMON Map by Kelsey Young](https://kelseyyoung.github.io/FRLGIronmonMap/)
  and its [pinned item catalogue](https://github.com/kelseyyoung/FRLGIronmonMap/blob/1282f84d70f6102534c139d5eb5da1a320f68d4e/src/data/items.ts)
- The [pret FireRed decompilation](https://github.com/pret/pokefirered), specifically
  [map-event formats](https://github.com/pret/pokefirered/blob/master/include/global.fieldmap.h),
  [region sections](https://github.com/pret/pokefirered/blob/master/src/data/region_map/region_map_sections.json),
  [pickup scripts](https://github.com/pret/pokefirered/blob/master/data/scripts/obtain_item.inc),
  and [renewable-item rules](https://github.com/pret/pokefirered/blob/master/src/renewable_hidden_items.c).

## Local Development

Keep this repository next to `Ironmon-Tracker`, just like EncounterDetails. Run
these commands from this repository's root using Bash (Git Bash on Windows):

```sh
bash deploy.sh   # Copy the repo's Lua file into the tracker
bash pull-in.sh  # Copy tracker-side edits back into this repo
```

Each script overwrites only the destination Lua file. Pick the correct direction
before running it, then disable/re-enable the extension or restart the tracker
to load code changes. Tests, ROMs, saves, and local audit tools are not packaged here.

## Releases and Updates

The extension uses `jwunderl/OverworldItems-IronmonExtension` for **Check for Updates**
and **Update** in the tracker, following EncounterDetails' release-check workflow.

1. Increase `self.version` in [OverworldItems.lua](./OverworldItems.lua), using two
   numeric components such as `1.1`.
2. Commit and push that version to `main`.
3. Publish a non-draft, non-prerelease GitHub release tagged `v1.1` at that commit, marked as the latest release. The initial version is `1.0`, with tag `v1.0`.
