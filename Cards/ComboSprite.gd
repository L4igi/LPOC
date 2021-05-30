extends Sprite

var leftAdj = preload("res://Cards/ComboSprites/leftAdj.png")
var rightAdj = preload("res://Cards/ComboSprites/rightAdj.png")
var leftRightAdj = preload("res://Cards/ComboSprites/leftRightAdj.png")
var rightLeftAdj = preload("res://Cards/ComboSprites/rightLeftAdj.png")
var leftAll = preload("res://Cards/ComboSprites/leftAll.png")
var rightAll = preload("res://Cards/ComboSprites/rightAll.png")
var leftAllRightAll = preload("res://Cards/ComboSprites/leftAllRightAll.png")
var rightAllLeftAll = preload("res://Cards/ComboSprites/rightAllLeftAll.png")
var rightLeftAll = preload("res://Cards/ComboSprites/rightLeftAll.png")
var leftRightAll = preload("res://Cards/ComboSprites/leftRightAll.png")
var randomLR = preload("res://Cards/ComboSprites/randomLR.png")
var randomAll = preload("res://Cards/ComboSprites/randomAll.png")
var randomSome = preload("res://Cards/ComboSprites/randomSome.png")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func match_combo_symbol(combo):
	match combo:
		CombatController.comboMode.LEFTADJACENT:
			set_texture(leftAdj)
		CombatController.comboMode.RIGHTADJACENT:
			set_texture(rightAdj)
		CombatController.comboMode.LEFTRIGHTADJACENT:
			set_texture(leftRightAdj)
		CombatController.comboMode.RIGHTLEFTADJACENT:
			set_texture(rightLeftAdj)
		CombatController.comboMode.LEFTALL:
			set_texture(leftAll)
		CombatController.comboMode.RIGHTALL:
			set_texture(rightAll)
		CombatController.comboMode.LEFTALLRIGHTALL:
			set_texture(leftAllRightAll)
		CombatController.comboMode.RIGHTALLLEFTALL:
			set_texture(rightAllLeftAll)
		CombatController.comboMode.RIGHTLEFTALL:
			set_texture(rightLeftAll)
		CombatController.comboMode.LEFTRIGHTALL:
			set_texture(leftRightAll)
		CombatController.comboMode.RANDOMADJACENT:
			set_texture(randomLR)
		CombatController.comboMode.RANDOMALL:
			set_texture(randomAll)
		CombatController.comboMode.RANDOMSOME:
			set_texture(randomSome)
