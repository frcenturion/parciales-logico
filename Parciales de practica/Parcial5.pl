%% PARCIAL 5 - PAIS EN LLAMAS


%% Base de conocimiento

% tieneFoco/2 relaciona el lugar en donde se encuentra el foco de incendio con el tamano del foco (que equivale a la cantidad de hectareas afectadas)

% Existen distintos tipos de lugares

% ciudad(Nombre, Poblacion)         La poblacion esta expresada en miles de habitantes
% pueblo(Nombre, Poblacion)
% campo(Nombre)

tieneFoco(ciudad(rosario, 500), 20).
tieneFoco(pueblo(cosquin, 20), 50).
tieneFoco(campo(km607), 300).


% También contamos con información acerca de la proximidad de los lugares, representada con el predicado cercanos/2,
% que relaciona dos nombres de lugares si son cercanos entre ellos.

cercanos(caba, laPlata).

% También contamos con un predicado provincia/2 que relaciona el nombre de un lugar
% (haya o no un foco de incendio en ese lugar) con el de la provincia donde queda

provincia(rosario, santaFe).
provincia(cosquin, cordoba).


% 1) tienenFocosParecidos(Lugar, OtroLugar)


% Relaciona el nombre de un lugar con el tipo de lugar
lugar(ciudad(Nombre, Poblacion), Nombre) :- tieneFoco(ciudad(Nombre, Poblacion), _).
lugar(pueblo(Nombre, Poblacion), Nombre) :- tieneFoco(pueblo(Nombre, Poblacion), _).
lugar(campo(Nombre), Nombre) :- tieneFoco(campo(Nombre), _).


% Dos lugares distintos tienen focos parecidos cuando la diferencia de tamano que hay entre los focos de cada lugar es menor a 5

tienenFocosParecidos(NombreLugar, NombreOtroLugar) :-
    lugar(Lugar, NombreLugar),
    lugar(OtroLugar, NombreOtroLugar),
    tieneFoco(Lugar, Tamanio),
    tieneFoco(OtroLugar, OtroTamanio),
    abs(Tamanio - OtroTamanio, Diferencia),
    Diferencia < 5,
    Lugar \= OtroLugar.


% 2) focoGrave(Foco)

% Se verifica para un foco si el mismo tiene mas de 40 hectareas, si esta en una ciudad o si la poblacion del lugar es mayor a 200 mil habitantes

focoGrave(NombreLugar) :-
    lugar(Lugar, NombreLugar),
    tieneFoco(Lugar, Hectareas),
    Hectareas >  40.
focoGrave(NombreLugar) :-
    estaEnUnaCiudad(NombreLugar).
focoGrave(NombreLugar) :-
    poblacion(NombreLugar, Poblacion),
    Poblacion > 200.


% Relaciona el nombre de un lugar con el hecho de si esta en una ciudad o no

estaEnUnaCiudad(NombreLugar) :- tieneFoco(ciudad(NombreLugar, _), _).

% Relaciona el nombre de un lugar con su poblacion

poblacion(NombreLugar, Poblacion) :- tieneFoco(ciudad(NombreLugar, Poblacion), _).
poblacion(NombreLugar, Poblacion) :- tieneFoco(pueblo(NombreLugar, Poblacion), _).



% 3) buenPronostico(Lugar)

% Un lugar tiene buen pronostico si alli no hay ningun foco grave y no hay lugares con focos graves que tengan focos parecidos

buenPronostico(NombreLugar) :-
    lugar(_, NombreLugar),
    not(focoGrave(NombreLugar)),
    focoGrave(NombreOtroLugar),
    not(tienenFocosParecidos(NombreLugar, NombreOtroLugar)).



% 4) provinciaComprometida(Provincia)

% Una provincia esta comprometida si tiene mas de 4 focos de incendio

provinciaComprometida(Provincia) :-
    provincia(Lugar, Provincia),
    lugar(TipoDeLugar, Lugar),
    findall(1, tieneFoco(TipoDeLugar, _), Focos),
    sum_list(Focos, CantidadFocos),
    CantidadFocos > 4.




% 5) provinciaAlHorno(Provincia)

% Una provincia esta al horno si esta comprometida y todos los focos en ella son focos graves, o si no tiene ningun lugar que no tenga un foco

provinciaAlHorno(Provincia) :-
    provinciaComprometida(Provincia),
    provincia(NombreLugar, Provincia),
    lugar(Lugar, NombreLugar),
    forall(tieneFoco(Lugar, _), focoGrave(Lugar)).



% 6) lugarEnRiesgo(Lugar)

% Un lugar esta en riesgo si no tiene buen pronostico, o si esta cerca de otro lugar en riesgo

lugarEnRiesgo(NombreLugar) :-
    lugar(_, NombreLugar),
    not(buenPronostico(NombreLugar)).
lugarEnRiesgo(NombreLugar) :-
    lugar(_, NombreLugar),
    cercanos(NombreLugar, NombreOtroLugar),
    lugarEnRiesgo(NombreOtroLugar).





