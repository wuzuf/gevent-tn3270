from _tn3270_parser cimport *
from libc.string cimport memcpy, memset
from libc.stdlib cimport malloc, free
import string

e2a = " \x01\x02\x03\x9c\t\x86\x7f\x97\x8d\x8e\x0b\x0c\r\x0e\x0f\x10\x11\x12\x13\x9d\x85\x08\x87\x18\x19\x92\x8f\x1c\x1d\x1e\x1f\x80\x81\x82\x83\x84\n\x17\x1b\x88\x89\x8a\x8b\x8c\x05\x06\x07\x90\x91\x16\x93\x94\x95\x96\x04\x98\x99\x9a\x9b\x14\x15\x9e\x1a \xa0\xa1\xa2\xa3\xa4\xa5\xa6\xa7\xa8[.<(+!&\xa9\xaa\xab\xac\xad\xae\xaf\xb0\xb1]$*);^-/\xb2\xb3\xb4\xb5\xb6\xb7\xb8\xb9|,%_>?\xba\xbb\xbc\xbd\xbe\xbf\xc0\xc1\xc2`:#@\'=\"\xc3abcdefghi\xc4\xc5\xc6\xc7\xc8\xc9\xcajklmnopqr\xcb\xcc\xcd\xce\xcf\xd0\xd1~stuvwxyz\xd2\xd3\xd4\xd5\xd6\xd7\xd8\xd9\xda\xdb\xdc\xdd\xde\xdf\xe0\xe1\xe2\xe3\xe4\xe5\xe6\xe7{ABCDEFGHI\xe8\xe9\xea\xeb\xec\xed}JKLMNOPQR\xee\xef\xf0\xf1\xf2\xf3\\\x9fSTUVWXYZ\xf4\xf5\xf6\xf7\xf8\xf90123456789\xfa\xfb\xfc\xfd\xfe\xff"
a2e = " \x01\x02\x037-./\x16\x05%\x0b\x0c\r\x0e\x0f\x10\x11\x12\x13<=2&\x18\x19?\'\x1c\x1d\x1e\x1f@O\x7f{[lP}M]\\Nk`Ka\xf0\xf1\xf2\xf3\xf4\xf5\xf6\xf7\xf8\xf9z^L~no|\xc1\xc2\xc3\xc4\xc5\xc6\xc7\xc8\xc9\xd1\xd2\xd3\xd4\xd5\xd6\xd7\xd8\xd9\xe2\xe3\xe4\xe5\xe6\xe7\xe8\xe9J\xe0Z_my\x81\x82\x83\x84\x85\x86\x87\x88\x89\x91\x92\x93\x94\x95\x96\x97\x98\x99\xa2\xa3\xa4\xa5\xa6\xa7\xa8\xa9\xc0j\xd0\xa1\x07 !\"#$\x15\x06\x17()*+,\t\n\x1b01\x1a3456\x0889:;\x04\x14>\xe1ABCDEFGHIQRSTUVWXYbcdefghipqrstuvwx\x80\x8a\x8b\x8c\x8d\x8e\x8f\x90\x9a\x9b\x9c\x9d\x9e\x9f\xa0\xaa\xab\xac\xad\xae\xaf\xb0\xb1\xb2\xb3\xb4\xb5\xb6\xb7\xb8\xb9\xba\xbb\xbc\xbd\xbe\xbf\xca\xcb\xcc\xcd\xce\xcf\xda\xdb\xdc\xdd\xde\xdf\xea\xeb\xec\xed\xee\xef\xfa\xfb\xfc\xfd\xfe\xff"

cdef bint _on_tn_command(tn3270_parser* parser, unsigned char c1):
    p = tn3270_parser_context(parser)
    return (<object>p).on_tn_command(c1)

cdef bint _on_tn_argcommand(tn3270_parser* parser, unsigned char c1, unsigned char c2):
    p = tn3270_parser_context(parser)
    return (<object>p).on_tn_command(c1, c2)

cdef bint _on_tn3270_command(tn3270_parser* parser, unsigned char c):
    p = tn3270_parser_context(parser)
    return (<object>p).on_tn3270_command(c)
        
cdef bint _on_tn3270_aid(tn3270_parser* parser, unsigned char c):
    p = tn3270_parser_context(parser)
    return (<object>p).on_tn3270_aid(c)
        
cdef bint _on_tn3270_wcc(tn3270_parser* parser, unsigned char c):
    p = tn3270_parser_context(parser)
    return (<object>p).on_tn3270_wcc(c)
        
cdef bint _on_tn3270_sf(tn3270_parser* parser, unsigned char c):
    p = tn3270_parser_context(parser)
    return (<object>p).on_tn3270_sf(c)
        
