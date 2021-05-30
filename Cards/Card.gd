extends Node2D

var damage = 0
var defense = 0
var status = CombatController.Status.NONE
var statusPoints = 0
var attackTarget 
var defenseTarget
var statusTarget
var comboMode
var trinketInteractions = []
var cardTypes = []
var cardData
var cardName
var cardOwner = null
var targetCount = 0
var targetActionDoneCount = 0
enum CardActions {COMBO = 0, ATTACK = 1, DEFENSE = 2, STATUS = 3, SPECIAL = 4, DONE = 5}
var nextCardAction = CardActions.COMBO
var cardFrame
var cardArt
var cardArtAnimationPlayer
var cardFrameAnimationPlayer
var cardAttackText
var cardDefenseText
var cardComboSprite
var combosWith = []
var matchedCombo = null

func setup_card(deckOwner):
	var file = File.new()
	file.open("res://Cards/CardStats.json", file.READ)
	var cards = JSON.parse(file.get_as_text())
	file.close()
	cardData = cards.get_result()
	cardOwner = deckOwner
	damage = cardData[cardName].get("damage")
	defense = cardData[cardName].get("defense")
	status = CombatController.Status.keys().find(cardData[cardName].get("status"))
	statusPoints = cardData[cardName].get("statusPoints")
	attackTarget = CombatController.Targets.keys().find(cardData[cardName].get("attackTarget"))
	defenseTarget = CombatController.Targets.keys().find(cardData[cardName].get("defenseTarget"))
	statusTarget = CombatController.Targets.keys().find(cardData[cardName].get("statusTarget"))
	comboMode = CombatController.comboMode.keys().find(cardData[cardName].get("comboMode"))
	cardTypes.clear()
	for cardType in cardData[cardName].get("cardTypes").values():
		cardTypes.append(CardManager.CardType.keys().find(cardType))
	nextCardAction = CardActions.COMBO
	cardFrame = $CardFrame
	cardArt = $CardFrame/CardArt
	cardArtAnimationPlayer = $CardFrame/CardArt/CardArtAnimationPlayer
	cardFrameAnimationPlayer = $CardFrame/CardFrameAnimationPlayer
	cardAttackText = $CardFrame/CardAttack/CardAttackText
	cardDefenseText = $CardFrame/CardDefense/CardDefenseText
	cardAttackText.set_bbcode("[center]"+str(damage)+"[center]")
	cardDefenseText.set_bbcode("[center]"+str(defense)+"[center]")
	cardComboSprite = get_node("CardFrame/ComboSprite")
	cardComboSprite.match_combo_symbol(comboMode)
	reset_card_animations()
	
func reset_card_animations():
	cardFrame.set_animation("default")
	cardArt.set_animation("default")
	cardFrame.set_frame(0)
	cardArt.set_frame(0)
	cardFrameAnimationPlayer.play("default")
	cardArtAnimationPlayer.play("default")
	
func apply_card_effect():
	targetActionDoneCount = 0
	if nextCardAction == 0:
		cardFrame.bounce_card(true)
		yield(cardFrame.tween, "tween_all_completed")
	#print("matching card action " +str(nextCardAction))
	match nextCardAction: 
		CardActions.COMBO:
			apply_combo()
		CardActions.ATTACK:
			apply_attack(CombatController.player, CombatController.currentEnemies)
		CardActions.DEFENSE:
			apply_defense(CombatController.player, CombatController.currentEnemies)
		CardActions.STATUS:
			apply_status(CombatController.player, CombatController.currentEnemies)
		CardActions.SPECIAL:
			apply_special_effect()
		CardActions.DONE:
			#reset card to init state
			self.nextCardAction = 0
			cardFrame.bounce_card(false)
			yield(cardFrame.tween, "tween_all_completed")
			CombatController.card_done(self)

func apply_combo():
	#work with combatcontroller combocards array to check for combo
#	print("Next Card")
	if CombatController.comboCards.size() > 1:
		match comboMode: 
			CombatController.comboMode.LEFTADJACENT: 
				combo_left_adjacent()
			CombatController.comboMode.RIGHTADJACENT:
				combo_right_adjacent()
			CombatController.comboMode.LEFTRIGHTADJACENT:
				combo_left_right_adjacent()
			CombatController.comboMode.RIGHTLEFTADJACENT:
				combo_right_left_adjacent()
			CombatController.comboMode.LEFTALL:
				combo_left_all()
			CombatController.comboMode.RIGHTALL:
				combo_right_all()
			CombatController.comboMode.LEFTRIGHTALL:
				combo_left_right_all()
			CombatController.comboMode.RIGHTLEFTALL:
				combo_right_left_all()
			CombatController.comboMode.LEFTALLRIGHTALL:
				combo_left_all_right_all()
			CombatController.comboMode.RIGHTALLLEFTALL:
				combo_right_all_left_all()
			CombatController.comboMode.RANDOMALL:
				combo_random_all()
			CombatController.comboMode.RANDOMADJACENT:
				combo_random_adjacent()
			CombatController.comboMode.RANDOMSOME:
				combo_random_some()
	else:
		nextCardAction += 1
		apply_card_effect()
		
