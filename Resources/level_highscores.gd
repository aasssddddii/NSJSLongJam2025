extends Resource
class_name Highscore_Library

#var default_level_data:Dictionary = {
	#"deliveries_made":0,
	#"houses_hit":0,
	#"angry_clients":0,
	#"score":0,
	#"profit":0,
	#"completed":false
#}
@export var level_1_data:Dictionary = {
	"deliveries_made":0,
	"houses_hit":0,
	"angry_clients":0,
	"score":0,
	"profit":0,
	"completed":false
}
@export var level_2_data:Dictionary= {
	"deliveries_made":0,
	"houses_hit":0,
	"angry_clients":0,
	"score":0,
	"profit":0,
	"completed":false
}
@export var level_3_data:Dictionary = {
	"deliveries_made":0,
	"houses_hit":0,
	"angry_clients":0,
	"score":0,
	"profit":0,
	"completed":false
}
@export var level_4_data:Dictionary= {
	"deliveries_made":0,
	"houses_hit":0,
	"angry_clients":0,
	"score":0,
	"profit":0,
	"completed":false
}
@export var level_5_data:Dictionary= {
	"deliveries_made":0,
	"houses_hit":0,
	"angry_clients":0,
	"score":0,
	"profit":0,
	"completed":false
}
@export var level_6_data:Dictionary= {
	"deliveries_made":0,
	"houses_hit":0,
	"angry_clients":0,
	"score":0,
	"profit":0,
	"completed":false
}
@export var level_7_data:Dictionary= {
	"deliveries_made":0,
	"houses_hit":0,
	"angry_clients":0,
	"score":0,
	"profit":0,
	"completed":false
}

@export var levels:Array[Dictionary] = [level_1_data,level_2_data,level_3_data,level_4_data,level_5_data,level_6_data,level_7_data]

func is_level_complete(level:int):
	var level_ref = levels[level-1]
	return level_ref["completed"]
	
func get_level_highscore(level:int):
	match level:
		1:
			return level_1_data
		2:
			return level_2_data
		3:
			return level_3_data
		4:
			return level_4_data
		5:
			return level_5_data
		6:
			return level_6_data
		7:
			return level_7_data
		_:
			pass

func get_level_data(level:int):
	match level:
		1:
			return level_1_data
		2:
			return level_2_data
		3:
			return level_3_data
		4:
			return level_4_data
		5:
			return level_5_data
		6:
			return level_6_data
		7:
			return level_7_data
		_:
			pass

##SETINGS
@export var shown_end_credits:bool#needs to be exported to level highscore for ease of saving
@export var shown_intro_scene:bool#needs to be exported to level highscore for ease of saving
@export var shown_overtime_intro_scene:bool#needs to be exported to level highscore for ease of saving
@export var level_5_complete:bool

@export var values_set:bool
@export var colorblind_mode:bool
@export var fullscreen:int
@export var game_muted:bool
@export var sfx_volume:int = 0#
@export var music_volume:int = 10#
