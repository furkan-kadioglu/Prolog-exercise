# Prolog-exercise
## Pok ́emon: Let’s Go, Prolog!
I will design an interface for Pok ́emon Trainers, so that they can create different Pok ́emon teams and simulate battles against other Trainers. Pok ́emon is identical in the singular and plural. 
## Knowledge Base
In my knowledge base **pokemon data.pl**, I have a list of predicates, `pokemon_stats`, `pokemon_evolution`, `pokemon_types`, type chart attack and pokemon trainer. They are defned as follows:

```prolog
pokemon_stats(Pokemon, Types, HealthPoint, Attack, Defense). 
pokemon_evolution(Pokemon, EvolvedPokemon, MinRequiredLevel). 
pokemon_types(PokemonTypes).
type_chart_attack(AttackingType, TypeMultipliers).
pokemon_trainer(PokemonTrainer, PokemonTeam, PokemonLevels).
```
- `pokemon_stats` defines a Pok ́emon, and for each Pok ́emon, its types, base health points, attack and defense values are listed. Health points, attack and defense values are Pok ́emon’s base statistics or in other words, when the Pok ́emon is at level 0.
```prolog
pokemon_stats(bulbasaur, [grass, poison], 45, 49, 49).
```
- `pokemon_evolution` defines the evolution process for Pok ́emon that can evolve. 
```prolog
pokemon_evolution(bulbasaur, ivysaur, 16).
```

- `pokemon_types` defines all Pok ́emon types. This is just a single fact to show the order of types to be used in type chart attack.
```prolog
pokemon_types([normal, fire, water, electric, grass, ice, fighting, poison, ground, flying, psychic, bug, rock, ghost, dragon, dark, steel, fairy]).
```

- `type_chart_attack` defines a type, and for each type, attack multipliers against all types are listed. The ordering of the multiplier lists are the same with pokemon types.
```prolog
type_chart_attack(grass, [1.0, 0.5, 2.0, 1.0, 0.5, 1.0, 1.0, 0.5, 2.0, 0.5, 1.0, 0.5, 2.0, 1.0, 0.5, 1.0, 0.5, 1.0]).
```

- `pokemon_trainer` defines a Pok ́emon trainer, and for each Pok ́emon trainer, his/her Pok ́emon team and their levels are listed.
```prolog
pokemon_trainer(ash, [pikachu, bulbasaur, charmeleon, squirtle], [45, 15, 28, 42]).
```
   
## Game Mechanics
In this section I will explain important mechanics that I consider while coding predicates. It will also help you to understand the concept better.
#### Leveling Up
Each Pok ́emon can be at any level. Level of a Pok ́emon has an effect on its statistics and evolution process. With every level a Pok ́emon gains 2 health points, 1 attack point and 1 defense point. For example; base values of health point, attack and defense for Balbasaur are 45, 49, 49 respectively. If I have a level 30 Bulbasaur then its values of health point, attack and defense will be 45 + 30 × 2 = 105, 49 + 30 × 1 = 79 and 49 + 30 × 1 = 79 respectively.
#### Evolution
When a Pok ́emon reaches its minimum required level for evolution it can evolve. However, it is not a compulsory action. So there can be Pok ́emon of any kind at any level (level 10 Charizard or level 50 Charmander are both possible situations). But, Pok ́emon trainers always make their Pok ́emon evolve before tournaments if possible (see pokemon tournament predicate).
#### Pok ́emon Types and Type Multipliers
All Pok ́emon creatures are assigned certain types. Each type has several strengths and weaknesses in both attack and defense. In battle, I use Pok ́emon that have a type advantage over my opponent; doing so will cause much more damage than normal. Each Pok ́emon are assigned to at least one and at most two types.
A single-type advantage (for instance a Water-type Pok ́emon against a Ground-type Pok ́emon) will net me double normal damage. The advantages also ”stack up”, so a double-type advantage (for instance a Water-type Pok ́emon against a Ground/Rock-type Pok ́emon) will net me quadruple damage. Conversely, a single- and double-type disadvantage will afflict half and a quarter normal damage respectively.
## Gotta Catch ’Em All
In this section, I will explain the predicates that I have written for this project. In the example queries, three dots (...) at the end of an output means that the output still continues and the displayed output is only the first part of the result. 
1. `find_pokemon_evolution(+PokemonLevel, +Pokemon, -EvolvedPokemon)`

This predicate is to find the evolved version of Pok ́emon given its level. If there is no evolution, then
EvolvedPokemon = Pokemon. Pok ́emon can evolve more than one time if it has enough levels. 

