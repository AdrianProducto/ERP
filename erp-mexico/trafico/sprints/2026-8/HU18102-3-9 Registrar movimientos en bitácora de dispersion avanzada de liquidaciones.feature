Feature: Registrar movimientos en bitácora de dispersion avanzada de liquidaciones
  Como usuario administrador
  Necesito llevar un control de las acciones realizadas en sistema sobre el proceso de dispersión avanzada
  Para tener un historial de los movimientos realizados por los usuarios y detectar actividades sospechosas

  Background: 
    Given el usuario se encuntra en el listado de liquidaciones del modulo de Tráfico
    And cuenta con permisos sobre el proceso de dispersión avanzada de liquidaciones

  Scenario: Registrar acción de entrar a proceso de dispersión avanzada
    Given el usuario accede al proceso de dispersión avanzada
    Then el sistema registra el movimiento en bitacora 
    And guarda al usuario que genero la acción
    And guarda la fecha y hora en la que se realizo la acción
    And guarda el proceso afectado como "Tráfico/Liquidaciones/Disp. Avanzada"
    And guarda la descripcion del movimiento "Entra a consulta de dispersiones"

  Scenario: Registrar acción de salir del proceso de dispersión avanzada
    Given el usuario accede al proceso de dispersión avanzada
    When cierra la consulta de dispersiones creadas
    Then el sistema registra el movimiento en bitacora 
    And guarda al usuario que genero la acción
    And guarda la fecha y hora en la que se realizo la acción
    And guarda el proceso afectado como "Tráfico/Liquidaciones/Disp. Avanzada"
    And guarda la descripcion del movimiento "Cancela consulta de dispersiones"

  Scenario: Resgistar accion de generación de dispersion
    Given el usuario entra al proceso de generar dispersión
    When confirma el proceso
    And se genera correctamente la dispersión
    Then el sistema registra el movimiento en bitacora 
    And guarda al usuario que genero la acción
    And guarda la fecha y hora en la que se realizo la acción
    And guarda el proceso afectado como "Tráfico/Liquidaciones/Disp. Avanzada"
    And guarda la descripcion del movimiento "Se genero dispersión avanzada <descrpcion_disp>"

  Scenario: Registrar accion de cancelar generación de dispersion
    Given el usuario entra al proceso de generar dispersión
    When cancela el proceso
    Then el sistema registra el movimiento en bitacora 
    And guarda al usuario que genero la acción
    And guarda la fecha y hora en la que se realizo la acción
    And guarda el proceso afectado como "Tráfico/Liquidaciones/Disp. Avanzada"
    And guarda la descripcion del movimiento "Se cancela generación dispersión"

  Scenario: Registrar accion de pagar/timbrar dispersion
    Given el usuario se encuentra en el proceso pagar/timbrar
    When finaliza el proceso
    And se genera correctamente la acción
    Then el sistema registra el movimiento en bitacora 
    And guarda al usuario que genero la acción
    And guarda la fecha y hora en la que se realizo la acción
    And guarda el proceso afectado como "Tráfico/Liquidaciones/Disp. Avanzada"
    And guarda la descripcion del movimiento "Se pagan/timbran liquidaciones de la dispersión <descripcion_disp"

  Scenario: Registrar accion de cancelar pagar/timbrar dispersion
    Given el usuario se encuentra en el proceso pagar/timbrar
    When cancela el proceso
    Then el sistema registra el movimiento en bitacora 
    And guarda al usuario que genero la acción
    And guarda la fecha y hora en la que se realizo la acción
    And guarda el proceso afectado como "Tráfico/Liquidaciones/Disp. Avanzada"
    And guarda la descripcion del movimiento "Se cancela pagar/timbrar liquidaciones de la dispersión <descripcion_disp"

  Scenario: Registrar accion de entrar a consultar liquidaciones
    Given el usuario se encuentra en el listado de dispersiones
    When solicita consultar las liquidaciones de una dispersión
    Then el sistema registra el movimiento en bitacora 
    And guarda al usuario que genero la acción
    And guarda la fecha y hora en la que se realizo la acción
    And guarda el proceso afectado como "Tráfico/Liquidaciones/Disp. Avanzada"
    And guarda la descripcion del movimiento "Entra a consulta de liquidaciones de la dispersión <descripcion_disp>"

  Scenario: Registrar accion de guardar cambios en dispersión
    Given que se asociaron y/o desasociaron liquidaciones a la dispersión que esta consultando el usuario
    When solicita guardar los cambios realizados
    And el sistema guarda exitosamente dichos cambios
    Then el sistema registra el movimiento en bitacora 
    And guarda al usuario que genero la acción
    And guarda la fecha y hora en la que se realizo la acción
    And guarda el proceso afectado como "Tráfico/Liquidaciones/Disp. Avanzada"
    And guarda la descripcion del movimiento "Se asociaron y/o desasociaron liquidaciones a la dispersión <descripcion_disp>"

  Scenario: Registrar accion de cancelar consultar dispersion
    Given el usuario se encuentra consultando las liquidaciones de una dispersión 
    When cancela la consulta de la dispersión
    Then el sistema registra el movimiento en bitacora 
    And guarda al usuario que genero la acción
    And guarda la fecha y hora en la que se realizo la acción
    And guarda el proceso afectado como "Tráfico/Liquidaciones/Disp. Avanzada"
    And guarda la descripcion del movimiento "Cancela consulta de liquidaciones de la dispersión <descripcion_disp>"

  Scenario: Registrar accion de borrar dispersión
    Given el usuario se encuentra en el listado de dispersiones
    When solicita borrar una dispersión
    And confirma el borrado
    Then el sistema registra el movimiento en bitacora 
    And guarda al usuario que genero la acción
    And guarda la fecha y hora en la que se realizo la acción
    And guarda el proceso afectado como "Tráfico/Liquidaciones/Disp. Avanzada"
    And guarda la descripcion del movimiento "Se borra dispersión"

  Scenario: Registrar accion de cancelar borrado de dispersión
    Given el usuario se encuentra en el listado de dispersiones
    When solicita borrar una dispersión
    And cancela el borrado de la dispersión
    Then el sistema registra el movimiento en bitacora 
    And guarda al usuario que genero la acción
    And guarda la fecha y hora en la que se realizo la acción
    And guarda el proceso afectado como "Tráfico/Liquidaciones/Disp. Avanzada"
    And guarda la descripcion del movimiento "Cancela borrado de dispersión"
  
