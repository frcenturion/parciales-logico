%% PARCIAL 1 - LA LEYENDA DE AANG

%% Base de conocimiento

% esPersonaje/1 nos permite saber qué personajes tendrá el juego
esPersonaje(aang).
esPersonaje(katara).
esPersonaje(zoka).
esPersonaje(appa).
esPersonaje(momo).
esPersonaje(toph).
esPersonaje(tayLee).
esPersonaje(zuko).
esPersonaje(azula).
esPersonaje(iroh).

esPersonaje(franco).

% esElementoBasico/1 nos permite conocer los elementos básicos que pueden controlar algunos personajes
esElementoBasico(fuego).
esElementoBasico(agua).
esElementoBasico(tierra).
esElementoBasico(aire).


% elementoAvanzadoDe/2 relaciona un elemento básico con otro avanzado asociado
elementoAvanzadoDe(fuego, rayo).
elementoAvanzadoDe(agua, sangre).
elementoAvanzadoDe(tierra, metal).

% controla/2 relaciona un personaje con un elemento que controla
controla(zuko, rayo).
controla(toph, metal).
controla(katara, sangre).
controla(aang, aire).
controla(aang, agua).
controla(aang, tierra).
controla(aang, fuego).
controla(azula, rayo).
controla(iroh, rayo).

% visito/2 relaciona un personaje con un lugar que visitó. Los lugares son functores que tienen la siguiente forma:
% reinoTierra(nombreDelLugar, estructura)
% nacionDelFuego(nombreDelLugar, soldadosQueLoDefienden)
% tribuAgua(puntoCardinalDondeSeUbica)
% temploAire(puntoCardinalDondeSeUbica)

visito(aang, reinoTierra(baSingSe, [muro, zonaAgraria, sectorBajo, sectorMedio])).
visito(iroh, reinoTierra(baSingSe, [muro, zonaAgraria, sectorBajo, sectorMedio])).
visito(zuko, reinoTierra(baSingSe, [muro, zonaAgraria, sectorBajo, sectorMedio])).
visito(toph, reinoTierra(fortalezaDeGralFong, [cuartel, dormitorios, enfermeria, salaDeGuerra, templo, zonaDeRecreo])).
visito(aang, nacionDelFuego(palacioReal, 1000)).
visito(katara, tribuAgua(norte)).
visito(katara, tribuAgua(sur)).
visito(aang, temploAire(norte)).
visito(aang, temploAire(oeste)).
visito(aang, temploAire(este)).
visito(aang, temploAire(sur)).
visito(franco, reinoTierra(baSingSe, [muro, zonaAgraria, sectorBajo, sectorMedio])).
visito(ivan, reinoTierra(baSingSe, [muro, zonaAgraria, sectorBajo, sectorMedio])).

% 1) esElAvatar

% El avatar es aquel personaje que controla todos los elementos basicos.

% Debemos plantear que para todo elemento basico, el personaje los controla.

esElAvatar(Personaje) :-
    esPersonaje(Personaje),
    forall(esElementoBasico(Elemento), controla(Personaje, Elemento)).


% 2) Clasificacion de personajes

% noEsMaestro -> No controla ningun elemento, ni basico ni avanzado

noEsMaestro(Personaje) :-
    esPersonaje(Personaje),
    not(controla(Personaje, _)).

% esMaestroPrincipiante -> Controla algun elemento basico pero ninguno avanzado

esMaestroPrincipiante(Personaje) :-
    esPersonaje(Personaje),
    controla(Personaje, Elemento),
    esElementoBasico(Elemento),
    not(elementoAvanzadoDe(Elemento, _)).

% esMaestroAvanzado -> Controla algun elemento avanzado o es el avatar

esMaestroAvanzado(Personaje) :-
    esPersonaje(Personaje),
    controla(Personaje, Elemento),
    elementoAvanzadoDe(_, Elemento).
esMaestroAvanzado(Personaje) :- esElAvatar(Personaje).


% 3) sigueA

% Un personaje sigue a otro si el segundo visito todos los lugares que visito el primero. Tambien zuko sigue a aang

% Debemos plantear que para todo lugar que haya visitado el primero, fueron visitados por el segundo.

sigueA(Personaje, OtroPersonaje) :-
    visito(Personaje, _),
    visito(OtroPersonaje, _),
    forall(visito(Personaje, Lugar), visito(OtroPersonaje, Lugar)),
    Personaje \= OtroPersonaje.
sigueA(zuko, aang).


% 4) esDignoDeConocer

% Todos los templos aire
esDignoDeConocer(temploAire(_)).

% La tribu agua del norte
esDignoDeConocer(tribuAgua(norte)).

% Ningun lugar de la nacion del fuego -> Por principio de universo cerrado no lo escribimos en la base de conocimiento

% Un lugar del reino tierra es digno de conocer si no tiene muros en su estructura
esDignoDeConocer(reinoTierra(Nombre, Estructura)) :-
    visito(_, reinoTierra(Nombre, Estructura)),
    not(member(muro, Estructura)).


% 5) esPopular 

% Un lugar es popular si fue visitado por mas de 4 personajes

% Debemos armar una lista con todos los personajes que visitaron determinado lugar y luego ver si la sumatoria de la lista es > 4

esPopular(Lugar) :-
    visito(_, Lugar),
    findall(1, visito(_, Lugar), PersonajesQueLoVisitaron),
    sumlist(PersonajesQueLoVisitaron, CantidadDePersonajes),
    CantidadDePersonajes > 4.



% 6) Modelado de informacion

% bumi es un personaje que controla el elemento tierra y visito Ba Sing Se en el reino tierra

esPersonaje(bumi).
controla(bumi, tierra).
visito(bumi, reinoTierra(baSingSe, [muro, zonaAgraria, sectorBajo, sectorMedio])).


% suki es un personaje que no controla ningún elemento y que visitó una prisión de máxima seguridad en la nación del fuego protegida por 200 soldados.

esPersonaje(suki).
visito(suki, nacionDelFuego(prisionDeMaximaSeguridad, 200)).