#matches active card with left adjacent card
func combo_left_adjacent():
	var comboCards = []
	var activeCardPosition = CombatController.comboCards.find(self)
	if self == CombatController.comboCards.front():
		pass
	else:
		comboCards.append(CombatController.comboCards[activeCardPosition-1])
	targetCount = comboCards.size()
	match_combo_card(comboCards, 0)
	
#matches active card with right adjacent card
func combo_right_adjacent():
	var comboCards = []
	var activeCardPosition = CombatController.comboCards.find(self)
	if activeCardPosition == (CombatController.comboCards.size()-1):
		pass
	else:
		comboCards.append(CombatController.comboCards[activeCardPosition+1])
	targetCount = comboCards.size()
	match_combo_card(comboCards, 0)
	
#matches active card with left and then right adjacent card
func combo_left_right_adjacent():
	var comboCards = []
	var activeCardPosition = CombatController.comboCards.find(self)
	if self == CombatController.comboCards.front():
		comboCards.append(CombatController.comboCards[1])
	elif activeCardPosition == (CombatController.comboCards.size()-1):
		comboCards.append(CombatController.comboCards[CombatController.comboCards.size()-2])
	else:
		comboCards.append(CombatController.comboCards[activeCardPosition-1])
		comboCards.append(CombatController.comboCards[activeCardPosition+1])
	targetCount = comboCards.size()
	match_combo_card(comboCards, 0)
	
#matches active card with right and then left adjacent card
func combo_right_left_adjacent():
	var comboCards = []
	var activeCardPosition = CombatController.comboCards.find(self)
	if self == CombatController.comboCards.front():
		comboCards.append(CombatController.comboCards[1])
	elif activeCardPosition == (CombatController.comboCards.size()-1):
		comboCards.append(CombatController.comboCards[CombatController.comboCards.size()-2])
	else:
		comboCards.append(CombatController.comboCards[activeCardPosition+1])
		comboCards.append(CombatController.comboCards[activeCardPosition-1])
	targetCount = comboCards.size()
	match_combo_card(comboCards, 0)
	
#matches active card all cards to the left
func combo_left_all():
	var comboCards = []
	var activeCardPosition = CombatController.comboCards.find(self)
	if self == CombatController.comboCards.front():
		pass
	else: 
		comboCards = CombatController.comboCards.slice(0, activeCardPosition-1, 1, true)
		comboCards.invert()
	targetCount = comboCards.size()
	match_combo_card(comboCards, 0)
	
#matches active card with all cards to the right
func combo_right_all():
	var comboCards = []
	var activeCardPosition = CombatController.comboCards.find(self)
	if activeCardPosition == CombatController.comboCards.size()-1:
		pass
	else: 
		comboCards = CombatController.comboCards.slice(activeCardPosition+1, CombatController.comboCards.size()-1, 1, true)
	targetCount = comboCards.size()
	match_combo_card(comboCards, 0)
	
#matches active card with all cards altering between left and right staring with left adjacent
func combo_left_right_all():
	var comboCards = []
	var activeCardPosition = CombatController.comboCards.find(self)
	var countUp = activeCardPosition + 1
	var countDown = activeCardPosition - 1
	if countUp >= CombatController.comboCards.size():
		combo_left_all()
		return
	elif countDown < 0:
		combo_right_all()
		return
	else:
		while countDown >= 0 || countUp < CombatController.comboCards.size():
			if countDown >= 0: 
				comboCards.append(CombatController.comboCards[countDown])
				countDown -= 1
			if countUp < CombatController.comboCards.size():
				comboCards.append(CombatController.comboCards[countUp])
				countUp += 1
	targetCount = comboCards.size()
	match_combo_card(comboCards, 0)
	
#matches active card with all cards altering between left and right staring with right adjacent
func combo_right_left_all():
	var comboCards = []
	var activeCardPosition = CombatController.comboCards.find(self)
	var countUp = activeCardPosition + 1
	var countDown = activeCardPosition - 1
	if countUp >= CombatController.comboCards.size():
		combo_left_all()
		return
	elif countDown < 0:
		combo_right_all()
		return
	else:
		while countDown >= 0 || countUp < CombatController.comboCards.size():
			if countUp < CombatController.comboCards.size():
				comboCards.append(CombatController.comboCards[countUp])
				countUp += 1
			if countDown >= 0: 
				comboCards.append(CombatController.comboCards[countDown])
				countDown -= 1
	targetCount = comboCards.size()
	match_combo_card(comboCards, 0)
	
