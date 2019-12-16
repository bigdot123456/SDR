/*
 * Generated by asn1c-0.9.22 (http://lionet.info/asn1c)
 * From ASN.1 module "RRLP-Components"
 * 	found in "../rrlp-components.asn"
 */

#include "GPSTimeAssistanceMeasurements.h"

static int
memb_referenceFrameMSB_constraint_1(asn_TYPE_descriptor_t *td, const void *sptr,
			asn_app_constraint_failed_f *ctfailcb, void *app_key) {
	long value;
	
	if(!sptr) {
		_ASN_CTFAIL(app_key, td, sptr,
			"%s: value not given (%s:%d)",
			td->name, __FILE__, __LINE__);
		return -1;
	}
	
	value = *(const long *)sptr;
	
	if((value >= 0 && value <= 63)) {
		/* Constraint check succeeded */
		return 0;
	} else {
		_ASN_CTFAIL(app_key, td, sptr,
			"%s: constraint failed (%s:%d)",
			td->name, __FILE__, __LINE__);
		return -1;
	}
}

static int
memb_gpsTowSubms_constraint_1(asn_TYPE_descriptor_t *td, const void *sptr,
			asn_app_constraint_failed_f *ctfailcb, void *app_key) {
	long value;
	
	if(!sptr) {
		_ASN_CTFAIL(app_key, td, sptr,
			"%s: value not given (%s:%d)",
			td->name, __FILE__, __LINE__);
		return -1;
	}
	
	value = *(const long *)sptr;
	
	if((value >= 0 && value <= 9999)) {
		/* Constraint check succeeded */
		return 0;
	} else {
		_ASN_CTFAIL(app_key, td, sptr,
			"%s: constraint failed (%s:%d)",
			td->name, __FILE__, __LINE__);
		return -1;
	}
}

static int
memb_deltaTow_constraint_1(asn_TYPE_descriptor_t *td, const void *sptr,
			asn_app_constraint_failed_f *ctfailcb, void *app_key) {
	long value;
	
	if(!sptr) {
		_ASN_CTFAIL(app_key, td, sptr,
			"%s: value not given (%s:%d)",
			td->name, __FILE__, __LINE__);
		return -1;
	}
	
	value = *(const long *)sptr;
	
	if((value >= 0 && value <= 127)) {
		/* Constraint check succeeded */
		return 0;
	} else {
		_ASN_CTFAIL(app_key, td, sptr,
			"%s: constraint failed (%s:%d)",
			td->name, __FILE__, __LINE__);
		return -1;
	}
}

