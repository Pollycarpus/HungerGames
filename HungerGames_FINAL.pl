:- dynamic(enemy/4).
:- dynamic(food/4).
:- dynamic(water/4).
:- dynamic(medicine/4).
:- dynamic(weapon/4).
:- dynamic(radar/2).
:- dynamic(inventory/1).
:- dynamic(locPlayer/2).
:- dynamic(hunger/1).
:- dynamic(thirst/1).
:- dynamic(health/1).
:- dynamic(myweapon/1).
:- dynamic(alive/1).
:- dynamic(turn/1).

alive(no).

listFood([[apple, 15], [donut, 20], ['canned soup', 30], [seblak, 10]]).
listMedicine([[panadol, 25], [bioplacenton, 20], [trombophob, 30], [betadine, 10], ['mefenamic acid', 15]]).
listEnemy([[joker, 5, 10, [apple, pouch]], [medusa, 7, 15, [betadine, 'canned soup', apple, sword]], [voldemort, 10, 20, [trombophob, donut, betadine, axe]]]).
listWeapon([[axe], [sword], [arrow]]).
listWater([[pouch], ['water pouch']]).
listMoveEnemy([[0,1],[0,-1],[1,0],[-1,0]]).

drinkableWater('water pouch').

randomPoint(MinB, MaxB, MinK, MaxK, X, Y) :-
    randomize, random(MinB, MaxB, X), random(MinK, MaxK, Y).

/* command start */

start :-
    alive(no), !, retract(alive(no)), assertz(alive(yes)), assertz(turn(0)),
    randomPoint(8, 10, 5, 7, Abs, Ord), setLocPlayer(Abs, Ord),
    randomize, random(10, 20, NEnemy), setEnemy(1, NEnemy),
    randomize, random(15, 20, NFood), setFood(1, NFood),
    randomize, random(15, 20, NWater), setWater(1, NWater),
    randomize, random(15, 20, NMed), setMedicine(1, NMed),
    randomize, random(15, 20, NWea), setWeapon(1, NWea),
    setRadar, setStatus, setInventory([]),
    write(' _   _ _   _ _   _ _____  ___________   _____   ___  ___  ___ _____ _____\n'), 
    write('| | | | | | | \\ | |  __ \\|  ___| ___ \\ |  __ \\ / _ \\ |  \\/  ||  ___/  ___|\n'),
    write('| |_| | | | |  \\| | |  \\/| |__ | |_/ / | |  \\// /_\\ \\| .  . || |__ \\ `--.\n'),
    write('|  _  | | | | . ` | | __ |  __||    /  | | __ |  _  || |\\/| ||  __| `--. \\ \n'),
    write('| | | | |_| | |\\  | |_\\ \\| |___| |\\ \\  | |_\\ \\| | | || |  | || |___/\\__/ /\n'),
    write('\\_| |_/\\___/\\_| \\_/\\____/\\____/\\_| \\_|  \\____/\\_| |_/\\_|  |_/\\____/\\____/\n'),
    write('                                __.oOo.__                                \n'),
    write('                               /\'(  _  )\\`\\                               \n'),
    write('                              / . \\/^\\/ . \\                              \n'),
    write('                             /  _)_\\`-\'_(_ \\                             \n'),
    write('                            /.-~   ).(   ~-.\\                            \n'),
    write('                           /\'     /\\_/\\     \`\\                           \n'),
    write('                                  "-V-"                                  \n'),
    write('Welcome to the 77th Hunger Games!\n'),
    write('You have been chosen as one of the lucky contestants. Be the last man standing\nand you will be remembered as one of the victors.\n'),
    nl, help, nl,
    write('Happy Hunger Games! And may the odds be ever in your favor.'), nl,
    printLookA(Abs, Ord), printAroundN(Abs, Ord).

start :- alive(yes), write('Sorry, there is played game\n').

/* menampilkan semua fungsi-fungsi yang dapat digunakan di game  */

