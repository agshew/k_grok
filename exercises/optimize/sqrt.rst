Homework 2
==========

This multi-part assignment will have separately graded sections.

 * Review a patch (10 points)
 * Submit a patch series (10 points)

Use asciinema
-------------

Record all of your command-line work separately for each part of the homework:
hw2-review, hw2-patch.

Example: asciinema rec /tmp/hw2-review

After starting the recording, launch screen and create multiple terminal buffers
(i.e. console sessions) in screen via '<CTRL>+a c'. Switch between them via
commands such as '<CTRL>+a "' (that the control and letter a keys pressed
simultaneously, followed by a press of the double quote key).

You can play a recording back with shortened inactive times.

Example: asciinema play -w 1 /tmp/hw2-review

Upload asciinema files to Google Docs and include a link in an email to the
instructors and TA. Not doing this will cost 2 points. Use subjects such as:

 * [HW 2] Review asciinema
 * [HW 2] Patch asciinema

Review a patch (10 points)
--------------------------

Send an email to the instructor and TA reviewing the following:

[PATCH] Optimize int_sqrt for small values for faster idle
https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1063272.html

The subject of this email should be:

Re: [PATCH] Optimize int_sqrt for small values for faster idle

In this review, include:

 * suggestions for improving the patch

 * name 3 people who modified this file
   apt install git-gui, and see git-gui blame

   * WARNING: You can't use a shallow clone, so either start with a full clone or
     convert a shallow clone to full with:
     git fetch --unshallow upstream
     git checkout upstream/master

   * NOTE: If you execute 'git gui blame' and see an error message that refers to
     there being no DISPLAY environment variable being set, then that means that
     you need install X or enable X forwarding when you ssh into your VM.
     `X for Mac OS X<www.xquartz.org>` and `X for Windows<x.cygwin.com>`
     ssh -Y ${HOSTNAME}
     Only use the '-Y' argument when you ssh to something secure like your VM.
     Otherwise add something like 'ForwardX11Timeout 1D' to ~/.ssh/config and use
     the  '-X' argument.

 * a list of everywhere the function is called

 * spot-checks or proofs of correctness

   In other words, call the function with a few values and compare it to what a
   calculator or other trusted source gives you. Think of good corner cases for
   unsigned integers, such as 0 and the max unsigned int of that size, along
   with a few normal values.

   You could write a mathematical proof, if that's something you like to do.

 * benchmarks of previous code vs. new code
   benchmark in a kernel module, not userspace
   use perf trace events, and graph CDF and PDF,
   see k_grok/exercises/tracepoint-silly/

   Since int_sqrt takes much less time than printk, jiffies aren't high enough
   resolution.  Include the linux/time.h header and use ktime_get(), and macros
   like ktime_sub(lhs, rhs) and ktime_to_ns(...) instead of standard math ops::

   ...
   #include <linux/time.h>
   ...
   static void silly_thread_func(void)
   {
       static unsigned long count;
       ktime_t x, y;
       s64 z;
       ...
       x = ktime_get();
       ...
       // operations to be measured
       // WARNING: Take out the printk! Only measure the optimzed sqrt function.
       ...
       y = ktime_get();
       z = ktime_to_ns(ktime_sub(y, x));
       trace_me_silly ( (unsigned long)z, count);
   }


Submit a patch series
---------------------

Reroll (i.e. act as if you are the original author, revising it) the patch you
just reviewed, addressing the feedback of the kernel developers and your
review. Send the rerolled patch to the instructor and TA.  It should include
the appropriate version in the subject's tag.

Add a new optimized version of the int_sqrt function for a new random range of
numbers. Regarding the random range and conclusions about bit length, you can
deduce that a number from, say, 65536 to 4294967295 is at least 8 bits
and less than 32 bits.

Add a prototype declaration after the one for int_sqrt in include/linux/kernel.h
Add the implementation after int_sqrt in lib/int_sqrt.c::

        unsigned long int_sqrt_optimized(unsigned long x){
        ...
        }
        EXPORT_SYMBOL(int_sqrt_optimized);

Go to https://www.random.org, change max to 1000000, and generate two random
numbers. See the prandom_u32() function in the kernel for generating numbers to
test, and
http://stackoverflow.com/questions/2509679/how-to-generate-a-random-number-from-within-a-range
for ranges of random numbers maybe get some ideas from
http://stackoverflow.com/questions/1100090/looking-for-an-efficient-integer-square-root-algorithm-for-arm-thumb2

For example::

        #include <linux/kernel.h>
        #include <linux/random.h>
        ...
        static void silly_thread_func(void)
        {
            ...
            static unsigned long rnd, min, max, num_bins, num_rand, bin_size;
            ...
            min = ???; // from random.org
            max = ???; // from random.org
            num_bins = max + 1;
            num_rand = ULONG_MAX + 1;
            bin_size = num_rand / num_bins;
            defect = num_rand % num_bins;
            ...
            do {
                rnd = prandom_u32();
            }
            // This is carefully written not to overflow
            while (num_rand - defect <= (unsigned long)rnd);
            ...
            // Use rnd here
        }

Cite the source of anything you don't write youreself int the patch history
(i.e. below the '---' mark)..

Benchmark as above. The benchmark kernel module source should be included as
separate emails in the series. Add the silly dir under ${KERNEL_SOURCE}/tools,
and then you can generate a patch.

Remember all of the other things the documentation says a patch should have.
