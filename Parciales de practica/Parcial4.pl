%% PARCIAL 4 - DOCTOR STONE

%% Base de conocimiento

% objetivo(Proyecto, Objetivo, TipoDeObjetivo)
objetivo(higiene, almejas, material(playa)).
objetivo(higiene, algas, material(mar)).
objetivo(higiene, grasa, material(animales)).
objetivo(higiene, hidroxidoDeCalcio, quimica([hacerPolvo, diluirEnAgua])).
objetivo(higiene, hidroxidoDeSodio, quimica([mezclarIngredientes])).
objetivo(higiene, jabon, quimica([mezclarIngredientes, dejarSecar])).

% prerrequisito(ObjetivoPrevio, ObjetivoSguiente)
prerrequisito(almejas, hidroxidoDeCalcio).
prerrequisito(hidroxidoDeCalcio, hidroxidoDeSodio).
prerrequisito(algas, hidroxidoDeSodio).
prerrequisito(hidroxidoDeSodio, jabon).
prerrequisito(grasa, jabon).

% conseguido(Objetivo)
conseguido(almejas).
conseguido(algas).


% 1)

% puedeRealizar(Cientifico, TipoDeObjetivo)

puedeRealizar(Cientifico, TipoDeObjetivo) :-
    objetivo(_, _, TipoDeObjetivo),
    puedeTrabajarEn(Cientifico, TipoDeObjetivo).


% puedeTrabajarEn(Cientifico, TipoDeObjetivo)

puedeTrabajarEn(senku, quimica(_)).
puedeTrabajarEn(chrome, material(TipoMaterial)) :-
    TipoMaterial \= animales.
puedeTrabajarEn(kohaku, material(animales)).
puedeTrabajarEn(suika, material(playa)).
puedeTrabajarEn(suika, material(bosque)).
puedeTrabajarEn(suika, material(playa)).
puedeTrabajarEn(suika, quimica([mezclarIngredientes])).
puedeTrabajarEn(chrome, quimica(Procesos)) :-
    length(Procesos, CantidadDeProcesos),
    CantidadDeProcesos =< 3.


% artesania(Dificultad)

puedeTrabajarEn(senku, artesania(Dificultad)) :-
    Dificultad =< 6.
puedeTrabajarEn(_, artesania(Dificultad)) :-
    Dificultad < 3. 


% 2) objetivoFinal(Proyecto, ObjetivoFinal)

% Se verifica para aquel objetivo que no es prerrequisito de ningun otro objetivo de ese mismo proyecto

% Debemos proponer que para todo objetivo de ese proyecto, el objetivo final no es prerrequisito de ninguno de ellos

objetivoFinal(Proyecto, ObjetivoFinal) :-
    objetivo(Proyecto, ObjetivoFinal, _),
    forall(objetivo(Proyecto, Objetivo, _), not(prerrequisito(ObjetivoFinal, Objetivo))).


% 3) esIndispensable(Cientifico, Objetivo)

esIndispensable(Cientifico, Objetivo) :-
    objetivo(_, Objetivo, TipoDeObjetivo),
    puedeRealizar(Cientifico, TipoDeObjetivo),
    not((puedeRealizar(OtroCientifico, TipoDeObjetivo), Cientifico \= OtroCientifico)).
    

% 4) puedeIniciarse(Objetivo)

% Se cumple si ese objetivo esta pendiente (si no se consiguio aun) y todos sus prerrequisitos si se consiguieron

% Debemos plantear que ese objetivo no se consiguio aun y que para todo prerrequisito de ese objetivo, si se consiguio

puedeIniciarse(Objetivo) :-
    objetivo(Objetivo, _, _),
    not(conseguido(Objetivo)),
    forall(prerrequisito(Prerequisito, Objetivo), conseguido(Prerequisito)).


% 5) 


% - Conseguir materiales que se encuentran en la superficie (no estan en el mar ni en la cueva) toma 3 horas, del mar 8 horas y de cuevas 48.
% - Los productos quimicos demoran 2 horas multiplicadas por la cantidad de procesos involucrados
% - Las artesanias demoran un tiempo equivalente a su dificultad

% tiempoEstimado(TipoDeObjetivo, Tiempo)

tiempoEstimado(material(Lugar), 3) :-
    Lugar \= mar, 
    Lugar \= cueva.