help :-
    write('Available commands:'), nl,
    write('quit.                --quit the game'), nl,
    write('look.                --look around you'), nl,
    write('n,s,e,w              --move n : north, s : south, e : east, w : west'), nl,
    write('map.                 --look at the map and detect enemies(need radar to use)\n'),
    write('take(Object)         --pick up an object\n'),
    write('drop(Object)         --drop an object\n'),
    write('use(Object)          --use an Object\n'),
    write('attack.              --attack enemy that crosses your path\n'),
    write('status.              --show your status\n'),
    write('save(Filename).      --save your game\n'),
    write('loadGame(Filename).  --load preciously saved game\n'),
    write('surrender.           --well, we don\'t recommend it:)\n'),
    write('makedonut.           --you can make donut in Kampus\n'), nl,
    write('Legends:\n'),
    write('* = cornucopia\n'),
    write('+ = lake\n'),
    write('@ = west_coast\n'),
    write('^ = cave\n'),
    write('= = forest\n'),
    write('& = kampus\n'),
    write('$ = mountain\n'),
    write('~ = river\n'),
    write('? = open_field\n'),
    write('M = medicine\n'),
    write('F = food\n'),
    write('W = water\n'),
    write('# = weapon\n'),
    write('P = player\n'),
    write('E = enemy\n'),
    write('- = accessible\n'),
    write('X = inaccessible\n').

e :-
    alive(yes), locPlayer(X, Y),
    U is X + 1,
    accessable(U, Y), !,
    goTo(X, Y, U, Y, p, _),
    write('You go east. '),
    enemyMoveInit,
    printLookA(U, Y), printAroundN(U, Y),
    updateStatus.


e :- alive(yes), !, write('You can\'t go there.\n '),
    updateStatus,
    enemyDo.

e :- alive(no), !, write('No game is being played.\n').

w :-
    alive(yes), locPlayer(X, Y),
    U is X - 1,
    accessable(U, Y), !,
    goTo(X, Y, U, Y, p, _),
    write('You go west. '),
    enemyMoveInit,
    printLookA(U, Y), printAroundN(U, Y),
    updateStatus.

w :- alive(yes), !, write('You can\'t go there.\n'),
    updateStatus,
    enemyDo.

w :- alive(no), !, write('No game is being played.\n').

n :-
    alive(yes), locPlayer(X, Y),
    U is Y - 1,
    accessable(X, U), !,
    goTo(X, Y, X, U, p, _),
    write('You go north. '),
    enemyMoveInit,
    printLookA(X, U), printAroundN(X, U),
    updateStatus.

n :- alive(yes), !, write('You can\'t go there.\n'), updateStatus,
    enemyDo.

n :- alive(no), !, write('No game is being played.\n').

s :-
    alive(yes), locPlayer(X, Y),
    U is Y + 1,
    accessable(X, U), !,
    goTo(X, Y, X, U, p, _),
    write('You go south. '),
    enemyMoveInit,
    printLookA(X, U), printAroundN(X, U),
    updateStatus.

s :- alive(yes), !, write('You can\'t go there.\n'),
    updateStatus,
    enemyDo.

s :- alive(no), !, write('No game is being played.\n').

look :-
    alive(yes), !,
    enemyDo,
    locPlayer(X, Y), printLookA(X, Y), nl,
    X0 is X-1, Y0 is Y-1, X1 is X+1, Y1 is Y+1, lookLoop(X0,Y0,X0,X1,Y0,Y1),
    updateStatus.

look :-
    alive(no), !, write('No game is being played.\n').

map :- alive(yes), inventory(Inventory), member(radar, Inventory), !, printPagar(0), write('#'), printMap(1, 1), printPagar(0), updateStatus.

map :- alive(yes), !, write('You don\'t have radar\n'), updateStatus.

map :- alive(no), !, write('No game is being played\n').

surrender :- alive(yes), !, write('Oh no! You\'ve surrendered.\n\nYou have lost the hunger game\n'), retract(alive(yes)), assertz(alive(no)), reset.

surrender :- alive(no), !, write('Even no game is being played._.\n').

makedonut :-
    alive(yes), locPlayer(Abs, Ord), location(Abs, Ord, kampus), inventory(L), length(L, C), C < 10, !, addInventory(donut),
    write('Donut has been cooked, now it is in your inventory\n'), enemyDo, updateDonut, updateStatus.

makedonut :-
    alive(yes), locPlayer(Abs, Ord), location(Abs, Ord, kampus), inventory(L), length(L, C), C == 10, !,
    write('Donut has been cooked. Your inventory is full, donut on the ground now, it seems still edible\n'), drop(donut),
    updateDonut, updateStatus.

makedonut :-
    alive(yes), locPlayer(Abs, Ord), \+location(Abs, Ord, kampus), !, write('You aren\'t in Kampus now, you can\'t make that delicious donut:(\n'),
    enemyDo, updateStatus.

makedonut :- alive(no), !, write('Even no game is being played._., why you really love donut<3\n').

