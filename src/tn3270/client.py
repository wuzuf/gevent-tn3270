import tn3270._parser
import string

from gevent import socket
import gevent.queue
import gevent.pool
import logging

logger = logging.getLogger(__name__)
        
class TN3270Client(tn3270._parser.VirtualScreenParser):
    def __init__(self, luname, device_type = "IBM-3278-2-E"):
        tn3270._parser.VirtualScreenParser.__init__(self, 24, 80)
        self.luname = luname
        self.device_type = device_type
        self._recv_queue = gevent.queue.Queue()
        self._send_queue = gevent.queue.Queue()
        self._group = gevent.pool.Group()
        self._parser = self
        
    def connect(self, address):
        logger.info('connecting to %r...' % (address,))
        self._socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self._socket.connect(address)
        self._group.spawn(self._send_loop)
        self._group.spawn(self._recv_loop)
        return self._recv_queue.get()
        
    def _recv_loop(self):
        while True:
            data = self._socket.recv(2048)
            if not data:
                logger.info('disconnected')
                break
            self._parser.feed(data)

    def _send_loop(self):
        while True:
            data = self._send_queue.get()
            self._socket.sendall(data)
            
    def join(self):
        self._group.join()
        
    def _send(self, buffer):
        self._send_queue.put(buffer)
        
    def sends(self, str, cursor_pos=None):
        return self.send("".join(["\x7d", "\xc1\x50\x11\xc1\x50", string.translate(str, tn3270._parser.a2e)]))
        
    def send(self, buffer):
        self._send("".join(["\x00\x00\x00\x00\x00", buffer, "\xff\xef"]))
        return self._recv_queue.get()
        
    def on_tn_command(self, command, arg = None):
        if command == 0xfd and arg == 0x28: # DO TN3270
            self._send("\xff\xfb\x28") # WILL TN3270
            
    def on_tn3270_send_device_type(self):
        self._send(''.join(["\xff\xfa\x28\x02\x07", self.device_type, "\x01", self.luname,"\xff\xf0"]))
            
    def on_tn3270_device_type_is(self, device_type, luname):
        self.device_type = device_type
        self.luname = luname
        self._send("\xff\xfa\x28\x03\x07\x00\x02\x04\xff\xf0")
            
    def on_tn3270_functions_request(self, functions):
        self.functions = functions
        self._send(''.join(["\xff\xfa\x28\x03\x04", functions, "\xff\xf0"]))
        
    def on_tn3270_message(self):
        self._recv_queue.put(self.get_screen())
