extends Camera3D

@export var camera_max_anim_time: float = 5.0  # Maximum animation time for camera movement
@export var camera_min_anim_time: float = 0.5  # Minimum animation time for camera movement
@export var speed: float = 1.5  # Speed at which the camera moves
@export var offset_marker: Marker3D = null  # Marker that defines the camera's target offset
@export var player: CharacterBody3D = null  # Reference to the player character

var can_update_camera: bool = true
var camera_tween: Tween = null  # Tween instance for animating the camera movement

func _ready() -> void:
	# Connect signals to handle player movement events
	player.move_start.connect(on_player_started_moving)
	player.move_end.connect(on_player_ended_moving)

func _process(delta: float) -> void:
	# If a camera tween is active, skip the camera update to avoid conflicts
	if camera_tween and camera_tween.is_running():
		return

	# Move the camera along the z-axis at the defined speed
	if can_update_camera:
		global_position.z += delta * -speed

func tween_camera_to_offset() -> void:
	# Stop any active tween before starting a new one
	if camera_tween and camera_tween.is_running():
		camera_tween.stop()
	
	camera_tween = get_tree().create_tween()
	var marker_pos = offset_marker.global_position
	var distance = abs(marker_pos.z - global_position.z)
	
	# Calculate animation time based on distance; ensure it stays within defined limits
	var anim_time = (camera_max_anim_time / distance) if distance > 1 else camera_min_anim_time

	# Tween the camera's global position to the marker's position over the calculated time
	camera_tween.tween_property(self, "global_position", marker_pos, anim_time)
	camera_tween.set_ease(Tween.EASE_IN)
	camera_tween.play()

func on_player_started_moving() -> void:
	# Disable camera updates when the player starts moving
	can_update_camera = false

func on_player_ended_moving() -> void:
	# Tween the camera to the offset when the player stops moving
	tween_camera_to_offset()
	can_update_camera = true