attack :-
    alive(yes), \+myweapon(none), locPlayer(Abs, Ord),
    enemy(_, Abs, Ord, _), !,
    attackLoop, enemyDo, updateStatus.

attack :-
    alive(yes), \+myweapon(none), !, write('There is nobody here. Nobody in your vision, anyway!\n'), enemyDo, updateStatus.

attack :-
    alive(yes), myweapon(none), !, write('You don\'t have a weapon, you can\'t attack\n'), enemyDo, updateStatus.

attack :-
    alive(no), !, write('No game is being played\n').

status :-
    alive(yes), !,
    write('Health : '), health(ValHP), write(ValHP), nl,
    write('Hunger : '), hunger(ValHu), write(ValHu), nl,
    write('Thirst : '), thirst(ValTh), write(ValTh), nl,
    write('Weapon : '), myweapon(ValWe), write(ValWe), nl,
    write('Inventory : '), inventory(ValIn), printInventory(ValIn), !.

status :-
    alive(no), !, write('You aren\'t play this game. just type start!._.\n').

take(Items) :-
    alive(yes), locPlayer(Abs, Ord), food(Items, Abs, Ord, Num), !, addInventory(Items), retract(food(Items, Abs, Ord, Num)),
    write('You took the '), write(Items), write('.'), nl, enemyDo, updateStatus, !.

take(Items) :-
    alive(yes), locPlayer(Abs, Ord), medicine(Items, Abs, Ord, Num), !, addInventory(Items), retract(medicine(Items, Abs, Ord, Num)),
    write('You took the '), write(Items), write('.'), nl, enemyDo, updateStatus, !.

take(Items) :-
    alive(yes), locPlayer(Abs, Ord), weapon(Items, Abs, Ord, Num), !, addInventory(Items), retract(weapon(Items, Abs, Ord, Num)),
    write('You took the '), write(Items), write('.'), nl,  enemyDo, updateStatus, !.

take(Items) :-
    alive(yes), locPlayer(Abs, Ord), water(Items, Abs, Ord, Num), !, addInventory(Items), retract(water(Items, Abs, Ord, Num)),
    write('You took the '), write(Items), write('.'), nl, enemyDo, updateStatus, !.

take(Items) :-
    alive(yes), Items == radar, locPlayer(Abs, Ord), radar(Abs, Ord), !, addInventory(Items), retract(radar(Abs, Ord)),
    write('You took the '), write(Items), write('. Now, you can use map.\n'), enemyDo, updateStatus, !.

take(Items) :-
    alive(yes), !, write('There is no '), write(Items), write(' here.\n'), enemyDo, updateStatus, !.

take(_) :- alive(no), !, write('No game is being played\n').

drop(X) :-
    alive(yes),
    inventory(Y),
    member(X,Y), !,
    write('You dropped the '), write(X), nl,
    del(X,Y,Z), retract(inventory(_)), assertz(inventory(Z)),
    enemyDo, addToMap(X), updateStatus.

drop(X) :-
    alive(yes),
    myweapon(X),
    retract(myweapon(X)), assertz(myweapon(none)),
    write('You dropped the '), write(X), write('. Now you don\'t use a weapon\n'),
    addToMap(X), addToMap(X), enemyDo, updateStatus.

drop(X) :-
    alive(yes), !, write('There is no '), write(X) , write(' here.'), enemyDo, updateStatus.

drop(_) :-
    alive(no), !, write('No game is being played\n').

use(X) :-
        alive(yes),
		inventory(Y),
		member(X,Y),
		listFood(P),
		member([X,W|_],P), !,
		write('You ate the '), write(X), nl,
		del(X,Y,Z), retract(inventory(_)), assertz(inventory(Z)),
		hunger(V), retract(hunger(_)), A is V + W, assertz(hunger(A)), enemyDo, updateStatus.

use(X) :-
        alive(yes),
		inventory(Y),
		member(X,Y),
		listMedicine(P),
		member([X,W|_],P), !,
		write('You treated your wounds with '), write(X), nl,
		del(X,Y,Z), retract(inventory(_)), assertz(inventory(Z)),
		health(V), retract(health(_)), A is V + W, assertz(health(A)), enemyDo, updateStatus.

use(X) :-
        alive(yes),
		inventory(Y),
		member(X,Y),
		X == 'water pouch', !,
		write('You drank from the '), write(X), write('. The pouch is now empty.'), nl,
		thirst(V), retract(thirst(_)), A is V + 50, assertz(thirst(A)), enemyDo, updateStatus,
		del(X,Y,Z), retract(inventory(_)), assertz(inventory(Z)),
		addInventory(pouch).