cdef bint _on_tn3270_ic(tn3270_parser* parser):
    p = tn3270_parser_context(parser)
    return (<object>p).on_tn3270_ic()
        
cdef bint _on_tn3270_pt(tn3270_parser* parser):
    p = tn3270_parser_context(parser)
    return (<object>p).on_tn3270_pt()
        
cdef bint _on_tn3270_sba(tn3270_parser* parser, unsigned addr):
    p = tn3270_parser_context(parser)
    return (<object>p).on_tn3270_sba(addr)
        
cdef bint _on_tn3270_eua(tn3270_parser* parser, unsigned addr):
    p = tn3270_parser_context(parser)
    return (<object>p).on_tn3270_eua(addr)
        
cdef bint _on_tn3270_ra(tn3270_parser* parser, unsigned addr, unsigned char c):
    p = tn3270_parser_context(parser)
    return (<object>p).on_tn3270_ra(addr, c)
    
cdef bint _on_tn3270_text(tn3270_parser* parser, unsigned char* s, unsigned l):
    p = tn3270_parser_context(parser)
    return (<object>p).on_tn3270_text(s[:l])
    
cdef bint _on_tn3270_device_type_is(tn3270_parser* parser, unsigned char* type, unsigned char* name):
    p = tn3270_parser_context(parser)
    return (<object>p).on_tn3270_device_type_is(type, name)
    
cdef bint _on_tn3270_device_type_request(tn3270_parser* parser, unsigned char* type, unsigned char* device_name, unsigned char* resource_name):
    p = tn3270_parser_context(parser)
    return (<object>p).on_tn3270_device_type_request(type, device_name, resource_name)
    
cdef bint _on_tn3270_functions_request(tn3270_parser* parser, unsigned char* functions, unsigned len):
    p = tn3270_parser_context(parser)
    return (<object>p).on_tn3270_functions_request(functions[:len])
    
cdef bint _on_tn3270_functions_is(tn3270_parser* parser, unsigned char* functions, unsigned len):
    p = tn3270_parser_context(parser)
    return (<object>p).on_tn3270_functions_is(functions[:len])

cdef bint _on_tn3270_device_type_reject(tn3270_parser* parser, unsigned char c):
    p = tn3270_parser_context(parser)
    return (<object>p).on_tn3270_device_type_reject(c)
    
cdef bint _on_tn3270_send_device_type(tn3270_parser* parser):
    p = tn3270_parser_context(parser)
    return (<object>p).on_tn3270_send_device_type()
    
cdef bint _on_tn3270_message(tn3270_parser* parser):
    p = tn3270_parser_context(parser)
    return (<object>p).on_tn3270_message()

cdef bint _on_error(tn3270_parser* parser):
    p = tn3270_parser_context(parser)
    cdef tn3270_parser_error error
    tn3270_parser_geterror(parser, &error)
    return (<object>p).on_error(<object>error)

cdef class IAnalyser:
    cdef tn3270_parser_settings settings
    cdef tn3270_parser* parser
    
    def __cinit__(self):
        self.settings.on_tn_command     = _on_tn_command
        self.settings.on_tn_argcommand  = _on_tn_argcommand
        self.settings.on_tn3270_command = _on_tn3270_command
        self.settings.on_tn3270_aid     = _on_tn3270_aid
        self.settings.on_tn3270_wcc     = _on_tn3270_wcc
        self.settings.on_tn3270_sf      = _on_tn3270_sf
        self.settings.on_tn3270_ic      = _on_tn3270_ic
        self.settings.on_tn3270_pt      = _on_tn3270_pt
        self.settings.on_tn3270_sba     = _on_tn3270_sba
        self.settings.on_tn3270_eua     = _on_tn3270_eua
        self.settings.on_tn3270_ra      = _on_tn3270_ra
        self.settings.on_tn3270_text    = _on_tn3270_text
        self.settings.on_tn3270_device_type_is = _on_tn3270_device_type_is
        self.settings.on_tn3270_send_device_type = _on_tn3270_send_device_type
    
        self.settings.on_tn3270_device_type_request = _on_tn3270_device_type_request
        self.settings.on_tn3270_functions_request = _on_tn3270_functions_request
        self.settings.on_tn3270_functions_is = _on_tn3270_functions_is
        self.settings.on_tn3270_device_type_reject = _on_tn3270_device_type_reject
        self.settings.on_error          = _on_error
        self.settings.on_tn3270_message      = _on_tn3270_message
        
        self.parser                     = tn3270_parser_create(&self.settings, <void*>self);
        
    def __deallocate__(self):
        tn3270_parser_destroy(self.parser)
        
    def feed(self, buffer):
        tn3270_parser_feed(self.parser, buffer, len(buffer))
        
    def parse(self, buffer):
        return tn3270_parser_parse(buffer, len(buffer), &self.settings, <void*>self)

