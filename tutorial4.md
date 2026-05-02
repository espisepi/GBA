dime como realizo la rotacion del cubo que se dibuja en el proyecto 3DEngine. añade la funcionalidad de rotar el cubo con las flecas arriba,abajo,izquierda,derecha de la gameboy


=======================

codex (chatgpt) response:

Hecho. La rotación del cubo se controla en el macro `Control` de [3DEngine.asm](/Users/joseangel/Proyectos/GBA/3DEngine/3DEngine.asm:28).

Cómo funciona ahora:

- Flecha arriba: decrementa `XRot`
- Flecha abajo: incrementa `XRot`
- Flecha izquierda: decrementa `YRot`
- Flecha derecha: incrementa `YRot`

Después, en cada frame, esta línea aplica la rotación a la matriz 3D:

```asm
XYZRotCalc XRot, YRot, ZRot, SinCos256
```

Es decir: los botones modifican `XRot`/`YRot`, y `XYZRotCalc` reconstruye `Matrix3D` usando la tabla `SinCos256`.

También actualicé el comentario inicial para reflejar que la cruceta rota en X/Y. Compilé la ROM con Docker/FASMARM y salió bien: `2 passes`, generando de nuevo [3DEngine.gba](/Users/joseangel/Proyectos/GBA/3DEngine/3DEngine.gba).