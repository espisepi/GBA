

creame un comando para mac (usando el docker que tengo levantado en este proyecto si es necesario) para replicar el comando del ficher ConvertGFX.bat


====================

El comando del `.bat`:

```bat
grit Car.png -gt -gB8 -ftb -fh!
```

en macOS sería, desde la raíz del proyecto:

```sh
cd Physics/2D/Acceleration/ConvertGFX
grit Car.png -gt -gB8 -ftb -fh!
```

O en una sola línea:

```sh
cd Physics/2D/Acceleration/ConvertGFX && grit Car.png -gt -gB8 -ftb -fh!
```

Si quieres ejecutarlo usando Docker montando el proyecto, sería algo así:

```sh
docker run --rm -v "$PWD":/work -w /work/Physics/2D/Acceleration/ConvertGFX <imagen-con-grit> grit Car.png -gt -gB8 -ftb -fh!
```

Pero ojo: el `Dockerfile` actual del proyecto solo instala `fasmarm`, no `grit`. Si tu contenedor ya levantado sí tiene `grit`, puedes probar:

```sh
docker exec -w /work/Physics/2D/Acceleration/ConvertGFX <nombre-contenedor> grit Car.png -gt -gB8 -ftb -fh!
```

Para ver el nombre del contenedor:

```sh
docker ps
```

Si quieres una versión portable tipo script macOS, crea `ConvertGFX.sh` al lado del `.bat` con:

```sh
#!/bin/sh
cd "$(dirname "$0")"
grit Car.png -gt -gB8 -ftb -fh!
```

y luego:

```sh
chmod +x Physics/2D/Acceleration/ConvertGFX/ConvertGFX.sh
./Physics/2D/Acceleration/ConvertGFX/ConvertGFX.sh
```