cdef class VerboseParser(IAnalyser):
    def on_tn_command(self, command, arg = None):
        if arg:
            print "TN COMMAND: 0x%02x (0x%02x)" % (command, arg)
        else:
            print "TN COMMAND: 0x%02x" % command

    def on_tn3270_device_type_is(self, type, name):
        print "DEVICE TYPE IS: %s - %s" % (type, name)

    def on_tn3270_device_type_request(self, type, device_name, resource_name):
        print "DEVICE TYPE REQUEST: %s - %s - %s" % (type, device_name, resource_name)

    def on_tn3270_command(self, c):
        print "COMMAND: 0x%02x" % c
        
    def on_tn3270_aid(self, c):
        print "AID: 0x%02x" % c
        
    def on_tn3270_wcc(self, c):
        print "WCC: 0x%02x" % c
        
    def on_tn3270_sf(self, c):
        print "SF: 0x%02x" % c
        
    def on_tn3270_ic(self):
        print "IC"
        
    def on_tn3270_pt(self):
        print "PT"
        
    def on_tn3270_sba(self, addr):
        print "SBA: %d" % addr
        
    def on_tn3270_eua(self, addr):
        print "EUA: 0x%02x" % addr
        
    def on_tn3270_ra(self, addr, c):
        print "RA: 0x%02x - 0x%02x" % (addr, c)
        
    def on_tn3270_text(self, s):
        print "TXT (%d): %s - %s" % (len(s), repr(s), string.translate(s, e2a))

    def on_tn3270_send_device_type(self):
        print "DEVICE SEND REQUEST"

    def on_tn3270_functions_request(self, functions):
        print "FUNCTIONS REQUEST: %s" % repr(functions)

    def on_tn3270_functions_is(self, functions):
        print "FUNCTIONS IS: %s" % repr(functions)

    def on_error(self, error):
        print "ERROR: %s" % error['offset']


cdef class VirtualScreenParser(IAnalyser):
    cdef char * _screen
    cdef int _rows
    cdef int _cols
    cdef int _bufferPos
    cdef int _cursorPos
    
    def __init__(self, rows = 24, cols = 80):
        self._screen = <char*>malloc(rows * cols * sizeof(char))
        self._rows = rows
        self._cols = cols
        memset(self._screen, 0, rows * cols)
        
    def __dealloc__(self):
        free(self._screen)
        
    def on_tn3270_command(self, c):
        if c == 0x05 or c == 0xf5:
            memset(self._screen, 0, self._rows * self._cols)
        
    def on_tn3270_wcc(self, c):
        pass
        
    def on_tn3270_aid(self, c):
        pass

    def on_tn3270_sba(self, addr):
        self._bufferPos = addr
        
    def on_tn3270_ic(self):
        self._cursorPos = self._bufferPos
        
    def on_tn3270_pt(self):
        for i in xrange(0, self._rows * self._cols):
             if self._screen[(self._bufferPos + i) % (self._rows * self._cols)] == '`':
                break
             self._screen[(self._bufferPos + i) % (self._rows * self._cols)] = '\x00'
        if(i != self._rows * self._cols):
            self._bufferPos = (self._bufferPos + i) % (self._rows * self._cols) + 1
            
    def on_tn3270_eua(self, addr):
        while self._bufferPos != addr:
            if self._screen[self._bufferPos] != '`':
                self._screen[self._bufferPos] = '\x00'
            self._bufferPos = (self._bufferPos + 1) % (self._rows * self._cols)
        
    def on_tn3270_ra(self, addr, c):
        if(addr > self._bufferPos) :
            memset(self._screen + self._bufferPos, c, addr - self._bufferPos)
        else:
            memset(self._screen + self._bufferPos, c, self._rows * self._cols - self._bufferPos)
            memset(self._screen, c, addr)
        self._bufferPos = addr
        
    def on_tn3270_sf(self, param):
        self._screen[self._bufferPos] = '`'
        self._bufferPos += 1

    def on_tn3270_text(self, txt):
        txt = string.translate(txt, e2a)
        if self._rows*self._cols - self._bufferPos < len(txt):
            d = self._rows*self._cols - self._bufferPos
            memcpy(self._screen + self._bufferPos, <char*>txt, d)
            memcpy(self._screen, (<char*>txt) + <int>d, len(txt) - d)
        else:
            memcpy(self._screen + self._bufferPos, <char*>txt, len(txt))
        self._bufferPos = (self._bufferPos + len(txt)) % (self._rows*self._cols)
        
    def get_screen(self):
        res = []
        for i in xrange(self._rows):
            res.append(self._screen[i * self._cols : self._cols + i * self._cols].replace('\x00', ' '))
        return '\n'.join(res)
