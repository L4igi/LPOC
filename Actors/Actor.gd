extends Node2D

var numSlots
var actorDeck = null
var health = 0
var defense = 0
var actorName
var numRewardCards = 0
var numRewardCardsToChoose = 0
onready var actorAnimationPlayer = get_node("AnimatedSprite/AnimationPlayer")
var statusEffects = {"NONE" :0, "BURN": 0, "POISON":0, "SLEEP":0, "INTENGIBLE":0}
onready var healthbar=$HealthBar/TextureProgress
onready var defenseTextLable = $TextureRect/DefenseText
onready var deck = preload("res://Deck/Deck.tscn")
	
func create_actor_deck():
	actorDeck = deck.instance()
	add_child(actorDeck)
	actorDeck.setup_deck()
	
func apply_attack(damage, card):
	if defense > 0: 
		defense -= damage
		if defense < 0: 
			health -= abs(defense)
			healthbar.value = health
			defense = 0
		defenseTextLable.set_bbcode("[center]"+str(self.defense)+"[center]")
	else:
		health -= damage 
		healthbar.value = health
		if health <= 0: 
			defeat()
	card.target_action_done()
	
func apply_defense(defense, card):
	self.defense += defense
	defenseTextLable.set_bbcode("[center]"+str(self.defense)+"[center]")
	card.target_action_done()
	
func apply_status(status, statusPoints, card):
	var dictStatus = CombatController.Status.keys()[status]
	statusEffects[str(dictStatus)] = statusEffects[str(dictStatus)] + statusPoints
	card.target_action_done()

func defeat():
	pass

func draw_hand_cards():
	return actorDeck.draw_cards(numSlots)

func draw_additional_cards(amount):
	return actorDeck.draw_cards(amount)

func tick_status_effects():
	#print(self.name + " Ticking Down Status Effects " +str(statusEffects))
	CombatController.stats_tick_done(self)
