extends Agent


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var target_food
var threat

# Called when the node enters the scene tree for the first time.
func _ready():
	._ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func task_check_dead(task):
	if stats.get_attribute_value("Energy") <= 0 or stats.get_attribute_value("Hunger") >= 100:
		task.succeed()
		return
	task.failed()

func task_check_hungry(task):
#	if stats.get_attribute_value("Hunger") >= 10:
#		task.succeed()
#		return
#	task.failed()
	task.succeed()
	return

func task_consume_food(task):
	if position.distance_to(target_food.position) > 50:
		task.failed()
		return
	else:
		var hunger_effect = DamageGameplayEffect.new()
		var energy_effect = RestoreGameplayEffect.new()
		hunger_effect.damage_max = target_food.food_data.nutrition
		hunger_effect.damage_min = target_food.food_data.nutrition
		hunger_effect.attribute_name = "Hunger"
		energy_effect.value = target_food.food_data.calories
		energy_effect.attribute_name = "Energy"
		stats.add_child(hunger_effect)
		stats.add_child(energy_effect)
		target_food.queue_free()
		EventBus.emit_signal("food_consumed")
		task.succeed()

func task_find_closest_food(task):
	target_food = _get_closest_food()
	if target_food && !threat:
		task.succeed()
	else:
		velocity = Vector2.ZERO
		task.failed()

func task_is_target_close(task):
	if position.distance_to(target_food.position) <= 15:
		task.succeed()
		return
	else:
		task.failed()

func task_move_towards_target(task):
	look_at(target_food.position)
	velocity = position.direction_to(target_food.position) * speed
	task.succeed()
	return

func task_enemy_close(task):
	var space_state = get_world_2d().direct_space_state
	for i in num_rays:
		var result = space_state.intersect_ray(position,
				position + ray_directions[i].rotated(rotation) * look_ahead,
				[self])
		if result:
			dangers[i] = 1
			if get_tree().get_nodes_in_group("blue").has(result.collider):
				threat = result.collider
				task.succeed()
				return
		else:
			dangers[i] = 0
			threat = null
	task.failed()
	return

func task_avoid_enemy(task):
	target_food = null
	var op_direction = -position.direction_to(threat.position)
	velocity = op_direction.normalized() * speed
	task.succeed()
	return

func _physics_process(delta):
	move_and_slide(velocity)
	update()

func _draw():
	if target_food:
		draw_line(Vector2.ZERO, (target_food.position - position).rotated(-rotation), Color.blue)
		draw_circle((target_food.position - position).rotated(-rotation), 5, Color.blue)
	for i in ray_directions.size():
		if dangers[i] == 1:
			draw_line(Vector2.ZERO,ray_directions[i] * look_ahead, Color.green)
			draw_circle(ray_directions[i] * look_ahead, 5, Color.green)
		else:
			draw_line(Vector2.ZERO,ray_directions[i] * look_ahead, Color.red)
