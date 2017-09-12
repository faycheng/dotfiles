import sys
import fire
import socket
import prompt_toolkit


if sys.version_info[0] == 2:
    bytes = str
    str = unicode
else:
    bytes = bytes
    str = str


def udp_con(host='localhost', port=8000):
    address = (host, port)
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    s.connect(address)
    try:
        while True:
            input = prompt_toolkit.prompt(u'Send:')
            s.sendall(input.encode('utf-8'))
            if input.decode('utf-8') == 'exit':
                break
            output = s.recv(8192)
            print('Recv:\n{}'.format(output))
    finally:
        s.close()


def udp_server(host='127.0.0.1', port=8000):
    help_text = """Usage:

Supported Commands:
    exit    close server
    help    show help message
    $msg    echo message 
""".encode('utf-8')
    address = (host, port)
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    s.bind(address)
    try:
        while True:
            data, client_address = s.recvfrom(8192)
            print('Accept new client: {} {}'.format(*client_address))
            if data.decode('utf-8').rstrip('\r\n') == 'exit':
                s.close()
                exit()
            elif data.decode('utf-8').rstrip('\r\n') == 'help':
                s.sendto(help_text, client_address)

            else:
                s.sendto(data, client_address)
    finally:
        s.close()


if __name__ == '__main__':
    fire.Fire()
