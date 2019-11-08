% Furkan Kadıoğlu
% 2015400051
% compiling: yes
% complete: yes
%4.1 
find_pokemon_evolution(PokemonLevel, 
                        Pokemon, 
                        EvolvedPokemon):-
    
    %more than once evolution
    pokemon_evolution(Pokemon, 
                        Evolved, 
                        MinRequiredLevel),
    PokemonLevel > MinRequiredLevel,
    find_pokemon_evolution(PokemonLevel, 
                            Evolved, 
                            EvolvedPokemon),!;
    %one evolution
    pokemon_evolution(Pokemon, 
                        EvolvedPokemon, 
                        MinRequiredLevel),
    PokemonLevel > MinRequiredLevel,!;
    %no evolution 
    EvolvedPokemon = Pokemon.

%4.2
pokemon_level_stats(PokemonLevel,
                    Pokemon, 
                    PokemonHp, 
                    PokemonAttack, 
                    PokemonDefense):-
    %takes possible pokemons' values for given query
    pokemon_stats(Pokemon, 
                    _, 
                    HealthPoint, 
                    Attack, 
                    Defense),

    %makes calculations for level relative
    PokemonHp is (2 * PokemonLevel) + HealthPoint,
    PokemonAttack is PokemonLevel + Attack,
    PokemonDefense is PokemonLevel + Defense.

%4.3
%takes two lists and one variable
%list1[x] == variable => returns list2[x]
member2(Pokemon, 
        PokemonTypes, 
        TypeMultipliers, 
        Multiplier):-
    
    %checks head element 
    PokemonTypes = [HeadTypes|_],
    TypeMultipliers = [HeadMulti|_],
    HeadTypes = Pokemon,
    Multiplier = HeadMulti,!;

    %checks tails
    PokemonTypes = [_|TailTypes],
    TypeMultipliers = [_|TailMulti],
    member2(Pokemon, 
            TailTypes, 
            TailMulti, 
            Multiplier).


single_type_multiplier(AttackerType, 
                        DefenderType, 
                        Multiplier):-
    %gets multipliers and pokemon type lists
    type_chart_attack(AttackerType, 
                        TypeMultipliers),
    pokemon_types(PokemonTypes),

    %returns Multiplier
    member2(DefenderType, 
            PokemonTypes, 
            TypeMultipliers, 
            Multiplier).


%4.4
type_multiplier(AttackerType, 
                DefenderTypeList, 
                Multiplier):-

    %two defense
    DefenderTypeList = [HeadDefense|TailDefense],
    TailDefense = [H|_],
    single_type_multiplier(AttackerType,
                            H,
                            TailMulti),
    single_type_multiplier(AttackerType,
                            HeadDefense,
                            HeadMulti),
    Multiplier is HeadMulti * TailMulti,!;

    %one defense
    DefenderTypeList = [HeadDefense|_],
    single_type_multiplier(AttackerType,
                            HeadDefense,
                            HeadMulti),
    Multiplier is HeadMulti.

%4.5
%returns max of A & B
max(A,B,Max):-
    A > B,
    Max is A,!;
    B >= A,
    Max is B.

%calculates Multiplier for given attack & defense 
%helper rule at this form poke_type(ground,normal,X)
poke_type(AttackTypes,
            DefenseTypes,
            Multiplier):-
    AttackTypes = [Ah|At],
    
    %two attack types
    (type_multiplier(Ah, 
                    DefenseTypes, 
                    AhMulti),
    At = [H|_],
    type_multiplier(H, 
                    DefenseTypes, 
                    AtMulti),
    max(AhMulti,
        AtMulti,
        Multiplier),!;
    
    %one attack types 
    type_multiplier(Ah, 
                    DefenseTypes, 
                    Multiplier)).


pokemon_type_multiplier(AttackerPokemon, 
                        DefenderPokemon, 
                        Multiplier):-
    
    %gets pokemons' types
    pokemon_stats(AttackerPokemon, 
                    AttackTypes, 
                    _, 
                    _, 
                    _),
    pokemon_stats(DefenderPokemon, 
                    DefenseTypes, 
                    _, 
                    _, 
                    _),
    poke_type(AttackTypes,
                DefenseTypes,
                Multiplier).
    
%4.6 
pokemon_attack(AttackerPokemon, 
                AttackerPokemonLevel, 
                DefenderPokemon,
                DefenderPokemonLevel, 
                Damage):-
    %gets Multiplier for battle  
    pokemon_type_multiplier(AttackerPokemon,
                            DefenderPokemon,
                            Multiplier),
    pokemon_level_stats(AttackerPokemonLevel,
                    AttackerPokemon, 
                    _, 
                    AttackerPokemonAttack, 
                    _),
    pokemon_level_stats(DefenderPokemonLevel,
                    DefenderPokemon, 
                    _, 
                    _, 
                    DefenderPokemonDefense),
    %calculates Damage
    Damage is (0.5 
                * AttackerPokemonLevel 
                * AttackerPokemonAttack 
                / DefenderPokemonDefense 
                *Multiplier) 
                + 1.


