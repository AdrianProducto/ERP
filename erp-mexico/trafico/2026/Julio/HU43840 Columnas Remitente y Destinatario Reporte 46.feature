@Jaqueline @HU43840 @ReporteCartasPorte
Feature: Agregar columnas Remitente y Destinatario al Reporte No. 46 Cartas Porte General

    Yo como usuario del módulo de Tráfico
    requiero que el Reporte No. 46 "Cartas Porte General" muestre la razón social
    y el domicilio fiscal del remitente y destinatario de cada viaje
    Para que pueda consultar esa información sin necesidad de abrir cada viaje individualmente

    Background: Given que el usuario tiene acceso al módulo de Tráfico
        And se encuentra en el Reporte No. 46 "Cartas Porte General"

    Scenario: Viaje con remitente y destinatario capturados muestra datos completos en ambas columnas
        Given existe un viaje con carta porte que tiene registrado un remitente con los datos:
            | Campo           | Valor                        |
            | RFC             | REM010101AAA                 |
            | Nombre          | Remitentes SA de CV          |
            | Calle y número  | Av. Industria 500            |
            | Colonia         | Industrial Norte             |
            | Ciudad          | Mexicali                     |
            | Estado          | Baja California              |
            | Código postal   | 21290                        |
            | Correo contacto | contacto@remitentes.com.mx   |
        And el mismo viaje tiene registrado un destinatario con los datos:
            | Campo           | Valor                        |
            | RFC             | DES010101BBB                 |
            | Nombre          | Destinatarios SA de CV       |
            | Calle y número  | Blvd. Comercio 200           |
            | Colonia         | Centro                       |
            | Ciudad          | Tijuana                      |
            | Estado          | Baja California              |
            | Código postal   | 22000                        |
            | Correo contacto | contacto@destinatarios.com   |
        When el usuario ejecuta el reporte
        Then la fila correspondiente a ese viaje muestra en la columna "Remitente":
            "REM010101AAA - Remitentes SA de CV, Av. Industria 500, Industrial Norte, Mexicali, Baja California, CP 21290, contacto@remitentes.com.mx"
        And muestra en la columna "Destinatario":
            "DES010101BBB - Destinatarios SA de CV, Blvd. Comercio 200, Centro, Tijuana, Baja California, CP 22000, contacto@destinatarios.com"

    Scenario: Viaje sin remitente capturado muestra columna Remitente vacía
        Given existe un viaje con carta porte que no tiene remitente registrado
        And el mismo viaje sí tiene destinatario capturado
        When el usuario ejecuta el reporte
        Then la fila correspondiente a ese viaje muestra la columna "Remitente" vacía
        And la columna "Destinatario" muestra los datos del destinatario registrado

    Scenario: Viaje sin destinatario capturado muestra columna Destinatario vacía
        Given existe un viaje con carta porte que sí tiene remitente registrado
        And el mismo viaje no tiene destinatario registrado
        When el usuario ejecuta el reporte
        Then la fila correspondiente a ese viaje muestra la columna "Destinatario" vacía
        And la columna "Remitente" muestra los datos del remitente registrado

    Scenario: Viaje sin remitente ni destinatario capturados muestra ambas columnas vacías
        Given existe un viaje con carta porte que no tiene remitente ni destinatario registrado
        When el usuario ejecuta el reporte
        Then la fila correspondiente a ese viaje muestra la columna "Remitente" vacía
        And la columna "Destinatario" vacía
        And el resto de los datos del viaje se muestran con normalidad
