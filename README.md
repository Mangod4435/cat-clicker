# 🐱 Cat Clicker

A cat clicker game made with **Godot 4.7** — click the cat, buy upgrades, watch the numbers go brrr.

> This is the Godot version of Cat Clicker. The original [Unity WebGL version](https://github.com/Mangod4435/Cat-Clicker) is archived.

## Features

- **Click the cat** to earn cats
- **Upgrade menu** with 7 upgrade rows (CPC/CPS based, prices scale by 1.15^n)
- **Settings panel** with sound toggle and reset button (with blur effect)
- **Autosave** every 30s and on focus loss — JSON + SHA-256 hash in `user://` (IndexedDB on web)

## Running

Open the project in Godot 4.7 (renderer: **GL Compatibility**, web-friendly) and hit ▶, or export to web — the viewport is 2560x1440 with `canvas_items` stretch, same as the original Unity canvas.

## Project layout

| Path | What it does |
|---|---|
| `scripts/game_manager.gd` | autoload — cats, CPC/CPS, upgrades, autosave, JSON + SHA-256 hashed saves |
| `scripts/upgrade_api.gd` | data table for upgrade names, base prices, CPC/CPS |
| `scripts/ui/` | one script per UI element |
| `scenes/main.tscn` | main scene |
| `scenes/upgrade_row.tscn` | reusable upgrade row |

## License

See [LICENSE](LICENSE).
