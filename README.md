# Arrastreitor 2mil
Programa experimentalaaaa escrito en lenguaje PureBasic para intentar aumentar mi productividad.

He creado esta estructura de un ejecutable para poder disponer en mi trabajo de muchos recursos que uso continuamente en hojas de cálculo, correos electrónicos, calculadora, etc. Así mismo; creo que podría combinarlo con futuros programas, todo con idea de ahorrar tiempo en tareas cotidianas.

# Estructura del proyecto:
Proyecto/
│
├── Principal.pb
│   ├── Declaraciones.pb
│   ├── MostrarAyuda.pb
│   ├── ManejoCeldas.pb
│   ├── GestionArchivos.pb
│   ├── Calculador.pb
│   └── LanzarExe.pb
│
├── Recursos/
│   ├── arrastra.ico
│   ├── Recientes.tpb
│   └── ...
│
└── Documentacion/
    ├── README.md
    ├── Licencia.txt
    └── ...
# Archivos del proyecto

> Principal.pb
Archivo principal del proyecto que incluye otros archivos necesarios y define procedimientos clave para la funcionalidad del programa.
> Declaraciones.pb
Declaraciones y enumeraciones de constantes y variables globales utilizadas en todo el proyecto.
> MostrarAyuda.pb
Procedimientos para la inicialización y navegación de los textos de ayuda del programa. Se definen pequeños consejos. 
> ManejoCeldas.pb
Procedimientos para crear y manejar paneles y celdas, incluyendo la inicialización, edición y restauración de colores.
> GestionArchivos.pb
Procedimientos para la gestión de archivos, incluyendo carga, guarda y manejo de archivos recientes.
> Calculador.pb
Procedimientos relacionados con la calculadora, incluyendo la realización de operaciones aritméticas y manejo de eventos de la calculadora.
> LanzarExe.pb
Procedimientos para lanzar programas externos con parámetros extraídos de texto (Está basado en un proyecto anterior, también publicado en mi github).


