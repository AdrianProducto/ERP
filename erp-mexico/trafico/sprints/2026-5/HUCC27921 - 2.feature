Feature: Nuevo método para envío de información a DOGO
  Yo como usuario de Tráfico,
  Quiero poder enviar la información del registro de tiempos de salidas y llegadas de mis viajes por medio de una API de DOGO,
  Para una mejor gestión de mi proceso de monitoreo de viajes.

  Background
    Given que está configurado mi conexión con la API de DOGO para enviar información de mis viajes
      And ya está preparado para enviar toda la información de los viajes hacia el sistema DOGO

  Scenario: Envío de datos del viaje a la API al marcar Salida del trayecto
    Given que tengo un viaje registrado en el sistema
      And el viaje se encuenta asignado con Unidad y Operador
     When marco Salida a un trayecto
     Then enviará la información de la Fecha y Hora de la Salida hacia la API en el campo "SalidaReal" de los nodos "Origen" y "Destino"

  Scenario: Envío de datos del viaje a la API al marcar Llegada del trayecto
    Given que tengo un viaje registrado en el sistema
      And el viaje cuenta con un registro de Salida
     When marco Llegada a un trayecto
     Then enviará la información de la Fecha y Hora de la Llegada hacia la API en el campo "EntradaReal" en los nodos "Origen" y "Destino"




