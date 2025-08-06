extends Camera2D

const regular_speed = Vector2(1,0)
const max_speed = Vector2(2,0)
const acceleration = Vector2(.012,0)
const deceleration = Vector2(.02,0)

var scroll_speed:Vector2 = regular_speed
var speed_up:bool

func _process(delta):
	if speed_up && scroll_speed.x < max_speed.x:
		scroll_speed += acceleration
	elif !speed_up && scroll_speed.x > regular_speed.x:
		scroll_speed -= deceleration
	position += scroll_speed
	
		

func _input(event):
	if event.is_action_pressed("button_up"):
		#speed up
		speed_up = true
	if event.is_action_pressed("button_down"):
		#slow down
		speed_up = false


func _on_level_end_check_area_entered(area):
	if area.name == "stage_end":
		print("STAGE CLEAR")
