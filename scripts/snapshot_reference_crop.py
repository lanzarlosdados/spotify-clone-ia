#!/usr/bin/env python3
"""
Prepara un screenshot real (foto de la app de Spotify) para usarlo como
referencia de snapshot testing, haciendo que coincida en píxeles EXACTOS
con el placeholder que generó swift-snapshot-testing en su primera corrida.

Flujo:
1. Escribís la vista SwiftUI + el snapshot test (assertSnapshot con `named:`).
2. Corrés el test una vez: no hay referencia todavía, la librería genera un
   placeholder en __Snapshots__/ con el tamaño exacto (en píxeles) que va a
   comparar en las próximas corridas.
3. Corrés este script pasándole ese placeholder + tu screenshot real de
   Spotify -> te devuelve una imagen recortada/escalada al mismo tamaño.
4. Reemplazás el placeholder en __Snapshots__/ por el archivo que generó
   este script (mismo nombre de archivo).
5. Corrés el test de nuevo: ahora compara tu código contra la app real.

Uso:
    python3 snapshot_reference_crop.py <placeholder.png> <screenshot_real.png> <salida.png> \
        [--top-crop PX] [--bottom-crop PX]

--top-crop / --bottom-crop: píxeles a recortar del screenshot real antes de
    escalar (status bar/notch arriba, home indicator abajo), si la vista que
    estás testeando no incluye esa zona.

Requiere Pillow: pip3 install pillow
"""
import argparse
from PIL import Image


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("placeholder", help="PNG generado por swift-snapshot-testing en la primera corrida")
    parser.add_argument("screenshot", help="Screenshot real de la app de Spotify")
    parser.add_argument("output", help="Ruta de salida (usar el mismo nombre que el placeholder al reemplazarlo)")
    parser.add_argument("--top-crop", type=int, default=0, help="Píxeles a recortar arriba (status bar/notch)")
    parser.add_argument("--bottom-crop", type=int, default=0, help="Píxeles a recortar abajo (home indicator)")
    args = parser.parse_args()

    with Image.open(args.placeholder) as ph:
        target_w, target_h = ph.size

    with Image.open(args.screenshot) as shot:
        shot = shot.convert("RGB")
        w, h = shot.size
        if args.top_crop or args.bottom_crop:
            shot = shot.crop((0, args.top_crop, w, h - args.bottom_crop))
        resized = shot.resize((target_w, target_h), Image.LANCZOS)
        resized.save(args.output)

    print(f"OK -> {args.output} ({target_w}x{target_h}px, igual al placeholder)")


if __name__ == "__main__":
    main()
