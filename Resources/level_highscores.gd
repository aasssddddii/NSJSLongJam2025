extends Resource
class_name Highscore_Library

var default_level_data:Dictionary = {
	"deliveries_made":0,
	"houses_hit":0,
	"angry_clients":0,
	"score":0,
	"profit":0,
	"completed":false
}
var level_1_data:Dictionary = default_level_data.duplicate()
var level_2_data:Dictionary = default_level_data.duplicate()
var level_3_data:Dictionary = default_level_data.duplicate()
var level_4_data:Dictionary = default_level_data.duplicate()
var level_5_data:Dictionary = default_level_data.duplicate()
var level_6_data:Dictionary = default_level_data.duplicate()
var level_7_data:Dictionary = default_level_data.duplicate()

var levels:Array[Dictionary] = [level_1_data,level_2_data,level_3_data,level_4_data,level_5_data,level_6_data,level_7_data]

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
