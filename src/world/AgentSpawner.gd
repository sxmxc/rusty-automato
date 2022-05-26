extends Node2D

export (PackedScene) var prey_scene
export (PackedScene) var predator_scene
export (int) var arena_offset

export (int) var initial_predators
export (int) var initial_prey

var rng = RandomNumberGenerator.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	EventBus.connect("agent_death",self,"_on_agent_death")
	var num_predetors = get_tree().get_nodes_in_group("predator").size()
	var num_prey = get_tree().get_nodes_in_group("prey").size()
	if num_predetors < initial_predators:
		var dif = initial_predators - num_predetors
		for i in dif:
			_spawn_predator(1)
	if num_prey < initial_prey:
		var dif = initial_prey - num_prey
		for i in dif:
			_spawn_prey(1)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_agent_death(agent):
	print("Agent death: " + agent.name)
	if agent.name == "PredatorAgent":
		_spawn_predator(agent.generation + 1)
	else:
		_spawn_prey(agent.generation + 1)
	pass

func _spawn_predator(generation):
	var new_agent = predator_scene.instance()
	var spawn_target_position = Vector2()
	spawn_target_position.x = rng.randi_range(0 + arena_offset, get_parent().get_node("Arena").rect_size.x - arena_offset)
	spawn_target_position.y = rng.randi_range(0 + arena_offset, get_parent().get_node("Arena").rect_size.y - arena_offset)
	new_agent.position = spawn_target_position
	new_agent.generation = generation
	get_parent().call_deferred("add_child", new_agent)

func _spawn_prey(generation):
	var new_agent = prey_scene.instance()
	var spawn_target_position = Vector2()
	spawn_target_position.x = rng.randi_range(0 + arena_offset, get_parent().get_node("Arena").rect_size.x - arena_offset)
	spawn_target_position.y = rng.randi_range(0 + arena_offset, get_parent().get_node("Arena").rect_size.y - arena_offset)
	new_agent.position = spawn_target_position
	new_agent.generation = generation
	get_parent().call_deferred("add_child", new_agent)
