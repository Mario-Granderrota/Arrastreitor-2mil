; Calculador.pb

Procedure.s Limpiar_Texto_Numerico(texto.s)
  Protected _i.i, _caracter.s, _textoLimpio.s = ""
  For _i = 1 To Len(texto)
    _caracter = Mid(texto, _i, 1)
    If _caracter >= "0" And _caracter <= "9" Or _caracter = "."
      _textoLimpio + _caracter
    EndIf
  Next
  ProcedureReturn _textoLimpio
EndProcedure

Procedure Es_Numerico(texto.s)
  Protected _i.i
  For _i = 1 To Len(texto)
    If Asc(Mid(texto, _i, 1)) < 48 Or Asc(Mid(texto, _i, 1)) > 57
      ProcedureReturn #False
    EndIf
  Next
  ProcedureReturn #True
EndProcedure

Procedure Cambiar_Operacion()
  _operacionActual + 1
  If _operacionActual > 4
    _operacionActual = 1
  EndIf
  Select _operacionActual
    Case 1
      SetGadgetText(#Boton_Operacion, "➕")
    Case 2
      SetGadgetText(#Boton_Operacion, "➖")
    Case 3
      SetGadgetText(#Boton_Operacion, "✖️")
    Case 4
      SetGadgetText(#Boton_Operacion, "➗")
  EndSelect
EndProcedure

Procedure Realizar_Operacion()
  SetGadgetItemText(#Lista_Vista45, 0, Limpiar_Texto_Numerico(GetGadgetItemText(#Lista_Vista45, 0)))
  SetGadgetItemText(#Lista_Vista46, 0, Limpiar_Texto_Numerico(GetGadgetItemText(#Lista_Vista46, 0)))
  Protected _cifra1.f = ValF(GetGadgetItemText(#Lista_Vista45, 0))
  Protected _cifra2.f = ValF(GetGadgetItemText(#Lista_Vista46, 0))
  Protected _resultado.f

  Select _operacionActual
    Case 1
      _resultado = _cifra1 + _cifra2
    Case 2
      _resultado = _cifra1 - _cifra2
    Case 3
      _resultado = _cifra1 * _cifra2
    Case 4
      If _cifra2 <> 0
        _resultado = _cifra1 / _cifra2
      Else
        Mostrar_Mensaje("Error: No se puede dividir entre cero")
        _resultado = 0
      EndIf
  EndSelect
  SetGadgetItemText(#Lista_Vista47, 0, StrF(_resultado))
EndProcedure

Procedure Procesar_Eventos_Calculadora(Evento.i)
  Select Evento
    Case #PB_Event_Gadget
      Select EventGadget()
        Case #Boton_Operacion
          Cambiar_Operacion()
        Case #Boton_Calcular
          Realizar_Operacion()
      EndSelect
  EndSelect
EndProcedure

Procedure Restaurar_Ventana()
  If IsWindow(#Ventana_Principal)
    ; Mostrar y restaurar la ventana si está minimizada
    ShowWindow_(WindowID(#Ventana_Principal), #SW_RESTORE)
    ; Intentar pasar la ventana al frente
    SetForegroundWindow_(WindowID(#Ventana_Principal))
    SetActiveWindow_(WindowID(#Ventana_Principal))
    SetFocus_(WindowID(#Ventana_Principal))
    Toggle_Restore_Menu_Item(#False) ; Actualizar el SysTray para mostrar el estado correcto
  EndIf
EndProcedure

Procedure Fijar_Ventana(Fijar.i)
  If Fijar
    SetWindowPos_(WindowID(#Ventana_Principal), #HWND_TOPMOST, 0, 0, 0, 0, #SWP_NOMOVE | #SWP_NOSIZE)
  Else
    SetWindowPos_(WindowID(#Ventana_Principal), #HWND_NOTOPMOST, 0, 0, 0, 0, #SWP_NOMOVE | #SWP_NOSIZE)
  EndIf
  SetActiveWindow(#Ventana_Principal)
EndProcedure

; IDE Options = PureBasic 6.10 LTS (Windows - x64)
; CursorPosition = 97
; Folding = --
; EnableXP
; DPIAware