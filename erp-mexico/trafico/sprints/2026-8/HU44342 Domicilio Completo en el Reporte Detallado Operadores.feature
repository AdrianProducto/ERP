@Jaqueline @HU44342 @ReporteOperadores
Feature: Mostrar dirección completa del operador en el reporte detallado de operadores

    Yo como usuario del catálogo de operadores
    requiero que el reporte detallado muestre la dirección completa de cada operador
    Para que pueda consultar en un solo lugar toda la información de domicilio sin tener que abrir el catálogo uno por uno

    Background:
        Given que el usuario tiene acceso al catálogo de operadores
        And existe al menos un operador registrado en el sistema

    Scenario: El operador tiene todos los campos de domicilio capturados
        Given que un operador tiene registrados su calle, número exterior, número interior, colonia, municipio, estado, código postal y domicilio de referencia
        When el usuario genera el reporte detallado de operadores
        Then la columna Domicilio muestra la dirección completa del operador con todos esos datos en un solo campo

    Scenario: El operador solo tiene algunos campos de domicilio capturados
        Given que un operador tiene registrada únicamente la calle, colonia y municipio, pero no tiene número interior ni domicilio de referencia
        When el usuario genera el reporte detallado de operadores
        Then la columna Domicilio muestra solo los campos que sí tienen información, sin espacios vacíos ni separadores de más

    Scenario: El operador tiene capturado el campo Domicilio/Referencia
        Given que un operador tiene capturado el campo "Domicilio/Referencia" en su catálogo
        When el usuario genera el reporte detallado de operadores
        Then la columna Domicilio incluye el contenido del campo "Domicilio/Referencia" al final de la dirección

    Scenario: El operador no tiene ningún dato de domicilio capturado
        Given que un operador no tiene ningún campo de domicilio registrado en su catálogo
        When el usuario genera el reporte detallado de operadores
        Then la columna Domicilio aparece vacía para ese operador

    Scenario: El usuario exporta el reporte a Excel
        Given que el usuario tiene abierto el reporte detallado de operadores en pantalla
        When el usuario hace clic en "Exportar XLS"
        Then el archivo de Excel descargado incluye la dirección completa en la columna Domicilio, igual que se ve en pantalla

    Scenario: El usuario imprime el reporte en PDF
        Given que el usuario tiene abierto el reporte detallado de operadores en pantalla
        When el usuario hace clic en "Imprimir PDF"
        Then el PDF generado muestra la dirección completa del operador en la columna Domicilio
