%% PARCIAL 3 - KARATE

%% Base de conocimiento

% Se conoce de cada alumno quien es su maestro.
% alumnoDe(Maestro, Alumno)
alumnoDe(miyagui, sara).
alumnoDe(miyagui, bobby).
alumnoDe(miyagui, sofia).
alumnoDe(chunLi, guidan).


% Además se sabe de cada alumno su destreza es decir su velocidad y las habilidades que sabe realizar estas pueden ser alguna de las siguientes:
% patadaRecta(potencia, distancia), 
% patadaDeGiro(potencia, punteria, distancia),
% patadaVoladora(potencia, distancia, altura, punteria), 
% codazo(potencia),
% golpeRecto(distancia, potencia).

% destreza(alumno, velocidad, [habilidades]).
destreza(sofia, 80, [golpeRecto(40, 3),codazo(20)]).
destreza(sara, 70, [patadaRecta(80, 2), patadaDeGiro(90, 95, 2), golpeRecto(1, 90)]).
destreza(bobby, 80, [patadaVoladora(100, 3, 2, 90), patadaDeGiro(50, 20, 1)]).
destreza(guidan, 70, [patadaRecta(60, 1), patadaVoladora(100, 3, 2, 90), patadaDeGiro(70, 80, 1)]).

% Además se conocen los cinturones que fueron obteniendo cada uno de los alumnos (están en el orden en que los ganaron)
%categoria(Alumno, Cinturones)
categoria(sofia, [blanco]).
categoria(sara, [blanco, amarillo, naranja, rojo, verde, azul, violeta, marron, negro]).
categoria(bobby, [blanco, amarillo, naranja, rojo, verde, azul, violeta, marron, negro]).
categoria(guidan, [blanco, amarillo, naranja]).

% 1) esBueno

% Un alumno es bueno cuando sabe hacer al menos dos patadas distintas o puede realizar un golpe recto a una velocidad media (entre 50 y 80)

esBueno(Alumno) :-
    sabeHacerDosPatadasDistintas(Alumno).
esBueno(Alumno) :-
    puedeRealizarGolpeRectoAVelocidadMedia(Alumno).

sabeHacerDosPatadasDistintas(Alumno) :-
    destreza(Alumno, _, Habilidades),
    esPatada(Patada1),
    member(Patada1, Habilidades),
    esPatada(Patada2),
    member(Patada2, Habilidades),
    Patada1 \= Patada2.

esPatada(patadaRecta((_,_))).
esPatada(patadaDeGiro((_, _, _))).
esPatada(patadaVoladora((_,_, _, _))).

puedeRealizarGolpeRectoAVelocidadMedia(Alumno) :-
    destreza(Alumno, Velocidad, Habilidades),
    member(golpeRecto(_, _), Habilidades),
    between(50, 80, Velocidad).


% 2) esAptoParaTorneo

% Se verifica si el alumno es bueno y ademas haya alcanzado el cinturon verde (puede que lo haya superado)

esAptoParaTorneo(Alumno) :-
    esBueno(Alumno),
    alcanzoElCinturonVerde(Alumno).

alcanzoElCinturonVerde(Alumno) :-
    categoria(Alumno, Cinturones),
    member(verde, Cinturones).


% 3) totalPotencia

% Relaciona a un alumno con la potencia total de todas sus habilidades. 

% La potencia total se calcula como la suma de las potencias de todas sus habilidades.

totalPotencia(Alumno, PotenciaTotal) :-
    destreza(Alumno, _, Habilidades),
    findall(Potencia, (member(Habilidad, Habilidades), potencia(Habilidad, Potencia)), TodasLasPotencias),
    sum_list(TodasLasPotencias, PotenciaTotal).


potencia(patadaRecta(Potencia, _), Potencia).
potencia(patadaDeGiro(Potencia, _, _), Potencia).
potencia(patadaVoladora(Potencia, _, _, _), Potencia).
potencia(codazo(Potencia), Potencia).
potencia(golpeRecto(_, Potencia), Potencia).


% 4) alumnoConMayorPotencia

alumnoConMayorPotencia(Alumno) :-
    totalPotencia(Alumno, PotenciaTotal1),
    forall(totalPotencia(_, PotenciaTotal2), PotenciaTotal1 >= PotenciaTotal2).


% 5) sinPatadas         

% Permite conocer si un alumno no sabe realizar patadas

sinPatadas(Alumno) :-
    destreza(Alumno, _, Habilidades),
    forall(member(Habilidad, Habilidades), not(esPatada(Habilidad))).


% 6) soloSabePatear     

% Se verifica si un alumno solo sabe unicamente realizar patadas

soloSabePatear(Alumno) :-
    destreza(Alumno, _, Habilidades),
    forall(member(Habilidad, Habilidades), esPatada(Habilidad)).


% 7) potencialesSemifinalistas 

% Conocer el conjunto de los posibles alumnos semifinalistas

% Para llegar a la semifinal el alumno debe cumplir alguna de las condiciones
%   - Ser aptos para el torneo
%   - Provenir de un maestro que tenga mas de un alumno
%   - Deben poder realizar una habilidad con buen estilo artistico (con una potencia de 100 o una punteria de 90)


cumpleCondiciones(Alumno) :-
    esAptoParaTorneo(Alumno).
cumpleCondiciones(Alumno) :-
    provieneDeUnMaestroQueTieneMasDeUnAlumno(Alumno).
cumpleCondiciones(Alumno) :-
    puedeRealizarHabilidadConBuenEstiloArtistico(Alumno).    


provieneDeUnMaestroQueTieneMasDeUnAlumno(Alumno) :-
    alumnoDe(Maestro, Alumno),
    cantidadAlumnos(Maestro, Cantidad),
    Cantidad > 1.


cantidadAlumnos(Maestro, Cantidad) :-
    findall(1, alumnoDe(Maestro, _), Total),
    sum_list(Total, Cantidad).


puedeRealizarHabilidadConBuenEstiloArtistico(Alumno) :-
    destreza(Alumno, _, Habilidades),
    tieneBuenEstiloArtistico(Habilidad),
    member(Habilidad, Habilidades).


tieneBuenEstiloArtistico(Habilidad) :-
    potencia(Habilidad, 100).
tieneBuenEstiloArtistico(Habilidad) :-
    punteria(Habilidad, 90).


punteria(patadaDeGiro(_, Punteria, _), Punteria).
punteria(patadaVoladora(_, _, _, Punteria), Punteria).


potencialesSemifinalistas(Semifinalistas) :-
    findall(Alumno, cumpleCondiciones(Alumno), PosiblesSemifinalistas),
    list_to_set(PosiblesSemifinalistas, Semifinalistas).


% 8) semifinalistas -> este es un punto de explosion combinatoria, por ende no lo voy a hacer