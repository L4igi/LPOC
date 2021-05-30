extends "res://Cards/Card.gd"

func setup_card(deckOwner):
	$CardFrame/TextEdit.text="FireCard"
	cardName = "FireCard"
	combosWith = [CardManager.CardType.WATER]
	.setup_card(deckOwner)
	for trinket in cardData[cardName].get("trinketInteractions").values():
		trinketInteractions.append(trinket)

func apply_combo_funcRef(funcRef, paramArray):
	print(matchedCombo)
	match matchedCombo:
		CardManager.CardType.WATER:
			match_water_combo()
	yield(get_tree().create_timer(cardArtAnimationPlayer.get_current_animation_length()),"timeout")
	.apply_combo_funcRef(funcRef, paramArray)
	
func match_water_combo():
	damage = 0
	combosWith.erase(CardManager.CardType.WATER)
	cardTypes.erase(CardManager.CardType.FIRE)
	#cardFrame.play_card_animation("water")
	cardArtAnimationPlayer.play("water")
	
