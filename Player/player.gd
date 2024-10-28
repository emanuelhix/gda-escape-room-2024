extends CharacterBody3D

const LEFT: String = "left"
const FORWARD: String = "forward"
const BACK: String = "back"
const RIGHT: String = "right"
const MOVE_DURATION: float = 0.25

signal move_start  # Fires when the movement animation starts
signal move_end    # Fires when the movement animation ends

# New end position
var end_position: Vector3 = Vector3()  # Renamed for clarity

# Angle for player to turn with
var dir_angle: float = 0.0  # Type specified for clarity

var tween: Tween = null

func _process(delta: float) -> void:
	if tween and tween.is_running():
		return

	var action_mapping = {
		LEFT: Vector3(-5, 0, 0),
		RIGHT: Vector3(5, 0, 0),
		FORWARD: Vector3(0, 0, -5),
		BACK: Vector3(0, 0, 5)
	}

	var direction: Vector3 = Vector3.ZERO
	var action_pressed: bool = false

	for action in action_mapping.keys():
		if Input.is_action_pressed(action):
			direction = action_mapping[action]
			match action:
				LEFT: dir_angle = 90
				RIGHT: dir_angle = -90
				FORWARD: dir_angle = 0
				BACK: dir_angle = 180
			action_pressed = true
			break  # Exit the loop once an action is pressed

	if not action_pressed:
		return

	print("Turning angle: " + str(dir_angle))
	end_position = global_position + direction
	tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", end_position, MOVE_DURATION)
	tween.tween_callback(move_end.emit)
	move_start.emit()
	tween.play()
