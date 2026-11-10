class_name UIState
extends RefCounted
## Port of UIState.cs

enum OpenedInterface { NONE, SETTING, UPGRADE }

static var state: OpenedInterface = OpenedInterface.NONE