use(X) :-
        alive(yes),
		inventory(Y),
		member(X,Y),
		X == pouch, !, 
		locPlayer(Abs,Ord),
		location(Abs,Ord,Namalokasi), Namalokasi == river,
		del(X,Y,Z), retract(inventory(_)), assertz(inventory(Z)),
		write('You fill your pouch with water'),
		addInventory('water pouch'), enemyDo, updateStatus.

use(X) :-
        alive(yes),
		inventory(Y),
		member(X,Y),
		X == pouch,
		locPlayer(Abs,Ord),
		location(Abs,Ord,Namalokasi), Namalokasi == lake,
		write('You fill your pouch with water\n.'),
		del(X,Y,Z), retract(inventory(_)), assertz(inventory(Z)),
		addInventory('water pouch'), enemyDo, updateStatus.

use(X) :-
        alive(yes),
		inventory(Y),
		member(X,Y),
		X == pouch,
		locPlayer(Abs,Ord),
		location(Abs,Ord,Namalokasi), !,
		write('You are not in lake or river but '), write(Namalokasi), nl,
		enemyDo, updateStatus.

use(X) :-
        alive(yes),
		inventory(Y),
		member(X,Y),
		listWeapon(P),
		member([X|_],P),
		myweapon(WeaNow), WeaNow \== none, !,
		write('You use '), write(X), write(' at your hands'), nl,
		del(X,Y,Z), retract(inventory(_)), assertz(inventory(Z)),
		retract(myweapon(_)), assertz(myweapon(X)),
		addInventory(WeaNow),
		enemyDo, updateStatus.

use(X) :-
        alive(yes),
		inventory(Y),
		member(X,Y),
		listWeapon(P),
		member([X|_],P),
		myweapon(WeaNow), WeaNow == none, !,
		write('You use '), write(X), write(' at your hands'), nl,
		del(X,Y,Z), retract(inventory(_)), assertz(inventory(Z)),
		retract(myweapon(_)), assertz(myweapon(X)),
		enemyDo, updateStatus.

use(X) :-
		alive(yes),!, write('You do not have '), write(X), enemyDo, updateStatus.

use(_) :- 
        alive(no), !, write('No game is being played\n').

setStatus :-
    assertz(health(100)),
    assertz(thirst(100)),
    assertz(hunger(100)),
    assertz(myweapon(none)).

accessable(X, Y) :-
    !,
    X >= 1,
    X =< 20,
    Y >= 1,
    Y =< 10.

/* mengeset lokasi player */
setLocPlayer(Abs, Ord) :-
    assertz(locPlayer(Abs,Ord)).

chooseName([], []).

chooseName(List, Name) :-
    length(List, Length),
    randomize, random(0, Length, Index),
    nth0(Index, List, [Name|_]).

location(X,Y,cave) :- X<7, Y<3, !.
location(X,Y,'west coast') :- X<6, Y>9, !; X<5, Y>8, !; X<4, Y>7, !; X<3, Y>6, !; X<2, Y>5, !.
location(X,Y,lake) :- X<2, Y>2, Y<5, !; X<3, Y>2, Y<4, !; X>6, X<11, Y>9, !; X>7, X<10, Y>8, !; X>12, X<15, Y=6, !; X=14, Y=7, !.
location(X,Y,cornucopia) :- X>7, X<11, Y>4, Y<8, !.
location(X,Y,forest) :- X>7, X<12, Y<3, !; X=11, Y>5, Y<9, !; X=12, Y>4, Y<10, !; X>12, X<15, Y>3, Y<6, !; X>12, X<15, Y>7, !; X=13, Y=17, !; X=15, Y>3, !; X = 13, Y = 7, !.
location(X,Y,kampus) :- X>15, X<19, Y>3, !.
location(X,Y,mountain) :- X=16, Y=1, !; X=17, Y<3, !; X=18, Y<4, !; X>18, !.
location(X,Y,river) :- X>1, X<8, Y=6, !; X=7, Y>2, Y<7, !; X>6, X<18, Y=3, !; X>14, X<17, Y=2, !.
location(X,Y,'open field') :- X=1, Y=5, !; X=2, Y>3, Y<6, !; X>2, X<7, Y>2, Y<6, !; X=7, Y<3, !; X>7, X<13, Y=4, X=11, Y=5, !; X>11, X<16, Y=1, !; X>11, X<15, Y=2, !; X>2, X<8, Y=7, !; X>3, X<11, Y=8, !; X>4, X<8, Y=9, !;  X>9, X<12, Y=9, !; X=6, Y=10, !; X>10, X<13, Y=10, !; X>=8, X =<12, Y=4, !; X=11, Y=5, !.

