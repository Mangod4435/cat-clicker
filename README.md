# Cat Clicker (Godot 4.7)

Port of the Unity WebGL version. Renderer: Compatibility (web-friendly). Viewport 2560x1440 (same as the Unity canvas), stretch mode `canvas_items`.

## Signals are NOT connected
Every handler exists as a public method, but no signal is wired. Connect them in the editor (Node dock → Signals):

| Node (in `scenes/main.tscn`) | Signal | Method |
|---|---|---|
| `Cat` | `pressed` | `on_clicked` |
| `UpgradeMenu` | `pressed` | `on_clicked` |
| `SettingButton` | `pressed` | `on_clicked` |
| `SettingsPanel/.../SoundToggle` | `toggled` | `on_toggled` |
| `SettingsPanel/.../SaveButton` | `pressed` | `on_clicked` |
| `SettingsPanel/.../ResetButton` | `pressed` | `on_clicked` |
| each of the 7 rows under `UpgradeMenu/Panel/.../Rows` | `pressed` | `on_clicked` |

## Layout
- `scripts/game_manager.gd` (autoload) - cats, CPC/CPS, upgrades, autosave every 30s, save on focus loss
- `scripts/setting_manager.gd` (autoload) - sound setting
- `scripts/upgrade_api.gd` - one data table for names, base prices, CPC/CPS (price = base x 1.15^n)
- `scripts/save_system.gd` - JSON + SHA-256 hash in `user://` (IndexedDB on web)
- `scripts/ui/` - one script per Unity UI script
- `scenes/main.tscn`, `scenes/upgrade_row.tscn`

## Not ported
Tab system (`Tab.cs` / Tab View prefab, not used in the scene), editor-only `GameDebugWindow`, the "APPLY" button, `.xcf` source art (still in the Unity repo), TextMeshPro fonts.
