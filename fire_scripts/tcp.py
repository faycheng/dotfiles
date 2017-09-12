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


def tcp_con(host='localhost', port=8000):
    address = (host, port)
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.connect(address)

    try:
        while True:
            input = prompt_toolkit.prompt(u'Send:')
            s.send(input.encode('utf-8'))
            if input.decode('utf-8') == 'exit':
                break
            output = s.recv(8192)
            print('Recv:\n{}'.format(output))
    finally:
        s.close()


def tcp_server(host='127.0.0.1', port=8000):
    help_text = """Usage:

Supported Commands:
    exit    close server
    help    show help message
    $msg    echo message 
""".encode('utf-8')
    address = (host, port)
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    s.bind(address)
    s.listen(10)
    while True:
        cs, address = s.accept()
        print('Accept new client: {} {}'.format(*address))
        while True:
            data = cs.recv(2048)
            if data.decode('utf-8').rstrip('\r\n') == 'exit':
                cs.shutdown(1)
                cs.close()
                exit()
            elif data.decode('utf-8').rstrip('\r\n') == 'help':
                cs.send(help_text)

            else:
                cs.send(data)


if __name__ == '__main__':
    fire.Fire()
