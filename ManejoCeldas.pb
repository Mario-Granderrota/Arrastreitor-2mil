; ManejoCeldas.pb

Procedure Crear_Panel(numPanel.i, colorFondo.i)
  Protected _i.i
  ContainerGadget(numPanel, 0, 0, 345, 190, #PB_Container_Raised)
  SetGadgetColor(numPanel, #PB_Gadget_BackColor, colorFondo)
  
  For _i = 0 To 4
    ListViewGadget(#Lista_Vista1 + (numPanel - #Panel1) * 10 + _i, 9, 10 + _i * 30, 150, 20)
    AddGadgetItem(#Lista_Vista1 + (numPanel - #Panel1) * 10 + _i, -1, _celdas((numPanel - #Panel1) * 10 + _i))
    EnableGadgetDrop(#Lista_Vista1 + (numPanel - #Panel1) * 10 + _i, #PB_Drop_Text, #PB_Drag_Copy)
  Next
  
  For _i = 5 To 9
    ListViewGadget(#Lista_Vista1 + (numPanel - #Panel1) * 10 + _i, 169, 10 + (_i - 5) * 30, 150, 20)
    AddGadgetItem(#Lista_Vista1 + (numPanel - #Panel1) * 10 + _i, -1, _celdas((numPanel - #Panel1) * 10 + _i))
    EnableGadgetDrop(#Lista_Vista1 + (numPanel - #Panel1) * 10 + _i, #PB_Drop_Text, #PB_Drag_Copy)
  Next
  CloseGadgetList()
EndProcedure

Procedure Crear_Panel_Calculadora()
  ContainerGadget(#Panel_Calculadora, 0, 0, 345, 190, #PB_Container_Raised)
  SetGadgetColor(#Panel_Calculadora, #PB_Gadget_BackColor, RGB(250, 199, 200))
  
  ListViewGadget(#Lista_Vista45, 100, 10, 150, 20)
  AddGadgetItem(#Lista_Vista45, -1, "")
  EnableGadgetDrop(#Lista_Vista45, #PB_Drop_Text, #PB_Drag_Copy)
  
  ButtonGadget(#Boton_Operacion, 40, 25, 50, 20, "➕")
  
  ListViewGadget(#Lista_Vista46, 100, 40, 150, 20)
  AddGadgetItem(#Lista_Vista46, -1, "")
  EnableGadgetDrop(#Lista_Vista46, #PB_Drop_Text, #PB_Drag_Copy)
  
  ButtonGadget(#Boton_Calcular, 100, 70, 50, 20, "🟰")
  
  ListViewGadget(#Lista_Vista47, 160, 70, 150, 20)
  AddGadgetItem(#Lista_Vista47, -1, "")
  EnableGadgetDrop(#Lista_Vista47, #PB_Drop_Text, #PB_Drag_Copy)

  ListViewGadget(#Lista_Vista41, 10, 100, 150, 20)
  AddGadgetItem(#Lista_Vista41, -1, "")
  EnableGadgetDrop(#Lista_Vista41, #PB_Drop_Text, #PB_Drag_Copy)
  
  ListViewGadget(#Lista_Vista42, 10, 130, 150, 20)
  AddGadgetItem(#Lista_Vista42, -1, "")
  EnableGadgetDrop(#Lista_Vista42, #PB_Drop_Text, #PB_Drag_Copy)
  
  ListViewGadget(#Lista_Vista43, 170, 100, 150, 20)
  AddGadgetItem(#Lista_Vista43, -1, "")
  EnableGadgetDrop(#Lista_Vista43, #PB_Drop_Text, #PB_Drag_Copy)
  
  ListViewGadget(#Lista_Vista44, 170, 130, 150, 20)
  AddGadgetItem(#Lista_Vista44, -1, "")
  EnableGadgetDrop(#Lista_Vista44, #PB_Drop_Text, #PB_Drag_Copy)
  
  CloseGadgetList()
EndProcedure

Procedure Calcular_Indice_Calculadora(gadgetID.i)
  Select gadgetID
    Case #Lista_Vista45
      ProcedureReturn _numCeldas
    Case #Lista_Vista46
      ProcedureReturn _numCeldas + 1
    Case #Lista_Vista47
      ProcedureReturn _numCeldas + 2
    Case #Lista_Vista41
      ProcedureReturn _numCeldas + 3
    Case #Lista_Vista42
      ProcedureReturn _numCeldas + 4
    Case #Lista_Vista43
      ProcedureReturn _numCeldas + 5
    Case #Lista_Vista44
      ProcedureReturn _numCeldas + 6
  EndSelect
  ProcedureReturn -1
EndProcedure

Procedure Actualizar_Celdas()
  Protected _i.i
  For _i = 0 To _numCeldas - 1
    SetGadgetItemText(#Lista_Vista1 + _i, 0, _celdas(_i))
  Next
  SetGadgetItemText(#Lista_Vista45, 0, _celdas(Calcular_Indice_Calculadora(#Lista_Vista45)))
  SetGadgetItemText(#Lista_Vista46, 0, _celdas(Calcular_Indice_Calculadora(#Lista_Vista46)))
  SetGadgetItemText(#Lista_Vista47, 0, _celdas(Calcular_Indice_Calculadora(#Lista_Vista47)))
  SetGadgetItemText(#Lista_Vista41, 0, _celdas(Calcular_Indice_Calculadora(#Lista_Vista41)))
  SetGadgetItemText(#Lista_Vista42, 0, _celdas(Calcular_Indice_Calculadora(#Lista_Vista42)))
  SetGadgetItemText(#Lista_Vista43, 0, _celdas(Calcular_Indice_Calculadora(#Lista_Vista43)))
  SetGadgetItemText(#Lista_Vista44, 0, _celdas(Calcular_Indice_Calculadora(#Lista_Vista44)))
EndProcedure

Procedure Restaurar_Colores_Celdas()
  Protected _i.i
  For _i = #Lista_Vista1 To #Lista_Vista40
    SetGadgetColor(_i, #PB_Gadget_BackColor, RGB(255, 255, 255))
  Next
  For _i = #Lista_Vista41 To #Lista_Vista47
    SetGadgetColor(_i, #PB_Gadget_BackColor, RGB(255, 255, 255))
  Next
  SetGadgetColor(#Panel_Calculadora, #PB_Gadget_BackColor, RGB(250, 199, 200))
EndProcedure

Procedure Normalizar_Celdas()
  Protected _i.i
  Restaurar_Colores_Celdas()
  For _i = 0 To _numCeldas - 1
    If _celdas(_i) = ""
      _celdas(_i) = "Celda " + Str(_i + 1)
      SetGadgetItemText(#Lista_Vista1 + _i, 0, _celdas(_i))
    EndIf
  Next
EndProcedure

Procedure Inicializar_Celdas()
  Protected _i.i
  For _i = 0 To _numCeldas - 1
    _celdas(_i) = "Celda " + Str(_i + 1)
    _seleccionadas(_i) = #False
  Next
  
  _celdas(_numCeldas) = "Pon aquí la primera cifra"
  _celdas(_numCeldas + 1) = "Pon aquí la segunda cifra"
  _celdas(_numCeldas + 2) = "Esto es el resultado"
  _celdas(_numCeldas + 3) = "Nota de calculadora 1"
  _celdas(_numCeldas + 4) = "Nota de calculadora 2"
  _celdas(_numCeldas + 5) = "Nota de calculadora 3"
  _celdas(_numCeldas + 6) = "Nota de calculadora 4"

  Actualizar_Celdas()
EndProcedure

Procedure Editar_Celda(gadgetID.i)
  Protected _i.i
  If Not _panelConfirmacionActivo And Not _panelInicialActivo And Not _panelAyudaActivo
    SetWindowTitle(#Ventana_Principal, "Editar texto de celda")
    _textoOriginal = GetGadgetItemText(gadgetID, 0)
    SetGadgetItemText(gadgetID, 0, "Modifica abajo esta celda")
    SetGadgetText(#Input_String_Gadget, _textoOriginal)
    SetActiveGadget(#Input_String_Gadget)
    HideGadget(#Input_Panel, 0)
    _gadgetActual = gadgetID

    For _i = #Lista_Vista1 To #Lista_Vista47
      If _i <> gadgetID
        If _i >= #Lista_Vista41 And _i <= #Lista_Vista47
          SetGadgetColor(_i, #PB_Gadget_BackColor, RGB(250, 199, 200))
        Else
          SetGadgetColor(_i, #PB_Gadget_BackColor, RGB(220, 220, 220))
        EndIf
      EndIf
    Next
    DisableGadget(#ComboBox_Accion, 1)
    HideMenu(0, 1)
    DisableGadget(#Panel_Principal, 1)
  EndIf
EndProcedure

Procedure Cambiar_Colores_Celdas()
  Protected _i.i
  For _i = #Lista_Vista1 To #Lista_Vista40
    Select _i
      Case #Lista_Vista1 To #Lista_Vista10
        SetGadgetColor(_i, #PB_Gadget_BackColor, RGB(220, 220, 220))
      Case #Lista_Vista11 To #Lista_Vista20
        SetGadgetColor(_i, #PB_Gadget_BackColor, RGB(173, 216, 230))
      Case #Lista_Vista21 To #Lista_Vista30
        SetGadgetColor(_i, #PB_Gadget_BackColor, RGB(255, 165, 0))
      Case #Lista_Vista31 To #Lista_Vista40
        SetGadgetColor(_i, #PB_Gadget_BackColor, RGB(144, 238, 144))
      Case #Lista_Vista41 To #Lista_Vista47
        SetGadgetColor(_i, #PB_Gadget_BackColor, RGB(255, 182, 193))
    EndSelect
  Next
EndProcedure

Procedure Mostrar_Panel_Inicial()
  HideGadget(#Input_Panel, 1)
  HideGadget(#Confirmacion_Panel, 1)
  HideGadget(#Panel_Inicial, 0)
  _panelInicialActivo = #True
  Cambiar_Colores_Celdas()
  DisableGadget(#ComboBox_Accion, 1)
  HideMenu(0, 1)
  DisableGadget(#Panel_Principal, 1)
EndProcedure

Procedure Ocultar_Panel_Inicial()
  HideGadget(#Panel_Inicial, 1)
  _panelInicialActivo = #False
  Restaurar_Colores_Celdas()
  DisableGadget(#ComboBox_Accion, 0)
  HideMenu(0, 0)
  DisableGadget(#Panel_Principal, 0)
EndProcedure

Procedure Ocultar_Panel_Confirmacion()
  SetWindowTitle(#Ventana_Principal, "Arrastreitor 2mil")
  HideGadget(#Confirmacion_Panel, 1)
  _panelConfirmacionActivo = #False
  Restaurar_Colores_Celdas()
  DisableGadget(#ComboBox_Accion, 0)
  HideMenu(0, 0)
  DisableGadget(#Panel_Principal, 0)
EndProcedure

; IDE Options = PureBasic 6.10 LTS (Windows - x64)
; CursorPosition = 133
; Folding = ---
; EnableXP
; DPIAware