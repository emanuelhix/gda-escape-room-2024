extends Camera3D

@export var CAMERA_MAX_ANIM_TIME = 5
@export var CAMERA_MIN_ANIM_TIME = 0.5
@export var SPEED: float = 1.5
@export var offset_marker: Marker3D = null
@export var player: CharacterBody3D = null


var can_update_camera: bool = true
var camera_tween = null

func _ready() -> void:
	player.move_start.connect(on_player_started_moving)
	player.move_end.connect(on_player_ended_moving)

func _process(delta: float) -> void:
	if camera_tween and camera_tween.is_running():
		return

	if can_update_camera:
		global_position.z += delta * -SPEED

func tween_camera_to_offset() -> void:
	if camera_tween and camera_tween.is_running():
		camera_tween.stop()
	
	camera_tween = get_tree().create_tween()
	var marker_pos = offset_marker.global_position
	var distance = abs(marker_pos.z - global_position.z)
	
	# time decreases as distance increases. if distance < 1, time would increase, so we just default to the min time.
	# this function is just c/x with some sanity checks.
	var anim_time = (CAMERA_MAX_ANIM_TIME / distance) if distance > 1 else CAMERA_MIN_ANIM_TIME

	camera_tween.tween_property(self, "global_position", marker_pos, anim_time)
	camera_tween.play()

func on_player_started_moving() -> void:
	can_update_camera = false

func on_player_ended_moving() -> void:
	tween_camera_to_offset()
	can_update_camera = true
