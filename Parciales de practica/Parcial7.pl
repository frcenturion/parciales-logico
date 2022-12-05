%% PARCIAL 7 - RATATOUILLE

% De las ratas sabemos su nombre y dónde viven
rata(remy, gusteaus).
rata(emile, bar).
rata(django, pizzeria).


% De los humanos, además de su nombre, qué platos saben cocinar y cuánta experiencia (del 1 al 10) tienen preparándolos.
cocina(linguini, ratatouille, 3).
cocina(linguini, sopa, 5).
cocina(colette, salmonAsado, 9).
cocina(horst, ensaladaRusa, 8).
cocina(linguini, ensaladaRusa, 10).

cocina(ivan, ensaladaDeZanahoria, 10).
cocina(franco, ensaladaDeZanahoria, 7).


% También tenemos información acerca de quién trabaja en cada restaurante:
trabajaEn(gusteaus, linguini).
trabajaEn(gusteaus, colette).
trabajaEn(gusteaus, skinner).
trabajaEn(gusteaus, horst).
trabajaEn(cafeDes2Moulins, amelie).

trabajaEn(restauranteFalopa, ivan).
trabajaEn(restauranteFalopa, franco).



% 1) inspeccionSatisfactoria(Restaurante)

% Se cumple para un restaurante cuando no viven ratas alli

inspeccionSatisfactoria(Restaurante) :-
    trabajaEn(Restaurante, _),
    not(rata(_, Restaurante)).


% 2) chef(Empleado, Restaurante)

% Relaciona un empleado con un restaurante si el empleado trabaja alli y sabe cocinar algun plato

chef(Empleado, Restaurante) :-
    trabajaEn(Restaurante, Empleado),
    cocina(Empleado, _, _).


% 3) chefcito(Rata)

% Se cumple para una rata si vive en el mismo restaurante donde trabaja linguini

cheficto(Rata) :-
    rata(Rata, Restaurante),
    trabajaEn(Restaurante, linguini).


% 4) cocinaBien(Persona, Plato)

% Es verdadero para una persona si su experiencia preparando ese plato es mayor a 7. Ademas, remy cocina bien cualquier plato que exista

cocinaBien(Persona, Plato) :-
    cocina(Persona, Plato, Experiencia),
    Experiencia > 7.

cocinaBien(remy, _).


% 5) encargadoDe(Encargado, Plato, Restaurante)

% Nos dice quien es el encargado de cocinar un plato en un restaurante, que es quien mas experiencia tiene preparandolo en ese lugar

encargadoDe(Encargado, Plato, Restaurante) :-
    trabajaEn(Restaurante, Encargado),
    cocina(Encargado, Plato, Experiencia),
    forall((cocina(OtroEmpleado, Plato, OtraExperiencia), trabajaEn(Restaurante, OtroEmpleado)), Experiencia >= OtraExperiencia).


% 6) 

% Ahora conseguimos un poco más de información sobre los platos. Los dividimos en entradas, platos principales y postres:
plato(ensaladaRusa, entrada([papa, zanahoria, arvejas, huevo, mayonesa])).
plato(bifeDeChorizo, principal(pure, 25)).
plato(frutillasConCrema, postre(265)).
plato(helado, postre(200)).
plato(ensaladaDeZanahoria, entrada([zanahoria])).

grupo(helado).

% De las entradas sabemos qué ingredientes las componen; de los principales, qué guarnición los
% acompaña y cuántos minutos de cocción precisan; y de los postres, cuántas calorías aportan.

% Un plato es saludable si tiene menos de 75 calorias

    % - En las entradas, cada ingrediente suma 15 calorías.
    % - Los platos principales suman 5 calorías por cada minuto de cocción. Las guarniciones agregan a la cuenta total: las papasFritas 50 y el puré 20, mientras que la ensalada no aporta calorías.
    % - De los postres ya conocemos su cantidad de calorías

% calorias(Plato, Calorias)

calorias(Plato, Calorias) :-
    plato(Plato, TipoDePlato),
    calcularCalorias(TipoDePlato, Calorias).

caloriasGuarnicion(pure, 20).
caloriasGuarnicion(papasFritas, 50).

calcularCalorias(entrada(Ingredientes), Calorias) :-
    length(Ingredientes, CantidadDeIngredientes),
    Calorias is CantidadDeIngredientes * 15.

calcularCalorias(principal(Guarnicion, MinutosDeCoccion), Calorias) :-
    caloriasGuarnicion(Guarnicion, CaloriasGuarnicion),
    Calorias is (5 * MinutosDeCoccion + CaloriasGuarnicion).

calcularCalorias(postre(Calorias), Calorias).


% saludable(Plato)

saludable(Plato) :-
    calorias(Plato, Calorias),
    Calorias < 75.

saludable(Plato) :-
    plato(Plato, postre(_)),
    grupo(Plato).


% 7) criticaPositiva(Restaurante, Critico)

% Es verdadero para un restaurante si un critico le escribe una resenia positiva

% Todos los criticos estan de acuerdo en que el lugar debe tener una inspeccion satisfactoria

% antonEgo espera, además, que en el lugar sean especialistas preparando ratatouille. 
% Un restaurante es especialista en aquellos platos que todos sus chefs saben cocinar bien.


criticaPositiva(Restaurante, Critico) :-
    inspeccionSatisfactoria(Restaurante),
    cumpleCriterios(Restaurante, Critico).

especialista(Restaurante, Plato) :-
    forall((chef(Chef, Restaurante), trabajaEn(Restaurante, Chef)), cocinaBien(Chef, Plato)).

cumpleCriterios(Restaurante, antonEgo) :-
    especialista(Restaurante, ratatouille).


% christophe, que el restaurante tenga más de 3 chefs.

cumpleCriterios(Restaurante, christophe) :-
    cantidadDeChefs(Restaurante, Cantidad),
    Cantidad > 3.


cantidadDeChefs(Restaurante, Cantidad) :-
    findall(1, chef(_, Restaurante), Chefs),
    sum_list(Chefs, Cantidad).


% cormillot requiere que todos los platos que saben cocinar los empleados del restaurante sean
% saludables y que a ninguna entrada le falte zanahoria.

cumpleCriterios(Restaurante, cormillot) :-
    todosSaludables(Restaurante),
    todasLasEntradasConZanahoria(Restaurante).

todosSaludables(Restaurante) :-
    forall(platoCocinadoEn(Plato, Restaurante), saludable(Plato)).

todasLasEntradasConZanahoria(Restaurante) :-
    forall((platoCocinadoEn(Plato, Restaurante), plato(Plato, entrada(Ingredientes))), member(zanahoria, Ingredientes)). 

platoCocinadoEn(Plato, Restaurante) :-
    chef(Empleado, Restaurante),
    cocina(Empleado, Plato, _).



% gordonRamsay no le da una crítica positiva a ningún restaurante.