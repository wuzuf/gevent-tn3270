import tn3270._parser

from gevent import socket
import gevent.queue
import gevent.pool
import gevent.server
import gevent.event
import logging

logger = logging.getLogger(__name__)

class TN3270Server:
    def __init__(self, address, handler):
        self.address = address
        self._handlerclass = handler
        self._group = gevent.pool.Group()

    def handle(self, socket, address):
        self._handlerclass(self, socket, address)
            
    def join(self):
        self._group.join()
            
    def start(self):
        server = gevent.server.StreamServer(self.address, self.handle) # creates a new server
        server.start() # start accepting new connections
        
class Request:
    is_connection = False
    aid = 0

class RequestHandler(tn3270._parser.VerboseParser):
    def __init__(self, server, socket, address):
        self.server = server
        self.client_address = address
        self._recv_queue = gevent.queue.Queue()
        self._send_queue = gevent.queue.Queue()
        
        self.request = Request()
        
        logger.info("Accepting new connection from %s:%d" % address)
        self.server._group.spawn(self._send_loop, socket)
        self.server._group.spawn(self._recv_loop, socket)
        self._send("\xFF\xFD\x28")
        
        self.setup()
    
    def setup(self):
        pass
    
    def finish(self):
        pass
    
    def handle(self):
        pass
    
    def send(self, buffer):
        self._send("\x00\x00\x00\x00\x00" + buffer + "\xff\xef")
    
    # TN3270 handling functions
    def on_tn_command(self, command, arg = None):
        if command == 0xfb and arg == 0x28: # WILL TN3270
            self._send("\xff\xfa\x28\x08\x02\xff\xf0") # SEND DEVICE TYPE
            
    def on_tn3270_device_type_request(self, device_type, device_name, resource_name):
        self.device_type = device_type
        self.resource_name = resource_name
        self._send("".join(["\xff\xfa\x28\x02\x04", device_type, "\x01", resource_name, "\xff\xf0"]))
            
    def on_tn3270_functions_request(self, functions):
        self._send("\xff\xfa\x28\x03\x07\xff\xf0")
            
    def on_tn3270_functions_is(self, functions):
        self.request.is_connection = True
        self.handle()
        self.request = Request()
        
    def on_tn3270_message(self):
        self.handle()
        self.request = Request()
        
    def on_tn3270_aid(self, aid):
        self.request.aid = aid
    
    def on_tn3270_sba(self, addr):
        pass
    
    def on_tn3270_text(self, txt):
        pass
        
    def _send(self, buffer):
        self._send_queue.put(buffer)
        
    def _recv_loop(self, socket):
        while True:
            data = socket.recv(2048)
            if not data:
                logger.info("Connection from %s:%d disconnected" % self.client_address)
                self._send_queue.put(self)
                break
            self.feed(data)
            

    def _send_loop(self, socket):
        while True:
            message = self._send_queue.get()
            if message is self:
                self.finish()
                break
            socket.sendall(message)
