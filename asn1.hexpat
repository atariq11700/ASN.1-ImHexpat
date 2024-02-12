#include <std/io.pat>
#include <std/string.pat>
#include <std/mem.pat>
#include <std/math.pat>

struct INTEGER<auto size>
    {
    match ( size )
        {
        ( 1 ):       u8 value;
        ( 2 ):    be u16 value;
        ( 3 ):    be u24 value;
        ( 4 ):    be u32 value;
        ( 6 ):    be u48 value;
        ( 12 ):   be u96 value;
        ( 16 ):   be u128 value;
        ( _ ):       u8 value[ size ];
        }
    } [[ format( "format_INTEGER" ) ]];

fn calc_max_digits_for_n_byte_int( auto size )
    {
    // ( int )( Math.Log( 2, 10 ) * 0x80000 )
    return ( size * 0x00026882 + 0xFFFF ) >> 16;
    };

fn format_INTEGER( INTEGER<0> integer )
    {
    auto size = sizeof( integer );
    match ( size )
        {
        ( 0 ): return std::format("{:d}", integer.value);
        ( 1 ): return std::format("{:d}", integer.value);
        ( 2 ): return std::format("{:d}", integer.value);
        ( 3 ): return std::format("{:d}", integer.value);
        ( 4 ): return std::format("{:d}", integer.value);
        ( 6 ): return std::format("{:d}", integer.value);
        ( 12 ): return std::format("{:d}", integer.value);
        ( 16 ): return std::format("{:d}", integer.value);

        ( _ ):
            {
            u8 digits[ calc_max_digits_for_n_byte_int( size ) ];
            u64 length = 1;

            for ( u64 i = 0, i < size, i += 1 )
                {

                u64 j;
                u64 carry = data.value[ i ];

                for ( j = 0, j < length || carry != 0, j += 1 )
                    {
                    u64 value = digits[ j ] * 256 + carry;
                    carry = std::math::floor( value / 10 );
                    value = value % 10;
                    digits[ j ] = u8( value );
                    }

                if ( j > length )
                    {
                    length = j;
                    }
                }

            str ret;
            while ( 0 != length )
                {
                length -= 1;
                ret += char( '0' + digits[ length ] );
                }
            return ret;
            }
        }
    };

struct BIT_STRING<auto size>
    {
    match ( size )
        {
        ( 1 ):       u8 value;
        ( 2 ):    be u16 value;
        ( 3 ):    be u24 value;
        ( 4 ):    be u32 value;
        ( 6 ):    be u48 value;
        ( 12 ):   be u96 value;
        ( 16 ):   be u128 value;
        ( _ ):       u8 value[ size ];
        }
    } [[ format( "format_BIT_STRING" ) ]];

fn format_BIT_STRING( BIT_STRING<0> bit_string )
    {

    };

enum tag_op_type : u8
    {
    END_OF_CONTENT      = 0,
    BOOLEAN,
    INTEGER,
    BIT_STRING,
    OCTET_STRING,
    NULL,
    OBJECT_IDENTIFIER,
    OBJECT_DESCRIPTOR,
    EXTERNAL,
    REAL_FLOAT,
    ENUMERATED,
    EMBDEDDED_PDV,
    UTF8String,
    SEQUENCE            = 16,
    SET,
    PrintableString     = 19,
    IA5String           = 22,
    UTCTime,
    GeneralizedTime
    } [[ format( "format_tag_op_type" ) ]];

