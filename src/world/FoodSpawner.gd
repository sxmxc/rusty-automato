extends Node2D

export (PackedScene) var food_scene
export (int) var arena_offset

export (Array, PackedScene) var available_food

var rng = RandomNumberGenerator.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	EventBus.connect("food_consumed",self,"_on_food_consumed")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_food_consumed():
	var random_idx = rng.randi_range(0, available_food.size() -1)
	food_scene = available_food[random_idx]
	if food_scene != null:
		var spawn_target = food_scene.instance()
		var spawn_target_position = Vector2()
		spawn_target_position.x = rng.randi_range(0 + arena_offset, get_parent().get_node("Arena").rect_size.x - arena_offset)
		spawn_target_position.y = rng.randi_range(0 + arena_offset, get_parent().get_node("Arena").rect_size.y - arena_offset)
		spawn_target.position = spawn_target_position
		get_parent().add_child(spawn_target)
	pass
