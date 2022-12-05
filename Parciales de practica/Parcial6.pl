%% PARCIAL 6 - DELIVERY DE COMIDAS

% Se conoce la composición de cada uno de los platos con sus ingredientes
% composicion(plato, [ingrediente])
composicion(platoPrincipal(milanesa),[ingrediente(pan,3), ingrediente(huevo,2),ingrediente(carne,2)]).
composicion(entrada(ensMixta),[ingrediente(tomate,2), ingrediente(cebolla,1),ingrediente(lechuga,2)]).
composicion(entrada(ensFresca),[ingrediente(huevo,1), ingrediente(remolacha,2),ingrediente(zanahoria,1)]).
composicion(postre(budinDePan),[ingrediente(pan,2),ingrediente(caramelo,1)]).

%Además se conoce las calorías de cada ingrediente posible, por unidad de medida usada para definir la composición de los platos.
% calorías(nombreIngrediente, cantidadCalorias)
calorias(pan,30).
calorias(huevo,18).
calorias(carne,40).
calorias(caramelo,170).

% También se conoce por cada proveedor qué ingredientes puede proporcionar.
% proveedor(nombreProveedor, [nombreIngredientes])
proveedor(disco, [pan, caramelo, carne, cebolla]).
proveedor(sanIgnacio, [zanahoria, lechuga, miel, huevo]).


% 1) caloriasTotal(Plato, TotalCaloriasPorPorcion)

% Las calorias de un plato se calculan a partir de sus ingredientes 

caloriasTotal(Plato, TotalCaloriasPorPorcion) :-
    composicion(Plato, Ingredientes),
    findall(Calorias, (member(Ingrediente, Ingredientes), caloriasTotalesPorIngrediente(Ingrediente, Calorias)), CaloriasTotales),
    sum_list(CaloriasTotales, TotalCaloriasPorPorcion).


caloriasTotalesPorIngrediente(ingrediente(Nombre, Cantidad), CaloriasTotales) :-
    calorias(Nombre, Calorias),
    CaloriasTotales is Cantidad * Calorias.


% 2) platoSimpatico(Plato)

% Un plato es simpatico si incluye entre sus ingredientes al pan y al huevo o si tiene menos de 200 calorias por porcion

platoSimpatico(Plato) :-
    composicion(Plato, Ingredientes),
    member(ingrediente(pan, _), Ingredientes),
    member(ingrediente(huevo, _), Ingredientes).

platoSimpatico(Plato) :-
    caloriasTotal(Plato, Calorias),
    Calorias < 200.


% 3) menuDiet(Plato1, Plato2, Plato3)

% Tres platos forman parte de un menu diet si el primero es entrada, el segundo es plato principal, el tercero es postre
% y ademas la suma de calorias por pocion de los tres no supera 450

menuDiet(Plato1, Plato2, Plato3) :-
    esEntrada(Plato1),
    esPlatoPrincipal(Plato2),
    esPostre(Plato3),
    caloriasTotal(Plato1, Calorias1),
    caloriasTotal(Plato2, Calorias2),
    caloriasTotal(Plato3, Calorias3),
    Calorias1 + Calorias2 + Calorias3 =< 450.    


esEntrada(entrada(Nombre)) :- composicion(entrada(Nombre), _).
esPlatoPrincipal(platoPrincipal(Nombre)) :- composicion(platoPrincipal(Nombre), _).
esPostre(postre(Nombre)) :- composicion(postre(Nombre), _).


% 5) tieneTodo(Proveedor, Plato)

% Relaciona un proveedor con un plato si el proveedor provee todos los ingredientes del plato

tieneTodo(Proveedor, Plato) :-
    composicion(Plato, Ingredientes),
    proveedor(Proveedor, Provisiones),
    forall(member(ingrediente(Ingrediente, _), Ingredientes), member(Ingrediente, Provisiones)).


% 6) ingredientePopular(Ingrediente)

% Un ingrediente es popular si hay mas de tres platos que lo incluyen

ingredientePopular(Ingrediente, Platos):-
    tiene(ingrediente(Ingrediente, _), _),
    findall(1, tiene(ingrediente(Ingrediente, _), _), Platos).
    sumlist(Platos, Cantidad),
    Cantidad > 3.

tiene(Ingrediente, Plato) :-
    composicion(Plato, Ingredientes),
    member(Ingrediente, Ingredientes).


% 7) PENDIENTE