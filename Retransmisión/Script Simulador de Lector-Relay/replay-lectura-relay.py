#!/usr/bin/env python3
import socket
import struct
import time

SERVER_IP   = "192.168.1.41"
SERVER_PORT = 5566
SESSION_ID  = 1

def send_packet(sock, payload: bytes, session: int):

    header = struct.pack("!IB", len(payload), session)
    sock.sendall(header + payload)

def main():
    with socket.create_connection((SERVER_IP, SERVER_PORT)) as sock:
        # Primer paquete: b'\x08\x02'
        data1 = b'\x08\x02' #02 por ser el segundo dispositivo en conectar con el servidor
        send_packet(sock, data1, SESSION_ID)
        print(f"Enviado paquete 1: {data1!r}")
        
        # Pulso breve para que el servidor procese
        time.sleep(2)

        # Segundo paquete: b'\x12\"…\x83'"
        data2 = # Añadir server data tal y como lo recibe el servidor 
        send_packet(sock, data2, SESSION_ID)
        print(f"Enviado paquete 2: {data2!r}")
        
        # Esperar un poco antes de cerrar
        time.sleep(1)

if __name__ == "__main__":
    main()