setEnemy(X, Y) :-
    X =< Y, !,
    randomPoint(1, 20, 1, 10, Abs, Ord),
    listEnemy(ListEnemy), chooseName(ListEnemy, Name),
    makeEnemy(Name, Abs, Ord, X),
    U is X + 1,
    setEnemy(U, Y).

setEnemy(_, _).

makeEnemy(Name, Abs, Ord, Num) :-
    assertz(enemy(Name, Abs, Ord, Num)).

setFood(X, Y) :-
    X =< Y, !,
    randomPoint(1, 10, 1, 20, Abs, Ord),
    listFood(ListFood), chooseName(ListFood, Name),
    makeFood(Name, Abs, Ord, X),
    U is X + 1,
    setFood(U, Y).

setFood(_, _).

makeFood(Name, Abs, Ord, Num) :-
    assertz(food(Name, Abs, Ord, Num)).

setWater(X, Y) :-
    X =< Y, !,
    randomPoint(1, 10, 1, 20, Abs, Ord),
    makeWater('water pouch', Abs, Ord, X),
    U is X + 1,
    setWater(U, Y).

setWater(_, _).

makeWater(Name, Abs, Ord, Num) :-
    assertz(water(Name, Abs, Ord, Num)).

setMedicine(X, Y) :-
    X =< Y, !,
    randomPoint(1, 10, 1, 20, Abs, Ord),
    listMedicine(ListM), chooseName(ListM, Name),
    makeMedicine(Name, Abs, Ord, X),
    U is X + 1,
    setMedicine(U, Y).

setMedicine(_, _).

makeMedicine(Name, Abs, Ord, Num) :-
    assertz(medicine(Name, Abs, Ord, Num)).

setWeapon(X, Y) :-
    X =< Y,
    !,
    randomPoint(1, 10, 1, 20, Abs, Ord),
    listWeapon(ListM), chooseName(ListM, Name),
    makeWeapon(Name, Abs, Ord, X),
    U is X + 1,
    setWeapon(U, Y).

setWeapon(_, _).

makeWeapon(Name, Abs, Ord, Num) :-
    assertz(weapon(Name, Abs, Ord, Num)).

setInventory(X) :-
    assertz(inventory(X)).

setRadar :-
    randomPoint(1, 10, 1, 20, Abs, Ord),
    makeRadar(Abs, Ord).

makeRadar(Abs, Ord) :-
    assertz(radar(Abs, Ord)).

attackEnemy(Abs, Ord, Num) :-
    alive(yes), enemy(Name, Abs, Ord, Num),
    listEnemy(ListEnemy),
    member([Name, DamMin, DamMax | _], ListEnemy),
    randomize, random(DamMin, DamMax, Damage),
    health(Health), NewHealth is Health - Damage,
    write('Oh No! You took '), write(Damage), write(' damage! The enemy is still there\n'),
    retract(health(Health)), assertz(health(NewHealth)), stillAlive.

attackEnemy(_, _, _) :-
    alive(no), !. /*do nothing */

stillAlive :-
    isAlive, alive(yes), !.

stillAlive :-
    isAlive, alive(no), !, nl, loseGame.

enemyDo :-
    enemy(_, Abs, Ord, Num),
    enemyGo(Abs, Ord, Num),
    fail.

enemyDo.

enemyGo(Abs, Ord, Num) :-
    enemyChanceAttack(Abs, Ord, Num), !.

enemyGo(Abs, Ord, Num) :-
    !, enemyMove(Abs, Ord, Num).

enemyChanceAttack(Abs, Ord, Num) :-
    locPlayer(Abs, Ord), !,
    attackEnemy(Abs, Ord, Num).

enemyMoveInit :-
    enemy(_, Abs, Ord, Num),
    enemyMove(Abs, Ord, Num),
    fail.

enemyMoveInit.

enemyMove(Abs, Ord, Num) :-
    listMoveEnemy(ListE),
    randomEnemyMove(ListE, Dx, Dy),
    /*write('Dx = '), write(Dx), write('Dy = '), write(Dy), nl,*/
    A is Dx + Abs,
    B is Dy + Ord,
    /*write('A = '), write(A), write('B = '), write(B),*/
    accessable(A, B),
    !, goTo(Abs, Ord, A, B, e, Num).

