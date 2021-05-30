extends "res://Cards/Card.gd"

func setup_card(deckOwner):
	$CardFrame/TextEdit.text="SlimeAttackCardCombo"
	cardName = "SlimeAttackCardCombo"
	.setup_card(deckOwner)
	
func apply_matched_card_combo(comboCards, currentComboCard):
	.apply_matched_card_combo(comboCards, currentComboCard)
