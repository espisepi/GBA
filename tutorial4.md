añade la funcionalidad de mover la camara en modo dios con todos los botones de la gameboy dentro de la escena 3d del proyecto 3DEngine


========================

Hecho. Añadí cámara libre “modo dios” en [3DEngine.asm](/Users/joseangel/Proyectos/GBA/3DEngine/3DEngine.asm:31) y recompilé [3DEngine.gba](/Users/joseangel/Proyectos/GBA/3DEngine/3DEngine.gba).

Controles nuevos:

- D-Pad izquierda/derecha: strafe lateral
- D-Pad arriba/abajo: avanzar/retroceder
- A/B: subir/bajar
- L/R: girar yaw
- Select/Start: pitch arriba/abajo

La cámara ahora tiene posición propia (`CameraX/Y/Z`) y cada frame reconstruye la matriz de vista antes de renderizar la escena 3D. Verificado con FASMARM vía Docker: compiló correctamente en 2 pasadas.