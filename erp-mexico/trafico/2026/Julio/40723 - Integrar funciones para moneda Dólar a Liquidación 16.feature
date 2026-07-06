
Feature: Configuración de moneda dólar en Liquidación 16
  Como usuario de Tráfico
  Quiero asignar importes y porcentajes en moneda dólar dentro de la configuración de Liquidación 16
  Para poder liquidar trayectos indistintamente en Pesos o en Dólares

  Background: Acceso a la configuración de Liquidación 16
    Given que el usuario tiene acceso al módulo de Tráfico 
    And accede a Rutas y Tarifas a la configuración del proceso "Liquidación 16"

  Scenario: Visualizar el nuevo formato de selección tipo Radio
    When el usuario ingresa a configuración de "Liquidación 16"
    Then el sistema debe mostrar un control tipo Radio con las opciones "Pesos" y "Dólares"
    And la opción "Pesos" debe estar seleccionada por default

  Scenario: Mantener la funcionalidad actual en el radio Pesos
    Given que el usuario selecciona el radio "Pesos" 
    Then el sistema debe mostrar la misma funcionalidad e información que existía previamente en la pestaña Pesos

  Scenario: Capturar información en el radio Dólares
    Given que el usuario selecciona el radio "Dólares"
    Then el sistema debe permitir capturar importes y porcentajes según se desee para la moneda Dólares
    And debe mostrar el combo "% Sobre Imp. Flete o Sueldo Base Ruta/Trayecto" equivalente al de Pesos

  Scenario: Conservar información al alternar entre opciones del radio
    Given que el usuario capturó información en el radio  "Pesos"
    And capturó información distinta en el radio "Dólares"
    When el usuario alterna entre ambas opciones sin guardar
    Then la información capturada en cada radio debe conservarse sin perderse

  Scenario: Mostrar campo Moneda por default en Pesos en "Liquidación 16"
    When el usuario ingresa al proceso de Liquidaciones 
    And selecciona la "Liquidación # 16"
    Then el sistema debe mostrar el campo "Moneda" con valor "PESOS" y "DÓLARES"
    And "PESOS" debe estar seleccionado por default

  Scenario: Mostrar tipo de cambio del día en el campo T.C.
    When el usuario selecciona el proceso "Liquidación 16"
    Then el sistema debe mostrar el campo "T.C." con el tipo de cambio vigente del día

  Scenario: Modificar manualmente el tipo de cambio
    Given que el sistema muestra el campo "T.C." 
    When el usuario modifica el valor del campo "T.C."
    Then el sistema debe permitir la edición del valor
    And debe utilizar el nuevo valor capturado para las conversiones de la liquidación

  Scenario: Cambiar la moneda de liquidación
    Given que el usuario se encuentra en el proceso de Liquidación 16
    When selecciona la opción "Dólares" en el campo "Moneda"
    Then el sistema debe considerar los importes configurados en los radios "Pesos" y "Dólares" (En Rutas y Tarifas)

  Scenario: Conversión automática de importes según moneda seleccionada
    Given que el usuario seleccionó Moneda "Dólares" en la Liquidación 16
    And el campo "T.C." tiene un valor
    When el sistema calcula la liquidación
    Then todos los importes deben mostrarse convertidos a Dólares aplicando el T.C.

  Scenario: Homologar trayectos con moneda mixta al seleccionar Pesos
    Given la liquidación contiene el trayecto capturado en moneda "Pesos"
    And el usuario selecciona "Pesos" como Moneda para la liquidación
    When el sistema procesa la liquidación
    Then el trayecto debe mostrarse convertida a Pesos si su moneda original era Dólares
    And debe mantenerse sin conversión si su moneda original ya era Pesos

    Ejemplos:
      | trayecto     | moneda           |
      | Trayecto A   | Dólares          |
      | Trayecto B   | Pesos            |

  Scenario: Homologar trayectos con moneda mixta al seleccionar Dólares
    Given la liquidación contiene el trayecto capturado en moneda "Dólares"
    And el usuario selecciona "Dólares" como Moneda de liquidación
    When el sistema procesa la liquidación
    Then el trayecto debe mostrarse convertido a Dólares si su moneda original era Pesos
    And debe mantenerse sin conversión si su moneda original ya era Dólares

    Ejemplos:
      | trayecto     | moneda           |
      | Trayecto C   | Pesos            |
      | Trayecto D   | Dólares          |

  Scenario: La liquidación final queda en una sola moneda
    Given que la liquidación contiene trayectos capturados en Pesos y en Dólares
    When el usuario selecciona una Moneda de liquidación y el sistema procesa la conversión
    Then todos los importes de la liquidación deben quedar expresados en la misma moneda seleccionada

  Scenario: Recalculo automático al modificar el T.C.
    Given que el usuario ya visualiza los importes calculados con el T.C. del día
    When el usuario modifica el valor del campo "T.C."
    Then el sistema debe recalcular automáticamente los importes mostrados sin acción adicional