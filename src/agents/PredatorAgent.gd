extends Agent



# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var prey
export (int) var arena_offset
var rng = RandomNumberGenerator.new()



# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	._ready()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func task_check_dead(task):
	if stats.get_attribute_value("Energy") <= 0 or stats.get_attribute_value("Hunger") >= 100:
		task.succeed()
		return
	task.failed()
	

func task_prey_near(task):
	var space_state = get_world_2d().direct_space_state
	for i in num_rays:
		var result = space_state.intersect_ray(position,
				position + ray_directions[i].rotated(rotation) * look_ahead,
				[self])
		if result:
			dangers[i] = 1
			if get_tree().get_nodes_in_group("prey").has(result.collider):
				prey = result.collider
				task.succeed()
				return
		else:
			dangers[i] = 0
			prey = null
	task.failed()
	return
	
func task_move_to_random(task):
	var distance = position.distance_to(target)
	if position.distance_to(target) <= 50:
		target = null
		velocity = Vector2.ZERO
	if !target:
		var rando_target_position = Vector2()
		rando_target_position.x = rng.randi_range(0 + arena_offset, get_parent().get_node("Arena").rect_size.x - arena_offset)
		rando_target_position.y = rng.randi_range(0 + arena_offset, get_parent().get_node("Arena").rect_size.y - arena_offset)
		target = rando_target_position
	look_at(target)
	velocity = position.direction_to(target) * speed
	task.succeed()
	
	

func task_move_towards_prey(task):
	if prey:
		look_at(prey.position)
		velocity = position.direction_to(prey.position) * speed
		task.succeed()
		return
	velocity = Vector2.ZERO
	task.failed()

func task_consume_prey(task):
	var distance = position.distance_to(prey.position)
	if position.distance_to(prey.position) > 70:
		task.failed()
		return
	var hunger_effect = DamageGameplayEffect.new()
	var energy_effect = RestoreGameplayEffect.new()
	hunger_effect.damage_max = prey.stats.get_attribute_value("Health") - prey.stats.get_attribute_value("Hunger")
	hunger_effect.damage_min = prey.stats.get_attribute_value("Health") - prey.stats.get_attribute_value("Hunger")
	hunger_effect.attribute_name = "Hunger"
	energy_effect.value = prey.stats.get_attribute_value("Energy")
	energy_effect.attribute_name = "Energy"
	stats.add_child(hunger_effect)
	stats.add_child(energy_effect)
	EventBus.emit_signal("agent_death", prey)
	prey = null
	velocity = Vector2.ZERO
	task.succeed()
	
func _physics_process(delta):
	velocity = move_and_slide(velocity)
	update()
	
func _draw():
#	if prey != null:
#		draw_line(Vector2.ZERO, (prey.position - position).rotated(-rotation), Color.blue)
#		draw_circle((prey.position - position).rotated(-rotation), 5, Color.blue)
#	if target:
#		draw_line(Vector2.ZERO, (target - position).rotated(-rotation), Color.blue)
#		draw_circle((target - position).rotated(-rotation), 5, Color.blue)
#	for i in ray_directions.size():
#		if dangers[i] == 1:
#			draw_line(Vector2.ZERO,ray_directions[i] * look_ahead, Color.green)
#			draw_circle(ray_directions[i] * look_ahead, 5, Color.green)
#		else:
#			draw_line(Vector2.ZERO,ray_directions[i] * look_ahead, Color.red)
#			draw_circle(ray_directions[i] * look_ahead, 5, Color.red)
	pass
