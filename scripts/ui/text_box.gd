extends MarginContainer

signal finished

@export var label: Label
@export var timer: Timer
@export var text_sfx: AudioStreamPlayer

var max_width: float = 256.0
var text: String = ""
var letter_index: int = 0
var letter_time: float = 0.03
var space_time: float = 0.06
var punctuation_time: float = 0.2

func display_text(text_to_display: String) -> void:
	text = text_to_display
	label.text = text_to_display
	await resized
	custom_minimum_size.x = min(size.x, max_width)
	if size.x > max_width:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		await resized
		await resized
		custom_minimum_size.y = size.y
	global_position.x -= size.x / 4
	global_position.y -= size.y + 12
	label.text = ""
	display_letter()

func display_letter() -> void:
	label.text += text[letter_index]
	letter_index += 1
	if letter_index >= text.length():
		finished.emit()
		return
	match text[letter_index]:
		"!", "?", ".", ",":
			timer.start(punctuation_time)
		" ":
			timer.start(space_time)
		_:
			timer.start(letter_time)
			var new_text_sfx = text_sfx.duplicate()
			new_text_sfx.pitch_scale += randf_range(-0.1, 0.1)
			if text[letter_index] in ["a", "e", "i", "o", "u"]:
				new_text_sfx.pitch_scale += 0.2
			get_tree().root.add_child(new_text_sfx)
			new_text_sfx.play()
			await new_text_sfx.finished
			new_text_sfx.queue_free()

func _on_letter_display_timer_timeout() -> void:
	display_letter()