enemyMove(Abs, Ord, Num) :-
    enemyMove(Abs, Ord, Num).

randomEnemyMove([], _, _).

randomEnemyMove(List, Dx, Dy) :-
    length(List, Length),
    random(0, Length, Index),
    nth0(Index, List, [Dx,Dy|_]).

goTo(Xs, Ys, X, Y, p, _) :- !,
    retract(locPlayer(Xs, Ys)),
    assertz(locPlayer(X, Y)).

goTo(Xs, Ys, X, Y, e, Num) :- !,
    retract(enemy(Name, Xs, Ys, Num)),
    assertz(enemy(Name, X, Y, Num)).

printInventory([]) :-
    !, write('Your inventory is empty!'), nl.

printInventory([X]) :-
    !, nl, write(' - '), write(X), nl.

printInventory([X|Xs]) :-
    !, nl, write(' - '), write(X), printInventory(Xs).

updateStatus :-
    turn(0), !, retract(hunger(Z)), C is Z - 1, assertz(hunger(C)),
    isAlive, alive(yes), retract(turn(0)), assertz(turn(1)).

updateStatus :-
    turn(1), !,
    retract(thirst(Y)), B is Y - 1, assertz(thirst(B)),
    retract(hunger(Z)), C is Z - 1, assertz(hunger(C)),
    isAlive, alive(yes), retract(turn(1)), assertz(turn(0)).

addInventory(Items) :-
    inventory(X),
    length(X, N),
    N < 10, !,
    retract(inventory(X)),
    assertz(inventory([Items|X])).

addInventory(_) :-
    !, write('Sorry your inventory is full\n').

isAlive :-
    alive(yes), health(Health), hunger(Hunger), thirst(Thirst),
    Health > 0, Hunger > 0, Thirst > 0, !.

isAlive :-
    alive(yes), !, retract(alive(yes)), assertz(alive(no)).

isAlive.

loseGame :-
    write('The enemy You have succumbed to the pain from your wounds. Your vision slowly turns to black and your heart beats slower every time. You are going to hell.  You died.\n\nGame over\n'), reset.

winGame :-
    reset,
    write('You heard the horn sound, you are very familiar with it. Every year you would hear the exact sound when\n'),
    write('watching the Hunger Games in your district. The horn signals the end of the Hunger Games.\n'),
    write('You have won the Hunger Games!'),
    retract(alive(yes)), assertz(alive(no)).

addToMap(Items) :-
    listFood(ListFood), member([Items|_], ListFood), !, findNum(f, 1, Num), locPlayer(Abs, Ord), assertz(food(Items, Abs, Ord, Num)).

addToMap(Items) :-
    listWater(ListWater), member([Items|_], ListWater), !, findNum(p, 1, Num), locPlayer(Abs, Ord), assertz(water(Items, Abs, Ord, Num)).

addToMap(Items) :-
    listMedicine(ListMedicine), member([Items|_], ListMedicine), !, findNum(m, 1, Num), locPlayer(Abs, Ord), assertz(medicine(Items, Abs, Ord, Num)).

addToMap(Items) :-
    listWeapon(ListWeapon), member([Items|_], ListWeapon), !, findNum(w, 1, Num), locPlayer(Abs, Ord), assertz(weapon(Items, Abs, Ord, Num)).

addToMap(Items) :-
    Items == radar, !, locPlayer(Abs, Ord), assertz(radar(Abs, Ord)).

findNum(f, Count, Num) :-
    food(_, _, _, Count), !, NCount is Count + 1, findNum(f, NCount, Num).

findNum(p, Count, Num) :-
    water(_, _, _, Count), !, NCount is Count + 1, findNum(p, NCount, Num).

findNum(m, Count, Num) :-
    medicine(_, _, _, Count), !, NCount is Count + 1, findNum(m, NCount, Num).

findNum(w, Count, Num) :-
    weapon(_, _, _, Count), !, NCount is Count + 1, findNum(w, NCount, Num).

findNum(_, Count, Count) :- !.

