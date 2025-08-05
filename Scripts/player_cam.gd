extends Camera2D

const scroll_speed = Vector2(1,0)


func _process(delta):
	position += scroll_speed
