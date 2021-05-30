extends "res://Cards/Card.gd"

func setup_card(deckOwner):
	$CardFrame/TextEdit.text="RainCloudCard"
	cardName = "RainCloudCard"
	.setup_card(deckOwner)
	for trinket in cardData[cardName].get("trinketInteractions").values():
		trinketInteractions.append(trinket)

func apply_matched_card_combo(comboCards, currentComboCard):
	.apply_matched_card_combo(comboCards, currentComboCard)

#func apply_special_effect():
#	var cardsToAdd = []
#	cardsToAdd.append("SwordCard")
#	print("before " +str(cardOwner.actorDeck.cardList))
#	add_card_to_deck(cardsToAdd)
#	print("after " +str(cardOwner.actorDeck.cardList))
