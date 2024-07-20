; MostrarAyuda.pb

Procedure Inicializar_Textos_Ayuda()
  _textosAyuda(0) = "Bienvenido a Arrastreitor 2mil."
  _textosAyuda(1) = "Instrucciones de uso:"
  _textosAyuda(2) = "Primero selecciona el modo de arrastre en el menú desplegable inferior."
  _textosAyuda(3) = "Segundo selecciona una celda y arrastra el texto"
  _textosAyuda(4) = "Si arrastras desde otro programa quizá necesites pulsar la tecla ~crtl~"
  _textosAyuda(5) = "Puedes ocultar Arrastreitor 2mil y restaurar desde el desplegable de la barra de tareas de Windows"
  _textosAyuda(6) = "En cálculo puedes cambiar la operación pulsando sobre el símbolo de operación"
  _textosAyuda(7) = "Arrastra el nombre de un programa para ejecutarlo, con o sin parámetros, hasta el icono de la ventana"
  _textosAyuda(8) = "Un primer ejemplo podría ser arrastrar: Notepad/ArchivoJuntoArrastreitor2MilPuntoExe.txt "
  _textosAyuda(9) = "Pero también podrías poner: Notepad/" + Chr(34) + "C:\Users\usuario\Documentos\Archivo.txt" + Chr(34)
  _textosAyuda(10) = "Carga una url así: msedge/~url~"+ Chr(34) + "www.paginaweb.com/carpeta/archivo" + Chr(34)
EndProcedure

Procedure Mostrar_Ayuda()
  Inicializar_Textos_Ayuda()
  _indiceTextoAyuda = 0
  SetGadgetText(#Help_Text, _textosAyuda(_indiceTextoAyuda))
  Mostrar_Ayuda_Panel()
  SetWindowTitle(#Ventana_Principal, "Ayuda de Arrastreitor 2Mil Activa")
EndProcedure

Procedure Navegar_Ayuda(Direccion.i)
  _indiceTextoAyuda + Direccion
  If _indiceTextoAyuda < 0
    _indiceTextoAyuda = ArraySize(_textosAyuda()) - 1
  ElseIf _indiceTextoAyuda >= ArraySize(_textosAyuda())
    _indiceTextoAyuda = 0
  EndIf
  SetGadgetText(#Help_Text, _textosAyuda(_indiceTextoAyuda))
EndProcedure

Procedure Mostrar_Ayuda_Panel()
  Protected _i.i
  HideGadget(#Confirmacion_Panel, 1)
  HideGadget(#Panel_Inicial, 1)
  HideGadget(#Input_Panel, 1)
  HideGadget(#Ayuda_Panel, 0)
  _panelAyudaActivo = #True
  
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
    EndSelect
  Next
  
  For _i = #Lista_Vista41 To #Lista_Vista47
    SetGadgetColor(_i, #PB_Gadget_BackColor, RGB(220, 220, 220))
  Next
  
  DisableGadget(#ComboBox_Accion, 1)
  HideMenu(0, 1)
EndProcedure

Procedure Ocultar_Ayuda()
  Protected _i.i
  HideGadget(#Ayuda_Panel, 1)
  _panelAyudaActivo = #False
  ; Restaurar los colores de las celdas
  For _i = #Lista_Vista1 To #Lista_Vista40
    SetGadgetColor(_i, #PB_Gadget_BackColor, #PB_Default)
  Next
  ; Restaurar los colores de las celdas de la calculadora
  For _i = #Lista_Vista41 To #Lista_Vista47
    SetGadgetColor(_i, #PB_Gadget_BackColor, #PB_Default)
  Next
  DisableGadget(#ComboBox_Accion, 0)
  HideMenu(0, 0)
  SetWindowTitle(#Ventana_Principal, "Arrastreitor 2mil") ; Restaura el título de la ventana
EndProcedure

; IDE Options = PureBasic 6.10 LTS (Windows - x64)
; CursorPosition = 14
; Folding = -
; EnableXP
; DPIAware