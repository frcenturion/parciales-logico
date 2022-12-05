%% PARCIAL 8 - SUENOS

%% PUNTO 1

% creeEn(Persona, Ente)
creeEn(gabriel, campanita).
creeEn(gabriel, magoDeOz).
creeEn(gabriel, cavenaghi).
creeEn(juan, conejoDePascuas).
creeEn(macarena, reyesMagos).
creeEn(macarena, magoCapria).
creeEn(macarena, campanita).

% para reflejar que diego no cree en nadie utilizo el concepto de universo cerrado y no lo agrego a la base de conocimiento

% tipos de suenios:
% suenio(cantante(CantidadDeDiscosVendidos))
% suenio(futbolista(Equipo))
% suenio(ganarLoteria(Numeros))

% suenio(Persona, Suenio)
suenio(gabriel, ganarLoteria([5, 9])).
suenio(gabriel, futbolista(arsenal)).
suenio(juan, cantante(100000)).
suenio(macarena, cantante(10000)).


%% PUNTO 2

% esAmbiciosa(Persona)
esAmbiciosa(Persona) :-
    suenio(Persona, _),
    findall(Dificultad, (suenio(Persona, Suenio), dificultad(Suenio, Dificultad)), Dificultades),
    sumlist(Dificultades, DificultadTotal),
    DificultadTotal > 20.


dificultad(cantante(CantidadDeDiscosVendidos), 6) :- 
    CantidadDeDiscosVendidos > 500000.

dificultad(cantante(CantidadDeDiscosVendidos), 4) :- 
    CantidadDeDiscosVendidos =< 500000.

dificultad(ganarLoteria(Numeros), Dificultad) :-
    length(Numeros, CantidadDeNumeros),
    Dificultad is CantidadDeNumeros * 10.

dificultad(futbolista(Equipo), 3) :-
    equipoChico(Equipo).

dificultad(futbolista(Equipo), 16) :-
    not(equipoChico(Equipo)).

equipoChico(arsenal).
equipoChico(aldosivi).


%% PUNTO 3

% tieneQuimica(Personaje, Persona)

tieneQuimica(Personaje, Persona) :-
    creeEn(Persona, Personaje),
    cumpleCondiciones(Persona, Personaje).

cumpleCondiciones(Persona, campanita) :-
    suenio(Persona, Suenio),
    dificultad(Suenio, Dificultad),
    Dificultad < 5.

cumpleCondiciones(Persona, Personaje) :-
    Personaje \= camapanita,
    forall(suenio(Persona, Suenio), puro(Suenio)),
    not(esAmbiciosa(Persona)).

puro(futbolista(Equipo)) :- 
    suenio(_, futbolista(Equipo)).
puro(cantante(Discos)) :- 
    suenio(_, cantante(Discos)), Discos < 200000.


%% PUNTO 4

% amigo(Persona1, Persona2)

amigo(campanita, reyesMagos).
amigo(campanita, conejoDePascua).


% puedeAlegrar (Personaje, Persona) 

puedeAlegrar(Personaje, Persona) :-
    suenio(Persona, _),
    tieneQuimica(Personaje, Persona),
    noEstaEnfermoOSuBackup(Personaje).

noEstaEnfermoOSuBackup(Personaje) :-
    not(enfermo(Personaje)).

noEstaEnfermoOSuBackup(Personaje) :-
    backup(Personaje, Backup),
    not(enfermo(Backup)).

backup(Personaje, Backup) :-
    amigodDirectoOIndirecto(Personaje, Backup).

amigoDirectoOIndirecto(Personaje, Backup) :-
    amigo(Personaje, Backup).
amigoDirectoOIndirecto(Personaje, Backup) :-
    amigo(Personaje, PersonajeIntermedio),
    amigoDirectoOIndirecto(PersonajeIntermedio, Backup).

enfermo(campanita).
enfermo(reyesMagos).
enfermo(conejoDePascuas).

amigo2(Persona1, Persona2) :- amigo(Persona1, Persona2).
amigo2(Persona1, Persona2) :- amigo(Persona2, Persona1).

amigo2(campanita, reyesMagos).

