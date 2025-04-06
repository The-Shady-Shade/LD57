extends Control

var text: Array[String] = [
	"Huh...",
]

func _ready() -> void:
	await get_tree().create_timer(1).timeout
	dialog_manager.start_dialog(text, global_position)
	await dialog_manager.finished
	get_tree().quit()
