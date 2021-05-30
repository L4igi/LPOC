extends "res://Cards/Card.gd"

func setup_card(deckOwner):
	$CardFrame/TextEdit.text="SwordCard"
	cardName = "SwordCard"
	.setup_card(deckOwner)
	for trinket in cardData[cardName].get("trinketInteractions").values():
		trinketInteractions.append(trinket)

func apply_matched_card_combo(comboCards, currentComboCard):
	.apply_matched_card_combo(comboCards, currentComboCard)

func apply_special_effect():
	find_cards("SwordCard", CardManager.SearchCardBy.NAME)
