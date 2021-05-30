extends Node2D

onready var player=get_node("/root/Player")
var turnDone = true


# Called when the node enters the scene tree for the first time.
func _ready():
	CombatController.connect("turnDone", self, "on_combatcontroller_turn_done")
	CombatController.playerDefeated = false
	CombatController.allEnemiesDefeated = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	$Button.set_visible(false)
	if turnDone:
		turnDone = false
		get_node("/root/CombatController").start_turn(player)

func on_combatcontroller_turn_done():
	turnDone = true
	$Button.set_visible(true)
