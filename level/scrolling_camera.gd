extends Camera3D

@export var camera_max_anim_time: float = 3.0  # Maximum animation time for camera movement
@export var camera_min_anim_time: float = 0.38  # Minimum animation time for camera movement
@export var speed: float = 1.2  # Speed at which the camera moves
@export var offset_marker: Marker3D = null  # Marker that defines the camera's target offset
@export var player: CharacterBody3D = null  # Reference to the player character

var camera_tween: Tween # Tween instance for animating the camera movement
var last_z: float = 0 # Last camera Z position for preventing the camera from going backwards.
var global_override: bool = true

func _ready() -> void:
	self.global_position = offset_marker.global_position
	# Connect signals to handle player movement events
	#player.move_start.connect(on_player_started_moving)
	player.move_end.connect(on_player_ended_moving)

func _process(delta: float) -> void:
	last_z = self.global_position.z
	# If a camera tween is active, skip the camera update to avoid conflicts
	if camera_tween and camera_tween.is_running():
		return

	# Move the camera along the z-axis at the defined speed
	if can_update_camera():
		global_position.z += delta * -speed

func tween_camera_to_offset() -> void:
	# Stop any active tween before starting a new one
	if camera_tween and camera_tween.is_running():
		camera_tween.stop()
	var marker_pos = offset_marker.global_position
	var distance = abs(marker_pos.z - global_position.z)
	last_z = min(marker_pos.z, last_z)
	if !can_update_camera():
		# update along x axis still
		camera_tween = get_tree().create_tween()
		camera_tween.tween_property(self, "global_position", Vector3(marker_pos.x, marker_pos.y, self.global_position.z), camera_min_anim_time)
		camera_tween.set_ease(Tween.EASE_IN)
		camera_tween.play()
		return
	# Calculate animation time based on distance; ensure it stays within defined limits
	var anim_time = (camera_max_anim_time / distance) if distance > 1 else camera_min_anim_time
	# Tween the camera's global position to the marker's position over the calculated time
	# Don't pause the camera with tweening if the player moves backwards.
	camera_tween = get_tree().create_tween()
	camera_tween.tween_property(self, "global_position", Vector3(marker_pos.x, marker_pos.y, last_z), anim_time)
	camera_tween.set_ease(Tween.EASE_IN)
	camera_tween.play()

func on_player_started_moving() -> void:
	pass

func on_player_ended_moving() -> void:
	# Tween the camera to the offset when the player stops moving
	tween_camera_to_offset()

func can_update_camera():
	# we use >= to account for moving only along the x direction (strafing)
	return global_override and !last_z > self.global_position.z

func force_reset():
	global_override = false
	if camera_tween and camera_tween.is_running():
		camera_tween.stop()
	self.global_position = offset_marker.global_position
	last_z = self.global_position.z
	global_override = true
