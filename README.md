# LuckyPieceOfCardboard (Rogue Like Card Game Proof of Concept)
The game was inspired by Slay the Spire and Luck be a Landlord. It combines a Deck Building Aspect with the RNG nature of a slot machine. The concept was created within 
a week to get it out of my mind. This game was started as a group effort but is currently only maitained by @L4igi. 
## What is working? 
The main gameplay loop is implemented. Cards, Decks and Enemies use JSON files for stats and effects. A base class to extend from was created for each of these
game elements. What makes this game unique is its combo system used in combat. Cards can interact based on their class. To demonstartate this some combinations are 
implemented like a raincloud extinguishing a fire (the fire card therefore makes less damage), or a fire lighting a matchstick (matchstick does more damage). The cards
are drawn and handled one after the other. With which other card the current active card interacts depends on the cards interaction modes. (Hard coded or random)
## Whats the next step? 
Actual Game Design. The base functionalities are working, now a variety of Cards, Decks and Enemies has to be created to make this concept an actual game. 
Trinkets are currently a work in progress. 
The game can be tried here: https://l4igi.itch.io/lpoc
