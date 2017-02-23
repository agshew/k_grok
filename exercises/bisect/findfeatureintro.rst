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

  git checkout upstream/master
  git bisect start
  FIRST_VERS=$(git tag --list | grep -E "^v" | sort -rV | tail -1)
