#undef TRACE_SYSTEM
#define TRACE_SYSTEM silly

#if !defined(_SILLY_TRACE_H) || defined(TRACE_HEADER_MULTI_READ)
#define _SILLY_TRACE_H

#include <linux/tracepoint.h>

TRACE_EVENT(me_silly,

	TP_PROTO(unsigned long time, unsigned long count),

	TP_ARGS(time, count),

	TP_STRUCT__entry(
		__field(	unsigned long,	time	)
		__field(	unsigned long,	count	)
	),

	TP_fast_assign(
		__entry->time = time;
		__entry->count = count;
	),

	TP_printk("%lu, %lu", __entry->count, __entry->time)
);

#endif /* _SILLY_TRACE_H */

/* This part must be outside protection */
#undef TRACE_INCLUDE_PATH
#define TRACE_INCLUDE_PATH .
#define TRACE_INCLUDE_FILE silly-trace
#include <trace/define_trace.h>