**Examples:**
```prolog
?- find_pokemon_evolution(40, charmeleon, EvolvedPokemon). 
EvolvedPokemon = charizard.

?- find_pokemon_evolution(50, charmander, EvolvedPokemon).
EvolvedPokemon = charizard.
```

**Note:** charmander →lvl16 charmeleon →lvl36 charizard.
```prolog
?- find_pokemon_evolution(10, charizard, EvolvedPokemon). 
EvolvedPokemon = charizard.

?- find_pokemon_evolution(20, charmander, EvolvedPokemon). 
EvolvedPokemon = charmeleon.
```
2. `pokemon_level_stats(+PokemonLevel, ?Pokemon, -PokemonHp, -PokemonAttack, -PokemonDefense)`

This predicate evaluates the statistics of a Pok ́emon for the given level. With every level a Pok ́emon gains 2 health points, 1 attack point and 1 defense point. You can get the base statistics from pokemon stats.

**Examples:**
```prolog
?- pokemon_level_stats(30, squirtle, PokemonHp, PokemonAttack, PokemonDefense). 
PokemonHp = 104,
PokemonAttack = 78,
PokemonDefense = 95.

?- pokemon_level_stats(10, blastoise, PokemonHp, PokemonAttack, PokemonDefense). 
PokemonHp = 99,
PokemonAttack = 113,
PokemonDefense = 130.

?- pokemon_level_stats(30, Pokemon, PokemonHp, PokemonAttack, PokemonDefense). 
Pokemon = bulbasaur,
PokemonHp = 105,
PokemonAttack = PokemonDefense, 
PokemonDefense = 79;
Pokemon = ivysaur,
PokemonHp = 120,
PokemonAttack = 92,
PokemonDefense = 93;
Pokemon = venusaur,
PokemonHp = 140,
PokemonAttack = 130,
PokemonDefense = 153;
Pokemon = charmander,
PokemonHp = 99,
PokemonAttack = 82,
PokemonDefense = 73;
   ...
```
3. `single_type_multiplier(?AttackerType, +DefenderType, ?Multiplier)` 

This predicate will be used to find single-type advantage/disadvantage multiplier. It can also be used
to find types that achieves a given multiplier.

**Examples:**
```prolog
?- single_type_multiplier(fire, grass, Multiplier).
Multiplier = 2.0;

?- single_type_multiplier(AttackerType, poison, 2.0). 
AttackerType = ground;
AttackerType = psychic;

?- single_type_multiplier(AttackerType, ghost, Multiplier). 
AttackerType = normal,
Multiplier = 0.0;
AttackerType = fire,
Multiplier = 1.0;
AttackerType = water,
Multiplier = 1.0;
AttackerType = electric,
Multiplier = 1.0;
...
```

4. `type_multiplier(?AttackerType, +DefenderTypeList, ?Multiplier)`

This predicate will be used to find double-type advantage/disadvantage multiplier. It can also be used to find types that achieves a given multiplier. DefenderTypeList can only have one item or two items.

**Examples:**
```prolog
?- type_multiplier(ice, [grass, ground], Multiplier).
Multiplier = 4.0;

?- type_multiplier(AttackerType, [grass, ground], 4.0).
AttackerType = ice;
```
5. `pokemon_type_multiplier(?AttackerPokemon, ?DefenderPokemon, ?Multiplier)`

This predicate will be used to find type multiplier between two Pok ́emon. It can also be used to find different attacker/defender Pok ́emon that achieves a given multiplier. If an attacker Pok ́emon has two types, then the Pok ́emon uses the type that gives the higher multiplier against the defender Pok ́emon.

**Examples:**
```prolog
?- pokemon_type_multiplier(bulbasaur, geodude, Multiplier).
Multiplier = 4.0;
```

**Note:** bulbasaur → (grass, poison), geodude → (rock, ground); grass vs (rock, ground) → Multiplier = 4.0, poison vs (rock, ground) → Multiplier = 0.25 ; 4.0 > 0.25 → 4.0
```prolog
?- pokemon_type_multiplier(AttackerPokemon, charizard, 4.0). 
AttackerPokemon = geodude;
AttackerPokemon = graveler;
AttackerPokemon = golem;
AttackerPokemon = onix;

?- pokemon_type_multiplier(machop, DefenderPokemon, 0.25). 
DefenderPokemon = butterfree;
DefenderPokemon = zubat;
DefenderPokemon = golbat;

?- pokemon_type_multiplier(psyduck, DefenderPokemon, Multiplier). 
DefenderPokemon = bulbasaur,
Multiplier = 0.5;
DefenderPokemon = ivysaur,
Multiplier = 0.5;
DefenderPokemon = venusaur,
Multiplier = 0.5;
DefenderPokemon = charmander,
Multiplier = 2.0;
...
 ```
 
