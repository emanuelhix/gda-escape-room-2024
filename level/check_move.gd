# unused script

extends RayCast3D  # or Node3D in Godot 4.x

@onready var player = get_parent()

func _ready():
	pass

func _process(delta):
	# Update the RayCast to check for collisions
	if not player:
		return
	#self.target_position = player.end_position
