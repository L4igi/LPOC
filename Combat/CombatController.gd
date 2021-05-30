extends Node

onready var player = get_node("/root/Player")
var currentEnemies = []
var currentActor = Actors.PLAYER
var currentActorNode = null
var currentEnemyTurn = 0
var drawnCards = []
var comboCards = []
enum Actors {PLAYER, ENEMY}
enum Targets {PLAYER, FIRST, LAST, SELF, RANDOMONE, RANDOMALL, ALL}
enum Status {NONE, BURN, POISON, SLEEP, INTENGIBLE}
enum comboMode {LEFTADJACENT, RIGHTADJACENT, LEFTRIGHTADJACENT, RIGHTLEFTADJACENT, LEFTALL, RIGHTALL, LEFTALLRIGHTALL, RIGHTALLLEFTALL, LEFTRIGHTALL, RIGHTLEFTALL, RANDOMADJACENT, RANDOMALL, RANDOMSOME}
signal turnDone 
var playerDefeated = false
var allEnemiesDefeated = false
var rewardScreen = preload("res://GUI/Reward/RewardWindow.tscn") 

func _ready():
	randomize()

func start_turn(actor):
	currentActorNode = actor
	actor.tick_status_effects()
	
#called from actor when after status effects are applied 
func stats_tick_done(actor):
	match currentActor:
		Actors.PLAYER:
			player_turn()
		Actors.ENEMY:
			enemy_turn(actor)
	
#first step of player turn clears variables, draws cards
#sets up combo cards for checking later & applies effect of first card
func player_turn():
	drawnCards.empty()
	drawnCards = player.draw_hand_cards()
	comboCards = drawnCards.duplicate()
	fill_card_slots()
	
#first step of enemy turn clears variables, draws cards
#sets up combo cards for checking later & applies effect of first card
func enemy_turn(enemy):
	drawnCards.empty()
	drawnCards = enemy.draw_hand_cards()
	comboCards = drawnCards.duplicate()
	fill_card_slots()

#fills all card slots with the card nodes
func fill_card_slots():
	CardSlots.clear_slots()
	var currentCard = 0
	CardSlots.set_all_slots(drawnCards, currentCard)
	
func apply_first_card_effects():
	#todo apply trinket effect that affects all cards of this turn
	match currentActor:
		Actors.PLAYER:
			apply_player_card_effects(drawnCards.front())
		Actors.ENEMY:
			apply_enemy_card_effects(drawnCards.front())

#sets card in Canvas card slot and calls apply card effect function
func apply_player_card_effects(card):
	#todo apply trinket effect that affects this one cards of this turn
	card.apply_card_effect()

#sets card in Canvas card slot and calls apply card effect function
func apply_enemy_card_effects(card):
	#todo apply trinket effect that affects this one cards of this turn
	card.apply_card_effect()
		

func add_enemy(enemy):
	currentEnemies.append(enemy)
	pass
	
func remove_enemy(enemy):
	currentEnemies.erase(enemy)
	pass

#called from card when card effects are finished 
func card_done(card):
	drawnCards.erase(card)
	match currentActor: 
		Actors.PLAYER:
			player_card_done()
		Actors.ENEMY:
			enemy_card_done()
				
#called when player card done, 
#call apply card effects until drawn cards are empty 
# apply combo if drawn cards are empty 
#after combo is handled switch over to enemy turn
func player_card_done():
	if drawnCards.empty() && !comboCards.empty(): 
		player_turn_end()
	elif comboCards.empty():
		currentActor = Actors.ENEMY
		start_turn(currentEnemies.front())
	else:
		apply_player_card_effects(drawnCards.front())

#called when player card done, 
#call apply card effects until drawn cards are empty 
#apply combo if drawn cards are empty 
#after combo is handled send signal turn done
func enemy_card_done():
	if drawnCards.empty() && !comboCards.empty(): 
		enemy_turn_end()
	elif comboCards.empty():
		currentEnemyTurn += 1
		if currentEnemyTurn < currentEnemies.size():
			start_turn(currentEnemies[currentEnemyTurn])
		else:
			currentEnemyTurn = 0
			currentActor = Actors.PLAYER
			emit_signal("turnDone")
	else:
		apply_enemy_card_effects(drawnCards.front())
		
#todo: check if cards create combo, spawn combo card
func player_turn_end():
#check combocards array for combos 
#	var comboCard = CardManager.instance_card("SwordCardCombo", player)
#	comboCard.setup_card(player)
#	cardPlace = -1
#	apply_player_card_effects(comboCard)
#after actor turn is done reset card to original state
	for card in comboCards: 
		card.setup_card(currentActorNode)
		card.cardOwner.actorDeck.put_cards_into_discard_pile(card)
	comboCards.clear()
	player_card_done()
	
#todo: check if cards create combo, spawn combo card
func enemy_turn_end():
	#check combocards array for combos 
#	var comboCard = CardManager.instance_card("SlimeCardCombo", currentEnemies[currentEnemyTurn])
#	comboCard.setup_card(currentEnemies[currentEnemyTurn])
#	cardPlace = -1
#	apply_enemy_card_effects(comboCard)
#after actor turn is done reset card to original state
	for card in comboCards: 
		card.setup_card(currentActorNode)
		card.cardOwner.actorDeck.put_cards_into_discard_pile(card)
	comboCards.clear()
	enemy_card_done()
	
func all_enemies_defeated():
	#reset all player cards to base 
	for card in comboCards: 
		card.setup_card(currentActorNode)
		card.cardOwner.actorDeck.put_cards_into_discard_pile(card)
	comboCards.clear()
	player.actorDeck.reset_deck()
	CardSlots.clear_slots()
	print("all enemies defeated")
	instance_reward_screen()
	
func player_defeated():
	for card in comboCards: 
		card.setup_card(currentActorNode)
		card.cardOwner.actorDeck.put_cards_into_discard_pile(card)
	comboCards.clear()
	CardSlots.clear_slots()
	print("player defeated")
	
func instance_reward_screen():
	var reward = rewardScreen.instance()
	add_child(reward)