6. `pokemon_attack(+AttackerPokemon, +AttackerPokemonLevel, +DefenderPokemon, +DefenderPokemonLevel, -Damage)`

This predicate finds the damage dealt from the attack of the AttackerPokemon to the DefenderPokemon.
Damage = (0.5 × AttackerPokemonLevel × (AttackerPokemonAttack / DefenderPokemonDefense) × TypeMultiplier) + 1

**Examples:**
```prolog
?- pokemon_attack(pikachu, 15, ekans, 12, Damage).
Damage = 10.375.

?- pokemon_attack(psyduck, 35, pikachu, 28, Damage).
Damage = 23.38970588235294.

?- pokemon_attack(golduck, 35, pikachu, 28, Damage).
Damage = 31.1102941176470.
```

7. `pokemon_fight(+Pokemon1, +Pokemon1Level, +Pokemon2, +Pokemon2Level, -Pokemon1Hp, -Pokemon2Hp, -Rounds)`


This predicate simulates a fight between two Pok ́emon then finds health points of each Pok ́emon at the end of the fight and the number of rounds. Each Pok ́emon attacks at the same time and each attack sequence count as one round. After each attack, health points of each Pok ́emon reduced by the amount of calculated damage points. When a Pok ́emon’s health points reach or drop below zero (HP <= 0), the fight ends.

**Examples:**
```prolog
?- pokemon_fight(pikachu, 15, ekans, 12, Pokemon1Hp, Pokemon2Hp, Rounds). 
Pokemon1Hp = 11.872727272727257,
Pokemon2Hp = -3.25,
Rounds = 6.

?- pokemon_fight(psyduck, 35, pikachu, 28, Pokemon1Hp, Pokemon2Hp, Rounds). 
Pokemon1Hp = 4.0,
Pokemon2Hp = -2.558823529411761,
Rounds = 4.

?- pokemon_fight(golduck, 35, pikachu, 28, Pokemon1Hp, Pokemon2Hp, Rounds). 
Pokemon1Hp = 85.3008849557522,
Pokemon2Hp = -2.330882352941181,
Rounds = 3.

?- pokemon_fight(pikachu, 18, pikachu, 18, Pokemon1Hp, Pokemon2Hp, Rounds). 
Pokemon1Hp = Pokemon2Hp, Pokemon2Hp = -2.301724137931041,
Rounds = 11.
```

8. `pokemon_tournament(+PokemonTrainer1, +PokemonTrainer2, -WinnerTrainerList)`

This predicate simulates a tournament between two Pok ́emon trainers then finds the winner Pok ́emon trainer of each fight. Pok ́emon trainers must have the same number of Pok ́emon. Pok ́emon fights in order. First Pok ́emon of the first Pok ́emon trainer fights with the first Pok ́emon of the second Pok ́emon trainer, second Pok ́emon of the first Pok ́emon trainer fights with the second Pok ́emon of the second Pok ́emon trainer. A fight ends when a Pok ́emon’s health points drop below zero. At the end of the fight, Pok ́emon with more health points win the fight, so does the Pok ́emon trainer that owns the winner Pok ́emon. In case of a tie, PokemonTrainer1 wins. Important Note: Pok ́emon trainers force their Pok ́emon to evolve (if possible) before tournament fights to gain maximum efficiency. So I check evolution status of each Pok ́emon.

**Examples:**
```prolog
?- pokemon_tournament(ash, team rocket, WinnerTrainerList).
WinnerTrainerList = [ash, team rocket, team rocket, ash]. 

?- pokemon_tournament(ash, misty, WinnerTrainerList).
WinnerTrainerList = [ash, ash, misty, ash].

?- pokemon_tournament(ash, brock, WinnerTrainerList).
WinnerTrainerList = [brock, brock, brock, ash].

?- pokemon_tournament(misty, brock, WinnerTrainerList).
WinnerTrainerList = [brock, brock, misty, misty].

?- pokemon_tournament(misty, team rocket, WinnerTrainerList).
WinnerTrainerList = [team rocket, team rocket, misty, misty]. 

?- pokemon_tournament(brock, team rocket, WinnerTrainerList).
WinnerTrainerList = [brock, brock, team rocket, team rocket].

?- pokemon_tournament(ash, ash clone, WinnerTrainerList).
WinnerTrainerList = [ash, ash, ash, ash].
```

