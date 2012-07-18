#include "_tn3270_parser.h"

struct tn3270_parser 
{
    unsigned char _addr[2];
    const unsigned char* _starttxt;
    int cs;
    tn3270_parser_settings* _parser_settings;
    int stack[10];
    int top;
    int count;
    void* _context;
    const char* _start;
    const char* _end;
    const char* _position;
    unsigned char _resource_name[9];
    unsigned char _device_name[9];
    unsigned char _device_type[20];
    unsigned char _functions_list[21];
    unsigned _len;
    unsigned char* _name;
    unsigned char _hadtxt;
};

void* tn3270_parser_context(tn3270_parser* parser)
{
    return parser->_context;
}

void tn3270_parser_starttxt(tn3270_parser* parser, const unsigned char* p)
{
    parser->_starttxt = p;
}

void tn3270_parser_endtxt(tn3270_parser* parser, const unsigned char* p)
{
    if (parser->_starttxt && parser->_starttxt < p)
    {
        parser->_parser_settings->on_tn3270_text(parser, (const char*)(parser->_starttxt), p - parser->_starttxt);
        parser->_hadtxt = 1;
    }
    parser->_starttxt = 0;
}

unsigned tn3270_parser_getaddr(tn3270_parser* parser)
{
    return ((parser->_addr[0] & 0xC0) == 0x00) ? (((parser->_addr[0] & 0x3F) << 8) | parser->_addr[1]) : ((parser->_addr[0] & 0x3F) << 6) | (parser->_addr[1] & 0x3F);
}

