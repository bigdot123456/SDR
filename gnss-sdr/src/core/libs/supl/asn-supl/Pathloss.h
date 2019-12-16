/*
 * Generated by asn1c-0.9.22 (http://lionet.info/asn1c)
 * From ASN.1 module "ULP-Components"
 * 	found in "../supl-common.asn"
 */

#ifndef _Pathloss_H_
#define _Pathloss_H_


#include <asn_application.h>

/* Including external dependencies */
#include <NativeInteger.h>

#ifdef __cplusplus
extern "C"
{
#endif

    /* Pathloss */
    typedef long Pathloss_t;

    /* Implementation */
    extern asn_TYPE_descriptor_t asn_DEF_Pathloss;
    asn_struct_free_f Pathloss_free;
    asn_struct_print_f Pathloss_print;
    asn_constr_check_f Pathloss_constraint;
    ber_type_decoder_f Pathloss_decode_ber;
    der_type_encoder_f Pathloss_encode_der;
    xer_type_decoder_f Pathloss_decode_xer;
    xer_type_encoder_f Pathloss_encode_xer;
    per_type_decoder_f Pathloss_decode_uper;
    per_type_encoder_f Pathloss_encode_uper;

#ifdef __cplusplus
}
#endif

#endif /* _Pathloss_H_ */
#include <asn_internal.h>
