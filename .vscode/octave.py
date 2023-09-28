import subprocess
import sys
from python_print_color import *


argumentos = sys.argv[1:]

if ".m" in argumentos[0]:
    comando = ["octave"] + argumentos
    resultado = subprocess.run(comando, shell=True, text=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

    print()
    print("[DEBUG]", end=" ")
    print_color_rgb("----- OCTAVE INICIADO -----", foreground=(0, 143, 19), background=(255, 255, 255), styles=["bold"])
    print()
    print("[DEBUG] Salida de Octave:")
    print()
    print(resultado.stdout)

    # Imprime los errores, si los hubiera
    if resultado.returncode != 0:
        print("Errores:")
        print(resultado.stderr)

else:
    print()
    print_color_8bits("[DEBUG] Error: NO SE HA ENCONTRADO EL PROGRAMA A EJECUTAR", foreground="red", styles=["bold"])
    print()