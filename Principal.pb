; Principal.pb

EnableExplicit

; Incluir los archivos necesarios
IncludeFile "Declaraciones.pb"
IncludeFile "MostrarAyuda.pb"
IncludeFile "ManejoCeldas.pb"
IncludeFile "GestionArchivos.pb"
IncludeFile "Calculador.pb"
IncludeFile "LanzarExe.pb"

; Procedimiento para mostrar mensajes
Procedure Mostrar_Mensaje(_mensaje.s)
  SetGadgetText(#Mensaje_Label, _mensaje)
  HideGadget(#Mensaje_Label, 0) ; Mostrar el mensaje
  ; Ocultar el mensaje después de un tiempo
  AddWindowTimer(#Ventana_Principal, 1, 3000) ; 3 segundos
EndProcedure

; Procedimiento para confirmar la edición
Procedure Confirmar_Edicion()
  If _gadgetActual <> -1
    Define _textoNuevo.s = GetGadgetText(#Input_String_Gadget)
    Guardar_Estado_Previo(_gadgetActual, _textoOriginal, -1, "", _textoNuevo)
    SetGadgetItemText(_gadgetActual, 0, _textoNuevo)
    If _gadgetActual >= #Lista_Vista1 And _gadgetActual <= #Lista_Vista44
      If (_gadgetActual - #Lista_Vista1) < ArraySize(_celdas())
        _celdas(_gadgetActual - #Lista_Vista1) = _textoNuevo
      Else
        Mostrar_Mensaje("Error: Índice fuera de rango: " + Str(_gadgetActual - #Lista_Vista1))
      EndIf
    ElseIf _gadgetActual >= #Lista_Vista45 And _gadgetActual <= #Lista_Vista47
      _celdas(Calcular_Indice_Calculadora(_gadgetActual)) = _textoNuevo
    EndIf
    HideGadget(#Input_Panel, 1)
    Restaurar_Colores_Celdas()
    DisableGadget(#ComboBox_Accion, 0)
    HideMenu(0, 0)
    SetWindowTitle(#Ventana_Principal, "Arrastreitor 2mil - " + GetFilePart(_archivoActual))
    _gadgetActual = -1
    DisableGadget(#Panel_Principal, 0)
    SetGadgetState(#Panel_Principal, _pestaniaActiva)
    AddKeyboardShortcut(#Ventana_Principal, #PB_Shortcut_Return, #EnterKey)
    AddKeyboardShortcut(#Ventana_Principal, #PB_Shortcut_Escape, #EscapeKey)
  EndIf
EndProcedure

; Procedimiento para cancelar la edición
Procedure Cancelar_Edicion()
  If _gadgetActual <> -1
    SetGadgetItemText(_gadgetActual, 0, _textoOriginal)
    HideGadget(#Input_Panel, 1)
    _gadgetActual = -1
    Restaurar_Colores_Celdas()
    DisableGadget(#ComboBox_Accion, 0)
    HideMenu(0, 0)
    SetWindowTitle(#Ventana_Principal, "Arrastreitor 2mil - " + GetFilePart(_archivoActual))
    DisableGadget(#Panel_Principal, 0)
    SetGadgetState(#Panel_Principal, _pestaniaActiva)
    AddKeyboardShortcut(#Ventana_Principal, #PB_Shortcut_Return, #EnterKey)
    AddKeyboardShortcut(#Ventana_Principal, #PB_Shortcut_Escape, #EscapeKey)
  EndIf
EndProcedure

; Procedimiento para crear el menú principal
Procedure Crear_Menu()
  If CreateMenu(0, WindowID(#Ventana_Principal))
    MenuTitle("Archivo")
    MenuItem(1, "Cargar...")
    MenuItem(2, "Salvar")
    MenuItem(3, "Salvar como...")
    MenuBar()
    OpenSubMenu("Recientes")
    Actualizar_Menu_Recientes()
    CloseSubMenu()
    MenuBar()
    MenuItem(7, "Salir")
    MenuTitle("Herramientas")
    MenuItem(4, "Borrar portapapeles")
    MenuItem(5, "Deshacer último")
    MenuTitle("Ver")
    MenuItem(8, "Ocultar")
    MenuItem(9, "Fijar ventana")
    MenuTitle("?")
    MenuItem(11, "Ayuda")
    DisableMenuItem(0, 2, 1)
    DisableMenuItem(0, 5, #True)
  Else
    Mostrar_Mensaje("No se pudo crear el menú.")
  EndIf
EndProcedure

; Procedimiento para crear el menú emergente
Procedure Crear_Popup_Menu()
  If CreatePopupMenu(#Popup_Menu)
    MenuItem(100, "Copiar")
    MenuItem(101, "Pegar")
    While GetMenuItemText(#Popup_Menu, 2) <> ""
      Remove_Menu_Item(#Popup_Menu, 2)
    Wend
  EndIf
EndProcedure

; Procedimiento para crear el menú de la bandeja del sistema (1)
Procedure Crear_SysTray_Menu1()
  If CreatePopupMenu(#SysTray_Popup_Menu1)
    MenuItem(200, "Restaurar")
    MenuItem(201, "Salir")
  EndIf
EndProcedure

; Procedimiento para crear el menú de la bandeja del sistema (2)
Procedure Crear_SysTray_Menu2()
  If CreatePopupMenu(#SysTray_Popup_Menu2)
    MenuItem(201, "Salir")
  EndIf
EndProcedure

; Procedimiento para cargar el icono de la bandeja del sistema
Procedure Cargar_Icono_SysTray()
  Define _iconoNombre.s
  _iconoNombre = "arrastra.ico"
  If LoadImage(0, _iconoNombre)
    AddSysTrayIcon(#SysTray_Icon, WindowID(#Ventana_Principal), ImageID(0))
    SysTrayIconToolTip(#SysTray_Icon, "Editor de Celdas")
    SysTrayIconMenu(#SysTray_Icon, MenuID(#SysTray_Popup_Menu2))
  Else
    Mostrar_Mensaje("No se pudo cargar la imagen del SysTray.")
  EndIf
EndProcedure

; Procedimiento para alternar el estado de fijar la ventana
Procedure Alternar_Fijar_Ventana()
  If _ventanaFijada = #False
    _ventanaFijada = #True
    Fijar_Ventana(#True)
    SetMenuItemText(0, 9, "Desfijar Ventana")
    SetMenuItemText(#Popup_Menu, 105, "Desfijar Ventana")
  Else
    _ventanaFijada = #False
    Fijar_Ventana(#False)
    SetMenuItemText(0, 9, "Fijar Ventana")
    SetMenuItemText(#Popup_Menu, 105, "Fijar Ventana")
  EndIf
EndProcedure

; Procedimiento para remover un ítem del menú
Procedure Remove_Menu_Item(_menuID.i, _itemID.i)
  If IsMenu(_menuID)
    RemoveMenu_(_menuID, _itemID, #MF_BYPOSITION)
  EndIf
EndProcedure

; Procedimiento para alternar el ítem de restaurar en el menú del SysTray
Procedure Toggle_Restore_Menu_Item(_show.i)
  If _show
    SysTrayIconMenu(#SysTray_Icon, MenuID(#SysTray_Popup_Menu1))
  Else
    SysTrayIconMenu(#SysTray_Icon, MenuID(#SysTray_Popup_Menu2))
  EndIf
EndProcedure

; Procedimiento para contar los ítems del menú
Procedure Count_Menu_Items(_menuID.i)
  Protected _count.i = 0
  If IsMenu(_menuID)
    While GetMenuItemText(_menuID, _count) <> ""
      _count + 1
    Wend
  EndIf
  ProcedureReturn _count
EndProcedure

; Procedimiento para manejar eventos de la ventana
Procedure Window_Callback(_windowID.i, _message.i, _wParam.i, _lParam.i)
  Protected _result.i = #PB_ProcessPureBasicEvents
  Select _message
    Case #WM_CLOSE
      If _windowID = WindowID(#Ventana_Principal)
        Confirmar_Salir()
        If _quit
          _result = #PB_ProcessPureBasicEvents
        Else
          _result = #False
        EndIf
      EndIf
    Case #WM_SYSCOMMAND
      Select _wParam
        Case #SC_MINIMIZE
          HideWindow(#Ventana_Principal, #True)
          Toggle_Restore_Menu_Item(#True)
          _result = #False
        Case #SC_RESTORE
          Toggle_Restore_Menu_Item(#False)
      EndSelect
  EndSelect
  ProcedureReturn _result
EndProcedure

; Procedimiento para procesar eventos de la ventana principal
Procedure Procesar_Evento_Principal(_evento.i)
  Static _listaOrigen.i
  Static _textoArrastrado.s
  Protected _j
  
  ; Manejo de los eventos de la ventana principal
  Select _evento
    Case #PB_Event_Timer
      Select EventTimer()
        Case 1
          HideGadget(#Mensaje_Label, 1) ; Ocultar el mensaje después del tiempo establecido
          RemoveWindowTimer(#Ventana_Principal, 1)
      EndSelect
    Case #PB_Event_SysTray
      If EventType() = #PB_EventType_LeftClick Or EventType() = #PB_EventType_RightClick
        DisplayPopupMenu(#SysTray_Popup_Menu, WindowID(#Ventana_Principal))
      EndIf
    Case #PB_Event_Menu
      Select EventMenu()
        Case 1
          Cargar_Desde_Archivo()
          _iniciando = 0
        Case 2
          Guardar_A_Archivo()
        Case 3
          Guardar_Como_A_Archivo()
        Case 4
          Borrar_Portapapeles()
        Case 5
          Deshacer_Ultimo_Movimiento()
        Case 7
          Confirmar_Salir()
        Case 8
          HideWindow(#Ventana_Principal, #True)
          Toggle_Restore_Menu_Item(#True)
          SysTrayIconMenu(#SysTray_Icon, MenuID(#SysTray_Popup_Menu1))
        Case 9
          Alternar_Fijar_Ventana()
        Case 11
          Mostrar_Ayuda()
        Case 100
          Copiar_Texto()
        Case 101
          Pegar_Texto()
        Case 200
          Restaurar_Ventana()
        Case 201
          Confirmar_Salir()
        Case #EnterKey
          Confirmar_Edicion()
        Case #EscapeKey
          Cancelar_Edicion()
        Default
          If EventMenu() >= 20 And EventMenu() <= 29
            _archivoReciente = _listaArchivosRecientes(EventMenu() - 20)
            Mostrar_Panel_Confirmacion_Recientes()
          Else
            Mostrar_Mensaje("MenuItem: " + Str(EventMenu()))
          EndIf
      EndSelect
    Case #PB_Event_Gadget
      _ultimaInteraccion = ElapsedMilliseconds()
      Select EventGadget()
        Case #ComboBox_Accion
        Case #Lista_Vista1 To #Lista_Vista47
          Select EventType()
            Case #PB_EventType_DragStart
              _listaOrigen = EventGadget()
              Select GetGadgetState(#ComboBox_Accion)
                Case 3
                  _textoArrastrado = ""
                  For _j = 0 To 39
                    _textoArrastrado + GetGadgetItemText(#Lista_Vista1 + _j, 0) + Chr(10)
                  Next _j
                Case 4
                  _textoArrastrado = ""
                  If _listaOrigen <= #Lista_Vista40
                    For _j = 0 To 4
                      _textoArrastrado + GetGadgetItemText(#Lista_Vista1 + (_listaOrigen - #Lista_Vista1) / 10 * 10 + _j, 0) + Chr(10)
                    Next _j
                  Else
                    For _j = 0 To 1
                      _textoArrastrado + GetGadgetItemText(#Lista_Vista41 + _j, 0) + Chr(10)
                    Next _j
                  EndIf
                Case 5
                  _textoArrastrado = ""
                  If _listaOrigen <= #Lista_Vista40
                    For _j = 5 To 9
                      _textoArrastrado + GetGadgetItemText(#Lista_Vista1 + (_listaOrigen - #Lista_Vista1) / 10 * 10 + _j, 0) + Chr(10)
                    Next _j
                  Else
                    For _j = 2 To 3
                      _textoArrastrado + GetGadgetItemText(#Lista_Vista41 + _j, 0) + Chr(10)
                    Next _j
                  EndIf
                Default
                  _textoArrastrado = GetGadgetItemText(_listaOrigen, 0)
              EndSelect
              DragText(_textoArrastrado)
            Case #PB_EventType_LeftDoubleClick
              If _iniciando = 0
                Editar_Celda(EventGadget())
              EndIf
            Case #PB_EventType_RightClick
              If _iniciando = 0
                _gadgetActual = EventGadget()
                DisplayPopupMenu(#Popup_Menu, WindowID(#Ventana_Principal))
              EndIf
          EndSelect
      EndSelect
    Case #PB_Event_GadgetDrop
      _ultimaInteraccion = ElapsedMilliseconds()
      If (EventGadget() >= #Lista_Vista1 And EventGadget() <= #Lista_Vista44) Or (EventGadget() >= #Lista_Vista45 And EventGadget() <= #Lista_Vista47)
        _textoArrastrado = EventDropText()
        If _textoArrastrado <> ""
          Select GetGadgetState(#ComboBox_Accion)
            Case 0
              Guardar_Estado_Previo(EventGadget(), GetGadgetItemText(EventGadget(), 0))
              SetGadgetItemText(EventGadget(), 0, _textoArrastrado)
              If (EventGadget() >= #Lista_Vista1 And EventGadget() <= #Lista_Vista44)
                _celdas(EventGadget() - #Lista_Vista1) = _textoArrastrado
              ElseIf EventGadget() >= #Lista_Vista45 And EventGadget() <= #Lista_Vista47
                _celdas(Calcular_Indice_Calculadora(EventGadget())) = _textoArrastrado
              EndIf
            Case 1
              Guardar_Estado_Previo(_listaOrigen, GetGadgetItemText(_listaOrigen, 0), EventGadget(), GetGadgetItemText(EventGadget(), 0))
              SetGadgetItemText(EventGadget(), 0, _textoArrastrado)
              If (EventGadget() >= #Lista_Vista1 And EventGadget() <= #Lista_Vista44)
                _celdas(EventGadget() - #Lista_Vista1) = _textoArrastrado
              ElseIf EventGadget() >= #Lista_Vista45 And EventGadget() <= #Lista_Vista47
                _celdas(Calcular_Indice_Calculadora(EventGadget())) = _textoArrastrado
              EndIf
              SetGadgetItemText(_listaOrigen, 0, "")
              _celdas(_listaOrigen - #Lista_Vista1) = ""
            Case 2
              _textoDestino = GetGadgetItemText(EventGadget(), 0)
              Guardar_Estado_Previo(_listaOrigen, GetGadgetItemText(_listaOrigen, 0), EventGadget(), _textoDestino)
              SetGadgetItemText(EventGadget(), 0, _textoArrastrado)
              If (EventGadget() >= #Lista_Vista1 And EventGadget() <= #Lista_Vista44)
                _celdas(EventGadget() - #Lista_Vista1) = _textoArrastrado
              ElseIf EventGadget() >= #Lista_Vista45 And EventGadget() <= #Lista_Vista47
                _celdas(Calcular_Indice_Calculadora(EventGadget())) = _textoArrastrado
              EndIf
              SetGadgetItemText(_listaOrigen, 0, _textoDestino)
              _celdas(_listaOrigen - #Lista_Vista1) = _textoDestino
            Case 3
              Dim _textosArrastrar.s(40)
              For _j = 0 To 39
                _textosArrastrar(_j) = GetGadgetItemText(#Lista_Vista1 + _j, 0)
              Next
              _textoArrastrado = _textosArrastrar(0) + Chr(10) + _textosArrastrar(1) + Chr(10) + _textosArrastrar(2) + Chr(10) + _textosArrastrar(3)
              Guardar_Estado_Previo(EventGadget(), GetGadgetItemText(EventGadget(), 0))
              SetGadgetItemText(EventGadget(), 0, _textoArrastrado)
            Case 4
              Dim _textosIzquierda.s(5)
              If EventGadget() <= #Lista_Vista40
                For _j = 0 To 4
                  _textosIzquierda(_j) = GetGadgetItemText(#Lista_Vista1 + (EventGadget() - #Lista_Vista1) / 10 * 10 + _j, 0)
                Next
              Else
                For _j = 0 To 1
                  _textosIzquierda(_j) = GetGadgetItemText(#Lista_Vista41 + _j, 0)
                Next
              EndIf
              _textoArrastrado = _textosIzquierda(0) + Chr(10) + _textosIzquierda(1) + Chr(10) + _textosIzquierda(2) + Chr(10) + _textosIzquierda(3) + Chr(10) + _textosIzquierda(4)
              Guardar_Estado_Previo(EventGadget(), GetGadgetItemText(EventGadget(), 0))
              SetGadgetItemText(EventGadget(), 0, _textoArrastrado)
            Case 5
              Dim _textosDerecha.s(5)
              If EventGadget() <= #Lista_Vista40
                For _j = 5 To 9
                  _textosDerecha(_j) = GetGadgetItemText(#Lista_Vista1 + (EventGadget() - #Lista_Vista1) / 10 * 10 + _j, 0)
                Next
              Else
                For _j = 2 To 3
                  _textosDerecha(_j) = GetGadgetItemText(#Lista_Vista41 + _j, 0)
                Next
              EndIf
              _textoArrastrado = _textosDerecha(0) + Chr(10) + _textosDerecha(1) + Chr(10) + _textosDerecha(2) + Chr(10) + _textosDerecha(3) + _textosDerecha(4)
              Guardar_Estado_Previo(EventGadget(), GetGadgetItemText(EventGadget(), 0))
              SetGadgetItemText(EventGadget(), 0, _textoArrastrado)
            Case 6
              Guardar_Estado_Previo(EventGadget(), GetGadgetItemText(EventGadget(), 0))
              SetGadgetItemText(EventGadget(), 0, _textoArrastrado)
              If (EventGadget() >= #Lista_Vista1 And EventGadget() <= #Lista_Vista44)
                _celdas(EventGadget() - #Lista_Vista1) = _textoArrastrado
              ElseIf EventGadget() >= #Lista_Vista45 And EventGadget() <= #Lista_Vista47
                _celdas(Calcular_Indice_Calculadora(EventGadget())) = _textoArrastrado
              EndIf
          EndSelect
        EndIf
        If EventGadget() = #Lista_Vista_Resultado
          Realizar_Operacion()
        EndIf
      ElseIf EventGadget() = #Lista_Vista_Resultado
        _textoArrastrado = GetGadgetItemText(EventGadget(), 0)
        DragText(_textoArrastrado)
      ElseIf EventGadget() = #IMAGE_ICON
        Ejecutar_Programa_Con_Texto(_textoArrastrado)
      EndIf
  EndSelect

  If ElapsedMilliseconds() - _ultimaInteraccion > 3000
    For _lista = #Lista_Vista1 To #Lista_Vista47
      Define _texto.s
      _texto = GetGadgetItemText(_lista, 0)
      _celdas(_lista - #Lista_Vista1) = _texto
      SetGadgetItemText(_lista, 0, _texto)
    Next
    _ultimaInteraccion = ElapsedMilliseconds()
  EndIf
  Procesar_Eventos_Calculadora(_evento)
EndProcedure

; Procedimiento para manejar eventos de teclas
Procedure Ventana_Principal_KeyDown()
  If EventType() = #PB_EventType_KeyDown
    Select EventGadget()
      Case #Input_OK_Button, #Guardar_Y_Salir, #Guardar_Y_Abrir_Reciente
        If KeyboardPushed(#PB_Shortcut_Return)
          Confirmar_Edicion()
        EndIf
      Case #Input_Cancel_Button, #Salir_Sin_Guardar, #Cancelar_Abrir_Reciente, #Cancelar_Salir
        If KeyboardPushed(#PB_Shortcut_Escape)
          Cancelar_Edicion()
        EndIf
    EndSelect
  EndIf
EndProcedure

; Abrir la ventana principal
OpenWindow(#Ventana_Principal, 110, 100, 355, 300, "Arrastreitor 2mil", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)

If LoadImage(2, "arrastra.ico")
  SetClassLongPtr_(WindowID(#Ventana_Principal), #GCL_HICON, ImageID(2))
EndIf

ImageGadget(#IMAGE_ICON, 300, 0, 32, 32, ImageID(2))
EnableGadgetDrop(#IMAGE_ICON, #PB_Drop_Text, #PB_Drag_Copy)

Cargar_Archivos_Recientes()
Crear_Menu()
Crear_Popup_Menu()
Crear_SysTray_Menu1()
Crear_SysTray_Menu2()
Cargar_Icono_SysTray()

PanelGadget(#Panel_Principal, 10, 10, 337, 190)
AddGadgetItem(#Panel_Principal, -1, "Pestaña 1")
Crear_Panel(#Panel1, RGB(220, 220, 220))

AddGadgetItem(#Panel_Principal, -1, "Pestaña 2")
Crear_Panel(#Panel2, RGB(173, 216, 230))

AddGadgetItem(#Panel_Principal, -1, "Pestaña 3")
Crear_Panel(#Panel3, RGB(255, 165, 0))

AddGadgetItem(#Panel_Principal, -1, "Pestaña 4")
Crear_Panel(#Panel4, RGB(144, 238, 144))

AddGadgetItem(#Panel_Principal, -1, "Cálculo")
Crear_Panel_Calculadora()

CloseGadgetList()

ComboBoxGadget(#ComboBox_Accion, 14, 202, 330, 20)
AddGadgetItem(#ComboBox_Accion, -1, "Simple arrastre de texto a otra celda.")
AddGadgetItem(#ComboBox_Accion, -1, "Arrastrar texto a otra celda y borrar la de origen")
AddGadgetItem(#ComboBox_Accion, -1, "Intercambiar los textos entre dos celdas")
AddGadgetItem(#ComboBox_Accion, -1, "Arrastrar las primeras 40 celdas como una única columna")
AddGadgetItem(#ComboBox_Accion, -1, "Arrastrar la columna izquierda de esta pestaña")
AddGadgetItem(#ComboBox_Accion, -1, "Arrastrar la columna derecha de esta pestaña")
AddGadgetItem(#ComboBox_Accion, -1, "Arrastrar texto desde otro programa")

SetGadgetState(#ComboBox_Accion, 0)
DisableGadget(#ComboBox_Accion, 1)

ContainerGadget(#Input_Panel, 10, 231, 335, 40, #PB_Container_Raised)
StringGadget(#Input_String_Gadget, 7, 8, 220, 20, "")
ButtonGadget(#Input_OK_Button, 235, 8, 17, 17, "✅")
ButtonGadget(#Input_Cancel_Button, 285, 8, 17, 17, "❎")
HideGadget(#Input_Panel, 1)
CloseGadgetList()

ContainerGadget(#Confirmacion_Panel, 10, 231, 335, 40, #PB_Container_Raised)
ButtonGadget(#Guardar_Y_Salir, 5, 8, 100, 20, "Guardar y Salir")
ButtonGadget(#Salir_Sin_Guardar, 115, 8, 100, 20, "Salir sin Guardar")
ButtonGadget(#Cancelar_Salir, 225, 8, 100, 20, "Cancelar")
HideGadget(#Confirmacion_Panel, 1)
CloseGadgetList()

ContainerGadget(#Confirmacion_Recientes_Panel, 10, 231, 335, 40, #PB_Container_Raised)
ButtonGadget(#Guardar_Y_Abrir_Reciente, 5, 8, 102, 20, "Guardar este e ir")
ButtonGadget(#Cancelar_Abrir_Reciente, 114, 8, 70, 20, "Cancelar")
ButtonGadget(#Abrir_Sin_Guardar_Reciente, 191, 8, 133, 20, "Abrir sin guardar este")
HideGadget(#Confirmacion_Recientes_Panel, 1)
CloseGadgetList()

ContainerGadget(#Panel_Inicial, 10, 228, 335, 46, #PB_Container_Raised)
ButtonGadget(#Cargar_Archivo, 55, 6, 100, 30, "Cargar Archivo")
ButtonGadget(#No_Cargar_Archivo, 185, 6, 100, 30, "No Cargar")
HideGadget(#Panel_Inicial, 0)
CloseGadgetList()

ContainerGadget(#Ayuda_Panel, 10, 231, 335, 61, #PB_Container_Raised)
TextGadget(#Help_Text, 10, 10, 290, 40, "", #PB_Text_Center)
ButtonGadget(#Cerrar_Ayuda, 311, 1, 17, 17, "❎")
ButtonGadget(#Subir_Ayuda, 311, 18, 17, 17, "⬆️")
ButtonGadget(#Bajar_Ayuda, 311, 37, 17, 17, "⬇️")
HideGadget(#Ayuda_Panel, 1)
CloseGadgetList()

TextGadget(#Mensaje_Label, 10, 290, 335, 20, "", #PB_Text_Center | #PB_Text_Border)
HideGadget(#Mensaje_Label, 1)

Mostrar_Panel_Inicial()

Fijar_Ventana(#True)
Delay(2000)
Fijar_Ventana(#False)

AddKeyboardShortcut(#Ventana_Principal, #PB_Shortcut_Return, #EnterKey) 
AddKeyboardShortcut(#Ventana_Principal, #PB_Shortcut_Escape, #EscapeKey)

Repeat
  _evento = WaitWindowEvent()
  Procesar_Evento_Principal(_evento)
  Ventana_Principal_KeyDown()
  Select EventGadget()
    Case #Input_OK_Button
      Confirmar_Edicion()
    Case #Input_Cancel_Button
      Cancelar_Edicion()
    Case #Guardar_Y_Salir
      Guardar_Y_Salir()
    Case #Salir_Sin_Guardar
      Salir_Sin_Guardar()
    Case #Cancelar_Salir
      Cancelar_Edicion()
    Case #Guardar_Y_Abrir_Reciente
      Guardar_Y_Abrir_Reciente()
    Case #Abrir_Sin_Guardar_Reciente
      Abrir_Sin_Guardar_Reciente()
    Case #Cancelar_Abrir_Reciente
      Cancelar_Abrir_Reciente()
    Case #Cargar_Archivo
      Cargar_Desde_Archivo()
      Ocultar_Panel_Inicial()
      _iniciando = 0
      DisableGadget(#ComboBox_Accion, 0)
    Case #No_Cargar_Archivo
      Inicializar_Celdas()
      Ocultar_Panel_Inicial()
      _iniciando = 0
      DisableGadget(#ComboBox_Accion, 0)
    Case #Cerrar_Ayuda
      Ocultar_Ayuda()
    Case #Subir_Ayuda
      If EventType() = #PB_EventType_LeftClick
        Navegar_Ayuda(-1)
      EndIf
    Case #Bajar_Ayuda
      If EventType() = #PB_EventType_LeftClick
        Navegar_Ayuda(1)
      EndIf
  EndSelect
Until _quit = #True

Guardar_Archivos_Recientes()

FreeMenu(#PB_All)
FreeGadget(#PB_All)
FreeImage(#PB_All)
CloseWindow(#Ventana_Principal)
End

; IDE Options = PureBasic 6.10 LTS (Windows - x64)
; CursorPosition = 554
; FirstLine = 12
; Folding = ---
; EnableXP
; DPIAware
; UseIcon = arrastra.ico
; Executable = Arrastreitor.exe