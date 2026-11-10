# Cat Clicker (Godot 4.7)

Port of the Unity WebGL version. Renderer: Compatibility (web-friendly). Viewport 2560x1440 (same as the Unity canvas), stretch mode `canvas_items`.

## Signals
Wired in `scenes/main.tscn`:

| Node (in `scenes/main.tscn`) | Signal | Method |
|---|---|---|
| `Cat` | `pressed` | `on_clicked` |
| `UpgradeMenu` | `pressed` | `on_clicked` |
| each of the 7 rows under `UpgradeMenu/Panel/.../Rows` | `pressed` | `on_clicked` |

The settings UI (`SettingButton`, `SoundToggle`, `SaveButton`, `ResetButton`) is not in the scene yet; those handlers are ready to connect once the nodes exist.

## Layout
- `scripts/game_manager.gd` (autoload) - cats, CPC/CPS, upgrades, autosave every 30s, save on focus loss
- `scripts/setting_manager.gd` (autoload) - sound setting
- `scripts/upgrade_api.gd` - one data table for names, base prices, CPC/CPS (price = base x 1.15^n)
- `scripts/save_system.gd` - JSON + SHA-256 hash in `user://` (IndexedDB on web)
- `scripts/ui/` - one script per Unity UI script
- `scenes/main.tscn`, `scenes/upgrade_row.tscn`

## Not ported
Tab system (`Tab.cs` / Tab View prefab, not used in the scene), editor-only `GameDebugWindow`, the "APPLY" button, `.xcf` source art (still in the Unity repo), TextMeshPro fonts.
