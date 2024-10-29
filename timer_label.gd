# This script is intended to be attached to a label and expects a timer export.
# It will update the label's text to be formatted with the amount of time left on the timer in hours:minutes:second form.

extends Label

@export var game_timer : Timer = null

func _process(_delta: float) -> void:
	self.text = seconds2hhmmss(game_timer.time_left)
	# clean up process function after the timer is done running.
	if game_timer.time_left <= 0:
		self.set_process(false)

func seconds2hhmmss(total_seconds: float) -> String:
	var seconds:float = fmod(total_seconds , 60.0)
	var minutes:int   =  int(total_seconds / 60.0) % 60
	var hours:  int   =  int(total_seconds / 3600.0)
	var hhmmss_string:String = "%02d:%02d:%05.2f" % [hours, minutes, seconds]
	return hhmmss_string