**Note:** ash clone is the clone of Ash (obviously). He has the exact same Pokemon team with
Ash. Thus the fights are always end in a draw and I declare Ash, PokemonTrainer1, as the winner.
                      
9. `best_pokemon(+EnemyPokemon, +LevelCap, -RemainingHP, -BestPokemon)`

This predicate finds the best Pok ́emon against the given EnemyPokemon where the both Pok ́emon’s levels are LevelCap. I define the best Pok ́emon as the Pok ́emon with the most remaining health points after the fight.

**Examples:**
```prolog
?- best_pokemon(charizard, 42, RemainingHP, BestPokemon). 
RemainingHP = 144.17441860465118,
BestPokemon = golem.

?- best_pokemon(charmander, 4, RemainingHP, BestPokemon). 
RemainingHP = 123.99999999999997,
BestPokemon = lapras.

?- best_pokemon(charmander, 42, RemainingHP, BestPokemon). 
RemainingHP = 179.63934426229508,
BestPokemon = lapras.

?- best_pokemon(charmander, 88, RemainingHP, BestPokemon). 
RemainingHP = 237.7309644670051,
BestPokemon = gyarados.
```

10. `best_pokemon_team(+OpponentTrainer, -PokemonTeam)`

This predicate finds the best Pok ́emon Team against the given OpponentTrainer where the levels of each Pok ́emon of my best Pok ́emon Team are the same with the corresponding Opponent’s Pok ́emon levels (e.g. Level of the first Pok ́emon of the best Pok ́emon Team is same with the level of the first Pok ́emon of the Opponent Trainer). I define the best Pok ́emon as the Pok ́emon with the most remaining health points after the fight.

**Examples:**
```prolog
?- best_pokemon_team(team rocket, PokemonTeam)
PokemonTeam = [wigglytuff, mew, zapdos, golem]. 

?- best_pokemon_team(ash, PokemonTeam)
PokemonTeam = [golem, mewtwo, gyarados, exeggutor].

?- best_pokemon_team(misty, PokemonTeam)
PokemonTeam = [lapras, lapras, exeggutor, exeggutor]. 

?- best_pokemon_team(brock, PokemonTeam)
PokemonTeam = [lapras, lapras, golem, mewtwo].
```

11. `pokemon_types(+TypeList, +InitialPokemonList, -PokemonList)`

This predicate will be used to find every Pok ́emon from InitialPokemonList that are at least one of the types from TypeList.

**Examples:**
```prolog
?- pokemon_types([grass, flying, ground], [bulbasaur, charmander, charizard, gyarados, pikachu], PokemonList).
PokemonList = [bulbasaur, charizard, gyarados].

?- pokemon_types([grass, poison], [bulbasaur, charmander, charizard, gastly, pikachu], PokemonList).
PokemonList = [bulbasaur, gastly].
```

12. `generate_pokemon_team(+LikedTypes, +DislikedTypes, +Criterion, +Count,-PokemonTeam)`

This predicate generates a Pok ́emon team based on liked and disliked types and some criteria. This team can only have Pok ́emon from LikedTypes and can’t have Pok ́emon from DislikedTypes. The predicate sorts Pok ́emon according to one of the three criterion in descending order: health points (h), attack (a), defense (d). Then selects Count number of Pok ́emon that have highest values in the selected criterion. If two or more Pok ́emon has the same value, the order is not important between these Pok ́emon.

**Examples:**
```prolog
?- generate_pokemon_team([dragon, fire, ghost, ice], [flying, ground, rock], a, 4, PokemonTeam).
PokemonTeam = [[cloyster, 50, 95, 180], [magmar, 65, 95, 57], [lapras, 130, 85, 80], [dragonair, 61, 84, 65]].

?- generate_pokemon_team([fire, water, electric], [psychic, dragon], h, 4, PokemonTeam).
PokemonTeam = [[lapras, 130, 85, 80], [gyarados, 95, 155, 109], [zapdos, 90, 90, 85], [moltres, 90, 100, 90]].

?- generate_pokemon_team([fire, water, electric], [psychic, dragon], a, 4, PokemonTeam).
PokemonTeam = [[gyarados, 95, 155, 109], [charizard, 78, 104, 78], [blastoise, 79, 103, 120], [moltres, 90, 100, 90]].

?- generate_pokemon_team([fire, water, electric], [psychic, dragon], d, 4, PokemonTeam).
PokemonTeam = [[cloyster, 50, 95, 180], [blastoise, 79, 103, 120], [gyarados, 95, 155, 109], [shellder, 30, 65, 100]].

```
