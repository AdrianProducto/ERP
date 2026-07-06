# language: es
# HU: Actualización automática de permisos del operador sin cerrar sesión

@mis-viajes @analisis
Feature: Actualización automática de permisos del operador sin cerrar sesión
  Como operador activo en la aplicación Mis Viajes
  Quiero que mis permisos se actualicen automáticamente cuando el supervisor los modifique en el ERP
  Para no tener que cerrar sesión y volver a entrar para ver los cambios reflejados

  Background:
    Dado que el operador está autenticado en la aplicación
    Y tiene una sesión activa en ese momento

  # ─────────────────────────────────────────
  # ACTUALIZACIÓN EN EL SIGUIENTE CICLO
  # ─────────────────────────────────────────

  @smoke @actualizacion
  Escenario: Los permisos se actualizan al completarse el siguiente ciclo de verificación
    Dado que el supervisor modificó los permisos del operador en el ERP
    Y el operador tiene sesión activa al momento en que el ciclo de verificación se ejecuta
    Cuando el sistema completa el ciclo de verificación y detecta el cambio
    Entonces la aplicación actualiza los permisos del operador en segundo plano
    Y el operador ve un mensaje sutil "Tus permisos han sido actualizados"
    Y las secciones habilitadas o deshabilitadas reflejan los nuevos permisos sin cerrar sesión

  @actualizacion
  Escenario: El operador accede a un módulo recién habilitado tras el siguiente ciclo
    Dado que el operador no tenía acceso al módulo "Liquidaciones"
    Y el supervisor habilitó ese módulo en el ERP
    Cuando transcurre el intervalo de verificación y el operador tiene sesión activa en ese momento
    Entonces el módulo "Liquidaciones" aparece disponible en la navegación del operador
    Y el operador puede acceder a él sin necesidad de cerrar sesión

  @actualizacion
  Escenario: Un módulo revocado deja de estar disponible tras el siguiente ciclo
    Dado que el operador tenía acceso al módulo "Registro de Fallas"
    Y el supervisor revocó ese acceso en el ERP
    Cuando transcurre el intervalo de verificación y el operador tiene sesión activa en ese momento
    Entonces el módulo "Registro de Fallas" desaparece de la navegación del operador
    Y si intenta acceder directamente es redirigido a la pantalla de inicio

  # ─────────────────────────────────────────
  # SIN SESIÓN ACTIVA
  # ─────────────────────────────────────────

  @actualizacion
  Escenario: El operador sin sesión activa no recibe la actualización en ese ciclo
    Dado que el supervisor modificó los permisos del operador en el ERP
    Y el operador no tiene sesión activa cuando se ejecuta el ciclo de verificación
    Cuando el sistema completa el ciclo de verificación
    Entonces no se intenta actualizar los permisos de ese operador
    Y los permisos se cargarán frescos en su siguiente inicio de sesión

  # ─────────────────────────────────────────
  # SIN CAMBIOS
  # ─────────────────────────────────────────

  @actualizacion
  Escenario: No se muestra notificación si los permisos no cambiaron en el ciclo
    Dado que el supervisor no modificó los permisos del operador
    Y el operador tiene sesión activa cuando se ejecuta el ciclo de verificación
    Cuando el sistema completa el ciclo sin detectar cambios
    Entonces no se muestra ninguna notificación al operador
    Y la sesión continúa sin interrupción

  # ─────────────────────────────────────────
  # INTERVALO CONFIGURABLE
  # ─────────────────────────────────────────

  @configuracion
  Escenario: El intervalo de verificación es un valor configurable
    Dado que el sistema inicia el worker de verificación de permisos
    Cuando se establece el intervalo mediante un parámetro de configuración
    Entonces el worker utiliza ese valor como intervalo entre ciclos
    # Nota: el mecanismo para cambiar el valor (variable de entorno, config, etc.) se definirá en la HU técnica

  @configuracion
  Escenario: El intervalo por defecto es de 12 horas
    Dado que no se ha configurado un intervalo personalizado
    Cuando el sistema inicia el worker de verificación de permisos
    Entonces el intervalo de verificación es de 12 horas
    Y el worker utiliza ese valor como referencia hasta que se configure otro

  # ─────────────────────────────────────────
  # ESQUEMA — MÓDULOS AFECTADOS POR CAMBIO DE PERMISOS
  # ─────────────────────────────────────────

  @smoke @actualizacion
  Esquema del escenario: El acceso a cada módulo se refleja correctamente tras el siguiente ciclo de verificación
    Dado que el supervisor <accion> el acceso al módulo "<modulo>" en el ERP
    Y el operador tiene sesión activa cuando se ejecuta el siguiente ciclo de verificación
    Cuando el sistema detecta el cambio y aplica los nuevos permisos
    Entonces el módulo "<modulo>" está "<estado>" en la aplicación del operador

    Ejemplos:
      | accion   | modulo             | estado        |
      | habilitó | Liquidaciones      | disponible    |
      | habilitó | Registro de Fallas | disponible    |
      | revocó   | Liquidaciones      | no disponible |
      | revocó   | Registro de Fallas | no disponible |
