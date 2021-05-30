extends "res://Cards/Card.gd"

func setup_card(deckOwner):
	$CardFrame/TextEdit.text="SlimeAttackCard"
	cardName = "SlimeAttackCard"
	.setup_card(deckOwner)
	
func apply_matched_card_combo(comboCards, currentComboCard):
	.apply_matched_card_combo(comboCards, currentComboCard)
