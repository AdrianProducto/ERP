@Jaqueline @HU42834 @BitacoraParametrosTrafico
Feature: Registro en bitácora de modificaciones a parámetros de configuración de Tráfico

    Yo como administrador del módulo de Tráfico
    requiero que el sistema registre automáticamente cada modificación realizada a los parámetros de configuración
    Para que pueda auditar quién cambió qué parámetro, cuándo y cuál era el valor anterior.

    Background: Given que el usuario tiene sesión activa en el sistema
        And el usuario tiene acceso al módulo de Parámetros de Configuración de Tráfico

    # ─────────────────────────────────────────────────────────────────
    # REGLA: Solo registra si el valor realmente cambió
    # ─────────────────────────────────────────────────────────────────

    Scenario: No se genera bitácora si el usuario guarda sin modificar ningún parámetro
        Given el usuario abre la página de Parámetros de Configuración de Tráfico
        When el usuario da clic en "Grabar" sin haber modificado ningún parámetro
        Then el sistema no genera ningún registro nuevo en bitácora
        And el guardado concluye normalmente

    Scenario: No se genera bitácora si el usuario modifica un parámetro pero lo revierte al valor original antes de guardar
        Given el parámetro "ControlarInventarioUnidades" tiene el valor "1" (activado)
        When el usuario desactiva el parámetro y luego lo vuelve a activar antes de dar clic en "Grabar"
        Then el sistema no genera ningún registro en bitácora para ese parámetro
        And el guardado concluye normalmente

    Scenario: Se generan registros independientes por cada parámetro que realmente cambió en un mismo Grabar
        Given el usuario modifica tres parámetros distintos en la misma sesión de edición
        When el usuario da clic en "Grabar"
        Then el sistema genera exactamente tres registros en bitácora, uno por cada parámetro modificado
        And cada registro es independiente con su propio valor anterior, valor nuevo, usuario y fecha y hora

    # ─────────────────────────────────────────────────────────────────
    # PARÁMETROS RADIO MUTUAMENTE EXCLUYENTES
    # ─────────────────────────────────────────────────────────────────

    Scenario: Cambio de versión de complemento carta porte genera dos registros en bitácora
        Given el parámetro "ComplementoCP20" tiene valor "1" (Versión 2.0 activa) y "ComplementoCP30" tiene valor "0"
        When el usuario selecciona la opción "Versión 3.1" y da clic en "Grabar"
        Then el sistema genera un registro en bitácora para "ComplementoCP20" con ANTERIOR: 1 | NUEVO: 0
        And el sistema genera un registro en bitácora para "ComplementoCP30" con ANTERIOR: 0 | NUEVO: 1

    # ─────────────────────────────────────────────────────────────────
    # PESTAÑA: General
    # Orden: columna izquierda de arriba hacia abajo, luego columna derecha
    # ─────────────────────────────────────────────────────────────────

    Scenario Outline: Registro en bitácora al modificar parámetros de la pestaña General
        Given el parámetro "<parametro>" de tipo "<tipo_control>" tiene un valor configurado en la pestaña General
        When el usuario modifica el parámetro "<parametro>" y da clic en "Grabar"
        Then el sistema genera un registro en bitácora con sReferencia = código técnico del parámetro
        And el campo sAdicional del registro contiene el formato "ANTERIOR: [valor previo] | NUEVO: [valor nuevo]"
        And el registro contiene el usuario que realizó el cambio y la fecha y hora de la modificación
        And el registro es visible en "Bitácora de Procesos" filtrando por proceso "Tráfico > Parámetros de Configuración de Tráfico"

        Ejemplos:
        | parametro                                                                                                                        | tipo_control   |
        | Permitir facturar cuando rebase el límite de crédito del cliente (PermitirFacturarRebaseCredito)                                  | Checkbox       |
        | Controlar inventario de unidades (ControlarInventarioUnidades)                                                                   | Checkbox       |
        | Controlar tarifas en función a Tipo de unidad, Clasificación, Tipo de viaje en rutas/viajes (ControlarTarifasXTipoUnidadClasificacionTipoViaje) | Checkbox |
        | Filtrar por grupos de unidades en Tráfico/Localización (FiltrarPorGrupoUnidades)                                                 | Checkbox       |
        | Aplicar descuentos masivos (AplicarDescuentosMasivos)                                                                            | Checkbox       |
        | Mostrar datos del viaje en la liquidación (MostrarDatosdelViajeEnLiquidacion)                                                    | Checkbox       |
        | Permitir registrar más $ anticipos que los autorizado en la ruta (PermitirRegistrarAnticiposMayores)                             | Checkbox       |
        | Permitir registrar más litros en los vales que los autorizado en la ruta (PermitirRegistrarLitrosMayores)                        | Checkbox       |
        | Permitir registrar peso de descarga mayor al peso de la carga (PermitirRegistrarPesosMayores)                                    | Checkbox       |
        | Asignar automáticamente el viaje/trayecto al importar el archivo de autopistas (AsignarViajeTrayectoAlImportarAutopista)          | Checkbox       |
        | Asignar automáticamente el viaje/trayecto al importar el archivo de combustible (AsignarViajeTrayectoAlImportarCombustible)       | Checkbox       |
        | No considerar fecha de salida del viaje al asociar un viaje a la carga de combustible (NoConsiderarFechaSalidaViajeAlAsociarCargaCombustible) | Checkbox |
        | Mostrar Millas/Galones (MostrarMillasGalones)                                                                                    | Checkbox       |
        | Generar una póliza/movimiento bancario al asignar op. masiva en anticipos (GenerarUnaPolizaOpMasivosAnticipos)                   | Checkbox       |
        | Guías de Identificación en Carta Porte (GuiasIdentificacionCartaPorte)                                                          | Checkbox       |
        | Días para informar próximo vencimiento doc. unidades/operadores - Operadores (DiasParaInfProxVenDoctoOpe)                        | Numérico       |
        | Días para informar próximo vencimiento doc. unidades/operadores - Unidades (DiasParaInfProxVenDoctoUni)                          | Numérico       |
        | Hash GMTGPS (HashGMTGPS)                                                                                                         | Texto          |
        | RFC Hash (HashRFC)                                                                                                               | Texto          |
        | Token de Cliente GMTGPS V2 (TokenClienteV2)                                                                                      | Texto          |
        | Complementos para editar viajes terminados (ComplementosParaEditarViajesTerminados)                                              | Checkbox       |
        | Precio x Lts Combustible (PrecioPorLtsCombustible)                                                                               | Numérico       |
        | Salario mínimo (SalarioMinimo)                                                                                                   | Numérico       |
        | Tipo Cálculo ISPT (TipoCalculoISPT)                                                                                              | Radio          |
        | Retención diaria ISPT (RetencionDiariaISPT)                                                                                      | Numérico       |
        | % sobre ingresos ISPT (PorcentajeISPT)                                                                                          | Numérico       |
        | Tipo Cálculo IMSS (TipoCalculoIMSS)                                                                                              | Radio          |
        | Retención diaria IMSS (RetencionDiariaIMSS)                                                                                      | Numérico       |
        | % sobre ingresos IMSS (PorcentajeIMSS)                                                                                           | Numérico       |
        | Tipo de Cálculo Infonavit (TipoCalculoInfonavit)                                                                                 | Radio          |
        | Tipo de Cálculo Fonacot (TipoCalculoFonacot)                                                                                     | Radio          |
        | Timbrar con complemento carta porte Versión 2.0 (ComplementoCP20)                                                               | Radio          |
        | Timbrar con complemento carta porte Versión 3.1 (ComplementoCP30)                                                               | Radio          |
        | Control de Evidencias (ControlDeEvidencias)                                                                                      | Checkbox       |
        | Permitir liquidar viajes sin evidencias (PermitirLiquidarViajesSinEvidencias)                                                    | Checkbox       |
        | Ocultar nodo DocumentaciónAduanera (OcultarNodoDocumentacionAduanera)                                                           | Checkbox       |
        | Asociar serie y folio del XML en Gastos de viaje (AsociarSerieFolioXMLGastosViaje)                                              | Checkbox       |
        | Activar retención en clientes Extranjeros/Persona Física (ActivarRetencionEnClientesExtranjerosPersonaFisica)                   | Checkbox       |
        | Mostrar remitente y destinatario en rutas/tarifas (MostarRemitenteDestinatarioRutasTarifas)                                     | Checkbox       |
        | Activar tablero de combustible (ActivarTableroDeCombustible)                                                                     | Checkbox       |
        | Distribuir los ingresos por trayecto (DistribuirIngresosPorTrayecto)                                                            | Checkbox       |
        | Ajuste a Litros (AjusteALitros)                                                                                                  | Numérico       |
        | Indicar fecha de alta y fecha de vigencia al catálogo de rutas/tarifas (IndicarFechaAltaYVigenciaEnRutasTarifas)                | Checkbox       |
        | Proceso de copiado de viajes en base a la regla 2.7.7.10 (CopiarViajeRegla27710)                                               | Checkbox       |
        | Asignar viaje a autopista sin restricción de fecha/hora (AsignarViajeAutopistaSinRestriccionFechaHora)                          | Checkbox       |
        | Permitir repetir el número al registrar Gasto de viaje (PermitirRepetirNumeroAlRegistrarGastoViaje)                             | Checkbox       |
        | Permitir registrar peso descarga por material al terminar viaje (PermitirRegistrarPesoDescargaPorMaterial)                      | Checkbox       |
        | Vista configurable para resolución 1920 x 1080 (AjustarResolucionVistaConfigurable)                                             | Checkbox       |
        | Editar materiales en viaje terminado (EditarMaterialesViajeTerminado)                                                           | Checkbox       |
        | Mostrar odómetro respecto vales/importación de combustible (MostrarOdometroRespectoValesImportacionDeCombustible)               | Checkbox       |
        | Agregar columnas Tipo de Documento y Relación 05 al listado de viajes (MostrarColumnaTipoDocumentoRelacion5)                    | Checkbox       |
        | Agregar campos de Litros Iniciales y Litros a Descontar (AgregarLitrosInicialesLitrosDescontar)                                 | Checkbox       |
        | Pantalla Aeropuerto Personalizada (PantallaAeropuertoPersonalizada)                                                             | Checkbox       |
        | Bloquear gasto de viaje / conciliación de combustible (BloquearGastoViajeConciliacionCombustible)                               | Checkbox       |
        | Pagar pasivos de Gastos de viaje (PagarPasivosGastosViaje)                                                                      | Checkbox       |
        | Permitir cargar más registros de una misma caseta en Importar Autopistas (PermitirCargarMasregistrosPorCasetaimportarAutopistas) | Checkbox      |

    # ─────────────────────────────────────────────────────────────────
    # PESTAÑA: Liquidaciones
    # Orden: columna izquierda de arriba hacia abajo, luego columna derecha
    # ─────────────────────────────────────────────────────────────────

    Scenario Outline: Registro en bitácora al modificar parámetros de la pestaña Liquidaciones
        Given el parámetro "<parametro>" de tipo "<tipo_control>" tiene un valor configurado en la pestaña Liquidaciones
        When el usuario modifica el parámetro "<parametro>" y da clic en "Grabar"
        Then el sistema genera un registro en bitácora con sReferencia = código técnico del parámetro
        And el campo sAdicional del registro contiene el formato "ANTERIOR: [valor previo] | NUEVO: [valor nuevo]"
        And el registro contiene el usuario que realizó el cambio y la fecha y hora de la modificación
        And el registro es visible en "Bitácora de Procesos" filtrando por proceso "Tráfico > Parámetros de Configuración de Tráfico"

        Ejemplos:
        | parametro                                                                                                                    | tipo_control   |
        | Mostrar importe a liquidar en viajes compuestos (LiquidarViajesCompuestos)                                                   | Checkbox       |
        | Liquidar solo viajes autorizados (LiquidarViajesAutorizados)                                                                 | Checkbox       |
        | Aplicar ajuste Sueldo/Comisión en la liquidación # 4 / # 6 (AplicarAjusteSueldoComisionLiquidacion4)                        | Checkbox       |
        | Aplicar Anticipo y vale de combustible desde trayectos (AplicarAnticipoValeCombustible)                                     | Checkbox       |
        | Generar Movimiento Bancario al Pagar Liquidación (GenerarMovimientosBancarioAlPagarLiquidacion)                             | Checkbox       |
        | Incluir varias liquidaciones en un pago (IncluirLiquidaciones)                                                              | Checkbox       |
        | Generar Movimiento Bancario al Pagar Anticipos (GenerarMovimientosBancarioAlPagarAnticipo)                                  | Checkbox       |
        | Permitir generar liquidaciones sin unidad (PermitirGenerarLiquidacionesSinUnidad)                                           | Checkbox       |
        | Elabora liquidaciones en dólares (ElaboraLiquidacionesDolares)                                                              | Checkbox       |
        | Al cerrar liquidación generar descuento x diesel faltante (GenerarDescuentoFaltantaDiesel)                                  | Checkbox       |
        | No Considerar en el Botón de Copiar Campos de Operación (NoConsiderarEnElBotonDeCopiarCamposDeOperacion)                    | Checkbox       |
        | No mostrar viajes/Trayectos sin gastos asociados al mismo viaje/Operador (NoMostrarViajesTrayectosSinGastosAsociadosAlMismoViajeOperador) | Checkbox |
        | No aplicar prorrateo de kilómetros en liquidación # 7 (NoAplicarProrrateoDeKilometrosEnLiquidacion7)                        | Checkbox       |
        | Generar Complemento de Nómina 1.2 (GeneraComplementoNomina)                                                                 | Checkbox       |
        | Visualizar columna Caseta en Detalle del Gasto de Viaje (VisualizarColumnaCasetaDetalleGastosDeViaje)                       | Checkbox       |
        | Liquidaciones para rendimiento termo (LiquidacionesParaRendimientoTermo)                                                    | Checkbox       |
        | No permitir liquidar viajes sin factura (LiquidarViajesSinFactura)                                                          | Checkbox       |
        | Rendimiento Urea (RendimientoUrea)                                                                                           | Checkbox       |
        | Cuenta p/Pago de Liq. (NumeroCtaBancariaParaLiquidaciones)                                                                  | Texto+Selector |
        | Cuenta p/Pago de Ant. (NumeroCtaBancariaParaAnticipos)                                                                      | Texto+Selector |
        | Cálculos especiales (CalculosEspeciales)                                                                                     | Checkbox       |
        | Funcionamiento de liquidaciones a través de CanBus (ActivarFuncionamientoCanbus)                                            | Checkbox       |
        | Mostrar columna saldo en liquidaciones (MostrarColumnaSaldo)                                                                 | Checkbox       |
        | Desactivar Concepto Adeudo Liq. Anterior (DesactivarConceptoAdeudoLiqAnterior)                                              | Checkbox       |
        | Descuento a conceptos de liquidación (ConfiguracionDescuentoDeduccionesGastosViaje)                                        | Checkbox       |
        | Tipo de liquidación por default (TipoLiquidacionPorDefault)                                                                  | Combo          |
        | Permitir agregar percepciones desde trayecto (PermitirAgregarPercepcionesDesdeTrayecto)                                     | Checkbox       |
        | Mostrar solamente anticipos depositados al liquidar (MostrarSolamenteAnticiposDepositadosAlLiquidar)                        | Checkbox       |
        | Permitir modificar sueldo en liquidación #8 (PermitirModificarSueldoLiquidacion8)                                           | Checkbox       |
        | Permitir modificar el importe base a liquidar para la liquidación #7 (PermitirModificarImporteBaseLiq7)                     | Checkbox       |
        | No permitir comprobación de gastos y liquidaciones de un viaje sin evidencias (NoPermitirComprobacionGastosLiqsEvidencia)   | Checkbox       |
        | Permitir editar el importe a liquidar (PermitirModificarImporteALiquidar)                                                   | Checkbox       |
        | Considerar Fecha de llegada del Trayecto al filtrar viajes (FechaLlegadaFiltrarViajesLiquidaciones)                         | Checkbox       |
        | Generar Gasto Acumulado Al Quitar Descuento (GenerarGastoAcumuladoAlQuitarDescuento)                                        | Checkbox       |
        | Considerar importe base de acuerdo al tipo de liquidación 7 o 10 en reporte #15 (ConsiderarImporteBaseDeAcuerdoTipoLiquidaciónEnReporte15) | Checkbox |
        | Inactivar el campo folio dentro del submódulo anticipos (InactivarCampoFolioSubmoduloAnticipos)                             | Checkbox       |
        | Liquidación 16) % SOBRE IMP. FLETE Y/O SUELDO BASE POR RUTA/TRAYECTO (ActivarLiquidacion16)                                | Checkbox       |
        | Calcular Rendimiento en base a combustible real capturado (RendimientoEnLitrosReales)                                       | Checkbox       |
        | Configuración odómetro final (ConfiguracionOdometroFinal)                                                                   | Checkbox       |
        | Mostrar información adicional en Itinerario de Liquidaciones (MostrarInformacionAdicionalItinerarioLiquidaciones)           | Checkbox       |
        | Liquidación Masiva (LiquidacionMasiva)                                                                                       | Checkbox       |
        | No mostrar columna Ingresos en Itinerario Liquidaciones (NoMostarColumnaIngresosItinerarioLiquidaciones)                    | Checkbox       |
        | Integrar costo social en liquidaciones (IntegrarCostoSocial)                                                                | Checkbox       |
        | Mostrar deducción por combustible (MostrarDeduccionPorCombustible)                                                          | Checkbox       |
        | Liquidaciones 17 y 18 Nómina Sindical y Nómina Carga General (Liquidaciones17y18)                                           | Checkbox       |
        | Poder definir trayecto con material peligroso para cálculo de liquidación 11 (PoderDefinirTrayectoConMaterialPeligrosoParaCalculoDeLiquidacion11) | Checkbox |
        | Omitir trayectos no liquidables (OmitirTrayectosNoLiquidables)                                                              | Checkbox       |

    # ─────────────────────────────────────────────────────────────────
    # PESTAÑA: Viajes
    # Orden: columna izquierda de arriba hacia abajo, luego columna derecha
    # ─────────────────────────────────────────────────────────────────

    Scenario Outline: Registro en bitácora al modificar parámetros de la pestaña Viajes
        Given el parámetro "<parametro>" de tipo "<tipo_control>" tiene un valor configurado en la pestaña Viajes
        When el usuario modifica el parámetro "<parametro>" y da clic en "Grabar"
        Then el sistema genera un registro en bitácora con sReferencia = código técnico del parámetro
        And el campo sAdicional del registro contiene el formato "ANTERIOR: [valor previo] | NUEVO: [valor nuevo]"
        And el registro contiene el usuario que realizó el cambio y la fecha y hora de la modificación
        And el registro es visible en "Bitácora de Procesos" filtrando por proceso "Tráfico > Parámetros de Configuración de Tráfico"

        Ejemplos:
        | parametro                                                                                                                         | tipo_control   |
        | Ocultar viajes sin carta porte, etiquetados como no facturables (OcultarViajesSinCartaporte)                                      | Checkbox       |
        | Activar viajes compuestos (ActivarViajesCompuestos)                                                                               | Checkbox       |
        | Terminar todos los trayectos/Viajes ligados al master (TerminarViajesTrayectosLigados)                                            | Checkbox       |
        | Permitir documentar CP y viaje cuando rebase el límite de crédito del cliente (PermitirDocumentarViajeRebaseCredito)              | Checkbox       |
        | Permitir documentar viajes con licencias vencidas (PermitirDocumentarViajeLicenciaVencida)                                        | Checkbox       |
        | Permitir documentar viajes con placas vencidas (PermitirDocumentarViajePlacasVencidas)                                            | Checkbox       |
        | Permitir documentar viajes con seguros vencidos (PermitirDocumentarViajeSegurosVencidos)                                          | Checkbox       |
        | Permitir documentar viajes con pasaportes vencidos (PermitirDocumentarViajePasaporteVencido)                                      | Checkbox       |
        | Marcar como terminado un trayecto al documentar (MarcarTerminadoUnTrayectoDocumentar)                                             | Checkbox       |
        | Hacer obligatorio el Número Viaje de Cliente/Load Number (HacerObligatorioViajeCliente)                                           | Checkbox       |
        | Registrar automáticamente unidades rentadas (RegistrarAutUnidadesRentadas)                                                        | Checkbox       |
        | Afectar liquidación y facturación en función al campo cantidad en viajes/carta porte (AfectarLiqFacturaConCantidadViaje)           | Checkbox       |
        | Poder agregar conceptos de facturación en ceros (PodreAgregarConceptoFacturacionEnCeros)                                          | Checkbox       |
        | Permitir agregar remolque a un viaje terminado (PermitirAgregarRemolqueViajeTerminado)                                            | Checkbox       |
        | Permitir registrar gastos al convoy del viaje (PermitirRegistrarGastosAlConvoyDelViaje)                                           | Checkbox       |
        | Poder agregar trayectos en viaje terminado (PoderAgregarTrayectosEnViajeTerminado)                                                | Checkbox       |
        | No permitir salida sin remolque asignado (NoPermitirSalidaSinRemolqueAsignado)                                                    | Checkbox       |
        | Permitir seleccionar sucursal en viajes (PermitirSeleccionarSucursalEnViajes)                                                     | Checkbox       |
        | Poder Modificar Importe Carta Porte/Viaje Relacionado a Liquidación #1 (PermitirModificarImporteCartaPorteViajeLiquidacion1)       | Checkbox       |
        | Capturar el convoy en Viajes/carta porte por Número Económico (PermitirCapturarConvoyEnViajesPorNumEconomico)                     | Checkbox       |
        | No mostrar unidades en mantenimiento al documentar viajes (NoMostrarAlDocumentarUnidadesEnMantenimiento)                          | Checkbox       |
        | Solo imprimir/Enviar una vez la carta porte (NoPermitirImprimirEnviarMasDeUnaVezCartaPorte)                                       | Checkbox       |
        | Activar conexión con Base de datos (ActivarConexionBD)                                                                            | Checkbox       |
        | Permitir seleccionar trayectos para CCP (PermitirSeleccionarTrayectoCCP)                                                          | Checkbox       |
        | No permitir elaborar viajes con rutas vencidas (NoPermitirElaborarViajesRutasVencidas)                                            | Checkbox       |
        | Habilitar cargos adicionales en viajes (HabilitarCargosAdicionalesViajes)                                                         | Checkbox       |
        | Manejo de cargos adicionales generales (ManejoDeCargosAdicionalesGenerales)                                                       | Checkbox       |
        | Permitir Importar Trayectos (PermitirImportarTrayecto)                                                                            | Checkbox       |
        | Botón autorizar sólo viajes ya facturados (AutorizarSoloViajesFacturados)                                                         | Checkbox       |
        | Viajes normal y viaje padre en pantalla aeropuerto (ViajeNormal_ViajePadre_Aeropuerto)                                            | Checkbox       |
        | Habilitar pestaña Addenda HEB (HabilitarPestanaAddendaHEB)                                                                        | Checkbox       |
        | Mostrar viajes documentados desde tráfico/viajes (MostrarViajesDocumentadosDesdeTraficoViajes)                                    | Checkbox       |
        | Activar que el No. Viaje Cliente/Load Number no se repita (ActivarNoViajeClienteNoSeRepita)                                       | Checkbox       |
        | Elabora-Cobra Viajes Por Concepto (ElaboraViajesPorConcepto)                                                                      | Checkbox       |
        | Elabora-Cobra Viajes Por Materiales (ElaboraViajesPorMateriales)                                                                  | Checkbox       |
        | Elabora-Cobra Viaje Conocimiento Embarque (ElaboraViajesPorConocimientoEmbarque)                                                   | Checkbox       |
        | Calcular importe flete en carta porte por conocimiento de embarque por volumen de llegada (CalcularImporteFletePorConocimientoDeEmbarquePorVolumenDeLlegada) | Checkbox |
        | Seleccionar múltiple tipo de material en Relación Liquidación Pemex (SeleccionarMultipleTipoDeMaterialEnRelacionLiquidacionPemex)  | Checkbox       |
        | Copiar No. Viaje / Load Number (CopiarNoViaje)                                                                                    | Checkbox       |
        | Mostrar Nombre Corto en captura Carta Porte (MostrarNombreCortoEnCartaPorte)                                                      | Checkbox       |
        | Concepto Facturación Flete (ConceptoFactFlete)                                                                                    | Texto+Selector |
        | Concepto Facturación Peaje (ConceptoFactPeaje)                                                                                    | Texto+Selector |
        | Concepto Facturación Combustible (ConceptoFactPorCombustible)                                                                     | Texto+Selector |
        | Concepto Facturación por Materiales (ConceptoFactPorMateriales)                                                                   | Texto+Selector |
        | Concepto TCDiesel Continental Tire (ConceptoFactFuel)                                                                             | Texto+Selector |
        | Poder enviar correo al facturar viaje desde el listado de Viajes (EnviarCorreoFacturarViajeDesdeListadoViajes)                    | Checkbox       |
        | No permitir asignar unidades con estatus diferente a disponible en viajes (NoPermitirAsignarEstatusNoDisponible)                  | Checkbox       |
        | No permitir guardar o asignar ruta no trazada (AsignarTrayectosNoTrazados)                                                        | Checkbox       |
        | No permitir dar salida a viaje si el punto de partida de la unidad es diferente al último punto registrado (NoPermitirSalidaSiSalidaEsDiferenteAUltimaUbicacionUnidad) | Checkbox |
        | No modificar campos en Cartas Porte facturadas y/o timbradas (NoModificarCamposEnCPFacturadasTimbradas)                           | Checkbox       |
        | No permitir anticipos a viajes no facturados/terminados (NoPermitirAnticiposViajesNoFacturadosTerminados)                         | Checkbox       |
        | Límite de trayectos pendientes de liquidación por sucursal (LimiteTrayectosPendientesLiquidacionSucursal)                         | Checkbox       |
        | No actualizar el concepto de facturación automáticamente (NoActualizarConceptoFacturacionAutomaticamente)                         | Checkbox       |
        | Permitir registro de percepciones en viajes facturados (PermitirRegistroDePercepcionesEnViajesFacturados)                         | Checkbox       |
        | Estatus Prioritario (EstatusPrioritario)                                                                                          | Checkbox       |
        | Pestaña Movimiento T.A.M. (MovimientoTAM)                                                                                         | Checkbox       |
        | No incluir el número de Identificador aduanero en descripción IMMEX (NoIncluirNumeroAduanero)                                     | Checkbox       |
        | Control de Facturación por Relación 05 (ControlDeFacturacionPorRelacion05)                                                        | Checkbox       |
        | Tipo de documento por defecto para carta porte (TipoDocumentoPorDefectoCartaPorte)                                               | Combo          |
        | Calcular automáticamente peso de combustible por la densidad (CalcularPesoCombustibleDensidad)                                    | Checkbox       |
        | Ingresos de viajes de paquetería (IngresosViajesDePaqueteria)                                                                     | Checkbox       |
        | Asignar concepto a gastos de autopista (AsignarConceptoGastosAutopistas)                                                          | Checkbox       |
        | No considerar los viajes Tipo CFDI Trasladado con Relación 05 como facturables (NoConsiderarViajesTipoCFDITrasladadoRelación05Facturables) | Checkbox |

    # ─────────────────────────────────────────────────────────────────
    # PESTAÑA: Permisionarios
    # Orden: de arriba hacia abajo (una sola columna)
    # ─────────────────────────────────────────────────────────────────

    Scenario Outline: Registro en bitácora al modificar parámetros de la pestaña Permisionarios
        Given el parámetro "<parametro>" de tipo "<tipo_control>" tiene un valor configurado en la pestaña Permisionarios
        When el usuario modifica el parámetro "<parametro>" y da clic en "Grabar"
        Then el sistema genera un registro en bitácora con sReferencia = código técnico del parámetro
        And el campo sAdicional del registro contiene el formato "ANTERIOR: [valor previo] | NUEVO: [valor nuevo]"
        And el registro contiene el usuario que realizó el cambio y la fecha y hora de la modificación
        And el registro es visible en "Bitácora de Procesos" filtrando por proceso "Tráfico > Parámetros de Configuración de Tráfico"

        Ejemplos:
        | parametro                                                                                                                       | tipo_control   |
        | Calcular la Retención sobre el Importe Base Liquidación + Ingresos Adicionales (CalcularRetencionSobreImporteBase)              | Checkbox       |
        | Permitir cerrar Liquidación de Permisionario cuando no cuenta con Comprobación de Gastos (PermitirCerrarLiquidacionPermisionario) | Checkbox      |
        | Permitir modificar Retención IVA al Liquidar (PermitirModificarRetencionLiquidacionPermisionario)                               | Checkbox       |
        | Mostrar opción de filtro permisionarios/trayectos en viajes (MostrarOpcionDeFiltroPermisionariosTrayectosEnViajes)              | Checkbox       |
        | Controlar tarifas de permisionarios en rutas/tarifas (ControlarTarifasDePermisionariosEnRutasTarifas)                          | Checkbox       |
        | Generar Pasivo Permisionario (GenerarPasivoPermisionario)                                                                        | Checkbox       |
        | Permitir editar importe en la liquidación (EditarLiquidacionPermisionario)                                                      | Checkbox       |
        | Incluir complemento Persona física integrante de coordinado (ComplementoPFIC)                                                   | Checkbox       |
        | Documentar carta porte con operador propio y unidad permisionaria (DocumentarCartaPorteConOperadorPropioyUnidadPermisionaria)    | Checkbox       |
        | Documentar carta porte con tipo figura integrante de coordinado (DocumentarCartaPorteConTipoFiguraIntegranteDeCoordinado)        | Checkbox       |
        | Tarifas y comisiones para operadores permisionarios desde Carta Porte (TarifasComisionesOperadoresPermisionariosCartaPorte)      | Checkbox       |

    # ─────────────────────────────────────────────────────────────────
    # PESTAÑA: Tabla de Valores
    # ─────────────────────────────────────────────────────────────────

    Scenario Outline: Registro en bitácora al operar registros en Tabla de Valores
        Given el usuario accede a la sección "<seccion>" en la pestaña Tabla de Valores
        When el usuario realiza la acción "<accion>" sobre un registro de esa sección y confirma
        Then el sistema registra en bitácora con sReferencia = "<seccion>"
        And el campo sAdicional contiene "<accion>: [descripción del registro afectado]"
        And el registro contiene el usuario y la fecha y hora de la operación
        And el registro es visible en "Bitácora de Procesos" filtrando por proceso "Tráfico > Parámetros de Configuración de Tráfico"

        Ejemplos:
        | seccion                                              | accion    |
        | Valores para calcular la liquidación #15             | Agregar   |
        | Valores para calcular la liquidación #15             | Modificar |
        | Valores para calcular la liquidación #15             | Eliminar  |
        | Configuración reporte detallado de viajes por semana | Agregar   |
        | Configuración reporte detallado de viajes por semana | Eliminar  |
        | Rendimiento CanBus                                   | Agregar   |
        | Rendimiento CanBus                                   | Modificar |
        | Rendimiento CanBus                                   | Eliminar  |

    # ─────────────────────────────────────────────────────────────────
    # PESTAÑA: Alerta de Correos — Sub-pestaña: Vencimiento de documentos
    # ─────────────────────────────────────────────────────────────────

    Scenario: Registro en bitácora al activar o desactivar el envío diario de alertas
        Given el usuario accede a la sub-pestaña "Vencimiento de documentos" en Alerta de correos
        When el usuario modifica el checkbox "Diariamente" y guarda
        Then el sistema registra en bitácora con sReferencia = "Diariamente"
        And el campo sAdicional contiene el formato "ANTERIOR: [valor previo] | NUEVO: [valor nuevo]"
        And el registro es visible en "Bitácora de Procesos" filtrando por proceso "Tráfico > Parámetros de Configuración de Tráfico"

    Scenario Outline: Registro en bitácora al modificar los días de envío de alertas por correo
        Given el usuario accede a la sub-pestaña "Vencimiento de documentos" en Alerta de correos
        When el usuario activa o desactiva el checkbox del día "<dia_ui>" y guarda
        Then el sistema registra en bitácora con sReferencia = "<codigo_tecnico>"
        And el campo sAdicional contiene el formato "ANTERIOR: [valor previo] | NUEVO: [valor nuevo]"
        And el registro es visible en "Bitácora de Procesos" filtrando por proceso "Tráfico > Parámetros de Configuración de Tráfico"

        Ejemplos:
        | dia_ui    | codigo_tecnico |
        | Lunes     | DiaLunes       |
        | Martes    | DiaMartes      |
        | Miércoles | DianMiercoles  |
        | Jueves    | DiaJueves      |
        | Viernes   | DiaViernes     |
        | Sábado    | DiaSabado      |
        | Domingo   | DiaDomingo     |

    Scenario: Registro en bitácora al agregar un correo en la lista de Alerta de Correos
        Given el usuario accede a la sub-pestaña "Vencimiento de documentos" en Alerta de correos
        When el usuario captura un nombre y un correo electrónico y da clic en "+" para agregar el registro
        Then el sistema registra en bitácora con sReferencia = "CatParametrosAlertaCorreo"
        And el campo sAdicional contiene "AGREGÓ: [Nombre] - [Correo electrónico]"
        And el registro es visible en "Bitácora de Procesos" filtrando por proceso "Tráfico > Parámetros de Configuración de Tráfico"

    Scenario: Registro en bitácora al eliminar un correo en la lista de Alerta de Correos
        Given existe al menos un correo configurado en la lista de alertas de vencimiento de documentos
        When el usuario selecciona el registro y da clic en eliminar
        Then el sistema registra en bitácora con sReferencia = "CatParametrosAlertaCorreo"
        And el campo sAdicional contiene "ELIMINÓ: [Nombre] - [Correo electrónico]"
        And el registro es visible en "Bitácora de Procesos" filtrando por proceso "Tráfico > Parámetros de Configuración de Tráfico"

    # ─────────────────────────────────────────────────────────────────
    # PESTAÑA: Alerta de Correos — Sub-pestaña: Notificación de estadías
    # ─────────────────────────────────────────────────────────────────

    Scenario Outline: Registro en bitácora al modificar parámetros de la sub-pestaña Notificación de estadías
        Given el parámetro "<parametro>" de tipo "<tipo_control>" tiene un valor configurado en la sub-pestaña "Notificación de estadías"
        When el usuario modifica el parámetro "<parametro>" y da clic en "Grabar"
        Then el sistema registra en bitácora con sReferencia = "<codigo_tecnico>"
        And el campo sAdicional contiene el formato "ANTERIOR: [valor previo] | NUEVO: [valor nuevo]"
        And el registro es visible en "Bitácora de Procesos" filtrando por proceso "Tráfico > Parámetros de Configuración de Tráfico"

        Ejemplos:
        | parametro                                          | codigo_tecnico              | tipo_control |
        | Enviar correo con notificación de estadías         | ParametrosAlertasPorCorreo  | Checkbox     |
        | Tractocamión                                       | EDT_Tractocamion            | Numérico     |
        | Semirremolque                                      | EDT_Semirremolque           | Numérico     |
        | Vehículo Unitario                                  | EDT_VehiculoUnitario        | Numérico     |

    Scenario: Registro en bitácora al agregar un correo en Notificación de estadías
        Given el usuario accede a la sub-pestaña "Notificación de estadías" en Alerta de correos
        When el usuario captura un nombre y un correo electrónico y da clic en "+" para agregar el registro
        Then el sistema registra en bitácora con sReferencia = "CatParametrosAlertaCorreo - Estadías"
        And el campo sAdicional contiene "AGREGÓ: [Nombre] - [Correo electrónico]"
        And el registro es visible en "Bitácora de Procesos" filtrando por proceso "Tráfico > Parámetros de Configuración de Tráfico"

    Scenario: Registro en bitácora al eliminar un correo en Notificación de estadías
        Given existe al menos un correo configurado en la lista de notificación de estadías
        When el usuario selecciona el registro y da clic en eliminar
        Then el sistema registra en bitácora con sReferencia = "CatParametrosAlertaCorreo - Estadías"
        And el campo sAdicional contiene "ELIMINÓ: [Nombre] - [Correo electrónico]"
        And el registro es visible en "Bitácora de Procesos" filtrando por proceso "Tráfico > Parámetros de Configuración de Tráfico"

    # ─────────────────────────────────────────────────────────────────
    # PESTAÑA: Apps Móviles
    # Orden: sección Mis Viajes de arriba hacia abajo, luego sección GMTERP
    # ─────────────────────────────────────────────────────────────────

    Scenario Outline: Registro en bitácora al modificar parámetros de la pestaña Apps Móviles
        Given el parámetro "<parametro>" de tipo "<tipo_control>" tiene un valor configurado en la pestaña Apps Móviles
        When el usuario modifica el parámetro "<parametro>" y da clic en "Grabar"
        Then el sistema genera un registro en bitácora con sReferencia = código técnico del parámetro
        And el campo sAdicional del registro contiene el formato "ANTERIOR: [valor previo] | NUEVO: [valor nuevo]"
        And el registro contiene el usuario que realizó el cambio y la fecha y hora de la modificación
        And el registro es visible en "Bitácora de Procesos" filtrando por proceso "Tráfico > Parámetros de Configuración de Tráfico"

        Ejemplos:
        | parametro                                                                   | tipo_control |
        | Correo S.O.S Móvil (CorreoSOS)                                              | Texto        |
        | Mensaje S.O.S Móvil (MensajeSOS)                                            | Texto        |
        | Recibir correo de notificación del móvil (CorreosViajeEstatusMovil)         | Texto        |
        | Formato para imprimir liquidación (FormatoLiquidacionApp)                   | Combo        |
        | Formato para imprimir carta porte (FormatoCartaPorteApp)                    | Combo        |
        | Visualizar viajes de hasta 30 días de elaboración (VisualizarViajesTreintaDiasElaboracion) | Checkbox |
        | Registro de entradas, salidas y disponibilidad (RegistroEntradaSalidaDisponibilidad)       | Checkbox |
        | No modificar hora de salida/llegada (NoModificarSalidaLlegadaApp)           | Checkbox     |
        | Estatus Salida Móvil - Mis Viajes (EstatusSalidaViaje)                      | Combo        |
        | Estatus Entrada Móvil - Mis Viajes (EstatusEntradaViaje)                    | Combo        |
        | Estatus Salida Válida Móvil - GMTERP (EstatusSalidaValido)                  | Combo        |
        | Estatus Salida Inválida Móvil - GMTERP (EstatusSalidaInvalido)              | Combo        |
        | En salida inválida enviar correo a (CorreosInformarEstatusInvalido)          | Texto        |
        | Estatus Entrada Válida Móvil - GMTERP (EstatusEntradaValido)                | Combo        |
        | Estatus Entrada Inválida Móvil - GMTERP (EstatusEntradaInvalido)            | Combo        |
        | En entrada inválida enviar correo a (CorreosInformarEstatusEntradaInvalido) | Texto        |

    Scenario: Registro en bitácora al activar la licencia de app móvil de un operador
        Given el usuario abre el modal "Config. Licencias" desde la pestaña Apps Móviles
        And el operador seleccionado no tiene licencia activa
        When el usuario da clic en "Activar"
        Then el sistema registra en bitácora con sReferencia = "Config. Licencias"
        And el campo sAdicional contiene "ACTIVÓ LICENCIA: [Número y Nombre del operador]"
        And el registro es visible en "Bitácora de Procesos" filtrando por proceso "Tráfico > Parámetros de Configuración de Tráfico"

    Scenario: Registro en bitácora al desactivar la licencia de app móvil de un operador
        Given el usuario abre el modal "Config. Licencias" desde la pestaña Apps Móviles
        And el operador seleccionado tiene licencia activa
        When el usuario da clic en "Desactivar"
        Then el sistema registra en bitácora con sReferencia = "Config. Licencias"
        And el campo sAdicional contiene "DESACTIVÓ LICENCIA: [Número y Nombre del operador]"
        And el registro es visible en "Bitácora de Procesos" filtrando por proceso "Tráfico > Parámetros de Configuración de Tráfico"

    Scenario: Registro en bitácora al guardar los derechos de acceso de un operador en la app móvil
        Given el usuario abre el modal "Config. Licencias" desde la pestaña Apps Móviles
        And el operador seleccionado tiene licencia activa
        When el usuario da clic en "Derechos", modifica la selección de procesos en el árbol y da clic en "Aceptar"
        Then el sistema registra en bitácora con sReferencia = "Config. Licencias - Derechos"
        And el campo sAdicional contiene "GUARDÓ DERECHOS: [Número y Nombre del operador]"
        And el registro es visible en "Bitácora de Procesos" filtrando por proceso "Tráfico > Parámetros de Configuración de Tráfico"

    Scenario: No se genera bitácora si el usuario sale del modal de derechos sin guardar
        Given el usuario abre el modal de derechos de un operador en "Config. Licencias"
        When el usuario modifica la selección de procesos y da clic en "Salir" sin aceptar
        Then el sistema no genera ningún registro en bitácora para esa acción

    Scenario: Registro en bitácora al agregar un contacto en Gestionar contactos de Apps Móviles
        Given el usuario abre el modal "Gestionar contactos" desde la pestaña Apps Móviles
        When el usuario agrega un nuevo contacto y confirma
        Then el sistema registra en bitácora con sReferencia = "Gestionar contactos"
        And el campo sAdicional contiene "AGREGÓ: [nombre y datos del contacto]"
        And el registro es visible en "Bitácora de Procesos" filtrando por proceso "Tráfico > Parámetros de Configuración de Tráfico"

    Scenario: Registro en bitácora al eliminar un contacto en Gestionar contactos de Apps Móviles
        Given el usuario abre el modal "Gestionar contactos" desde la pestaña Apps Móviles
        And existe al menos un contacto configurado en la lista
        When el usuario elimina un contacto y confirma
        Then el sistema registra en bitácora con sReferencia = "Gestionar contactos"
        And el campo sAdicional contiene "ELIMINÓ: [nombre y datos del contacto]"
        And el registro es visible en "Bitácora de Procesos" filtrando por proceso "Tráfico > Parámetros de Configuración de Tráfico"

    # ─────────────────────────────────────────────────────────────────
    # PESTAÑA: Notificaciones
    # Orden: columna Vencimiento Doc. Unidad, luego columna Vencimiento Doc. Operador
    # ─────────────────────────────────────────────────────────────────

    Scenario Outline: Registro en bitácora al modificar parámetros de la pestaña Notificaciones
        Given el parámetro "<parametro>" de tipo "<tipo_control>" tiene un valor configurado en la pestaña Notificaciones
        When el usuario modifica el parámetro "<parametro>" y da clic en "Grabar"
        Then el sistema genera un registro en bitácora con sReferencia = código técnico del parámetro
        And el campo sAdicional del registro contiene el formato "ANTERIOR: [valor previo] | NUEVO: [valor nuevo]"
        And el registro contiene el usuario que realizó el cambio y la fecha y hora de la modificación
        And el registro es visible en "Bitácora de Procesos" filtrando por proceso "Tráfico > Parámetros de Configuración de Tráfico"

        Ejemplos:
        | parametro                                                                    | tipo_control |
        | Placas - Vencimiento de Doc. Unidad (NotificacionPlacasUnidad)               | Checkbox     |
        | Permisos - Vencimiento de Doc. Unidad (NotificacionPermisosUnidad)           | Checkbox     |
        | Seguro placa mexicana - Vencimiento de Doc. Unidad (NotificacionSeguroMexicano) | Checkbox  |
        | Seguro placa americana - Vencimiento de Doc. Unidad (NotificacionSeguroAmericano) | Checkbox |
        | Documentos Adicionales - Vencimiento de Doc. Unidad (NotificacionAdicionalesUnidad) | Checkbox |
        | Días para notificar próximo vencimiento - Unidad (DiasNotificacionUnidad)    | Numérico     |
        | Licencia - Vencimiento de Doc. Operador (NotificacionLicencia)               | Checkbox     |
        | Pasaporte - Vencimiento de Doc. Operador (NotificacionPasaporte)             | Checkbox     |
        | Documentos Adicionales - Vencimiento de Doc. Operador (NotificacionAdicionalesOperador) | Checkbox |
        | Días para notificar próximo vencimiento - Operador (DiasNotificacionOperador) | Numérico    |

    # ─────────────────────────────────────────────────────────────────
    # SUBDIÁLOGOS (botones que abren páginas externas)
    # ─────────────────────────────────────────────────────────────────

    Scenario Outline: Registro en bitácora al realizar cambios en subdiálogos de configuración
        Given el usuario abre el subdiálogo "<subdialogo>" desde Parámetros de Tráfico
        When el usuario realiza la acción "<accion>" y confirma
        Then el sistema registra en bitácora con sReferencia = "<subdialogo>"
        And el campo sAdicional contiene "<accion>: [descripción del registro afectado]"
        And el registro contiene el usuario y la fecha y hora de la operación
        And el registro es visible en "Bitácora de Procesos" filtrando por proceso "Tráfico > Parámetros de Configuración de Tráfico"

        Ejemplos:
        | subdialogo                                | accion    |
        | Definir condiciones bonos                 | Agregar   |
        | Definir condiciones bonos                 | Modificar |
        | Definir condiciones bonos                 | Eliminar  |
        | Definir fórmulas Desctós.                 | Agregar   |
        | Definir fórmulas Desctós.                 | Eliminar  |
        | Config. formato correo seguimiento viajes | Modificar |
        | Config. formato de correo detallado viaje | Modificar |
        | Cálculos especiales                       | Modificar |
        | Límite de trayectos por sucursal          | Modificar |

    # ─────────────────────────────────────────────────────────────────
    # CONSULTA — Bitácora de Procesos existente (Configuración)
    # PAGE_Utilerias_Configuracion_BitacoraDeProcesos
    # No se construye pantalla nueva. Se agrega columna "Detalle" a la
    # pantalla existente que concatena: Referencia + " — " + Adicional
    # ─────────────────────────────────────────────────────────────────

    Scenario: Los registros de parámetros de Tráfico aparecen en la Bitácora de Procesos existente
        Given el usuario realizó modificaciones a parámetros de Tráfico
        When el usuario accede a "Bitácora de Procesos" en Configuración y filtra por proceso "Tráfico > Parámetros de Configuración de Tráfico"
        Then el sistema muestra los registros generados por las modificaciones
        And cada registro muestra: FechaHora, Usuario, Proceso y la columna Detalle
        And la columna Detalle muestra el código técnico del parámetro seguido del valor anterior y el valor nuevo

    Scenario: La columna Detalle concatena Referencia y Adicional
        Given existe un registro en bitácora con Referencia = "SalarioMinimo" y Adicional = "ANTERIOR: 178.00 | NUEVO: 185.00"
        When el usuario consulta ese registro en "Bitácora de Procesos"
        Then la columna Detalle muestra "SalarioMinimo — ANTERIOR: 178.00 | NUEVO: 185.00"

    Scenario: Visualización de valores booleanos de parámetros Checkbox en la Bitácora de Procesos
        Given existe un registro en bitácora de un parámetro de tipo Checkbox con Adicional = "ANTERIOR: 0 | NUEVO: 1"
        When el usuario consulta ese registro en "Bitácora de Procesos"
        Then la columna Detalle muestra los valores "0" y "1" tal como se almacenaron en BD
        And la interpretación visual (Sí/No) queda a criterio del usuario que consulta