attackLoop :-
    isAlive, alive(yes),
    locPlayer(Abs, Ord),
    enemy(Name, Abs, Ord, Num),
    listEnemy(ListEnemy),
    member([Name, DamMin, DamMax|_], ListEnemy),
    % randomize, 
    random(DamMin, DamMax, Damage),
    health(Health), NewHealth is Health - Damage,
    write('Oh No! You took '), write(Damage), write(' damage! The enemy is dead.\n'),
    randomDropItem(Name, Items), addToMap(Items), write('The enemy drop an item\n'),
    retract(health(Health)), assertz(health(NewHealth)),    /*mengupdate health yang baru*/
    retract(enemy(Name, Abs, Ord, Num)),                    /*menghapus musuh */
    fail.

attackLoop :- alive(no), !, loseGame.

attackLoop :- !.

save(NamaFile) :-
    alive(yes), !, telling(ID), tell(NamaFile),
    listing(food/4), listing(medicine/4), listing(enemy/4), listing(water/4), listing(weapon/4),
    listing(inventory/1), listing(locPlayer/2), listing(hunger/1), listing(thirst/1), listing(health/1),
    listing(alive/1), listing(turn/1), listing(radar/2), listing(myweapon/1),
    told,
    tell(ID).

save(_) :- alive(no), !, write('No game is played\n').

loadGame(NamaFile) :-
    hardreset,
    seeing(_), see(NamaFile),
    repeat,
    read(Data),
    process(Data),
    seen, !, write('Your previous game has been successfully loaded !').

loadGame(NamaFile) :- !, write('Sorry '), write(NamaFile), write(' isn\'t exists').

process(end_of_file) :- !.
process(Data) :- asserta(Data), fail.

reset :-
    retractall(food(_,_,_,_)),
    retractall(enemy(_,_,_,_)),
    retractall(weapon(_,_,_,_)),
    retractall(medicine(_,_,_,_)),
    retractall(water(_,_,_,_)),
    retractall(inventory(_)),
    retractall(hunger(_)),
    retractall(thirst(_)),
    retractall(turn(_)),
    retractall(health(_)),
    retractall(locPlayer(_,_)),
    retractall(radar(_,_)),
    retractall(myweapon(_)).

hardreset :-
    retractall(alive(_)), reset.

del(X,[X|Tail],Tail) :- !.

del(X,[Y|Tail],[Y|Tail1]):-
        del(X,Tail,Tail1), !.

randomDropItem(Name, Items) :-
    listEnemy(ListEnemy),
    member([Name, _, _, ListItems], ListEnemy),
    length(ListItems, Length),
    randomize, random(0, Length, Index),
    nth0(Index, ListItems, Items).

printPagar(X) :-
    X =< 21, !, write('#'), U is X + 1, printPagar(U).

printPagar(X) :-
    X > 21, !, nl.

printMap(X, Y) :-
    X =< 20, Y =< 10, locPlayer(X, Y), !, write('P'), U is X + 1, printMap(U, Y).

printMap(X, Y) :-
    X =< 20, Y =< 10, enemy(_, X, Y, _), !, write('E'), U is X + 1, printMap(U, Y).

printMap(X, Y) :-
    X =< 20, Y =< 10, location(X, Y, Map), Map == cave, !, write('^'), U is X + 1, printMap(U, Y).

printMap(X, Y) :-
    X =< 20, Y =< 10, location(X, Y, Map), Map == 'west coast', !, write('@'), U is X + 1, printMap(U, Y).

printMap(X, Y) :-
    X =< 20, Y =< 10, location(X, Y, Map), Map == lake, !, write('+'), U is X + 1, printMap(U, Y).

printMap(X, Y) :-
    X =< 20, Y =< 10, location(X, Y, Map), Map == cornucopia, !, write('*'), U is X + 1, printMap(U, Y).

printMap(X, Y) :-
    X =< 20, Y =< 10, location(X, Y, Map), Map == forest, !, write('='), U is X + 1, printMap(U, Y).

printMap(X, Y) :-
    X =< 20, Y =< 10, location(X, Y, Map), Map == kampus, !, write('&'), U is X + 1, printMap(U, Y).

printMap(X, Y) :-
    X =< 20, Y =< 10, location(X, Y, Map), Map == mountain, !, write('$'), U is X + 1, printMap(U, Y).

printMap(X, Y) :-
    X =< 20, Y =< 10, location(X, Y, Map), Map == river, !, write('~'), U is X + 1, printMap(U, Y).

printMap(X, Y) :-
    X =< 20, Y =< 10, location(X, Y, Map), Map == 'open field', !, write('?'), U is X + 1, printMap(U, Y).

