extends Node

var swordCard = preload("res://Cards/SwordCard/SwordCard.tscn") 
var swordCardCombo = preload("res://Cards/SwordComboCard/SwordComboCard.tscn")
var fireCard = preload("res://Cards/FireCard/FireCard.tscn")
var matchStickCard = preload("res://Cards/MatchStickCard/MatchStickCard.tscn")
var rainCloudCard = preload("res://Cards/RainCloudCard/RainCloudCard.tscn")
var slimeAttackCard = preload("res://Cards/SlimeAttackCard/SlimeAttackCard.tscn") 
var slimeCardCombo = preload("res://Cards/SlimeComboCard/SlimeComboCard.tscn") 

enum CardType {WEAPON, FIRE, WATER, WOOD}
enum SearchCardBy {NAME, TYPE}
enum SearchIn {ACTIVEDECK, DISCARDPILE, HANDCARDS, CARDLIST}

var playerCards = {"SwordCard": swordCard, "SwordCardCombo": swordCardCombo, "FireCard": fireCard, "MatchStickCard": matchStickCard, "RainCloudCard":rainCloudCard}
var enemyCards = {"SlimeAttackCard": slimeAttackCard, "SlimeCardCombo": slimeCardCombo}

func _ready():
	randomize()

func instance_card(card, deckOwner):
	var instancedCard = null
	if deckOwner.is_in_group("Player"):
		instancedCard = playerCards.get(card).instance()
#		if instancedCard == null: 
#			instancedCard = enemyCards.get(card).instance()
	elif deckOwner.is_in_group("Enemy"):
		instancedCard = enemyCards.get(card).instance()
#		if instancedCard == null: 
#			instancedCard = playerCards.get(card).instance()
	return instancedCard
			
func delete_card(cardInstance):
	cardInstance.queue_free()
