extends CanvasLayer

@onready var control = $Node/Control/BackgroundTexture
@export var timer_label : Label = null
@onready var final_time_label : Label = $Node/Control/FinalTime
@onready var final_msg_lbl : Label = $Node/Control/FinalMessage

func fade_to_black(is_winner : bool):
	var fade_tween = get_tree().create_tween()
	fade_tween.tween_property(control, "modulate", Color(Color.BLACK, 1), 2)
	fade_tween.play()
	fade_tween.tween_callback(func(): tween_callback(is_winner))

func tween_callback(is_winner : bool):
	final_time_label.text = "Clear Time: " + timer_label.text
	if is_winner:
		final_time_label.show()
	final_msg_lbl.text = "You escaped." if is_winner else "Game Over."
	final_msg_lbl.show()