tiempoEstimado(material(mar), 8).
tiempoEstimado(material(cueva), 48).
tiempoEstimado(quimica(Procesos), Tiempo) :-
    length(Procesos, CantidadDeProcesos),
    Tiempo is 2 * CantidadDeProcesos.
tiempoEstimado(artesania(Tiempo), Tiempo).


% cuantoTiempoFalta(Proyecto, TiempoRestante)

% El tiempo restante es la suma de los tiempos estimados para realizar los objetivos pendientes (los que no se cumplieron)

cuantoTiempoFalta(Proyecto, TiempoRestante) :-
    objetivo(Proyecto, _, _),
    findall(Tiempo, (objetivo(Proyecto, Objetivo, TipoDeObjetivo), objetivoPendiente(Proyecto, Objetivo), tiempoEstimado(TipoDeObjetivo, Tiempo)), TiemposTotales),
    sum_list(TiemposTotales, TiempoRestante).



% objetivosPendientes(Proyecto, ObjetivosPendientes)

objetivosPendientes(Proyecto, ObjetivosPendientes) :-
    findall(Objetivo, (objetivo(Proyecto, Objetivo, _), not(conseguido(Objetivo))), ObjetivosPendientes).

% objetivoPendiente(Proyecto, Objetivo)

objetivoPendiente(Proyecto, Objetivo) :-
    objetivo(Proyecto, Objetivo, _),
    not(conseguido(Objetivo)).


% 6) 

% Un objetivo bloquea el avance de otro objetivo si es su prerrequisito directa o indirectamente

bloqueaElAvanceDeOtro(Objetivo, OtroObjetivo) :-
    prerrequisitoDirectoOIndirecto(Objetivo, OtroObjetivo).

prerrequisitoDirectoOIndirecto(Objetivo, OtroObjetivo) :- prerrequisito(Objetivo, OtroObjetivo).
prerrequisitoDirectoOIndirecto(Objetivo, OtroObjetivo) :-
    prerrequisito(Objetivo, ObjetivoIntermedio),
    prerrequisitoDirectoOIndirecto(ObjetivoIntermedio, OtroObjetivo).


% esCritico(Objetivo, Proyecto) 

% Un objetivo es critico si bloquea al avance de algun objetivo costoso (tiempo estimado mayor a 5 horas)

objetivoCostoso(Objetivo) :-
    objetivo(_, Objetivo, TipoDeObjetivo),
    tiempoEstimado(TipoDeObjetivo, Tiempo),
    Tiempo > 5.

esCritico(Objetivo, Proyecto) :-
    objetivo(Proyecto, Objetivo, _),
    bloqueaElAvanceDeOtro(Objetivo, OtroObjetivo),
    objetivoCostoso(OtroObjetivo).


% 7) leConvieneTrabajarSobre(Persona, Objetivo, Proyecto)

% Se cumplira siempre y cuando el objetivo en cuestion pueda iniciarse, que la persona sea capaz de hacerlo y...

    % - O bien la persona es indispensable para ese objetivo, siendo el mismo critico para el proyecto.
    % - O bien el tiempo que lleva ese objetivo es mas de la mitad del tiempo que falta para terminar el proyecto
    % - O bien todos los otros objetivos del proyecto que pueden iniciarse los puede hacer alguien mas



leConvieneTrabajarSobre(Persona, Objetivo, Proyecto) :-
    objetivo(Proyecto, Objetivo, TipoDeObjetivo),
    puedeIniciarse(Objetivo),
    puedeRealizar(Persona, TipoDeObjetivo),
    cumpleRequisitos(Persona, Proyecto, Objetivo).


cumpleRequisitos(Persona, Proyecto, Objetivo) :-
    esIndispensable(Persona, Objetivo),
    esCritico(Objetivo, Proyecto).

cumpleRequisitos(_, Proyecto, Objetivo) :-
    objetivo(_, Objetivo, TipoDeObjetivo),
    tiempoEstimado(TipoDeObjetivo, Tiempo),
    cuantoTiempoFalta(Proyecto, TiempoRestante),
    Tiempo > (TiempoRestante / 2).

cumpleRequisitos(Persona, Proyecto, Objetivo) :-
    forall((objetivo(Proyecto, OtroObjetivo, TipoDeObjetivo), puedeIniciarse(OtroObjetivo), Objetivo \= OtroObjetivo), (puedeRealizar(OtraPersona, TipoDeObjetivo), OtraPersona \= Persona)).
    




