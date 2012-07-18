#include <string.h>

typedef struct tn3270_parser tn3270_parser;
typedef struct tn3270_parser_error tn3270_parser_error;
typedef struct tn3270_parser_settings tn3270_parser_settings;

typedef int (*tn_cb) (tn3270_parser*);
typedef int (*tn_char_cb) (tn3270_parser*, unsigned char);
typedef int (*tn_char_char_cb) (tn3270_parser*, unsigned char, unsigned char);

typedef int (*tn3270_str_str_cb) (tn3270_parser*, unsigned char*, unsigned char*);
typedef int (*tn3270_str_str_str_cb) (tn3270_parser*, unsigned char*, unsigned char*, unsigned char*);
typedef int (*tn3270_char_cb) (tn3270_parser*, unsigned char);
typedef int (*tn3270_addr_cb) (tn3270_parser*, unsigned);
typedef int (*tn3270_addr_char_cb) (tn3270_parser*, unsigned, unsigned char);
typedef int (*tn3270_cb) (tn3270_parser*);
typedef int (*tn3270_str_cb) (tn3270_parser*, const char*);
typedef int (*tn3270_str_len_cb) (tn3270_parser*, const char*, unsigned);

struct tn3270_parser_settings
{
  
  tn_char_cb             on_tn_command;
  tn_char_char_cb        on_tn_argcommand;

  tn3270_str_str_cb      on_tn3270_device_type_is;
  tn3270_str_str_str_cb  on_tn3270_device_type_request;
  tn3270_str_len_cb      on_tn3270_functions_request;
  tn3270_str_len_cb      on_tn3270_functions_is;
  tn3270_cb              on_tn3270_send_device_type;
  tn3270_char_cb         on_tn3270_device_type_reject;

  tn3270_char_cb         on_tn3270_command;
  tn3270_char_cb         on_tn3270_aid;
  tn3270_char_cb         on_tn3270_wcc;
  tn3270_addr_cb         on_tn3270_sba;
  tn3270_cb              on_tn3270_ic;
  tn3270_cb              on_tn3270_pt;
  tn3270_addr_cb         on_tn3270_eua;
  tn3270_addr_char_cb    on_tn3270_ra;
  tn3270_char_cb         on_tn3270_sf;
  tn3270_str_len_cb      on_tn3270_text;
  tn3270_cb              on_tn3270_message;

  tn3270_cb              on_error;

};

struct tn3270_parser_error
{
    unsigned offset;
    unsigned state;
};

int tn3270_parser_parse(unsigned char* start, unsigned length, tn3270_parser_settings* cb, void* context );
void* tn3270_parser_context(tn3270_parser* parser);
void tn3270_parser_geterror(tn3270_parser* parser, tn3270_parser_error* error);
