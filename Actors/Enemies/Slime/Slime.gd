extends "res://Actors/Actor.gd"

func _ready():
	health = 25
	healthbar.max_value = health
	healthbar.value = health
	numSlots = 3
	actorName = "Slime"
	create_actor_deck()
	get_node("/root/CombatController").add_enemy(self)

func apply_attack(damage, card):
	actorAnimationPlayer.play("hurt")
	yield(actorAnimationPlayer, "animation_finished")
	actorAnimationPlayer.play("idle")
	.apply_attack(damage, card)

func defeat():
	print("defeated")
	CombatController.currentEnemies.erase(self)
	if CombatController.currentEnemies.empty():
		CombatController.allEnemiesDefeated = true
	self.queue_free()
