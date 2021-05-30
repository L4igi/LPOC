extends CanvasLayer

onready var player = get_node("/root/Player")
var deckListMenuScene = preload("res://GUI/Options/DeckListMenu/DeckListMenu.tscn")
var cardListMenu
var projectResolution


func _on_DeckButton_button_down():
	if !cardListMenu:
		cardListMenu = deckListMenuScene.instance()
		get_node("/root").add_child(cardListMenu)
		cardListMenu.update_deckList(player.actorDeck.activeDeck)
	else:
		cardListMenu.queue_free()
		cardListMenu = null


func _on_CardListButoon_button_down():
	if !cardListMenu:
		cardListMenu = deckListMenuScene.instance()
		get_node("/root").add_child(cardListMenu)
		cardListMenu.update_deckList(player.actorDeck.cardList)
	else:
		cardListMenu.queue_free()
		cardListMenu = null


func _on_DiscardPileButton_button_down():
	if !cardListMenu:
		cardListMenu = deckListMenuScene.instance()
		get_node("/root").add_child(cardListMenu)
		cardListMenu.update_deckList(player.actorDeck.discardPile)
	else:
		cardListMenu.queue_free()
		cardListMenu = null