#matches active card with all cards to the left first and then all cards to the right
func combo_left_all_right_all():
	var comboCards = []
	var activeCardPosition = CombatController.comboCards.find(self)
	var countUp = activeCardPosition + 1
	var countDown = activeCardPosition - 1
	if countUp >= CombatController.comboCards.size():
		combo_left_all()
		return
	elif countDown < 0:
		combo_right_all()
		return
	else:
		while countDown >= 0:
			comboCards.append(CombatController.comboCards[countDown])
			countDown -= 1
		while countUp < CombatController.comboCards.size():
			comboCards.append(CombatController.comboCards[countUp])
			countUp += 1
	targetCount = comboCards.size()
	match_combo_card(comboCards, 0)
	
#matches active card with all cards to the right first and then all cards to the left
func combo_right_all_left_all():
	var comboCards = []
	var activeCardPosition = CombatController.comboCards.find(self)
	var countUp = activeCardPosition + 1
	var countDown = activeCardPosition - 1
	if countUp >= CombatController.comboCards.size():
		combo_left_all()
		return
	elif countDown < 0:
		combo_right_all()
		return
	else:
		while countUp < CombatController.comboCards.size():
			comboCards.append(CombatController.comboCards[countUp])
			countUp += 1
		while countDown >= 0:
			comboCards.append(CombatController.comboCards[countDown])
			countDown -= 1
	targetCount = comboCards.size()
	match_combo_card(comboCards, 0)
	
#matches active card with all cards in random order
func combo_random_all():
	var comboCards = []
	var randomCards = CombatController.comboCards.duplicate()
	randomCards.shuffle()
	randomCards.erase(self)
	for card in randomCards:
		comboCards.append(card)
	targetCount = comboCards.size()
	match_combo_card(comboCards, 0)
	
#matches active card with random number of cards in random order
func combo_random_some():
	var comboCards = []
	var randomCards = CombatController.comboCards.duplicate()
	randomCards.shuffle()
	randomCards.erase(self)
	var cardsToCombo = (randomCards.size() - randi() % randomCards.size())-1
	# to combo with at least one card: var cardsToCombo = randi() % randomCards.size() 
	randomCards = randomCards.slice(0, cardsToCombo)
	for card in randomCards:
		comboCards.append(card)
	targetCount = comboCards.size()
	match_combo_card(comboCards, 0)
	
#matches active card with left and right adjacent in random order
func combo_random_adjacent():
	var randomLR = randi() % 2
	if randomLR == 0: 
		combo_left_right_adjacent()
		return
	elif randomLR == 1: 
		combo_right_left_adjacent()
		return 
	
#apply combo effects function is called here step by step for each card to check combo with 
func match_combo_card(comboCards, currentComboCard):
	if currentComboCard < comboCards.size():
#		print("all cards drawn: " + str(CombatController.comboCards))
#		print("current active card " +str(self.name) + str(cardTypes))
#		print("Current Combo Card " +str(comboCards[currentComboCard].name) +str(comboCards[currentComboCard].cardTypes))
		apply_matched_card_combo_steps(comboCards, currentComboCard)
	elif comboCards.empty():
#		print("all cards drawn: " + str(CombatController.comboCards))
#		print("current active card " +str(self))
#		print("Current Combo Card " +str("empty"))
		target_action_done()
		
func apply_matched_card_combo_steps(comboCards, currentComboCard, step = 0):
	var funcRef = funcref(self, "apply_matched_card_combo_steps")
	var comboCard = comboCards[currentComboCard]
	match step: 
		0:
			var paramArray = [comboCards, currentComboCard, 1]
			comboCard.cardFrame.play_card_animation_funcref("wiggle", funcRef, paramArray)
		1:
			if check_for_combo(comboCard):
				var paramArray = [comboCards, currentComboCard, 2]
				var targetPosition = self.global_position-comboCard.global_position
				comboCard.cardFrame.bounce_card_target_funcRef(targetPosition, funcRef, paramArray)
			else:
				 apply_matched_card_combo_steps(comboCards, currentComboCard,2)
		2:
			if matchedCombo: 
				var paramArray = [comboCards, currentComboCard, 3]
				apply_combo_funcRef(funcRef, paramArray)
			else:
				apply_matched_card_combo_steps(comboCards, currentComboCard,3)
		3:
			match_combo_card(comboCards, (currentComboCard+1))
			target_action_done()
			
func check_for_combo(comboCard):
	for combo in combosWith:
		if comboCard.cardTypes.has(combo):
			matchedCombo = combo
			return true
	return false
	
