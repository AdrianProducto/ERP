Feature: Agregar descripción de los trayectos modificados en la bitácora de procesos
    Yo como usuario del ERP,
    Quiero que se agregue una descripción de los trayectos modificados en la bitácora de procesos donde muestre el nombre del origen y destino del trayecto modificado o agregado en un viaje,
    Para que pueda tener un registro claro y detallado de los cambios realizados en los viajes.

  Background:
    Given que el usuario tiene registrado un viaje con trayectos en el sistema
      And el usuario ingresa a modificar el viaje para modificar la información del trayecto o agregar un nuevo trayecto al viaje

  Scenario: Generar la tabla de bitácora de procesos donde el usuario haya modificado la información de un trayecto del viaje
    Given que el usuario se encuentra en el proceso de Bitácora de procesos en el módulo de Configuración
      And el usuario filtra la búsqueda por el módulo de Tráfico en donde se encuentran los viajes y un rango de fechas
      And el usuario selecciona que en la bitácora se muestre del listado de Viajes, el proceso de Modificar
     When el usuario ejecuta la búsqueda para generar la tabla de bitácora de procesos
     Then se debe generar la tabla de bitácora con la información según los filtros seleccionados
      And en la columna de Referencia, donde el proceso fue Modificar, se debe ver de la siguiente manera:
        | Referencia |
        | ACEPTÓ/GRABÓ PÁGINA MODIFICANDO VIAJE [#VIAJE] MODIFICÓ TRAYECTO #origentrayecto "-" #destinotrayecto |

  Scenario: Generar la tabla de bitácora de procesos donde el usuario haya agregado un nuevo trayecto al viaje
    Given que el usuario se encuentra en el proceso de Bitácora de procesos en el módulo de Configuración
      And el usuario filtra la búsqueda por el módulo de Tráfico en donde se encuentran los viajes y un rango de fechas
      And el usuario selecciona que en la bitácora se muestre del listado de Viajes, el proceso de Modificar
     When el usuario ejecuta la búsqueda para generar la tabla de bitácora de procesos
     Then se debe generar la tabla de bitácora con la información según los filtros seleccionados
      And en la columna de Referencia, donde el proceso fue Modificar, se debe ver de la siguiente manera:
        | Referencia |
        | ACEPTÓ/GRABÓ PÁGINA MODIFICANDO VIAJE [#VIAJE] AGREGÓ TRAYECTO #origentrayecto "-" #destinotrayecto |
