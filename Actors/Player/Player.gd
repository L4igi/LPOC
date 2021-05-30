extends "res://Actors/Actor.gd"

func _ready():
	position=Vector2(300,300)
	health=100
	healthbar.max_value=health
	healthbar.value=health
	numSlots=3
	actorName = "Player"
	numRewardCards = 3
	numRewardCardsToChoose = 1
	create_actor_deck()
