extends Resource
class_name Prep_Library


var level_1_prep_data:Dictionary = {
	"street_name":"Basic Blvd.",
	"day":"Monday",
	"clients":6,
	"required":1,
	"notes":["dont drink the potions", "try to get some headshots", "that house was always red, right?","try not to melt the mailbox again","half the battle is knowing where to throw","trust your throwing arm"]
}
var level_2_prep_data:Dictionary = {
	"street_name":"Village Vly.",
	"day":"Tuesday",
	"clients":6,
	"required":3,#endgame testing
	"notes":["if it is bubbling, it is working", "aim for the door, not the window", "always shake before throwing","more deliveries, fewer lawsuits that is the goal","mix fast, throw faster"]
}
var level_3_prep_data:Dictionary = {
	"street_name":"Coventry Ct.",
	"day":"Wednesday",
	"clients":6,
	"required":3,#endgame testing
	"notes":["delivery window, 3 to 5 seconds", "hit the target, dodge the lawsuits", "potions first, questions later"]
}
var level_4_prep_data:Dictionary = {
	"street_name":"Witches Wy.",
	"day":"Thursday",
	"clients":6,
	"required":4,#endgame testing
	"notes":["Do not trust the witches", "I gave that witch a potion, witches love potions", "black cats make terrible mailboxes","the cauldron says you are late", "bubble bubble, throw me double"]
}
var level_5_prep_data:Dictionary = {
	"street_name":"Albedo Aly.",
	"day":"Friday",
	"clients":6,
	"required":4,#endgame testing
	"notes":["Always tip your brewer", "last house on the left wants invisibility. again?","the council of hats is watching", "the witch eyes see all"]
}
var level_6_prep_data:Dictionary = {
	"street_name":"Treacherous Trl.",
	"day":"Saturday",
	"clients":6,
	"required":6,
	"notes":["no refunds, EVER!!", "by royal decree, aim better this time", "the king needs potions you must deliver"]
}
var level_7_prep_data:Dictionary = {
	"street_name":"Perfect Pl.",
	"day":"Sunday",
	"clients":6,
	"required":6,
	"notes":["delivered with style", "sir Mixalot rides again", "the king said he wanted results — not fire", "always label your potions"]
}
var endless_prep_data:Dictionary = {
	"street_name":["Toadstool Ter.","Crystal Ct.","Potionpost Pk.","Spellcaster St.","Brewster Ln.","Potion Pkwy.","Herb Grv.","Witchhazel Rd.","Frogspawn Ct.","Froggy Ct.","Flask Ct.","Glow Rd.","Moonlit Ln."],
	"day":"Endless Mode",
	"clients":0,
	"required":0,
	"notes":["hope you brought snacks, this shift does not end","sleep is for quitters", "no lunch breaks, no quitting, just potions", "always label your potions","you have unlocked infinite job security","your shift ends when the kingdom runs out of houses","rumor is the street loops forever, good luck"]
}

var all_level_prep = [level_1_prep_data,level_2_prep_data,level_3_prep_data,level_4_prep_data,level_5_prep_data,level_6_prep_data,level_7_prep_data]

func get_level_prep(level:int):
	return all_level_prep[level-1]