func apply_combo_funcRef(funcRef, paramArray):
	matchedCombo = null
	funcRef.call_funcv(paramArray)

func apply_attack(player, currentEnemies):
	cardAttackText.set_bbcode("[center]"+str(damage)+"[/center]")
	if attackTarget != null: 
		targetCount = count_card_targets(player, currentEnemies, attackTarget)
		var targets = match_target(player, currentEnemies, attackTarget, targetCount)
		for target in targets: 
			target.apply_attack(damage, self)
	else:
		nextCardAction += 1
		apply_card_effect()
		
func apply_defense(player, currentEnemies): 
	cardDefenseText.set_bbcode("[center]"+str(defense)+"[center]")
	if defenseTarget != null: 
		targetCount = count_card_targets(player, currentEnemies, defenseTarget)
		var targets = match_target(player, currentEnemies, defenseTarget, targetCount)
		for target in targets: 
			target.apply_defense(defense, self)
	else:
		nextCardAction += 1
		apply_card_effect()
	
func apply_status(player, currentEnemies):
	#print("applying status")
	if statusTarget != null: 
		targetCount = count_card_targets(player, currentEnemies, statusTarget)
		var targets = match_target(player, currentEnemies, statusTarget, targetCount)
		for target in targets: 
			target.apply_status(status, statusPoints, self)
	else:
		nextCardAction += 1
		apply_card_effect()
		
#effects like draw card, shuffle deck etc
func apply_special_effect():
	#print("applying special")
	#todo replace with special effect for now pass turn 
	nextCardAction += 1
	apply_card_effect()
	
# these functions can be used as special effect function:
func draw_additional_cards(cardsToDraw):
	targetCount = 1
	var drawnCards = cardOwner.actorDeck.draw_cards(cardsToDraw)
	if !drawnCards.empty():
		for card in drawnCards:
			CombatController.drawnCards.append(card)
			CombatController.comboCards.append(card)
		CardSlots.add_additional_card(drawnCards, self)
		
#pass an array containg strings of the cards to be added
func add_card_to_deck(cardsToAdd):
	targetCount = 1
	cardOwner.actorDeck.add_cards_to_active_deck(cardsToAdd, self)
	
#pass an array containg strings of the cards to be added 
func add_card_to_discard_pile(cardsToAdd):
	targetCount = 1
	cardOwner.actorDeck.add_cards_to_discard_pile(cardsToAdd, self)
	
func find_cards(searchFor, searchBy):
	targetCount = 1
	#searchIn, searchBy, searchFor, searchAmount
	var foundCards = cardOwner.actorDeck.search_for_card(CardManager.SearchIn.ACTIVEDECK, CardManager.SearchCardBy.TYPE, CardManager.CardType.FIRE, -1)
	target_action_done()
	
	
func check_trinkes():
	pass

func count_card_targets(player, currentEnemies, targetType):
	var countTargets = 0
	match targetType: 
		CombatController.Targets.SELF: 
			countTargets += 1
		CombatController.Targets.FIRST: 
			countTargets += 1
		CombatController.Targets.LAST: 
			countTargets += 1
		CombatController.Targets.PLAYER:
			countTargets += 1
		CombatController.Targets.RANDOMONE:
			countTargets += 1
		CombatController.Targets.RANDOMALL:
			countTargets += randi() % currentEnemies.size() + 1
		CombatController.Targets.ALL:
			countTargets += currentEnemies.size()
	return countTargets
	
func match_target(player, currentEnemies, targetType, targetCount):
	var target = []
	match targetType: 
		CombatController.Targets.SELF: 
			target.append(cardOwner)
		CombatController.Targets.FIRST: 
			target.append(currentEnemies[0])
		CombatController.Targets.LAST: 
			target.append(currentEnemies[currentEnemies.size()-1])
		CombatController.Targets.PLAYER:
			target.append(player)
		CombatController.Targets.RANDOMONE:
			target.append(currentEnemies[randi() % currentEnemies.size()-1])
		CombatController.Targets.RANDOMALL:
			target = currentEnemies.duplicate()
			target.shuffle()
			for count in (currentEnemies.size()-targetCount):
				target.erase(target.front())
		CombatController.Targets.ALL:
			target = currentEnemies.duplicate()
	return target

func target_action_done():
	targetActionDoneCount += 1
	if CombatController.allEnemiesDefeated:
		cardFrame.bounce_card(false)
		yield(cardFrame.tween, "tween_all_completed")
		CombatController.all_enemies_defeated()
	elif CombatController.playerDefeated:
		CombatController.player_defeated()
	elif targetActionDoneCount == targetCount\
	|| targetCount == 0:
		nextCardAction += 1
		apply_card_effect()
