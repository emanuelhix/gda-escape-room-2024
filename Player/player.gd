extends CharacterBody3D

#	New end position
var endPos:Vector3 = Vector3();
#	Current player position
var player_pos: Vector3 = Vector3();
#	Angle for Player to turn with
var dir_angle:float = 0;
#	Input cooldown
var cooldown_timer: float = 0.0

#	Sets position when scene begins
func _ready():
	player_pos = global_transform.origin

func _process(delta: float) -> void:
	#	Count CD timer down
	if cooldown_timer > 0.0:
		cooldown_timer -= delta
	
	#	If any direction input pressed + CD timer is <= 0, Perform movement and turning
	if (Input.is_action_pressed("Left") || Input.is_action_pressed("Right") || Input.is_action_pressed("Forward") || Input.is_action_pressed("Back")) && cooldown_timer <= 0.0: 
		if Input.is_action_pressed("Left"):
			endPos = player_pos + Vector3(-5, 0 ,0)
			dir_angle = 90;
		elif Input.is_action_pressed("Right"):
			endPos = player_pos + Vector3(5, 0 ,0)
			dir_angle = -90;
		elif Input.is_action_pressed("Forward"):
			endPos = player_pos + Vector3(0, 0 ,-5)
			dir_angle = 0;
		elif Input.is_action_pressed("Back"):
			endPos = player_pos + Vector3(0, 0 ,5)
			dir_angle = 180;
			
		
		##	TODO: 
		##	This shit ain't interpolating lmao. 
		##	I imagine one can implement a function that is dedicated to
		##	interpolating the Player to the new endPos which would disable any movement
		##	from the _process function. You can probably do this with the cooldown_timer?
		
		##	TODO:
		##	There is also no "turning" interpolation. The player instantly turns.
		
		#	Player position is "interpolated" to new Endpos 
		player_pos = player_pos.lerp(endPos, delta * 20)
		global_transform.origin = player_pos;
		#	Set input CD to be 0.1s
		cooldown_timer = 0.1;
