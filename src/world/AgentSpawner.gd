extends Node2D

export (PackedScene) var prey_scene
export (PackedScene) var predator_scene
export (int) var arena_offset



var rng = RandomNumberGenerator.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	EventBus.connect("agent_death",self,"_on_agent_death")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_agent_death(agent):
	print("Agent death: " + agent.name)
	var new_agent
	if agent.name == "BlueAgent":
		new_agent = predator_scene.instance()
	else:
		new_agent = prey_scene.instance()
	if new_agent != null:
		var spawn_target_position = Vector2()
		spawn_target_position.x = rng.randi_range(0 + arena_offset, get_parent().get_node("Arena").rect_size.x - arena_offset)
		spawn_target_position.y = rng.randi_range(0 + arena_offset, get_parent().get_node("Arena").rect_size.y - arena_offset)
		new_agent.position = spawn_target_position
		new_agent.generation = agent.generation + 1
		get_parent().add_child(new_agent)
	pass
