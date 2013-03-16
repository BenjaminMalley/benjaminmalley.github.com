---
layout: post
title: "Installing Debian Wheezy on an encrypted LVM with Windows dual-boot"
date: 2012-01-03 20:13
comments: true
categories: 
---
###UPDATE: I've confirmed that this issue is no longer present in the latest version of Debian testing for x86-64.

For a while now, Debian's intaller has supported the Linux Logical
Volume Manager, which allows you to replace your partitions with logical
volumes that can be resized or extended with additional disks easily.
You can find out more about the benefits of LVM on Wikipedia.  The
Debian installer provides a number of automated options for a whole disk
LVM and encrypted LVM setup, but if, for example, you want to dual boot
Windows off of the same disk, you're going to need to get your hands
dirty.

For the most part, I followed [this guide](http://www.linuxbsdos.com/2011/05/10/how-to-install-ubuntu-11-04-on-an-encrypted-lvm-file-system/), which is for Ubuntu and doesn't discuss dual-booting, but was nonetheless useful. At least until I got to the final step. After selecting "Finish partitioning and write changes to disk", I got a warning message informing me that the installer could not continue because there was unsafe swap space detected.

So what happened? Because I encrypted the entire volume group, rather
than encrypting each logical volume group separately, the installer was
unable to detect that the swap volume was, in fact, encrypted. Now
having an unencrypted swap space is, in face, insecure, but the refusal
of the installer to proceed from this felt silly. Even if I was setting
up unencrypted swap (which I wasn't), it's my computer. Let me do it.
Warn me, for sure, but let me do it.

How to proceed from this show stopper? I could re-encrypt the swap space
at the logical volume level, but I would be prompted for yet another
password every time I booted up, which wouldn't be ideal. Plus, I have
an aversion to unnecessarily complicated setups. So I went back into the
partitioning menu and killed my swap space by selecting "do not use" and
then I proceeded with the install.

Debian threw up some warnings about the dangers of installing without
swap, but having 4 GB of ram on the machine, so I wasn't too concerned.
Unlike with the unsafe swap space error, this didn't prevent me from
moving forward.  So I selected my install packages and booted into the
new OS.

From here, adding a swap volume is a relatively straightforward affair.
You can get detailed information about your logical volumes with
<code>vgdisplay -v vg01</code>.

If you're following along at home, change <code>vg01</code> to whatever
you've named your volume group. vgdisplay lists all of the logical
volumes under that volume group. Each entry begins with LV Name, which
is that logical volume's name. I had an entry for
<code>/dev/vg01/swap</code>, which was the logical volume I had set
aside for swap but wasn't using. Those names will of course be different
on every system, so all of the following commands should be changed to
reflect that. I set up a new swap volume with <code>mkswap -c
/dev/vg01/swap</code>.

Now I've got a swap volume, but it's not being used. I can verify this
with ```free -m```. The last line shows 0 available swap space:

```
Swap: 0 0 0
```

I could enable it by typing swapon <code>/dev/vg01/swap</code>, but I'd
have to re-enable it every time I boot up. In order to enable the swap
permanently, I edited <code>/etc/fstab</code>, the filesystem table to
include my new swap volume:

```
/dev/mapper/vg01-swap swap swap defaults 0 0
```

Here, the second and third entries refer to the mount point and
filesystem type respectively and should both be swap, regardless of the
logical volume label. Reboot the system and you're done. After system
boot, I typed <code>free -m</code> again to verify the change:

```
Swap: 3811 0 3811
```

