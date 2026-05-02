


Cuando ejecuto:

docker run --rm \
  -v "$PWD:/work" \
  -w /work \
  fasmarm-gba \
  3DEngine/3DEngine.asm 3DEngine/3DEngine.gba



me aparece este error: 


joseangel@Joses-MacBook-Pro GBA % docker run --rm \
  -v "$PWD:/work" \
  -w /work \
  fasmarm-gba \
  3DEngine/3DEngine.asm 3DEngine/3DEngine.gba
WARNING: The requested image's platform (linux/amd64) does not match the detected host platform (linux/arm64/v8) and no specific platform was requested
flat assembler for ARM  version 1.44 (built on fasm 1.73.30)  (16384 kilobytes memory)
error: out of memory.


============================

chatgpt Response:

Ese error viene de FASMARM, no de Docker:

16384 kilobytes memory
error: out of memory

Está usando solo 16 MB. Dale más memoria con -m.

Prueba este comando:

docker run --rm \
  --platform linux/amd64 \
  -v "$PWD:/work" \
  -w /work \
  fasmarm-gba \
  -m 65536 \
  3DEngine/3DEngine.asm 3DEngine/3DEngine.gba

Si aún falla, sube más:

docker run --rm \
  --platform linux/amd64 \
  -v "$PWD:/work" \
  -w /work \
  fasmarm-gba \
  -m 262144 \
  3DEngine/3DEngine.asm 3DEngine/3DEngine.gba

Eso le da a FASMARM:

65536 KB = 64 MB
262144 KB = 256 MB

Luego ejecuta:

open -a mGBA 3DEngine/3DEngine.gba

El WARNING de linux/amd64 en Mac M2 es normal. Con --platform linux/amd64 simplemente lo haces explícito.


