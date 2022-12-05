%% PARCIAL 2 - ESCAPDEP

%% Base de conocimiento

% Datos de las personas que se crearon una cuenta en la pagina

%persona(Apodo, Edad, Peculiaridades).         
persona(ale, 15, [claustrofobia, cuentasRapidas, amorPorLosPerros]).
persona(agus, 25, [lecturaVeloz, ojoObservador, minuciosidad]).
persona(fran, 30, [fanDeLosComics]).
persona(rolo, 12, []).


% Hay varias empresas metidas en este rubro y cada una tiene distintas salas

%esSalaDe(NombreSala, Empresa).
esSalaDe(elPayasoExorcista, salSiPuedes).
esSalaDe(socorro, salSiPuedes).
esSalaDe(linternas, elLaberintoso).
esSalaDe(guerrasEstelares, escapepepe).
esSalaDe(fundacionDelMulo, escapepepe).


% Las salas no son todas iguales. Contamos con las siguientes experiencias:

%terrorifica(CantidadDeSustos, EdadMinima).
%familiar(Tematica, CantidadDeHabitaciones).
%enigmatica(Candados).
%sala(Nombre, Experiencia).
sala(elPayasoExorcista, terrorifica(100, 18)).
sala(socorro, terrorifica(20, 12)).
sala(linternas, familiar(comics, 5)).
sala(guerrasEstelares, familiar(futurista, 7)).
sala(fundacionDelMulo, enigmatica([combinacionAlfanumerica, deLlave, deBoton])).


% 1) nivelDeDificultadDeLaSala

nivelDeDificultadDeLaSala(Sala, Dificultad) :-
    sala(Sala, Experiencia),
    calcularDificultad(Experiencia, Dificultad).

% Para las salas de experiencia terrorifica el nivel de dificultad es la cantidad de sustos menos la edad minima para ingresar

calcularDificultad(terrorifica(Sustos, EdadMinima), Dificultad) :-
    Dificultad is Sustos - EdadMinima.

% Para las de experiecia familiar es 15 si es de una tematica futurista y para cualquier otra tematica es la cantidad de habitaciones

calcularDificultad(familiar(futurista, _), Dificultad) :-
    Dificultad is 15.
calcularDificultad(familiar(Tematica, Habitaciones), Habitaciones) :-
    Tematica \= futurista.

% El de las enigmaticas es la cantidad de candados que tenga

calcularDificultad(enigmatica(Candados), Dificultad) :-
    length(Candados, Dificultad).


% 2) puedeSalir

% Una persona puede salir de una sala si la dificultad de la sala es 1 o si tiene mas de 13 anios y la dificultad es menor a 5. En ambos casos la persona no debe ser claustrofobica

puedeSalir(Persona, Sala) :-
    persona(Persona, _, _),
    not(claustrofobica(Persona)),
    nivelDeDificultadDeLaSala(Sala, 1).

puedeSalir(Persona, Sala) :-
    persona(Persona, Edad, _),
    not(claustrofobica(Persona)),
    nivelDeDificultadDeLaSala(Sala, Dificultad),
    Dificultad < 5,
    Edad > 13.

% Predicado auxiliar que relaciona a una persona con el hecho de si es claustrofobica o no
claustrofobica(Persona) :-
    persona(Persona, _, Peculiaridades),
    member(claustrofobia, Peculiaridades).


% 3) tieneSuerte

% Una persona tiene suerte en una sala si puede salir de ella aun sin tener ninguna peculiaridad

tieneSuerte(Persona, Sala) :-
    puedeSalir(Persona, Sala),
    noTieneNingunaPeculiaridad(Persona).

noTieneNingunaPeculiaridad(Persona) :-
    persona(Persona, _, Peculiaridades),
    length(Peculiaridades, 0).


% 4) esMacabra 

% Una empresa es macabra si todas sus salas son de experiencia terrorifica

% Debemos plantear que para toda sala que posea la empresa, son de experiencia terrorifica

esMacabra(Empresa) :-
    esSalaDe(_, Empresa),
    forall(esSalaDe(Sala, Empresa), esDeExperienciaTerrorifica(Sala)).

esDeExperienciaTerrorifica(Sala) :-
    sala(Sala, terrorifica(_, _)).


% 5) empresaCopada

% Una empresa es copada si no es macabra y el promedio de dificultad de sus salas es menor a 4.

empresaCopada(Empresa) :-
    esSalaDe(_, Empresa),
    not(esMacabra(Empresa)),
    promedioDificultad(Empresa, Promedio),
    Promedio < 4.


promedioDificultad(Empresa, Promedio) :-
    findall(Dificultad, (nivelDeDificultadDeLaSala(Sala, Dificultad), esSalaDe(Sala, Empresa)), Dificultades),
    sumlist(Dificultades, DificultadTotal),
    cantidadSalas(Empresa, CantidadDeSalas),
    Promedio is DificultadTotal / CantidadDeSalas.


cantidadSalas(Empresa, CantidadDeSalas) :-
    findall(Sala, (sala(Sala, _), esSalaDe(Sala, Empresa)), Salas),
    length(Salas, CantidadDeSalas).

% aca podriamos haber directamente calculado el length de Dificultades en vez de hacer un predicado aparte que calcule la cantidad de salas


% 6) Modelado de informacion

% La empresa supercelula es dueña de salas de escape familiares ambientadas en videojuegos. La sala estrellasDePelea cuenta con 7
% habitaciones pero lamentablemente no sabemos la cantidad que tiene su nueva sala choqueDeLaRealeza.

sala(estrellasDePelea, familiar(videojuegos, 7)).
esSalaDe(estrellasDePelea, supercelula).
esSalaDe(choqueDeLaRealeza, supercelula).

% La empresa SKPista (fanática de un famoso escritor) es la dueña de una única sala terrorífica para mayores de 21 llamada 
% miseriaDeLaNoche que nos asegura 150 sustos.

sala(miseriaDeLaNoche, terrorifica(150, 21)).
esSalaDe(miseriaDeLaNoche, skpista).

% La nueva empresa que se suma a esta gran familia es Vertigo, pero aún no cuenta con salas.