fn format_tag_op_type( tag_op_type op )
    {
    match ( op )
        {
        ( tag_op_type::END_OF_CONTENT ):     return "END_OF_CONTENT";
        ( tag_op_type::BOOLEAN ) :           return "BOOLEAN";
        ( tag_op_type::INTEGER ):            return "INTEGER";
        ( tag_op_type::BIT_STRING ):         return "BIT_STRING";
        ( tag_op_type::OCTET_STRING ):       return "OCTET_STRING";
        ( tag_op_type::NULL ):               return "NULL";
        ( tag_op_type::OBJECT_IDENTIFIER ):  return "OBJECT_IDENTIFIER";
        ( tag_op_type::OBJECT_DESCRIPTOR ):  return "OBJECT_DESCRIPTOR";
        ( tag_op_type::EXTERNAL ):           return "EXTERNAL";
        ( tag_op_type::REAL_FLOAT ):         return "REAL_FLOAT";
        ( tag_op_type::ENUMERATED ):         return "ENUMERATED";
        ( tag_op_type::EMBDEDDED_PDV ):      return "EMBDEDDED_PDV";
        ( tag_op_type::UTF8String ):         return "UTF8String";
        ( tag_op_type::SEQUENCE ):           return "SEQUENCE";
        ( tag_op_type::SET ):                return "SET";
        ( tag_op_type::PrintableString ):    return "PrintableString";
        ( tag_op_type::IA5String ):          return "IA5String";
        ( tag_op_type::UTCTime ):            return "UTCTime";
        ( tag_op_type::GeneralizedTime ):    return "GeneralizedTime";
        }
    };

enum tag_constr_type : u8
    {
    Primitive    = 0,
    Constructed  = 1
    };

fn format_tag_constr_type( tag_constr_type constr )
    {
    match ( constr )
        {
        ( tag_constr_type::Primitive ):     return "Primitive";
        ( tag_constr_type::Constructed ):   return "Constructed";
        }
    };

enum tag_class_type : u8
    {
    Universal           = 0b00,
    Application         = 0b01,
    Context_specific    = 0b10,
    Private             = 0b11
    };

fn format_tag_class_type( tag_class_type class )
    {
    match ( class )
        {
        ( tag_class_type::Universal ):          return "Universal";
        ( tag_class_type::Application ) :       return "Application";
        ( tag_class_type::Context_specific ):   return "Context_specific";
        ( tag_class_type::Private ):            return "Private";
        }
    };

bitfield tag_type
    {
    tag_op_type op: 5;
    tag_constr_type construction: 1;
    tag_class_type class: 2;
    } [[format("format_tag_type")]];

fn format_tag_type( tag_type tag )
    {
    match ( tag.class )
        {
        ( tag_class_type::Context_specific ):
            {
            return std::format
                    (
                    "{:d} {:s} {:s}",
                    tag.op ,
                    format_tag_constr_type( tag.construction ),
                    format_tag_class_type( tag.class )
                    );
            }
        ( tag_class_type::Universal ):
            {
            return std::format
                    (
                    "{:s} {:s} {:s}",
                    format_tag_op_type( tag.op ) ,
                    format_tag_constr_type( tag.construction ),
                    format_tag_class_type( tag.class )
                    );
            }
        }
    };

#define LENGTH_MASK 0b10000000
#define LENGTH_BYTES_SIZE_MASK ( ~LENGTH_MASK )

enum length_format_type : u8
    {
    LENGTH_SHORT = 0b0,
    LENGTH_LONG = 0b1
    } [[ format( "format_length_format_type" ) ]];

fn format_length_format_type( length_format_type len_fmt )
    {
    match ( len_fmt )
        {
        ( length_format_type::LENGTH_SHORT ):   return "LENGTH_SHORT";
        ( length_format_type::LENGTH_LONG ):    return "LENGTH_LONG";
        }
    };

bitfield long_length_meta_type
    {
    unsigned length_bytes: 7;
    length_format_type fmt: 1;
    } [[format("format_long_length_meta_type")]];

fn format_long_length_meta_type( long_length_meta_type long_len_meta )
    {
    return std::format
            (
            "{:s}|{:d}",
            format_length_format_type( long_len_meta.fmt ),
            long_len_meta.length_bytes
            );
    };

bitfield short_length_meta_type
    {
    padding: 7;
    length_format_type fmt: 1;
    } [[ format("format_short_length_meta_type" ) ]];

fn format_short_length_meta_type( short_length_meta_type short_len_meta )
    {
    return std::format
            (
            "{:s}",
            format_length_format_type( short_len_meta.fmt )
            );
    };

union single_byte_length_type
    {
    short_length_meta_type meta;
    u8 length;
    } [[ format( "format_single_byte_length_type" ) ]];

