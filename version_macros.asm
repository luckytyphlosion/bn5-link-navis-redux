
	.macro .vdefinelabel, label_name, tp_offset, tc_offset
		.if IS_PROTOMAN == 1
			.definelabel label_name, tp_offset
		.else
			.definelabel label_name, tc_offset
		.endif
	.endmacro

	.macro .vorg, tp_offset, tc_offset
		.if IS_PROTOMAN == 1
			.org tp_offset
		.else
			.org tc_offset
		.endif
	.endmacro

	.macro .vbranch, tp_offset, tc_offset
		.if IS_PROTOMAN == 1
			b tp_offset
		.else
			b tc_offset
		.endif
	.endmacro

	; .macro .vequ, var_name, tp_value, tc_value
	; 	.if IS_PROTOMAN == 1
	; 		var_name equ tp_value
	; 	.else
	; 		var_name equ tc_value
	; 	.endif
	; .endmacro

	.expfunc vequ(tp_value, tc_value), IS_PROTOMAN == 1 ? tp_value : tc_value