%4.7 
% checks whether one of pokemons dead or not
is_dead(Hp1,
        Hp2,
        D1_2,
        D2_1,
        Round,
        Counter,
        FinalHp_1,
        FinalHp_2):-
    %one sequence for the battle
    H1 is Hp1 - D2_1,
    H2 is Hp2 - D1_2,
    X is Counter + 1,

    %death condition
    ((H1 =< 0; H2 =< 0),
    Round is X,
    FinalHp_1 is H1,
    FinalHp_2 is H2,!;

    %no death condition
    is_dead(H1,
        H2,
        D1_2,
        D2_1,
        Round,
        X,
        FinalHp_1,
        FinalHp_2)).


pokemon_fight(Pokemon1,
                Pokemon1Level, 
                Pokemon2, 
                Pokemon2Level,
                Pokemon1Hp, 
                Pokemon2Hp, 
                Rounds):-
    %gets Damage values for both of them 
    %pokemon1 attacks to pokemon2
    pokemon_attack(Pokemon1, 
                Pokemon1Level, 
                Pokemon2,
                Pokemon2Level, 
                Damage1_2),
    %pokemon2 attacks to pokemon1
    pokemon_attack(Pokemon2, 
                Pokemon2Level, 
                Pokemon1,
                Pokemon1Level, 
                Damage2_1),

    %get Hp values
    pokemon_level_stats(Pokemon1Level,
                    Pokemon1, 
                    Hp_1, 
                    _, 
                    _),
    pokemon_level_stats(Pokemon2Level,
                    Pokemon2, 
                    Hp_2, 
                    _, 
                    _),
    
    %calls Round calculator
    is_dead(Hp_1,
        Hp_2,
        Damage1_2,
        Damage2_1,
        Rounds,
        0,
        Pokemon1Hp,
        Pokemon2Hp).

%4.8 

tournament(_,
            _,
            [],
            [],
            [],
            [],
            WinnerTrainerList):-
    WinnerTrainerList = [].

tournament(PokemonTrainer1,
            PokemonTrainer2,
            PokemonTeam1,
            PokemonLevels1,
            PokemonTeam2,
            PokemonLevels2,
            WinnerTrainerList):-
    
    %defines team lists' heads & tails  
    PokemonTeam1 = [HeadTeam1|TailTeam1],
    PokemonTeam2 = [HeadTeam2|TailTeam2],

    %defines level lists' heads & tails
    PokemonLevels1 =  [HeadLevels1|TailLevels1],
    PokemonLevels2 =  [HeadLevels2|TailLevels2],

    %defines winners' head and tail 
    WinnerTrainerList = [HeadWinner|TailWinner],

    %battle happened for tail pokemons 
    tournament(PokemonTrainer1,
            PokemonTrainer2,
            TailTeam1,
            TailLevels1,
            TailTeam2,
            TailLevels2,
            TailWinner),

    
    %battle happened for first pokemons 
    %evolutions possible
    find_pokemon_evolution(HeadLevels1, 
                            HeadTeam1, 
                            EvolvedPokemon1),

    find_pokemon_evolution(HeadLevels2, 
                            HeadTeam2, 
                            EvolvedPokemon2),
    pokemon_fight(EvolvedPokemon1,
                HeadLevels1, 
                EvolvedPokemon2, 
                HeadLevels2,
                Pokemon1Hp, 
                Pokemon2Hp, 
                _),

    (Pokemon2Hp > Pokemon1Hp,
    HeadWinner = PokemonTrainer2,!;
    HeadWinner = PokemonTrainer1).

    

pokemon_tournament(PokemonTrainer1, 
                    PokemonTrainer2, 
                    WinnerTrainerList):-
    %gets Trainers' Pokemons 
    pokemon_trainer(PokemonTrainer1, 
                    PokemonTeam1, 
                    PokemonLevels1),
    pokemon_trainer(PokemonTrainer2, 
                    PokemonTeam2, 
                    PokemonLevels2),

    %makes the tournament
    tournament(PokemonTrainer1,
            PokemonTrainer2,
            PokemonTeam1,
            PokemonLevels1,
            PokemonTeam2,
            PokemonLevels2,
            WinnerTrainerList).

%4.9
%returns highest value in List
max_elements(X,List):-
    List = [H|T],
    (max_elements(Y,T),
    max(H,Y,X),!;
    X is H).

