extends Control

var text: Array[String] = [
	"Hello there!",
	"This story starts here...",
]

func _ready() -> void:
	await get_tree().create_timer(1).timeout
	dialog_manager.start_dialog(text, global_position)
