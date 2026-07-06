@Jaqueline @HU37508 @FolioViajeCartaPorte
Feature: Asignación automática de folio en viajes carta porte cuando otro usuario toma el folio primero

    Yo como usuario capturista con acceso al módulo de Viajes
    requiero que el sistema asigne automáticamente el siguiente folio disponible
    cuando el folio que me fue asignado al abrir la pantalla ya fue usado por otro usuario
    Para que no tenga que volver a capturar la información ni ver mensajes de error.

    Background:
        Given que el usuario está autenticado en el sistema con acceso al módulo de Viajes
        And la empresa tiene más de una licencia activa con varios usuarios trabajando al mismo tiempo
        And hay folios disponibles del tipo de carta porte seleccionado

    Scenario: El número de folio se actualiza solo al pasar a otro campo
        Given que el usuario tiene abierta la pantalla de alta de viaje
        And el sistema le asignó el folio "000000000706" al abrir la pantalla
        And otro usuario guardó un viaje con ese mismo folio mientras el primer usuario seguía capturando
        When el usuario pasa de un campo a otro en la pantalla de captura
        Then el campo Folio muestra automáticamente el siguiente número disponible del mismo tipo de carta porte
        And no aparece ningún aviso ni mensaje emergente en pantalla

    Scenario: Al guardar con el folio ya tomado el sistema asigna otro y guarda sin interrumpir
        Given que el usuario tiene abierta la pantalla de alta de viaje
        And el sistema le asignó el folio "000000000706" al abrir la pantalla
        And el usuario ya completó todos los datos requeridos del viaje
        And otro usuario guardó un viaje con ese mismo folio antes de que el primer usuario presionara Aceptar
        When el usuario hace clic en el botón "Aceptar"
        Then el sistema asigna automáticamente el siguiente folio disponible del mismo tipo de carta porte
        And el viaje se guarda correctamente sin mostrar mensajes de error
        And el usuario no regresa a la pantalla de captura
        And el campo Folio muestra el número con el que quedó guardado el viaje

    Scenario: El folio sigue disponible al guardar y se usa sin cambios
        Given que el usuario tiene abierta la pantalla de alta de viaje
        And el sistema le asignó el folio "000000000706" al abrir la pantalla
        And ningún otro usuario utilizó ese folio antes de que el primer usuario guardara
        When el usuario hace clic en el botón "Aceptar"
        Then el viaje se guarda con el folio "000000000706" sin ningún cambio
        And no aparece ningún aviso ni mensaje relacionado con folios

    Scenario: Al modificar un viaje sin folio confirmado el sistema asigna el siguiente sin avisar
        Given que el usuario tiene abierta la pantalla de modificación de un viaje que aún no tiene folio confirmado
        And el sistema le asignó el folio "000000000710" al abrir la pantalla
        And otro usuario guardó un viaje con ese folio antes de que el primer usuario presionara Aceptar
        When el usuario hace clic en el botón "Aceptar"
        Then el sistema asigna automáticamente el siguiente folio disponible del mismo tipo de carta porte
        And el viaje se guarda correctamente sin interrumpir al usuario

    Scenario: Tres usuarios intentan guardar con el mismo folio al mismo tiempo
        Given que tres usuarios tienen abierta la pantalla de alta de viaje al mismo tiempo
        And los tres ven el folio "000000000706" al abrir la pantalla
        When los tres hacen clic en "Aceptar" uno tras otro
        Then el primer usuario guarda el viaje con el folio "000000000706"
        And el segundo usuario guarda el viaje con el siguiente folio disponible sin ver ningún error
        And el tercer usuario guarda el viaje con el folio siguiente sin ver ningún error
        And cada viaje queda registrado con un número de folio diferente

    Scenario: No hay más folios disponibles del tipo seleccionado al guardar
        Given que el usuario tiene abierta la pantalla de alta de viaje con el tipo "CARTA PORTE CFDI - MXLI"
        And no hay ningún folio disponible de ese tipo al momento de guardar
        When el usuario hace clic en el botón "Aceptar"
        Then el sistema muestra un mensaje indicando que no hay folios disponibles para el tipo de carta porte seleccionado
        And el viaje no se guarda
        And el usuario permanece en la pantalla de captura con todos sus datos tal como los dejó

    Scenario: No hay más folios disponibles del tipo seleccionado al pasar a otro campo
        Given que el usuario tiene abierta la pantalla de alta de viaje
        And el folio que tenía asignado ya fue usado por otro usuario
        And tampoco hay ningún otro folio disponible del mismo tipo de carta porte
        When el usuario pasa de un campo a otro en la pantalla de captura
        Then el sistema muestra un mensaje indicando que no hay folios disponibles para continuar
        And el campo Folio queda vacío

    Scenario: El nuevo folio asignado es del mismo tipo de carta porte que el usuario seleccionó
        Given que el usuario tiene seleccionado el tipo "CARTA PORTE CFDI - MXLI"
        And el folio original ya fue usado por otro usuario
        When el sistema asigna automáticamente el siguiente folio disponible
        Then el nuevo folio es del tipo "CARTA PORTE CFDI - MXLI"
        And el sistema no asigna un folio de otro tipo aunque ese tipo tenga folios disponibles

    Scenario: El folio que aparece en pantalla al guardar es el mismo que se imprime
        Given que el sistema asignó automáticamente un folio diferente al que se mostró al abrir la pantalla
        And el viaje fue guardado correctamente
        When el sistema abre la pantalla de selección de formato de impresión
        Then el formato muestra el mismo número de folio con el que se guardó el viaje
        And el historial de cambios del viaje registra ese número de folio, no el que se mostró al inicio

        Ejemplos:
        | tipo_documento          |
        | CARTA PORTE CFDI - MXLI |
        | CARTA PORTE CFDI - MXLO |
        | CARTA PORTE CFDI        |