best_pokemon(EnemyPokemon, 
             LevelCap, 
             RemainingHP, 
             BestPokemon):-
    
    %finds Pokemons beat EnemyPokemon
    findall(Pokemon1,
    (pokemon_fight(Pokemon1,
                    LevelCap, 
                    EnemyPokemon, 
                    LevelCap,
                    Pokemon1Hp, 
                    Pokemon2Hp, 
                    Rounds),
    Pokemon1Hp > Pokemon2Hp),
    BestList),
    
    %finds Pokemons' Hp beat EnemyPokemon
    findall(Pokemon1Hp,
    (pokemon_fight(Pokemon1,
                    LevelCap, 
                    EnemyPokemon, 
                    LevelCap,
                    Pokemon1Hp, 
                    Pokemon2Hp, 
                    Rounds),
    Pokemon1Hp > Pokemon2Hp),
    HpList),
    
    %returns maximum RemaingHp
    max_elements(RemainingHP,HpList),
    %returns Pokemon has maximum RemaingHp
    member2(RemainingHP,
            HpList,
            BestList,
            BestPokemon).
    
%4.10
%base case for recursive function
team([],[],[]). 

%returns the bests recursively
team(Team,Levels,TheBest):-
    
    Team = [HeadTeam|TailTeam],
    Levels = [HeadLevels|TailLevels],
    TheBest = [HeadBest|TailBest],

    %first pokemon
    (best_pokemon(HeadTeam, 
                HeadLevels, 
                _, 
                HeadBest),
    %rest of pokemons
    team(TailTeam,TailLevels,TailBest),!;
    best_pokemon(HeadTeam, 
                HeadLevels, 
                _, 
                HeadBest)).

best_pokemon_team(OpponentTrainer, 
                PokemonTeam):-
    
    %gets Opponent's Team and their Levels
    pokemon_trainer(OpponentTrainer, 
                    OpponentTeam, 
                    OpponentLevels),
    
    %returns List has the bests
    team(OpponentTeam,
        OpponentLevels,
        PokemonTeam).

%4.11
%returns List contain X or not.
contain(X,List):-
    List =  [H|T],
    (H = X,!;
    contain(X,T)).

%returns Is there any element of X in List
list_contain(X,List):-
    X = [H|T],
    (contain(H,List),!;
    list_contain(T,List)).

%base case 
inter([], _, []).

%returns intersection lists
inter([H1|T1], L2, [H1|Res]) :-
    contain(H1, L2),
    inter(T1, L2, Res),!;
    contain(H1, L2).
inter([_|T1], L2, Res) :-
    inter(T1, L2, Res).


pokemon_types(TypeList, 
            InitialPokemonList, 
            PokemonList):-

    %finds Pokemons have TypeList
    findall(X,
            (pokemon_stats(X, Types, _, _, _),
                list_contain(Types,TypeList)),
            List),

    %finds intersection 
    %InitialPokemonList and Pokemons have TypeList
    inter(List,
        InitialPokemonList,
        PokemonList).

%4.12
%cuts the Highest 
count(Origin,Count,Res):-
    Origin = [HeadOrigin|TailOrigin],
    Res = [HeadRes|TailRes],
    C is Count - 1,
    C >= 0,
    HeadRes = HeadOrigin,
    count(TailOrigin,C,TailRes),!;
    Res = [].
    

%comparison for sorting 
%keeps duplicates
compare_defense(X,[_,_,_,A1],[_,_,_,A1]):- 
    compare(X,A1,A1+1).
compare_defense(X,[_,_,_,A1],[_,_,_,A2]):- 
    compare(X,A2,A1).


%keeps duplicates
compare_attack(X,[_,_,A1,_],[_,_,A1,_]):- 
    compare(X,A1,A1+1).
compare_attack(X,[_,_,A1,_],[_,_,A2,_]):- 
    compare(X,A2,A1).

%keeps duplicates
compare_hp(X,[_,A1,_,_],[_,A1,_,_]):- 
    compare(X,A1,A1+1).
compare_hp(X,[_,A1,_,_],[_,A2,_,_]):- 
    compare(X,A2,A1).

generate_pokemon_team(LikedTypes, 
                    DislikedTypes, 
                    Criterion, 
                    Count,
                    PokemonTeam):-
    %Liked Pokemons
    findall(E,
        pokemon_stats(E, 
            _, _, _, _),
        AllPokemons),
    %finds liked pokemons    
    pokemon_types(LikedTypes,
                AllPokemons, 
                LikedList),
    %finds disliked pokemons
    pokemon_types(DislikedTypes,
                AllPokemons, 
                DislikedList),
    intersection(LikedList,
                DislikedList,
                ConfusedSoul),
    subtract(LikedList,
            ConfusedSoul,
            LovelyPokemons),

    
    %gets selected pokomens' values
    findall([Name,Hp,Attack,Defense],
            (member(Name,LovelyPokemons),
                pokemon_stats(Name, 
                            _, 
                            Hp, 
                            Attack, 
                            Defense)),
            ProposalTeam),
    
    %Sort 
    (predsort(compare_attack,ProposalTeam,SortedProp),
        Criterion = a,!;
    predsort(compare_defense,ProposalTeam,SortedProp),
        Criterion = d,!;
    predsort(compare_hp,ProposalTeam,SortedProp),
        Criterion = h,!),     
    

    %Select Highest
    count(SortedProp,Count,PokemonTeam).
