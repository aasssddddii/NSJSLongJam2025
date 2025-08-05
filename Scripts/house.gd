extends Sprite2D


var house_data:Dictionary


func _ready():
	$Area2D.body_entered.connect(potion_recieved)
	
	
func potion_recieved(body:Node2D):
	print("something recieved: ", body.name)
