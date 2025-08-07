extends Resource
class_name Prep_Library


var level_1_prep_data:Dictionary = {
	"street_name":"Basic Blvd.",
	"day":"Monday",
	"clients":6,
	"required":1,
	"notes":["dont drink the potions", "try to get some headshots", "that house was always red, right?","try not to melt the mailbox again"]
}
var level_2_prep_data:Dictionary = {
	"street_name":"Village Vly.",
	"day":"Tuesday",
	"clients":6,
	"required":3,#endgame testing
	"notes":["if it’s bubbling, it’s working", "aim for the door, not the window", "always shake before throwing"]
}
var level_3_prep_data:Dictionary = {
	"street_name":"Coventry Ct.",
	"day":"Wednesday",
	"clients":6,
	"required":3,#endgame testing
	"notes":["delivery window: 3–5 seconds", "2", "3"]
}
var level_4_prep_data:Dictionary = {
	"street_name":"Witches Wy.",
	"day":"Thursday",
	"clients":6,
	"required":4,#endgame testing
	"notes":["Don’t trust the witches", "I gave that witch a potion, witches love potions", "black cats make terrible mailboxes","the cauldron says you're late"]
}
var level_5_prep_data:Dictionary = {
	"street_name":"Albedo Aly.",
	"day":"Friday",
	"clients":6,
	"required":4,#endgame testing
	"notes":["Always tip your brewer", "last house on the left wants invisibility... again","the council of hats is watching"]
}
var level_6_prep_data:Dictionary = {
	"street_name":"Treacherous Trl.",
	"day":"Saturday",
	"clients":6,
	"required":6,
	"notes":["no refunds, EVER!!", "by royal decree, aim better this time", "the king's hay fever isn’t fixing itself"]
}
var level_7_prep_data:Dictionary = {
	"street_name":"Perfect Pl.",
	"day":"Sunday",
	"clients":6,
	"required":6,
	"notes":["delivered with style", "sir Mixalot rides again", "the king said he wanted results — not fire"]
}

var all_level_prep = [level_1_prep_data,level_2_prep_data,level_3_prep_data,level_4_prep_data,level_5_prep_data,level_6_prep_data,level_7_prep_data]

func get_level_prep(level:int):
	return all_level_prep[level-1]