%%{
    machine tn3270;
    alphtype unsigned char;
    access parser->;

    action error { parser->_position = p; parser->_parser_settings->on_error(parser); }

    action tn_command {parser->_parser_settings->on_tn_command(parser, fc);}
    action tn_argcommand {parser->_parser_settings->on_tn_argcommand(parser, *(p-1), fc);}

    action tn3270_command { parser->_parser_settings->on_tn3270_command(parser, fc); }
    action tn3270_aid { parser->_parser_settings->on_tn3270_aid(parser, fc); }
    action tn3270_wcc { parser->_parser_settings->on_tn3270_wcc(parser, fc); }
    action tn3270_sba { parser->_parser_settings->on_tn3270_sba(parser, tn3270_parser_getaddr(parser)); }
    action tn3270_eua { parser->_parser_settings->on_tn3270_eua(parser, tn3270_parser_getaddr(parser)); }
    action tn3270_ic { parser->_parser_settings->on_tn3270_ic(parser); }
    action tn3270_pt { parser->_parser_settings->on_tn3270_pt(parser); }
    action tn3270_sf { parser->_parser_settings->on_tn3270_sf(parser, fc); }
    action tn3270_ra { parser->_parser_settings->on_tn3270_ra(parser, tn3270_parser_getaddr(parser), fc); }
    action tn3270_sfe { parser->_parser_settings->on_tn3270_sf(parser, fc); parser->count = fc; fcall tn3270_args; }
    action tn3270_message { tn3270_parser_endtxt(parser, p); parser->_hadtxt = 0; parser->_parser_settings->on_tn3270_message(parser); }

    action tn3270_start_name {
        parser->_starttxt = p; 
    }
    action tn3270_resource_name {
        parser->_name = parser->_resource_name;
        *(parser->_name) = 0;
    }
    action tn3270_addr {
        parser->_name = parser->_addr;
        *(parser->_name) = 0;
    }
    action tn3270_device_name {
        parser->_name = parser->_device_name;
        *(parser->_name) = 0;
    }
    action tn3270_device_type {
        parser->_name = parser->_device_type;
        *(parser->_name) = 0;
    }
    action tn3270_functions_list {
        parser->_name = parser->_functions_list;
        *(parser->_name) = 0;
    }
    action tn3270_name {
        *(parser->_name++) = fc; 
    }
    
    action tn3270_name_end {
        *(parser->_name++) = 0; 
    }

    action tn3270_function_request {
        parser->_parser_settings->on_tn3270_functions_request(parser, parser->_functions_list, parser->_name - parser->_functions_list - 1);
    }
    action tn3270_function_is {
        parser->_parser_settings->on_tn3270_functions_is(parser, parser->_functions_list, parser->_name - parser->_functions_list - 1);
    }
    action tn3270_send_device_type {
        parser->_parser_settings->on_tn3270_send_device_type(parser);
    }
    action tn3270_device_type_request {
        parser->_parser_settings->on_tn3270_device_type_request(parser, parser->_device_type, parser->_device_name, parser->_resource_name);
    }
    action tn3270_device_type_is {
        parser->_parser_settings->on_tn3270_device_type_is(parser, parser->_device_type, parser->_device_name);
    }
    action tn3270_device_type_reject {
        parser->_parser_settings->on_tn3270_device_type_reject(parser, fc);
    }
    action tn3270_header {}

    action tn3270_starttxt { tn3270_parser_starttxt(parser, p); }
    action tn3270_endtxt { tn3270_parser_endtxt(parser, p); }

    action tn3270_endarg { if(!(--parser->count)) { fret; } }

    action tn_subneg { fcall tn3270_subneg; }
    action tn_subneg_end { fret; }

    ##########
    # TELNET
    ##########

    tn_iac = 0xff;
    tn_se = 240;
    tn_nop = 241;
    tn_dm = 242;
    tn_brk = 243;
    tn_ip = 244;
    tn_ao = 245;
    tn_ayt = 246;
    tn_ec = 247;
    tn_el = 248;
    tn_ga = 249;
    tn_sb = 250;
    tn_will = 251;
    tn_wont = 252;
    tn_do = 253;
    tn_dont = 254;
    tn_eor = 239;
      
    tn_command = tn_nop | tn_brk | tn_ip | tn_ao | tn_ayt | tn_ec | tn_el | tn_ga;
    tn_command_arg = tn_will | tn_wont | tn_do | tn_dont;
    tn_commmand_subneg = tn_sb;

    tn_plain_text = (^tn_iac | tn_iac tn_iac);
      
    tn_basic_command  = tn_iac tn_command @tn_command;
    tn_arg_command    = tn_iac tn_command_arg any @tn_argcommand ;
    tn_subneg_command = tn_iac tn_commmand_subneg any @tn_subneg;

    tn_iac_sequence = ( tn_basic_command | tn_arg_command | tn_subneg_command );

    ##########
    # TN3270E
    ##########

    tn3270_tn3270e             = 0x28;
    tn3270_associate           = 0x00;
    tn3270_connect             = 0x01;
    tn3270_device_type         = 0x02;
    tn3270_functions           = 0x03;
    tn3270_is                  = 0x04;
    tn3270_reason              = 0x05;
    tn3270_reject              = 0x06;
    tn3270_request             = 0x07;
    tn3270_send                = 0x08;
    tn3270_conn_partner        = 0x00;
    tn3270_device_in_use       = 0x01;
    tn3270_inv_associate       = 0x02;
    tn3270_inv_name            = 0x03;
    tn3270_inv_device_type     = 0x04;
    tn3270_type_name_error     = 0x05;
    tn3270_unknown_error       = 0x06;
    tn3270_unsupported_req     = 0x07;
    tn3270_bind_image          = 0x00;
    tn3270_data_stream_ctl     = 0x01;
    tn3270_responses           = 0x02;
    tn3270_scs_ctl_codes       = 0x03;
    tn3270_sysreq              = 0x04;

    tn3270_ascii = [A-Z0-9_\-];

    tn3270_resource_name = tn3270_ascii{1,8} >tn3270_resource_name $tn3270_name  %tn3270_name_end;
    tn3270_device_types = tn3270_ascii{1,15} >tn3270_device_type   $tn3270_name  %tn3270_name_end;
    tn3270_device_name = tn3270_ascii{1,8}   >tn3270_device_name   $tn3270_name  %tn3270_name_end;
    tn3270_reason_code = tn3270_conn_partner | tn3270_inv_associate | tn3270_inv_name | tn3270_inv_device_type | tn3270_type_name_error | tn3270_unknown_error | tn3270_unsupported_req;
    tn3270_function_list = ( tn3270_bind_image | tn3270_data_stream_ctl | tn3270_responses | tn3270_scs_ctl_codes | tn3270_sysreq ){0,20} >tn3270_functions_list  $tn3270_name  %tn3270_name_end;

    # subnegociation
    tn3270_subneg_send_device_type = tn3270_send . tn3270_device_type %tn3270_send_device_type;
    tn3270_subneg_device_type_request = tn3270_device_type . tn3270_request . tn3270_device_types . ( tn3270_connect . tn3270_resource_name | tn3270_associate . tn3270_device_name ) %tn3270_device_type_request;
    tn3270_subneg_device_type_is = tn3270_device_type . tn3270_is . tn3270_device_types . tn3270_connect . tn3270_device_name %tn3270_device_type_is;
    tn3270_subneg_device_type_reject = tn3270_device_type . tn3270_reject . tn3270_reason . tn3270_reason_code %tn3270_device_type_reject;
    tn3270_subneg_function_request = tn3270_functions . tn3270_request . tn3270_function_list %tn3270_function_request;
    tn3270_subneg_function_is = tn3270_functions . tn3270_is . tn3270_function_list %tn3270_function_is;
    tn3270_subneg_list = tn3270_subneg_send_device_type
                       | tn3270_subneg_device_type_request
                       | tn3270_subneg_device_type_is
                       | tn3270_subneg_device_type_reject
                       | tn3270_subneg_function_request
                       | tn3270_subneg_function_is;
    
    tn3270_subneg := tn3270_subneg_list . tn_iac . tn_se @tn_subneg_end;

    tn3270_arg = any.any @tn3270_endarg;
    tn3270_args := tn3270_arg+;

    tn3270_command = (0x05 | 0xf5 | 0x01 | 0xf1 | 0x7e | 0x6f | 0xf6 | 0x6e | 0xf2 | 0xf3) @tn3270_command;
    tn3270_wcc = any @tn3270_wcc;
    tn3270_aid = 0x7d @tn3270_aid;
    tn3270_addr = any{2} >tn3270_addr  $tn3270_name  %tn3270_name_end;

    # orders
    tn3270_sba = 0x11 . tn3270_addr @tn3270_sba;
    tn3270_sf = 0x1d . any @tn3270_sf;
    tn3270_ic = 0x13 @tn3270_ic;
    tn3270_eua = 0x12 . tn3270_addr @tn3270_eua;
    tn3270_pt = 0x05 @tn3270_pt;
    tn3270_sfe = 0x29 . any @tn3270_sfe;
    tn3270_ra = 0x3c . tn3270_addr . any @tn3270_ra;
        
    tn3270_order = ( tn3270_sba | tn3270_sf | tn3270_ic | tn3270_eua | tn3270_pt | tn3270_sfe | tn3270_ra ) >tn3270_endtxt %tn3270_starttxt;
    tn3270_plain_text = (any - (0x11 | 0x1d | 0x12 | 0x05 | 0x29 | 0x3c | tn_iac)) +;
    tn3270_content = (tn3270_order | tn3270_plain_text) *;
    tn3270_header = any {5} @tn3270_header;
    tn3270_data = ( ( (tn3270_command . tn3270_wcc) | (tn3270_aid . tn3270_addr) ) . tn3270_content);
    tn3270_message = tn3270_header . tn3270_data . tn_iac @tn3270_message;
    main := ( tn_iac_sequence | tn3270_message . tn_eor )*  $err(error);

}%%

