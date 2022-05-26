extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Hunger_attribute_changed(attribute):
	EventBus.emit_signal("hunger_updated", attribute.current_value, owner)
	pass # Replace with function body.


func _on_Energy_attribute_changed(attribute):
	EventBus.emit_signal("energy_updated", attribute.current_value, owner)
	pass # Replace with function body.


func _on_Health_attribute_changed(attribute):
	EventBus.emit_signal("health_updated", attribute.current_value, owner)
	pass # Replace with function body.
