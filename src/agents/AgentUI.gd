extends CanvasLayer


onready var stat_box = $StatBox
onready var health_bar = $StatBox/VBoxContainer/HealthBar
onready var hunger_bar = $StatBox/VBoxContainer/HungerBar
onready var energy_bar = $StatBox/VBoxContainer/EnergyBar


# Called when the node enters the scene tree for the first time.
func _ready():
	stat_box.set_target(get_parent())
	EventBus.connect("energy_updated", self, "_on_energy_updated")
	EventBus.connect("health_updated", self, "_on_health_updated")
	EventBus.connect("hunger_updated", self, "_on_hunger_updated")
	pass # Replace with function body.

func _on_energy_updated(value, source):
	if source == owner:
		energy_bar.set_value(value)

func _on_health_updated(value, source):
	if source == owner:
		health_bar.set_value(value)
	
func _on_hunger_updated(value, source):
	if source == owner:
		hunger_bar.set_value(value)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