%% write data;

void tn3270_parser_init( tn3270_parser *parser, tn3270_parser_settings* cb, void* context )
{
    parser->_starttxt = 0;
	parser->_hadtxt = 0;
    parser->_parser_settings = cb;
    parser->_context = context;
    %% write init;
}

void tn3270_parser_execute( tn3270_parser *parser, const unsigned char* start, unsigned length)
{
    const unsigned char *p = start;
    const unsigned char *pe = p + length;
    const unsigned char *eof = 0;
    parser->_start = start;
    parser->_end = start + length;

    %% write exec;
}

int tn3270_parser_finish( tn3270_parser *parser )
{
    if ( parser->cs == tn3270_error )
        return -1;
    if ( parser->cs >= tn3270_first_final )
        return 1;
    return 0;
}

int tn3270_parser_parse(unsigned char* start, unsigned length, tn3270_parser_settings* cb, void* context )
{
    tn3270_parser parser;
    tn3270_parser_init(&parser, cb, context);
    tn3270_parser_execute(&parser, start, length);
    return tn3270_parser_finish(&parser);
}

tn3270_parser* tn3270_parser_create(tn3270_parser_settings* cb, void* context )
{
    tn3270_parser* parser = (tn3270_parser*) malloc(sizeof(tn3270_parser));
    tn3270_parser_init(parser, cb, context);
}

void tn3270_parser_destroy(tn3270_parser *parser)
{
	free(parser);
}

void tn3270_parser_geterror( tn3270_parser *parser, tn3270_parser_error *error )
{
    error->offset = parser->_position - parser->_start;
    error->state = parser->cs;
}


void tn3270_parser_feed(tn3270_parser* parser, unsigned char* start, unsigned length)
{
	if(parser->_hadtxt) {
	    parser->_starttxt = start;
	    parser->_hadtxt = 0;
	}
	tn3270_parser_execute(parser, start, length);
	tn3270_parser_endtxt(parser, start + length);
}
