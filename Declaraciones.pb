; Declaraciones.pb

Enumeration
  #Ventana_Principal = 1
  #SysTray_Icon
  #Popup_Menu
  #SysTray_Popup_Menu
  #SysTray_Popup_Menu1
  #SysTray_Popup_Menu2
  #Panel_Principal
  #Panel1
  #Panel2
  #Panel3
  #Panel4
  #Panel_Calculadora
  #Input_Panel
  #Input_String_Gadget
  #Input_OK_Button
  #Input_Cancel_Button
  #Confirmacion_Panel
  #Guardar_Y_Salir
  #Salir_Sin_Guardar
  #Cancelar_Salir
  #Panel_Inicial
  #Cargar_Archivo
  #No_Cargar_Archivo
  #Ayuda_Panel
  #Help_Text
  #Cerrar_Ayuda
  #Subir_Ayuda
  #Bajar_Ayuda
  #ComboBox_Accion
  #Confirmacion_Recientes_Panel
  #Guardar_Y_Abrir_Reciente
  #Cancelar_Abrir_Reciente
  #Abrir_Sin_Guardar_Reciente
  #Lista_Vista_Resultado
  #Mensaje_Label
  #EnterKey
  #EscapeKey
  #Boton_Operacion
  #Boton_Calcular
EndEnumeration

Enumeration 100
  #Lista_Vista1 = 100
  #Lista_Vista2
  #Lista_Vista3
  #Lista_Vista4
  #Lista_Vista5
  #Lista_Vista6
  #Lista_Vista7
  #Lista_Vista8
  #Lista_Vista9
  #Lista_Vista10
  #Lista_Vista11
  #Lista_Vista12
  #Lista_Vista13
  #Lista_Vista14
  #Lista_Vista15
  #Lista_Vista16
  #Lista_Vista17
  #Lista_Vista18
  #Lista_Vista19
  #Lista_Vista20
  #Lista_Vista21
  #Lista_Vista22
  #Lista_Vista23
  #Lista_Vista24
  #Lista_Vista25
  #Lista_Vista26
  #Lista_Vista27
  #Lista_Vista28
  #Lista_Vista29
  #Lista_Vista30
  #Lista_Vista31
  #Lista_Vista32
  #Lista_Vista33
  #Lista_Vista34
  #Lista_Vista35
  #Lista_Vista36
  #Lista_Vista37
  #Lista_Vista38
  #Lista_Vista39
  #Lista_Vista40
  #Lista_Vista41
  #Lista_Vista42
  #Lista_Vista43
  #Lista_Vista44
  #Lista_Vista45
  #Lista_Vista46
  #Lista_Vista47
EndEnumeration

Global _evento.i, _ultimaInteraccion.i, _salir.i, _quit.i, _result.i, _event.i, _iniciando.i = 1
Global _numCeldas.i = 40
Global _contador.i
Global Dim _celdas.s(_numCeldas + 7)
Global Dim _seleccionadas.b(_numCeldas + 7)
Global _i.i
Global _lista.i
Global _textoDestino.s
Global _accion.i
Global _ventanaFijada.i = #False
Global _archivoActual.s = ""
Global _archivosRecientes.s = "Recientes.tpb"
Global Dim _listaArchivosRecientes.s(10)
Global _indiceTextoAyuda.i
Global Dim _textosAyuda.s(11)
Global _archivoReciente.s
Global _deshacerDisponible.i = #False
Global _panelConfirmacionActivo.i = #False
Global _panelInicialActivo.i = #False
Global _panelAyudaActivo.i = #False
Global _gadgetActual.i = -1
Global _textoOriginal.s
Global _pestaniaActiva.i
Global _textoPrevioOrigen.s, _textoPrevioDestino.s, _textoModificadoOrigen.s, _textoModificadoDestino.s
Global _celdaPrevioOrigen.i, _celdaPrevioDestino.i
Global _alarmaDescanso.i = 0
Global _alarmaManejadaEsteMinuto.i = #False
Global _descansoTime.i = 0
Global _operacionActual.i = 1
Global _textoExe0.s, _textoParametro1.s, _textoParametro2.s, _textoParametro3.s, _textoParametro4.s
Global _textoParametro5.s, _textoParametro6.s, _textoParametro7.s, _textoParametro8.s, _textoParametro9.s
Global _numeroParametros.i

Declare Clear_Sub_Menu(MenuID)
Declare Actualizar_Menu_Recientes()
Declare Count_Menu_Items(MenuID)
Declare Remove_Menu_Item(MenuID, itemID)
Declare Mostrar_Panel_Confirmacion()
Declare Ocultar_Panel_Confirmacion()
Declare Confirmar_Salir()
Declare Guardar_A_Archivo()
Declare Guardar_Como_A_Archivo()
Declare Cargar_Archivos_Recientes()
Declare Guardar_Archivos_Recientes()
Declare Mostrar_Panel_Inicial()
Declare Ocultar_Panel_Inicial()
Declare Editar_Celda(gadgetID.i)
Declare Confirmar_Edicion()
Declare Cancelar_Edicion()
Declare Crear_Menu()
Declare Crear_Popup_Menu()
Declare Cargar_Icono_SysTray()
Declare Fijar_Ventana(Fijar.i)
Declare Alternar_Fijar_Ventana()
Declare Procesar_Evento_Principal(Evento.i)
Declare Toggle_Restore_Menu_Item(show.i)
Declare Mostrar_Ayuda_Panel()
Declare Ocultar_Ayuda()
Declare Mostrar_Ayuda()
Declare Navegar_Ayuda(Direccion.i)
Declare Actualizar_Texto_Ayuda()
Declare Cambiar_Operacion()
Declare Realizar_Operacion()
Declare Alternar_Colores()
Declare Copiar_Texto()
Declare Pegar_Texto()
Declare Mostrar_Mensaje(mensaje.s)
Declare Restaurar_Ventana()

; IDE Options = PureBasic 6.10 LTS (Windows - x64)
; CursorPosition = 162
; EnableXP
; DPIAware