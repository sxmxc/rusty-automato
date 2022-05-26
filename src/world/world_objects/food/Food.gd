extends Sprite


export(Resource) var food_data


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body):
	if get_tree().get_nodes_in_group("obstacles").has(body):
		position += Vector2(50,-50)
	pass # Replace with function body.
