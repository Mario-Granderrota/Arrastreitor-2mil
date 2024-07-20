; GestionArchivos.pb

EnableExplicit

Procedure Clear_Sub_Menu(MenuID)
  Protected _i.i
  For _i = Count_Menu_Items(MenuID) - 1 To 0 Step -1
    Remove_Menu_Item(MenuID, _i)
  Next
EndProcedure

Procedure Actualizar_Menu_Recientes()
  Protected _i.i
  Clear_Sub_Menu(3)
  For _i = 0 To ArraySize(_listaArchivosRecientes()) - 1
    If _listaArchivosRecientes(_i) <> ""
      MenuItem(20 + _i, _listaArchivosRecientes(_i))
    EndIf
  Next
EndProcedure

Procedure Anadir_Archivo_Reciente(archivo.s)
  Protected _i.i
  For _i = 0 To ArraySize(_listaArchivosRecientes()) - 1
    If _listaArchivosRecientes(_i) = archivo
      ProcedureReturn
    EndIf
  Next

  For _i = ArraySize(_listaArchivosRecientes()) - 1 To 1 Step -1
    _listaArchivosRecientes(_i) = _listaArchivosRecientes(_i - 1)
  Next
  _listaArchivosRecientes(0) = archivo
  Actualizar_Menu_Recientes()
  Guardar_Archivos_Recientes()
EndProcedure

