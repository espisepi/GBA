

chatgpt Response:

Voy a darte un flujo Docker práctico para Mac M2: crear una imagen Linux, descargar/usar FASMARM dentro del contenedor, montar tu carpeta del repo y generar la ROM .gba para abrirla con mGBA en macOS.


Sí. Hazlo así:

1. Instala Docker Desktop en Mac

brew install --cask docker

Abre Docker Desktop una vez.

2. Clona el repo

git clone https://github.com/PeterLemon/GBA.git
cd GBA

El repo de PeterLemon/GBA está pensado para compilar con FASMARM y generar archivos .gba; luego puedes abrirlos con emuladores como mGBA.  ￼

3. Crea este Dockerfile dentro de la carpeta GBA

FROM --platform=linux/amd64 debian:bookworm
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /tools
RUN wget https://arm.flatassembler.net/FASMARM_full.ZIP -O fasmarm.zip \
    && unzip fasmarm.zip \
    && chmod +x fasmarm
WORKDIR /work
ENTRYPOINT ["/tools/fasmarm"]

FASMARM tiene versión para Linux 32/64, no para macOS directamente.  ￼

4. Construye la imagen

Desde la carpeta GBA:

docker build -t fasmarm-gba .

5. Compila un ejemplo

Busca un .asm:

find . -name "*.asm" | head

Ejemplo:

docker run --rm \
  -v "$PWD:/work" \
  fasmarm-gba \
  /work/HelloWorld/HelloWorld.asm /work/HelloWorld/HelloWorld.gba

Si esa ruta no existe, usa una de las que te salga con find.

6. Ejecuta la ROM en mGBA

Instala mGBA:

brew install --cask mgba-app

Abre la ROM:

open -a mGBA ./HelloWorld/HelloWorld.gba

Comando reutilizable cómodo

Añade un alias:

alias fasmarm='docker run --rm -v "$PWD:/work" fasmarm-gba'

Y luego compilas así:

fasmarm /work/HelloWorld/HelloWorld.asm /work/HelloWorld/HelloWorld.gba

La idea es:

Mac M2
 ├─ Docker ejecuta FASMARM Linux x86_64
 ├─ genera el .gba en tu carpeta local
 └─ mGBA en macOS abre el .gba