static asn_per_constraints_t ASN_PER_MEMB_REFERENCE_FRAME_MSB_CONSTR_2 = {
	{ APC_CONSTRAINED,	 6,  6,  0,  63 }	/* (0..63) */,
	{ APC_UNCONSTRAINED,	-1, -1,  0,  0 },
	0, 0	/* No PER value map */
};
static asn_per_constraints_t ASN_PER_MEMB_GPS_TOW_SUBMS_CONSTR_3 = {
	{ APC_CONSTRAINED,	 14,  14,  0,  9999 }	/* (0..9999) */,
	{ APC_UNCONSTRAINED,	-1, -1,  0,  0 },
	0, 0	/* No PER value map */
};
static asn_per_constraints_t ASN_PER_MEMB_DELTA_TOW_CONSTR_4 = {
	{ APC_CONSTRAINED,	 7,  7,  0,  127 }	/* (0..127) */,
	{ APC_UNCONSTRAINED,	-1, -1,  0,  0 },
	0, 0	/* No PER value map */
};
static asn_TYPE_member_t asn_MBR_GPSTimeAssistanceMeasurements_1[] = {
	{ ATF_NOFLAGS, 0, offsetof(struct GPSTimeAssistanceMeasurements, referenceFrameMSB),
		(ASN_TAG_CLASS_CONTEXT | (0 << 2)),
		-1,	/* IMPLICIT tag at current level */
		&asn_DEF_NativeInteger,
		memb_referenceFrameMSB_constraint_1,
		&ASN_PER_MEMB_REFERENCE_FRAME_MSB_CONSTR_2,
		0,
		"referenceFrameMSB"
		},
	{ ATF_POINTER, 3, offsetof(struct GPSTimeAssistanceMeasurements, gpsTowSubms),
		(ASN_TAG_CLASS_CONTEXT | (1 << 2)),
		-1,	/* IMPLICIT tag at current level */
		&asn_DEF_NativeInteger,
		memb_gpsTowSubms_constraint_1,
		&ASN_PER_MEMB_GPS_TOW_SUBMS_CONSTR_3,
		0,
		"gpsTowSubms"
		},
	{ ATF_POINTER, 2, offsetof(struct GPSTimeAssistanceMeasurements, deltaTow),
		(ASN_TAG_CLASS_CONTEXT | (2 << 2)),
		-1,	/* IMPLICIT tag at current level */
		&asn_DEF_NativeInteger,
		memb_deltaTow_constraint_1,
		&ASN_PER_MEMB_DELTA_TOW_CONSTR_4,
		0,
		"deltaTow"
		},
	{ ATF_POINTER, 1, offsetof(struct GPSTimeAssistanceMeasurements, gpsReferenceTimeUncertainty),
		(ASN_TAG_CLASS_CONTEXT | (3 << 2)),
		-1,	/* IMPLICIT tag at current level */
		&asn_DEF_GPSReferenceTimeUncertainty,
		0,	/* Defer constraints checking to the member type */
		0,	/* No PER visible constraints */
		0,
		"gpsReferenceTimeUncertainty"
		},
};
static int asn_MAP_GPSTimeAssistanceMeasurements_oms_1[] = { 1, 2, 3 };
static ber_tlv_tag_t asn_DEF_GPSTimeAssistanceMeasurements_tags_1[] = {
	(ASN_TAG_CLASS_UNIVERSAL | (16 << 2))
};
static asn_TYPE_tag2member_t asn_MAP_GPSTimeAssistanceMeasurements_tag2el_1[] = {
    { (ASN_TAG_CLASS_CONTEXT | (0 << 2)), 0, 0, 0 }, /* referenceFrameMSB at 950 */
    { (ASN_TAG_CLASS_CONTEXT | (1 << 2)), 1, 0, 0 }, /* gpsTowSubms at 951 */
    { (ASN_TAG_CLASS_CONTEXT | (2 << 2)), 2, 0, 0 }, /* deltaTow at 952 */
    { (ASN_TAG_CLASS_CONTEXT | (3 << 2)), 3, 0, 0 } /* gpsReferenceTimeUncertainty at 953 */
};
static asn_SEQUENCE_specifics_t asn_SPC_GPSTimeAssistanceMeasurements_specs_1 = {
	sizeof(struct GPSTimeAssistanceMeasurements),
	offsetof(struct GPSTimeAssistanceMeasurements, _asn_ctx),
	asn_MAP_GPSTimeAssistanceMeasurements_tag2el_1,
	4,	/* Count of tags in the map */
	asn_MAP_GPSTimeAssistanceMeasurements_oms_1,	/* Optional members */
	3, 0,	/* Root/Additions */
	-1,	/* Start extensions */
	-1	/* Stop extensions */
};
asn_TYPE_descriptor_t asn_DEF_GPSTimeAssistanceMeasurements = {
	"GPSTimeAssistanceMeasurements",
	"GPSTimeAssistanceMeasurements",
	SEQUENCE_free,
	SEQUENCE_print,
	SEQUENCE_constraint,
	SEQUENCE_decode_ber,
	SEQUENCE_encode_der,
	SEQUENCE_decode_xer,
	SEQUENCE_encode_xer,
	SEQUENCE_decode_uper,
	SEQUENCE_encode_uper,
	0,	/* Use generic outmost tag fetcher */
	asn_DEF_GPSTimeAssistanceMeasurements_tags_1,
	sizeof(asn_DEF_GPSTimeAssistanceMeasurements_tags_1)
		/sizeof(asn_DEF_GPSTimeAssistanceMeasurements_tags_1[0]), /* 1 */
	asn_DEF_GPSTimeAssistanceMeasurements_tags_1,	/* Same as above */
	sizeof(asn_DEF_GPSTimeAssistanceMeasurements_tags_1)
		/sizeof(asn_DEF_GPSTimeAssistanceMeasurements_tags_1[0]), /* 1 */
	0,	/* No PER visible constraints */
	asn_MBR_GPSTimeAssistanceMeasurements_1,
	4,	/* Elements count */
	&asn_SPC_GPSTimeAssistanceMeasurements_specs_1	/* Additional specs */
};

