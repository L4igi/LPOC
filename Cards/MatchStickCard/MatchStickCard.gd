extends "res://Cards/Card.gd"

func setup_card(deckOwner):
	$CardFrame/TextEdit.text="MatchStickCard"
	cardName = "MatchStickCard"
	combosWith = [CardManager.CardType.FIRE]
	.setup_card(deckOwner)
	for trinket in cardData[cardName].get("trinketInteractions").values():
		trinketInteractions.append(trinket)
	
func apply_combo_funcRef(funcRef, paramArray):
	match matchedCombo:
		CardManager.CardType.FIRE:
			match_fire_combo()
	yield(get_tree().create_timer(cardArtAnimationPlayer.get_current_animation_length()),"timeout")
	.apply_combo_funcRef(funcRef, paramArray)
	
func match_fire_combo():
	damage *= 2
	combosWith.erase(CardManager.CardType.FIRE)
#	combosWith.erase(CardManager.CardType.FIRE)
	cardTypes.append(CardManager.CardType.FIRE)
	cardFrame.play_card_animation("fire")
	cardArtAnimationPlayer.play("fire")
	cardAttackText.set_bbcode("[center]"+str(damage)+"[center]")
	
