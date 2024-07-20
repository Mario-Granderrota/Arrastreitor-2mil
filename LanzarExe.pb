; LanzarExe.pb

Procedure.i Contar_Barras(texto.s)
  Protected _inicio.i = 1
  Protected _fin.i
  Protected _longitud.i = Len(texto)
  Protected _urlStart.i
  
  ; Verificar si hay ~url~
  _urlStart = FindString(texto, "~url~")
  
  ; Dividir texto y asignar a variables de parámetros
  _numeroParametros = 0
  Repeat
    ; Si se encuentra ~url~, tratar el resto como un único parámetro
    If _urlStart > 0 And _inicio = _urlStart
      _fin = Len(texto) + 1
      _numeroParametros + 1
      Select _numeroParametros
        Case 1
          _textoExe0 = Mid(texto, 1, _urlStart - 1)
        Case 2
          _textoParametro1 = Mid(texto, _urlStart + 5, _fin - (_urlStart + 5))
      EndSelect
      Break
    Else
      _fin = FindString(texto, "/", _inicio)
      If _fin = 0
        _fin = Len(texto) + 1
      EndIf
      _numeroParametros + 1
      Select _numeroParametros
        Case 1
          _textoExe0 = Mid(texto, _inicio, _fin - _inicio)
        Case 2
          _textoParametro1 = Mid(texto, _inicio, _fin - _inicio)
        Case 3
          _textoParametro2 = Mid(texto, _inicio, _fin - _inicio)
        Case 4
          _textoParametro3 = Mid(texto, _inicio, _fin - _inicio)
        Case 5
          _textoParametro4 = Mid(texto, _inicio, _fin - _inicio)
        Case 6
          _textoParametro5 = Mid(texto, _inicio, _fin - _inicio)
        Case 7
          _textoParametro6 = Mid(texto, _inicio, _fin - _inicio)
        Case 8
          _textoParametro7 = Mid(texto, _inicio, _fin - _inicio)
        Case 9
          _textoParametro8 = Mid(texto, _inicio, _fin - _inicio)
        Case 10
          _textoParametro9 = Mid(texto, _inicio, _fin - _inicio)
      EndSelect
      _inicio = _fin + 1
    EndIf
  Until _inicio > Len(texto)
  
  ProcedureReturn _numeroParametros
EndProcedure

ProcedureDLL.i Abrir_Programa_Con_Parametros(_numeroParametros.i, _textoExe0.s, _textoParametro1.s, _textoParametro2.s, _textoParametro3.s, _textoParametro4.s, _textoParametro5.s, _textoParametro6.s, _textoParametro7.s, _textoParametro8.s, _textoParametro9.s)
  Protected _ejecutar.s = "" 
  Protected _parametros.s = ""
  Protected _i.i
  Protected _programID.i
  Protected _programHandle.i
  
  _ejecutar = _textoExe0
  For _i = 1 To _numeroParametros - 1
    Select _i
      Case 1: _parametros + #DQUOTE$ + _textoParametro1 + #DQUOTE$ + " "
      Case 2: _parametros + #DQUOTE$ + _textoParametro2 + #DQUOTE$ + " "
      Case 3: _parametros + #DQUOTE$ + _textoParametro3 + #DQUOTE$ + " "
      Case 4: _parametros + #DQUOTE$ + _textoParametro4 + #DQUOTE$ + " "
      Case 5: _parametros + #DQUOTE$ + _textoParametro5 + #DQUOTE$ + " "
      Case 6: _parametros + #DQUOTE$ + _textoParametro6 + #DQUOTE$ + " "
      Case 7: _parametros + #DQUOTE$ + _textoParametro7 + #DQUOTE$ + " "
      Case 8: _parametros + #DQUOTE$ + _textoParametro8 + #DQUOTE$ + " "
      Case 9: _parametros + #DQUOTE$ + _textoParametro9 + #DQUOTE$ + " "
    EndSelect
  Next

  _programHandle = RunProgram(_ejecutar, _parametros, "", #PB_Program_Open)
  If _programHandle
    _programID = ProgramID(_programHandle)
    ProcedureReturn _programID ; Devuelve el ID del programa. Programa lanzado exitosamente
  Else
    ProcedureReturn 1 ;"No se pudo lanzar el programa"
  EndIf
EndProcedure

Procedure Ejecutar_Programa_Con_Texto(texto.s)
  _numeroParametros = Contar_Barras(texto)
  If _numeroParametros > 0
    Abrir_Programa_Con_Parametros(_numeroParametros, _textoExe0, _textoParametro1, _textoParametro2, _textoParametro3, _textoParametro4, _textoParametro5, _textoParametro6, _textoParametro7, _textoParametro8, _textoParametro9)
  EndIf
EndProcedure

; IDE Options = PureBasic 6.10 LTS (Windows - x64)
; CursorPosition = 97
; FirstLine = 67
; Folding = -
; EnableXP
; DPIAware