Procedure Cargar_Desde_Archivo()
  Protected _contador.i = 0
  ; Actualización del filtro para incluir múltiples tipos de archivos
  Protected Pattern$ = "Text files (*.txt)|*.txt|Excel files (*.xls)|*.xls|All files (*.*)|*.*"
  Protected _archivo.s = OpenFileRequester("Selecciona el archivo a cargar", "", Pattern$, 0)

  ; Verificación de posibilidad de deshacer el último movimiento
  If _deshacerDisponible
    Protected _respuesta.i = MessageRequester("Cambios sin guardar", "Hay cambios sin guardar. ¿Desea guardarlos antes de cargar un nuevo archivo?", #PB_MessageRequester_YesNoCancel)
    Select _respuesta
      Case #PB_MessageRequester_Yes
        Guardar_A_Archivo()
        If _archivoActual = ""
          ProcedureReturn
        EndIf
      Case #PB_MessageRequester_Cancel
        ProcedureReturn
    EndSelect
  EndIf
  
  If _archivo <> ""
    If ReadFile(0, _archivo)
      While Not Eof(0) And _contador < _numCeldas
        _celdas(_contador) = ReadString(0)
        SetGadgetItemText(#Lista_Vista1 + _contador, 0, _celdas(_contador))
        _contador + 1
      Wend
      ; Inicializar el resto de celdas si el archivo tiene menos celdas que el máximo permitido
      For _contador = _contador To _numCeldas - 1
        _celdas(_contador) = "Celda " + Str(_contador + 1)
        SetGadgetItemText(#Lista_Vista1 + _contador, 0, _celdas(_contador))
      Next
      CloseFile(0)
      Mostrar_Mensaje("Archivo cargado exitosamente.")
      Anadir_Archivo_Reciente(_archivo)
      _archivoActual = _archivo
      SetWindowTitle(#Ventana_Principal, "Arrastreitor 2mil - " + GetFilePart(_archivoActual))
    Else
      Mostrar_Mensaje("No se pudo abrir el archivo.")
    EndIf
  ElseIf _iniciando = 1
    Inicializar_Celdas() ; Solo inicializa las celdas si el programa está iniciando
  EndIf
EndProcedure

Procedure Cargar_Desde_Archivo_Reciente(archivo.s)
  Protected _contador.i = 0
  
  ; Verificación de posibilidad de deshacer el último movimiento
  If _deshacerDisponible
    Protected _respuesta.i = MessageRequester("Cambios sin guardar", "Hay cambios sin guardar. ¿Desea guardarlos antes de abrir un archivo reciente?", #PB_MessageRequester_YesNoCancel)
    Select _respuesta
      Case #PB_MessageRequester_Yes
        Guardar_A_Archivo()
        If _archivoActual = ""
          ProcedureReturn
        EndIf
      Case #PB_MessageRequester_Cancel
        ProcedureReturn
    EndSelect
  EndIf

  If archivo <> ""
    If ReadFile(0, archivo)
      While Not Eof(0) And _contador < _numCeldas
        _celdas(_contador) = ReadString(0)
        SetGadgetItemText(#Lista_Vista1 + _contador, 0, _celdas(_contador))
        _contador + 1
      Wend
      CloseFile(0)
      Mostrar_Mensaje("Archivo cargado exitosamente.")
      _archivoActual = archivo
      SetWindowTitle(#Ventana_Principal, "Arrastreitor 2mil - " + GetFilePart(_archivoActual))
    Else
      Mostrar_Mensaje("No se pudo abrir el archivo.")
    EndIf
  EndIf
EndProcedure

Procedure Guardar_A_Archivo()
  Protected _contador.i
  If _archivoActual <> ""
    If CreateFile(0, _archivoActual)
      For _contador = 0 To _numCeldas - 1
        WriteStringN(0, _celdas(_contador))
      Next
      CloseFile(0)
      Mostrar_Mensaje("Archivo guardado exitosamente.")
      Anadir_Archivo_Reciente(_archivoActual)
      SetWindowTitle(#Ventana_Principal, "Arrastreitor 2mil - " + GetFilePart(_archivoActual))
    Else
      Mostrar_Mensaje("No se pudo crear el archivo.")
    EndIf
  Else
    Mostrar_Panel_Confirmacion() ; Mostrar confirmación si no hay archivo seleccionado
  EndIf
EndProcedure

Procedure Guardar_Como_A_Archivo()
  Protected _contador.i
  Protected Pattern$ = "Text files (*.txt)|*.txt|Excel files (*.xls)|*.xls|All files (*.*)|*.*"
  Protected _archivo.s = SaveFileRequester("Selecciona el archivo para guardar", "", Pattern$, 0)
  
  If _archivo <> ""
    ; Asegurarse de que la extensión sea correcta si no se especifica
    If LCase(GetExtensionPart(_archivo)) <> "txt" And LCase(GetExtensionPart(_archivo)) <> "xls"
      _archivo + ".txt"
    EndIf
    
    ; Comprobar si el archivo ya existe
    If FileSize(_archivo) <> -1
      If MessageRequester("Confirmación", "El archivo ya existe. ¿Desea sobrescribirlo?", #PB_MessageRequester_YesNo) = #PB_MessageRequester_No
        ProcedureReturn
      EndIf
    EndIf
    
    If CreateFile(0, _archivo)
      For _contador = 0 To _numCeldas - 1
        WriteStringN(0, _celdas(_contador))
      Next
      CloseFile(0)
      Mostrar_Mensaje("Archivo guardado exitosamente.")
      Anadir_Archivo_Reciente(_archivo)
      _archivoActual = _archivo
      SetWindowTitle(#Ventana_Principal, "Arrastreitor 2mil - " + GetFilePart(_archivoActual))
      DisableMenuItem(0, 2, 0) ; Habilitar la opción de "Salvar" en el menú
    Else
      Mostrar_Mensaje("No se pudo crear el archivo.")
    EndIf
  EndIf
EndProcedure

Procedure Guardar_Estado_Previo(celdaOrigen.i, textoOrigen.s, celdaDestino.i = -1, textoDestino.s = "", textoModificadoOrigen.s = "", textoModificadoDestino.s = "")
  _textoPrevioOrigen = textoOrigen
  _textoPrevioDestino = textoDestino
  _textoModificadoOrigen = textoModificadoOrigen
  _textoModificadoDestino = textoModificadoDestino
  _celdaPrevioOrigen = celdaOrigen
  _celdaPrevioDestino = celdaDestino
  _pestaniaActiva = GetGadgetState(#Panel_Principal)
  _deshacerDisponible = #True
  DisableMenuItem(0, 5, #False)
  DisableMenuItem(0, 2, 0) ; Habilitar la opción de "Salvar"
EndProcedure

Procedure Deshacer_Ultimo_Movimiento()
  If _deshacerDisponible
    SetGadgetState(#Panel_Principal, _pestaniaActiva)

    SetGadgetItemText(_celdaPrevioOrigen, 0, _textoPrevioOrigen)
    If _celdaPrevioOrigen >= #Lista_Vista1 And _celdaPrevioOrigen <= #Lista_Vista44
      _celdas(_celdaPrevioOrigen - #Lista_Vista1) = _textoPrevioOrigen
    ElseIf _celdaPrevioOrigen >= #Lista_Vista45 And _celdaPrevioOrigen <= #Lista_Vista47
      _celdas(Calcular_Indice_Calculadora(_celdaPrevioOrigen)) = _textoPrevioOrigen
    EndIf
    
    If _celdaPrevioDestino <> -1
      SetGadgetItemText(_celdaPrevioDestino, 0, _textoPrevioDestino)
      If _celdaPrevioDestino >= #Lista_Vista1 And _celdaPrevioDestino <= #Lista_Vista44
        _celdas(_celdaPrevioDestino - #Lista_Vista1) = _textoPrevioDestino
      ElseIf _celdaPrevioDestino >= #Lista_Vista45 And _celdaPrevioDestino <= #Lista_Vista47
        _celdas(Calcular_Indice_Calculadora(_celdaPrevioDestino)) = _textoPrevioDestino
      EndIf
    EndIf

    _deshacerDisponible = #False
    DisableMenuItem(0, 5, #True)
  EndIf
EndProcedure

Procedure Copiar_Texto()
  If _gadgetActual <> -1
    SetClipboardText(GetGadgetItemText(_gadgetActual, 0))
    Mostrar_Mensaje("Texto copiado al portapapeles.")
  EndIf
EndProcedure

Procedure Pegar_Texto()
  If _gadgetActual <> -1
    Guardar_Estado_Previo(_gadgetActual, GetGadgetItemText(_gadgetActual, 0))
    SetGadgetItemText(_gadgetActual, 0, GetClipboardText())
    Mostrar_Mensaje("Texto pegado desde el portapapeles.")
  EndIf
EndProcedure

Procedure Guardar_Archivos_Recientes()
  Protected _fileNum.i, _i.i
  _fileNum = CreateFile(#PB_Any, _archivosRecientes)
  If _fileNum
    For _i = 0 To ArraySize(_listaArchivosRecientes())
      If _listaArchivosRecientes(_i) <> ""
        WriteStringN(_fileNum, _listaArchivosRecientes(_i))
      EndIf
    Next
    CloseFile(_fileNum)
  EndIf
EndProcedure

Procedure Cargar_Archivos_Recientes()
  Protected _fileNum.i, _i.i
  If FileSize(_archivosRecientes) > 0
    _fileNum = ReadFile(#PB_Any, _archivosRecientes)
    If _fileNum
      _i = 0
      While Not Eof(_fileNum) And _i < ArraySize(_listaArchivosRecientes())
        _listaArchivosRecientes(_i) = ReadString(_fileNum)
        _i + 1
      Wend
      CloseFile(_fileNum)
    EndIf
  EndIf
  If IsMenu(0)
    Actualizar_Menu_Recientes()
  EndIf
EndProcedure

Procedure Limpiar_Archivos_Recientes()
  Protected _i.i
  For _i = 0 To ArraySize(_listaArchivosRecientes()) - 1
    _listaArchivosRecientes(_i) = ""
  Next
  Actualizar_Menu_Recientes()
  Guardar_Archivos_Recientes()
EndProcedure

Procedure Borrar_Portapapeles()
  SetClipboardText("")
  Mostrar_Mensaje("Portapapeles borrado.")
EndProcedure

Procedure Mostrar_Panel_Confirmacion()
  If _deshacerDisponible Or _archivoActual = ""
    SetWindowTitle(#Ventana_Principal, "Guardar trabajo")
    HideGadget(#Input_Panel, 1)
    HideGadget(#Confirmacion_Panel, 0)
    _panelConfirmacionActivo = #True
    Cambiar_Colores_Celdas()
    DisableGadget(#ComboBox_Accion, 1)
    HideMenu(0, 1)
    DisableGadget(#Panel_Principal, 1)
  Else
    _quit = #True
  EndIf
EndProcedure

Procedure Mostrar_Panel_Confirmacion_Recientes()
  SetWindowTitle(#Ventana_Principal, "Abrir archivo reciente")
  HideGadget(#Input_Panel, 1)
  HideGadget(#Confirmacion_Recientes_Panel, 0)
  _panelConfirmacionActivo = #True
  Cambiar_Colores_Celdas()
  DisableGadget(#ComboBox_Accion, 1)
  HideMenu(0, 1)
  DisableGadget(#Panel_Principal, 1)
EndProcedure

Procedure Ocultar_Panel_Confirmacion_Recientes()
  SetWindowTitle(#Ventana_Principal, "Arrastreitor 2mil - " + GetFilePart(_archivoActual))
  HideGadget(#Confirmacion_Recientes_Panel, 1)
  _panelConfirmacionActivo = #False
  Restaurar_Colores_Celdas()
  DisableGadget(#ComboBox_Accion, 0)
  HideMenu(0, 0)
  DisableGadget(#Panel_Principal, 0)
EndProcedure

Procedure Confirmar_Salir()
  If _deshacerDisponible Or _archivoActual = "" Or _panelConfirmacionActivo = #False And _panelInicialActivo = #False And _panelAyudaActivo = #False
    Mostrar_Panel_Confirmacion()
  Else
    _quit = #True
  EndIf
EndProcedure

Procedure Guardar_Y_Salir()
  If _archivoActual <> ""
    Guardar_A_Archivo()
  Else
    Guardar_Como_A_Archivo()
  EndIf
  _quit = #True
EndProcedure

Procedure Salir_Sin_Guardar()
  _quit = #True
EndProcedure

Procedure Cancelar_Salida()
  Ocultar_Panel_Confirmacion()
EndProcedure

Procedure Guardar_Y_Abrir_Reciente()
  If _archivoActual <> ""
    Guardar_A_Archivo()
  Else
    Guardar_Como_A_Archivo()
  EndIf
  Cargar_Desde_Archivo_Reciente(_archivoReciente)
  Ocultar_Panel_Confirmacion_Recientes()
EndProcedure

Procedure Abrir_Sin_Guardar_Reciente()
  Cargar_Desde_Archivo_Reciente(_archivoReciente)
  Ocultar_Panel_Confirmacion_Recientes()
EndProcedure

Procedure Cancelar_Abrir_Reciente()
  Ocultar_Panel_Confirmacion_Recientes()
EndProcedure

; IDE Options = PureBasic 6.10 LTS (Windows - x64)
; CursorPosition = 180
; FirstLine = 153
; Folding = -----
; EnableXP
; DPIAware