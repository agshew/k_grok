#include <linux/module.h>
#include <linux/kthread.h>
#include <linux/time.h>

#define CREATE_TRACE_POINTS
#include "silly-trace.h"

static void silly_thread_func(void)
{
	static unsigned long count;
	unsigned long res;
	ktime_t x, y;
	s64 z;

	set_current_state(TASK_INTERRUPTIBLE);
	schedule_timeout(HZ);

	count++;
	x = ktime_get();
	res = int_sqrt(17);
	y = ktime_get();
	z = ktime_to_ns(ktime_sub(y, x));
	trace_me_silly( (unsigned long)z, count);
	printk("hello! %lu int_sqrt(17)=%lu\n", count, res);
}

static int silly_thread(void *arg)
{
	while (!kthread_should_stop())
		silly_thread_func();

	return 0;
}

static struct task_struct *silly_tsk;

static int __init silly_init(void)
{
	silly_tsk = kthread_run(silly_thread, NULL, "silly-thread");
	if (IS_ERR(silly_tsk))
		return -1;

	return 0;
}

static void __exit silly_exit(void)
{
	kthread_stop(silly_tsk);
}

module_init(silly_init);
module_exit(silly_exit);

MODULE_AUTHOR("Steven Rostedt");
MODULE_DESCRIPTION("silly-module");
MODULE_LICENSE("GPL");
