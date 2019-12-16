/*
 * Generated by asn1c-0.9.22 (http://lionet.info/asn1c)
 * From ASN.1 module "RRLP-Components"
 * 	found in "../rrlp-components.asn"
 */

#ifndef _AdditionalAssistanceData_H_
#define _AdditionalAssistanceData_H_


#include <asn_application.h>

/* Including external dependencies */
#include "GPSAssistanceData.h"
#include "ExtensionContainer.h"
#include "GANSSAssistanceData.h"
#include <constr_SEQUENCE.h>

#ifdef __cplusplus
extern "C"
{
#endif

    /* AdditionalAssistanceData */
    typedef struct AdditionalAssistanceData
    {
        GPSAssistanceData_t *gpsAssistanceData /* OPTIONAL */;
        ExtensionContainer_t *extensionContainer /* OPTIONAL */;
        /*
	 * This type is extensible,
	 * possible extensions are below.
	 */
        GANSSAssistanceData_t *ganssAssistanceData /* OPTIONAL */;

        /* Context for parsing across buffer boundaries */
        asn_struct_ctx_t _asn_ctx;
    } AdditionalAssistanceData_t;

    /* Implementation */
    extern asn_TYPE_descriptor_t asn_DEF_AdditionalAssistanceData;

#ifdef __cplusplus
}
#endif

#endif /* _AdditionalAssistanceData_H_ */
#include <asn_internal.h>