fn format_single_byte_length_type( single_byte_length_type len )
    {
    return std::format
            (
            "{:s} Len: {:d}",
            format_short_length_meta_type( len.meta ),
            len.length
            );
    };

struct multi_byte_length_type
    {

    long_length_meta_type meta;
    match ( $[ addressof( this ) ] & LENGTH_BYTES_SIZE_MASK )
        {
        ( 1 ):       u8 length;
        ( 2 ):    be u16 length;
        ( 3 ):    be u24 length;
        ( 4 ):    be u32 length;
        ( 6 ):    be u48 length;
        ( 12 ):   be u96 length;
        ( 16 ):   be u128 length;
        ( _ ):
            {
            std::print( "{:x}", $ );
            u8 length[ $[ addressof( this ) ] & LENGTH_BYTES_SIZE_MASK ];
            }
        }
     } [[ format( "format_multi_byte_length_type" ) ]];

fn format_multi_byte_length_type( multi_byte_length_type len )
    {
    return std::format
            (
            "{:s} Len: {:d}",
            format_long_length_meta_type( len.meta ),
            len.length
            );
    };

struct oid_type<auto size>
    {
    u8 value[ size ];
    } [[ format( "format_oid_type" ) ]];

#define OID_FIRST_NODE_MASK 40
#define OID_NODE_FMT_MASK 0b10000000
#define OID_NODE_FMT_LONG 0b10000000
#define OID_NODE_FMT_SHORT 0b00000000

fn format_oid_type( oid_type<0> oid )
    {
    auto size = sizeof( oid );
    str ret;

    if ( size == 0 )
        {
        return "NULL OID";
        }

    ret += std::format( "{:d}.{:d}", u8( std::math::floor( oid.value[ 0 ] / OID_FIRST_NODE_MASK ) ), oid.value[ 0 ] % OID_FIRST_NODE_MASK );

    bool parsing_long = false;
    u64 start_idx = 0;
    u64 end_idx = 0;
    for ( u64 i = 1, i < size, i += 1 )
        {
        if ( oid.value[ i ] & OID_NODE_FMT_MASK == OID_NODE_FMT_SHORT )
            {
            if ( !parsing_long )
                {
                ret += std::format( ".{:d}", oid.value[ i ] );
                }
            else
                {
                parsing_long = false;
                end_idx = i;

                u64 byte_count = ( end_idx - start_idx ) + 1;

                u64 node = 0;
                for ( u64 j = 0, j < byte_count, j += 1 )
                    {
                    node = ( node << 7 ) + ( oid.value[ start_idx + j ] & ~OID_NODE_FMT_MASK );
                    }

                ret += std::format(".{:d}", node);
                start_idx = 0;
                end_idx = 0;
                }
            }
        else if ( oid.value[ i ] & OID_NODE_FMT_MASK == OID_NODE_FMT_LONG )
            {
            if ( !parsing_long )
                {
                parsing_long = true;
                start_idx = i;
                }
            }
        else
            {
            std::print( "Bad OID node format" );
            break;
            }
        }
    return ret;
    };

struct utc_time_no_seconds_type
    {
    char YY[ 2 ];
    char MM[ 2 ];
    char DD[ 2 ];
    char hh[ 2 ];
    char mm[ 2 ];
    char Z;
    } [[ format( "format_utc_time_no_seconds_type" ) ]];

struct utc_time_seconds_type
    {
    char YY[ 2 ];
    char MM[ 2 ];
    char DD[ 2 ];
    char hh[ 2 ];
    char mm[ 2 ];
    char ss[ 2 ];
    char Z;
    } [[ format( "format_utc_time_seconds_type" ) ]];

fn format_utc_time_no_seconds_type( utc_time_no_seconds_type time )
    {
    return std::format
            (
            "{:s}-{:s}-{:s} {:s}:{:s}Z",
            time.YY,
            time.MM,
            time.DD,
            time.hh,
            time.mm,
            time.Z
            );
    };

fn format_utc_time_seconds_type( utc_time_seconds_type time )
    {
    return std::format
            (
            "{:s}-{:s}-{:s} {:s}:{:s}:{:s}Z",
            time.YY,
            time.MM,
            time.DD,
            time.hh,
            time.mm,
            time.ss,
            time.Z
            );
    };


