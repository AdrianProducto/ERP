Feature: Importación de Consumos de Combustible para Transporte de Personal
  Como usuario administrador del módulo de Transporte de Personal
  Quiero importar consumos de combustible desde archivo, asignarlos a recorridos y generar gastos
  Para poder controlar el gasto de combustible por unidad y vincularlo a las liquidaciones de operadores

  Background:
    Given el usuario tiene permisos de acceso al módulo de Transporte de Personal 
    
  @TPersonal @Combustible @Setup @SisProcesos
  Scenario: Registrar procesos del subproceso en SisProcesos
    Given el módulo de Transporte de Personal existe con IdProceso 1800000
    When el DBA ejecuta el script de registro de procesos
    Then se crean los siguientes registros en SisProcesos:
      | IdProceso | Proceso                          | IdPadre | Pagina                                            |
      | 1800500   | Consumos Combustible TPersonal   | 1800000 | PAGE_ProConsumosCombustibleTPersonalListado       |
      | 1800501   | Importar Consumos TPersonal      | 1800500 | NULL                                               |
      | 1800502   | Asignar Recorrido TPersonal      | 1800500 | NULL                                               |
      | 1800503   | Generar Gasto TPersonal          | 1800500 | NULL                                               |
      | 1800504   | Eliminar Consumo TPersonal       | 1800500 | NULL                                               |
      | 1800505   | Reporte Consumo TPersonal        | 1800500 | PAGE_Report_ConsumoCombustibleTPersonal            |
    And todos los registros tienen Activo = 1

  @TPersonal @Combustible @Listado @HappyPath
  Scenario: Visualizar página de listado con filtros, tabla y botonera
    Given el usuario tiene derechos sobre el proceso 1800500
    When el usuario navega a PAGE_ProConsumosCombustibleTPersonalListado
    Then el sistema muestra los filtros: EDT_Desde, EDT_Hasta, COMBO_Filtro (1=Todos, 2=Pendientes, 3=Asignados, 4=Con gasto), BTN_Aplicar
    And el sistema muestra la tabla TABLE_ProConsumosCombustibleTPersonal con formato DataTable jQuery
    And la tabla contiene las siguientes columnas: Comprobante, Fecha, Unidad, Litros, IVA, Total, Recorrido, Salida, Liquidación, Proveedor, Odómetro
    And el sistema muestra los botones: BTN_Importar, BTN_AsignarRecorrido, MENU_GenerarGasto (con OPT_DeViaje y OPT_PorTipoUnidad), BTN_Eliminar
    And el sistema carga los registros del período consultado vía CargaListado()
    And el sistema persiste los filtros actuales mediante ClsSisParametros::SetValorParametroPagina


  @TPersonal @Combustible @Listado @Derechos
  Scenario: Botones de acción se deshabilitan cuando el usuario no tiene el derecho correspondiente
    Given el usuario NO tiene derecho sobre el proceso 1800501 (Importar)
    And el usuario NO tiene derecho sobre el proceso 1800502 (Asignar Recorrido)
    And el usuario NO tiene derecho sobre el proceso 1800503 (Generar Gasto)
    And el usuario NO tiene derecho sobre el proceso 1800504 (Eliminar)
    When el usuario navega a PAGE_ProConsumosCombustibleTPersonalListado
    Then BTN_Importar..State = Grayed
    And BTN_AsignarRecorrido..State = Grayed
    And MENU_GenerarGasto.OPT_DeViaje..State = Grayed
    And MENU_GenerarGasto.OPT_PorTipoUnidad..State = Grayed
    And BTN_Eliminar..State = Grayed

  @TPersonal @Combustible @Listado @Derechos
  Scenario: Botones de acción se habilitan cuando el usuario tiene los derechos
    Given el usuario tiene derecho sobre todos los procesos 1800501 a 1800504
    When el usuario navega a la página
    Then BTN_Importar..State = Active
    And BTN_AsignarRecorrido..State = Active
    And MENU_GenerarGasto.OPT_DeViaje..State = Active
    And MENU_GenerarGasto.OPT_PorTipoUnidad..State = Active
    And BTN_Eliminar..State = Active

  @TPersonal @Combustible @Listado @Bitacora
  Scenario: Registrar en bitácora al entrar a la página de listado
    Given el usuario navega a PAGE_ProConsumosCombustibleTPersonalListado
    When se ejecuta el evento de inicialización de la página
    Then el sistema llama a ClsSisBitacoras::Registrar con IdProceso = 1800500
    And la descripción del registro es "ENTRA PAGINA CONSUMO COMBUSTIBLE TPERSONAL"

  @TPersonal @Combustible @Listado @Bitacora
  Scenario: Registrar en bitácora cada acción de la botonera
    Given el usuario está en la página de listado
    When el usuario hace clic en BTN_Importar
    Then el sistema registra en bitácora con IdProceso 1800501
    When el usuario hace clic en BTN_AsignarRecorrido
    Then el sistema registra en bitácora con IdProceso 1800502
    When el usuario selecciona MENU_GenerarGasto > OPT_DeViaje
    Then el sistema registra en bitácora con IdProceso 1800503
    When el usuario hace clic en BTN_Eliminar
    Then el sistema registra en bitácora con IdProceso 1800504

  @TPersonal @Combustible @Listado @UX
  Scenario: Ocultar botones de acción cuando no hay registros en el listado
    Given no existen consumos de combustible en el período consultado
    When CargaListado() se ejecuta
    Then BTN_AsignarRecorrido..Visible = False
    And MENU_GenerarGasto..Visible = False
    And BTN_Eliminar..Visible = False

  @TPersonal @Combustible @Listado @UX
  Scenario: Persistir filtros entre sesiones del usuario
    Given el usuario establece EDT_Desde = "01/06/2026" y COMBO_Filtro = 2 (Pendientes)
    And hace clic en BTN_Aplicar
    Then el sistema guarda los filtros mediante ClsSisParametros::SetValorParametroPagina
    When el usuario cierra la página y vuelve a ingresar
    Then el sistema restaura EDT_Desde = "01/06/2026" y COMBO_Filtro = 2 desde los parámetros guardados