printMap(X, Y) :-
    X > 20, Y =< 10, write('#'), nl, U is 1, V is Y + 1, V =< 10, !, write('#'), printMap(U, V).

printMap(X, Y) :-
    X > 20, Y == 10, !.

printAroundN(X, Y) :-
    write('To the north is '), A is Y - 1, accessable(X, A), !, location(X, A, N), write(N), printAroundE(X, Y).

printAroundN(X, Y) :-
    !, write('inaccessible'),  printAroundE(X, Y).

printAroundE(X, Y) :-
    write(', to the east is '), B is X + 1, accessable(B, Y), !, location(B, Y, E), write(E), printAroundS(X, Y).

printAroundE(X, Y) :-
    !, write('inaccessible'),  printAroundS(X, Y).

printAroundS(X, Y) :-
    write(', to the south is '), C is Y + 1, accessable(X, C), !, location(X, C, S), write(S), printAroundW(X, Y).

printAroundS(X, Y) :- !, write('inaccessible'),  printAroundW(X, Y).

printAroundW(X, Y) :-
    write(', to the west is '), D is X - 1, accessable(D, Y), !, location(D, Y, W), write(W), write('.\n').

printAroundW(_, _) :- !, write('inaccessible.\n').

printLookA(X,Y) :-
    location(X,Y,Loc), write('You are in the '), write(Loc), write('. '), printLook(X,Y).

printLook(X, Y) :-
    countEnemy(X, Y, N), N == 1, write('There is an enemy nearby you. '), fail.

printLook(X, Y) :-
    countEnemy(X, Y, N), N > 1, write('There are '), write(N), write(' enemies nearby you. '), fail.

printLook(X,Y) :-
    medicine(Items,X,Y,_), write('You see a '), write(Items), write(' on the ground. '), fail.

printLook(X,Y) :-
    food(Items,X,Y,_), write('You see a '), write(Items), write(' on the ground. It seems edible. '), fail.

printLook(X,Y) :-
    water(Items,X,Y,_), write('You see a '), write(Items), write(' on the ground. '), fail.

printLook(X,Y) :-
    weapon(Items,X,Y,_), write('You see a '), write(Items), write(' on the ground. '), fail.

printLook(X, Y) :-
    radar(X, Y), !, write('Wow, you see a radar on the ground.\n').

printLook(_,_) :- !.

countEnemy(X, Y, C) :- findall(1, enemy(_, X, Y, _), L), length(L, C).

lookLoop(X,Y,X0,X1,Y0,Y1) :-
    X =< X1, Y=< Y1, X >= X0, Y >= Y0, !,
    printPrio(X,Y),
    U is X + 1,
    lookLoop(U,Y,X0,X1,Y0,Y1).

lookLoop(X,Y,X0,X1,Y0,Y1) :-
    X > X1, nl, !,
    U is X0, V is Y + 1,
    lookLoop(U,V,X0,X1,Y0,Y1).

lookLoop(_,Y,_,_,_,Y1) :-
    Y > Y1, !.

printPrio(X,Y) :-
    \+accessable(X,Y), !, write('X').

printPrio(X,Y) :-
    enemy(_,X,Y,_), ! ,write('E').

printPrio(X,Y) :-
    medicine(_,X,Y,_), !, write('M').

printPrio(X,Y) :-
    food(_,X,Y,_), !, write('F').

printPrio(X,Y) :-
    water(_,X,Y,_), !, write('W').

printPrio(X,Y) :-
    weapon(_,X,Y,_), !, write('#').

printPrio(X,Y) :-
    locPlayer(X, Y), !, write('P').

printPrio(X,Y) :-
    accessable(X,Y), !, write('-').


updateDonut :-
    write('Because making donut is so tiring, you are thirsty now\n'),
    retract(thirst(Y)), B is Y - 10, assertz(thirst(B)),
    isAlive, alive(yes), !.

updateDonut :-
    alive(no), loseDonut.

loseDonut :-
    reset, !,
    write('\nYou\'re so in spirit while making donut. You are too forcing yourself.\n'),
    write('And you died because of donut. I think this is called true love.\n'),
    write('\nGame Over.').

quit :- halt.

/* Daftar pustaka : https://stackoverflow.com/questions/5211010/saving-variables-prolog

http://www.dailyfreecode.com/code/prolog-delete-element-given-list-3093.aspx

https://stackoverflow.com/questions/8510701/how-can-i-print-all-database-facts-in-prolog

http://www.gprolog.org/manual/gprolog.html */
