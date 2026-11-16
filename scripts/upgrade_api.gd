class_name UpgradeAPI
extends RefCounted
## Port of UpgradeAPI.cs. One data table replaces all the per-upgrade switch statements.
## Add a new upgrade by adding one entry here (plus a row in the upgrade menu).

const GROWTH := 1.15 # Cookie Clicker style: base * 1.15^n

# base = starting price, cpc = cats-per-click added per level, cps = cats-per-second added per level
const DATA := {
	"Cozy Spot":  {"display": "Cozy Nap Spot"  , "base": 20.0        , "cpc": 0.0, "cps": 0.1},
	"Sharp Claw": {"display": "Sharper Claws"  , "base": 100.0       , "cpc": 1.0, "cps": 0.0},
	"Fish Bowl":  {"display": "Fish Bowl"      , "base": 100.0       , "cpc": 0.0, "cps": 1.0},
	"TV":         {"display": "Cat TV Channel" , "base": 1000.0      , "cpc": 0.0, "cps": 3.0},
	"Laser":      {"display": "Automated Laser", "base": 50000.0     , "cpc": 0.0, "cps": 50.0},
	"Factory":    {"display": "Kitten Factory" , "base": 10000000.0  , "cpc": 0.0, "cps": 200.0},
	"Satellite":  {"display": "Satellite Dish" , "base": 5000000000.0, "cpc": 0.0, "cps": 3000.0},
}


## Get every upgrade's name
static func names() -> Array:
	return DATA.keys()

## Check if upgrade name exists
static func exists(upgrade_name: String) -> bool:
	return DATA.has(upgrade_name)

## Get display name aka *friendly name*
static func display_name(upgrade_name: String) -> String:
	return DATA[upgrade_name]["display"] if DATA.has(upgrade_name) else upgrade_name


static func get_price(upgrade_name: String) -> float:
	if not DATA.has(upgrade_name):
		push_error("No upgrade with name \"%s\" found" % upgrade_name)
		return 0.0
	return DATA[upgrade_name]["base"]


## Price of the NEXT level, given how many the player already owns.
static func get_calculated_price(upgrade_name: String, owned: int) -> float:
	return get_price(upgrade_name) * pow(GROWTH, owned)
