extends Label
## Port of CatsTextDP.cs

var _last_cats := -1.0


func _process(_delta: float) -> void:
	if GameManager.cats != _last_cats:
		text = "%s cats" % NumberFormatter.format_double(GameManager.cats)
		_last_cats = GameManager.cats
