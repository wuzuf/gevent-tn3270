import tn3270
import gevent

class MyHandler(tn3270.RequestHandler):
    def setup(self):
        self.init_screen = "\xf5\xc3\x11\xc1\x50" + tn3270.a2e("Hello, World!")
        self.screen = "\xf5\xc3\x11\xc1\x50" + tn3270.a2e("Hello, World!")
        
    def handle(self):
        if self.request.is_connection:
            self.send(self.init_screen)
        else:
            self.send(self.screen)

server = tn3270.TN3270Server(("127.0.0.1", 8023), MyHandler)
server.start()

client = tn3270.TN3270Client("AA123456")

print client.connect(("127.0.0.1", 8023))
count = 0
for count in xrange(0, 10):
    print client.sends("Hello %d" % count)