extends Button
## Port of UpgradeButtons.cs + CostDP.cs + AmountDP.cs (one row = icon, name, cost, owned amount).
## Children: Icon (TextureRect), Name / Cost / Amount (Label), Mask (ColorRect dimmer).
## Set `upgrade_name` to a key of UpgradeAPI.DATA.

enum ButtonState { AVAILABLE, NOT_AFFORDABLE, SHADOW, UNREVEALED }

@export var upgrade_name: String = ""
@export var row_icon: Texture2D

@onready var _icon: TextureRect = $Icon
@onready var _mask: ColorRect = $Mask
@onready var _name_label: Label = $Name
@onready var _cost_label: Label = $Cost
@onready var _amount_label: Label = $Amount

var _last_state := -1
var _last_amount := -1


func _ready() -> void:
	_icon.texture = row_icon
	_name_label.text = UpgradeAPI.display_name(upgrade_name)


func _process(_delta: float) -> void:
	var owned := GameManager.get_upgrade(upgrade_name)
	var price := UpgradeAPI.get_calculated_price(upgrade_name, owned)

	_cost_label.text = "%s Cats" % NumberFormatter.format_double(price)
	if owned != _last_amount:
		_amount_label.text = str(owned)
		_last_amount = owned

	var state := _evaluate_state(price)
	_apply_reveal_side_effect(state)
	if state != _last_state:
		_apply_state(state)
		_last_state = state


## Connect this row's "pressed" signal to this yourself.
func on_clicked() -> void:
	var price := UpgradeAPI.get_calculated_price(upgrade_name, GameManager.get_upgrade(upgrade_name))
	if GameManager.cats < price:
		return
	GameManager.add_cat(-price)
	GameManager.add_upgrade(upgrade_name, 1)


func _evaluate_state(price: float) -> int:
	var cats := GameManager.cats
	if cats >= price:
		return ButtonState.AVAILABLE
	if GameManager.get_revealed(upgrade_name):
		return ButtonState.NOT_AFFORDABLE
	if cats >= UpgradeAPI.get_price(upgrade_name) * 0.9:
		return ButtonState.SHADOW
	return ButtonState.UNREVEALED


# Only place allowed to WRITE shared state, and only once the condition is truly met.
func _apply_reveal_side_effect(state: int) -> void:
	if state == ButtonState.AVAILABLE and not GameManager.get_revealed(upgrade_name):
		GameManager.set_revealed(upgrade_name, true)


func _apply_state(state: int) -> void:
	match state:
		ButtonState.AVAILABLE:
			modulate.a = 1.0
			_mask.visible = false
			disabled = false
			_icon.modulate = Color.WHITE
		ButtonState.NOT_AFFORDABLE:
			modulate.a = 1.0
			_mask.visible = true
			disabled = true
			_icon.modulate = Color.WHITE
		ButtonState.SHADOW:
			modulate.a = 1.0
			_mask.visible = true
			disabled = true
			_icon.modulate = Color.BLACK # silhouette
		ButtonState.UNREVEALED:
			modulate.a = 0.0 # invisible but keeps its slot in the list
			_mask.visible = true
			disabled = true
