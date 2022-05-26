extends KinematicBody2D
class_name Agent

var food
export (int) var speed = 200
export var num_rays = 8
export var steer_force = .1
export var look_ahead = 8

var target = Vector2()
var velocity = Vector2()
var acceleration = Vector2.ZERO

var interests = []
var dangers = []
var ray_directions = []
var chosen_dir = Vector2.ZERO

var generation = 1

var stats

onready var generation_label = $GenLabel

func _ready():
	stats = $Stats/GameplayAttributeMap
	interests.resize(num_rays)
	dangers.resize(num_rays)
	ray_directions.resize(num_rays)
	for i in num_rays:
		var angle = i * 2 * PI / num_rays
		ray_directions[i] = Vector2.RIGHT.rotated(angle)
	generation_label.set_text("%s" % generation)

func _draw():
	pass

func task_idle(task):
	task.succeed()
	pass

func task_check_dead(task):
	task.succeed()
	return
	
func task_check_hungry(task):
	if stats.get_attribute_value("Hunger") >= 10:
		task.succeed()
		return
	task.failed()
	return
	
func task_die(task):
	EventBus.emit_signal("agent_death", self)
	task.succeed()
	return
	
func task_walk_to_food(task):
	_walk(food[0].position)
	if position.distance_to(target) > 50:
		task.failed()
	else:
		task.succeed()
	return

func task_search_for_food(task):
	food = get_tree().get_nodes_in_group("food")
	if food.size() == 0:
		task.failed()
	else:
		task.succeed()
	return

func task_consume_food(task):
	task.succeed()
	return
	
func _walk(xtarget):
	target = xtarget

func _get_closest_food() -> Node2D:
	var current_closest = null
	var food_nodes = get_tree().get_nodes_in_group("food")
	if food_nodes.size() > 0:
		var distance = position.distance_to(food_nodes[0].position)
		for i in food_nodes.size():
			if position.distance_to(food_nodes[i].position) <= distance:
				current_closest = food_nodes[i]
	return current_closest

func _physics_process(delta):
	update()
