@Jaqueline @HU37274 @GastosViaje
Feature: Incluir la columna "Creado Por" en el Excel del Listado de Gastos de Viaje

    Yo como usuario del módulo de Gastos de Viaje
    requiero que al descargar el archivo Excel del Listado de Gastos de Viaje
    se incluya la columna "Creado Por"
    Para que pueda identificar qué usuario registró cada gasto de viaje desde el archivo descargado.

    Background: Given que el usuario tiene acceso al módulo de Gastos de Viaje
        And existen gastos de viaje registrados en el sistema

    Scenario: La columna "Creado Por" aparece en el Excel descargado
        Given que el usuario se encuentra en el Listado de Gastos de Viaje
        When el usuario descarga el archivo Excel del listado
        Then el archivo Excel debe contener la columna "Creado Por"
        And la columna debe mostrar el nombre del usuario que registró cada gasto

    Scenario: La columna "Creado Por" muestra el nombre del usuario correcto
        Given que existe un gasto de viaje registrado por el usuario "Juan Pérez"
        When el usuario descarga el archivo Excel del listado
        Then en la fila correspondiente a ese gasto, la columna "Creado Por" debe mostrar "Juan Pérez"

    Scenario: La columna "Creado Por" se mantiene al aplicar filtro por fechas
        Given que el usuario tiene seleccionado un rango de fechas en el listado
        When el usuario descarga el archivo Excel con ese filtro aplicado
        Then el archivo Excel debe contener únicamente los gastos del rango seleccionado
        And cada registro debe mostrar correctamente el nombre del usuario en la columna "Creado Por"

    Scenario: Gasto registrado por un usuario que ya no está activo en el sistema
        Given que existe un gasto de viaje registrado por un usuario que fue dado de baja
        When el usuario descarga el archivo Excel del listado
        Then la columna "Creado Por" debe seguir mostrando el nombre del usuario que lo registró originalmente
        And no debe aparecer vacía ni con error
