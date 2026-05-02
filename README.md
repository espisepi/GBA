
Docker build on MAC OS M2:

// Comando para levantar la imagen docker con el archivo Dockerfile de este proyecto
docker build -t fasmarm-gba .


=======================

Compilar y Ejecutar proyecto/carpeta HelloWorld:

// Comando para realizar compilacion del codigo asm a gba binario
docker run --rm \
  -v "$PWD:/work" \
  -w /work \
  fasmarm-gba \
  HelloWorld/HelloWorld.asm HelloWorld/HelloWorld.gba

// Comando para ejecutar el archivo gba binario en un emulador gba (mGBA)
open -a mGBA ./HelloWorld/HelloWorld.gba

=======================

Compilar y Ejecutar proyecto/carpeta 3DEngine:

// Comando para realizar compilacion del codigo asm a gba binario
docker run --rm \
  --platform linux/amd64 \
  -v "$PWD:/work" \
  -w /work \
  fasmarm-gba \
  -m 262144 \
  3DEngine/3DEngine.asm 3DEngine/3DEngine.gba

// Comando para ejecutar el archivo gba binario en un emulador gba (mGBA)
open -a mGBA ./3DEngine/3DEngine.gba


==========================

Compilar y Ejecutar proyecto/carpeta hysics/2D/Acceleration:

// Comando para realizar compilacion del codigo asm a gba binario
docker run --rm \
  --platform linux/amd64 \
  -v "$PWD:/work" \
  -w /work \
  fasmarm-gba \
  -m 262144 \
  Physics/2D/Acceleration/Acceleration.asm Physics/2D/Acceleration/Acceleration.gba

// Comando para ejecutar el archivo gba binario en un emulador gba (mGBA)
open -a mGBA ./Physics/2D/Acceleration/Acceleration.gba


// Comando para ejecutar grit para convertir imagen png a graficos gameboy:
docker run --rm --platform linux/amd64 \
  -v "$PWD":/work \
  -w /work/Physics/2D/Acceleration/ConvertGFX \
  --entrypoint sh \
  fasmarm-gba \
  ./ConvertGFX.sh


// Comando para ejecutar grit para convertir imagen png a graficos gameboy:
docker run --rm --platform linux/amd64 \
  -v "$PWD":/work \
  -w /work/Physics/2D/Acceleration/ConvertGFX \
  --entrypoint grit \
  fasmarm-gba \
  Car.png -gt -gB8 -ftb -fh!




========================
GBA
===
<br />
Game Boy Advance Bare Metal Code by krom (Peter Lemon).<br />
<br />
All code compiles out of box with the FASMARM assembler by revolution:<br />
https://arm.flatassembler.net<br />
I have included binaries of all the demos.<br />
<br />
For more information about coding the ARM CPU please visit my webpage that I run with SimonB:<br />
https://gbadev.org<br />
https://forum.gbadev.org<br />
<br />
Howto Compile:<br />
All the code compiles into a single binary (ROMNAME.gba) file.<br />
Using FASMARM open up ROMNAME.asm & click the Run/Compile button.<br />
<br />
Howto Run:<br />
I only test with a real GBA using a flash cartridge.<br />
<br />
You can also use GBA emulators like mGBA, no$gba, higan & the MAME GBA Driver.
