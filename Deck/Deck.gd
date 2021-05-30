extends Node2D

var deckListData = null
var cardList = []
var activeDeck = []
var discardPile = []
var deckOwner = null


# Called when the node enters the scene tree for the first time.
func _ready():
	#deckOwner = get_node("/root/Player")
	var file = File.new()
	file.open("res://Deck/DeckList.json", file.READ)
	var cards = JSON.parse(file.get_as_text())
	file.close()
	deckListData = cards.get_result()

func setup_deck():
	deckOwner = get_parent()
	build_deck()

func build_deck():
	var cardListData = deckListData[deckOwner.actorName + str("Deck")]
	var cardsToAdd = []
	for card in cardListData:
		for count in range(0,cardListData.get(card)):
			cardsToAdd.append(card)
	add_cards_to_active_deck(cardsToAdd)
	activeDeck.shuffle()

#resets deck, puts all cards into active deck
func reset_deck():
	discardPile.clear()
	activeDeck.clear()
	activeDeck = cardList.duplicate()
	activeDeck.shuffle()

func draw_cards(cardsToDraw):
	var drawnCards = []
	for card in cardsToDraw:
		if activeDeck.empty():
			activeDeck = discardPile.duplicate()
			discardPile.clear()
			activeDeck.shuffle()
			if activeDeck.empty():
				print("no more cards to draw")
				return drawnCards
		var cardToUse = activeDeck.front()
		drawnCards.append(cardToUse)
		activeDeck.erase(cardToUse)
	return drawnCards
	
#add new card not already in deck to draw pile/active deck
func add_cards_to_active_deck(cards, activeCard = null):
	for card in cards:
		var instancedCard = CardManager.instance_card(card, deckOwner)
		cardList.append(instancedCard)
		activeDeck.append(instancedCard)
		instancedCard.setup_card(deckOwner)
	if activeCard:
		activeCard.target_action_done()

#add new card not already in deck to discrad pile
func add_cards_to_discard_pile(cards, activeCard = null):
	for card in cards:
		var instancedCard = CardManager.instance_card(card, deckOwner)
		cardList.append(instancedCard)
		discardPile.append(instancedCard)
		instancedCard.setup_card(deckOwner)
	if activeCard:
		activeCard.target_action_done()
	
#puts cards already in deck into the discard pile
func put_cards_into_discard_pile(card):
	if activeDeck.has(card):
		activeDeck.remove(card)
	discardPile.push_front(card)

func remove_card_from_deck(card):
	if cardList.has(card):
		cardList.remove(card)
	if activeDeck.has(card):
		activeDeck.remove(card)
	if discardPile.has(card):
		discardPile.remove(card)
	CardManager.delete_card(card)
		
#searchIn choose activedeck, cardlist, discardpile or hand cards,
#searchby choose name or type
#searchfor value to search for
#searchamount choose -1 to get all or amount to search amount
func search_for_card(searchIn, searchBy, searchFor, searchAmount):
	var activeSearchIn = activeDeck
	match searchIn: 
		CardManager.SearchIn.ACTIVEDECK:
			activeSearchIn = activeDeck
		CardManager.SearchIn.CARDLIST:
			activeSearchIn = cardList
		CardManager.SearchIn.DISCARDPILE:
			activeSearchIn = discardPile
		CardManager.SearchIn.HANDCARDS:
			activeSearchIn = CombatController.comboCards
	var cardsFound = []
	match searchBy:
		CardManager.SearchCardBy.NAME:
			for card in activeSearchIn:
				if card.cardName == searchFor:
					cardsFound.append(card)
					if cardsFound.size() == searchAmount:
						return cardsFound
		CardManager.SearchCardBy.TYPE:
			for card in activeSearchIn:
				if card.cardTypes.has(searchFor):
					cardsFound.append(card)
					if cardsFound.size() == searchAmount:
						return cardsFound
	return cardsFound

func shuffle_deck():
	cardList.shuffle()
