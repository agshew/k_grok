============================================
Find When Features Are Introduced or Changed
============================================

Normally, it is easy to find when a feature was introduced into the Linux
kernel without using git-bisect. However, we'll use git-bisect in this case in
order to get familiar with it.

Update to the latest upstream::

  cd ${KERNEL_SOURCE}
  git pull upstream
  git fetch --tags upstream

x32
---

The x32 ABI was created to reduce memory pressure due to pointers on x86_64
systems. See `x32 ABI support by distributions<https://lwn.net/Articles/548838/>`
for more information.

The X86_X32 configuration variable is defined in arch/x86/Kconfig.

Let's find out when it was introduced::

  git bisect start --term-new=x32 --term-old=nox32
  git bisect x32 v4.10
  git bisect nox32 v3.0

You should see::

  Bisecting: 197138 revisions left to test after this (roughly 18 steps)
  [682b7c1c8ea8885aa681ddf530d6cf2ad4f2dc15] Merge branch 'drm-next' of git://people.freedesktop.org/~airlied/linux

Check for X86_X32 config option::

  grep X86_X32 arch/x86/Kconfig

The option is present, so mark it::

  git bisect x32

You should see::

  Bisecting: 98921 revisions left to test after this (roughly 17 steps)
  [06991c28f37ad68e5c03777f5c3b679b56e3dac1] Merge tag 'driver-core-3.9-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core

Repeat grep and bisect::

  Bisecting: 49496 revisions left to test after this (roughly 16 steps)
  [94b5aff4c6f72fee6b0f49d49e4fa8b204e8ded9] Merge tag 'tty-3.5-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty

Repeat grep and bisect::

  Bisecting: 24538 revisions left to test after this (roughly 15 steps)
  [e4e88f31bcb5f05f24b9ae518d4ecb44e1a7774d] Merge branch 'next' of git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc

At this point, the grep fails, so mark as nox32::

  Bisecting: 12266 revisions left to test after this (roughly 14 steps)
  [5f0e685f316a1de6d3af8b23eaf46651faca32ab] Merge tag 'spi-for-linus' of git://git.secretlab.ca/git/linux-2.6

Repeat grep (fails) and mark as nox32::

  Bisecting: 6160 revisions left to test after this (roughly 13 steps)
  [c39e8ede284f469971589f2e04af78216e1a771d] Merge tag 'fixes-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc

Repeat grep (succeeds) and mark as x32::

  Bisecting: 2932 revisions left to test after this (roughly 12 steps)
  [e317234975cb7463b8ca21a93bb6862d9dcf113f] Merge branch 'v4l_for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media

Repeat grep (fails) and mark as nox32::

  Bisecting: 1466 revisions left to test after this (roughly 11 steps)
  [3fc498f165304dc913f1d13b5ac9ab4c758ee7ab] smp: introduce a generic on_each_cpu_mask() function

Repeat grep (fails) and mark as nox32::

  Bisecting: 757 revisions left to test after this (roughly 10 steps)
  [afb9bd704c7116076879352a2cc2c43aa12c1e14] Merge branch 'for-linus' of git://git.open-osd.org/linux-open-osd

Repeat grep (fails) and mark as nox32::

  Bisecting: 396 revisions left to test after this (roughly 9 steps)
  [820d41cf0cd0e94a5661e093821e2e5c6b36a9d8] Merge tag 'cleanup2' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc

Repeat grep (fails) and mark as nox32::

  Bisecting: 232 revisions left to test after this (roughly 8 steps)
  [40380f1c7841a5dcbf0b20f0b6da11969211ef77] ia64: Fixup asm/cmpxchg.h

Repeat grep (succeeds) and mark as x32::

  Bisecting: 81 revisions left to test after this (roughly 6 steps)
  [e152c38abaa92352679c9b53c4cce533c03997c6] Merge tag 'devicetree-for-linus' of git://git.secretlab.ca/git/linux-2.6

Repeat grep (succeeds) and mark as x32::

  Bisecting: 40 revisions left to test after this (roughly 5 steps)
  [d046ff8b30319d9aa38d877a0ba4206771e54346] x86-64: Add prototype for old_rsp to a header file

Repeat grep (fails) and mark as nox32::

  Bisecting: 20 revisions left to test after this (roughly 4 steps)
  [3f21723079d3ff1c0f71790b4f7fbf9546856eb1] Merge branch 'core/types' into x86/x32

Repeat grep (succeeds) and mark as x32::

  Bisecting: 9 revisions left to test after this (roughly 3 steps)
  [fca460f95e928bae373daa8295877b6905bc62b8] x32: Handle the x32 system call flag

Repeat grep (fails) and mark as nox32::

  Bisecting: 4 revisions left to test after this (roughly 2 steps)
  [5fd92e65a68b813667bc8739f5fa463e5bfcd66d] x32: Allow x32 to be configured

Repeat grep (succeeds) and mark as x32::

  Bisecting: 2 revisions left to test after this (roughly 1 step)
  [c5a373942bbc41698724fc948c74f959f73407e5] x32: Signal-related system calls

Repeat grep (fails) and mark as nox32::

  Bisecting: 0 revisions left to test after this (roughly 1 step)
  [a06c9bc0647f66df0534fb887ddf6cddd35f426c] x32: If configured, add x32 system calls to system call tables

Repeat grep (fails) and mark as nox32::

  5fd92e65a68b813667bc8739f5fa463e5bfcd66d is the first x32 commit
  commit 5fd92e65a68b813667bc8739f5fa463e5bfcd66d
  Author: H. J. Lu <hjl.tools@gmail.com>
  Date:   Sun Feb 19 10:40:03 2012 -0800

    x32: Allow x32 to be configured

    At this point, one should be able to build an x32 kernel.

    Note that for now we depend on CONFIG_IA32_EMULATION.  Long term, x32
    and IA32 should be detangled.

    Signed-off-by: H. Peter Anvin <hpa@zytor.com>

  :040000 040000 e1cf5bc2fe872240e6c48a20e79ee61d65f9749f 928f6a557fd6b1b5b7652ef72018632a70f233e6 M      arch

The commit that added the X86_X32 config option has been found!

Clean up bisection state::

  git bisect reset
