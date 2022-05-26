extends MarginContainer

var target
export (Vector2) var target_offset = Vector2(-39, -91)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	rect_position = target.position + target_offset
	rect_rotation = 0
	pass

func set_target(xtarget):
	target = xtarget
