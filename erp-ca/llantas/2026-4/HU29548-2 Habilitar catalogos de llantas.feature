Feature: Activar el proceso de catalogos del modulo de llantas

    Yo como usuario del modulo de llantas
    Requiero que sean visibles todos los catalogos del modulo
    Para que el usuario pueda realizar todas las configuraciones necesarias para usar el modulo.

Background: 
Given que el usuario se encuentra dentro de una base de datos del pais de guatemala

Scenario: Los catalogos del modulo son visibles para el usuario
When el usuario ingrese al proceso de "Catalogos"
Then Los siguientes catalogos deberan de ser visibles para el usuario:
|Catalogos                   |
|Articulos                   |
|Medidas de llantas          |
|Desechar llantas            |
|Modelo de llantas           |
|Marcas de llantas           |
|Estatus llantas             |
|Parametros de configuracion |
And el usuario tiene habilitada la posibilidad de realizar registros en ellos.