u8 nest = 1;
struct TLV
    {
    std::print( "{:s}-----------------", "|" * nest );
    std::print( "{:s}Reading tag byte {:x} at {:x}", "|" * nest , $[ $ ], $ );
    tag_type tag;
    std::print( "{:s}Tag: {:}", "|" * nest, tag );

    std::print( "{:s}Reading length byte {:x} at {:x}", "|" * nest, $[ $ ], $ );
    if ( ( ( $[ $ ] & LENGTH_MASK ) >> 7 ) == length_format_type::LENGTH_SHORT )
        {
        single_byte_length_type length;
        }
    else if ( ( ( $[ $ ] & LENGTH_MASK ) >> 7 ) == length_format_type::LENGTH_LONG )
        {
        multi_byte_length_type length;
        }
    else
        {
        std::print( "Bad length byte" );
        return 1;
        }
    std::print( "{:s}Length: {:}", "|" * nest, length );

    match ( tag.class )
        {
        ( tag_class_type::Context_specific ):
            {
            nest += 1;
            TLV value[while ( ( $ < addressof( this ) + length.length ) ) ];
            nest -= 1;
            }
        ( tag_class_type::Universal ):
            {
            match ( tag.op, tag.construction )
                {
                ( tag_op_type::INTEGER, tag_constr_type::Primitive ):
                    {
                    INTEGER<length.length> value;
                    std::print( "{:s}Value: {:}", "|" * nest, value );
                    }

                ( tag_op_type::SEQUENCE, tag_constr_type::Constructed ):
                    {
                    nest += 1;
                    TLV value[while ( ( $ < addressof( this ) + length.length ) ) ];
                    nest -= 1;
                    }

                ( tag_op_type::SET, tag_constr_type::Constructed ):
                    {
                    nest += 1;
                    TLV value[while ( ( $ < addressof( this ) + length.length ) ) ];
                    nest -= 1;
                    }

                ( tag_op_type::ENUMERATED, tag_constr_type::Primitive ):
                    {
                    match ( length.length )
                        {
                        ( 1 ): u8 value;
                        ( _ ): u8 value[ length.length ];
                        }
                    }

                ( tag_op_type::OBJECT_IDENTIFIER, tag_constr_type::Primitive ):
                    {
                    oid_type<length.length> value;
                    std::print( "{:s}Value: {:}", "|" * nest, value );
                    }

                ( tag_op_type::NULL, tag_constr_type::Primitive ):
                    {
                    std::print( "{:s}Value: NULL", "|" * nest );
                    }

                ( tag_op_type::OCTET_STRING, _ ):
                    {
                    char value[ length.length ];
                    std::print( "{:s}Value: {:}", "|" * nest, value );
                    }

                ( tag_op_type::PrintableString, _ ):
                    {
                    char value[ length.length ];
                    std::print( "{:s}Value: {:}", "|" * nest, value );
                    }

                ( tag_op_type::UTCTime, _ ):
                    {
                    if ( length.length == sizeof( utc_time_seconds_type ) )
                        {
                        utc_time_seconds_type value;
                        std::print( "{:s}Value: {:}", "|" * nest, value );
                        }
                    else if ( length.length == sizeof( utc_time_no_seconds_type ) )
                        {
                        utc_time_no_seconds_type value;
                        std::print( "{:s}Value: {:}", "|" * nest, value );
                        }
                    else
                        {
                        std::print( "Bad UTCTime size" );
                        }
                    }

                ( tag_op_type::BIT_STRING, _ ):
                    {
                    BIT_STRING<length.length> value;
                    std::print( "{:s}Value: {:}", "|" * nest, value );
                    }
                
                ( tag_op_type::BOOLEAN, tag_constr_type::Primitive ):
                    {
                    bool value;
                    std::print( "{:s}Value: {:}", "|" * nest, value );
                    }

                ( _, _ ):
                    {
                    std::print
                        (
                        "BAD TAG, {:s}",
                        format_tag_type( tag )
                        );
                    }
                }
            }
        }

    };
TLV tlv_at_0xA0 @ 0x00;