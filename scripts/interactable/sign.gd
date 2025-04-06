extends Node2D

@export var text: Array[String] = []
var finished: bool = false

func _on_interaction_area_body_entered(body: Node2D) -> void:
	if body == global.player && !finished:
		dialog_manager.start_dialog(text, global_position)
		finished = true
