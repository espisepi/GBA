añade a mi dockerfile que se instale grit y dime el comando para ejecutarlo desde docker


==================


He actualizado [Dockerfile](/Users/joseangel/Proyectos/GBA/Dockerfile:1) para partir de `devkitpro/devkitarm:latest`, que ya incluye `grit`, y encima mantiene tu instalación de `fasmarm`. También he reconstruido la imagen `fasmarm-gba` correctamente.

Para reconstruirla tú:

```sh
docker build -t fasmarm-gba .
```

Para ejecutar el equivalente a tu `ConvertGFX.bat` desde Docker:

```sh
docker run --rm --platform linux/amd64 \
  -v "$PWD":/work \
  -w /work/Physics/2D/Acceleration/ConvertGFX \
  --entrypoint grit \
  fasmarm-gba \
  Car.png -gt -gB8 -ftb -fh!
```

Como ya tienes `ConvertGFX.sh`, también puedes lanzarlo así:

```sh
docker run --rm --platform linux/amd64 \
  -v "$PWD":/work \
  -w /work/Physics/2D/Acceleration/ConvertGFX \
  --entrypoint sh \
  fasmarm-gba \
  ./ConvertGFX.sh
```

Verifiqué que `grit` está disponible dentro de la imagen.