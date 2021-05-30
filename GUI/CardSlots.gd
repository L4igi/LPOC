extends Node2D

var cardPlace = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_slots(cards, currentCard):
	var card = cards[currentCard]
	cardPlace = currentCard + 1  
	var slotToUse = get_node("Slot" + str(cardPlace))
	card.position = slotToUse.position
	slotToUse.add_child(card)
	set_all_slots(cards, currentCard+1)
			
func set_all_slots(cards, currentCard):
	yield(get_tree().create_timer(0.2),"timeout")
	if currentCard < cards.size():
		set_slots(cards, currentCard)
	else:
		CombatController.apply_first_card_effects()
		
func clear_slots():
	cardPlace = 0
	for slot in self.get_children():
		for card in slot.get_children():
			#print("removing " +str(card))
			slot.remove_child(card)
			
func add_additional_card(cardsToAdd, activeCard = null):
	for card in cardsToAdd: 
		cardPlace += 1
		var slotToUse = get_node("Slot" + str(cardPlace))
		card.position = slotToUse.position
		slotToUse.add_child(card)
	if activeCard:
		activeCard.target_action_done()
			
#func check_slots_empty():
#	var slotsEmpty = true
#	for slot in self.get_children():
#		if slot.get_child_count() != 0: 
#			slotsEmpty = false
#	return slotsEmpty
