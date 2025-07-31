# TinyCoom

As the name **clearly** implies, this is **TinyC** - ore + D - **oom** and is the final result of all the experimentation I when through when modifying the original ISO.  
This is the magnum opus.  
The best result that I could achieve.  
It is essentially [Tiny Core DOOM File Substitution](https://github.com/Mr-Watch/Tiny-Core-DOOM/tree/main/Tiny%20Core%20DOOM%20File%20Substitution) with a few more files modified to give it a bit more of a **DOOM** vibe, which is something that the [DoomLinux](https://github.com/shadlyd15/DoomLinux) repository lacked in my opinion.  
Not that it was necessary, but I just thought it might have been fun to include, to make the distro feel a bit more unique.

## Doom-install-script

Basically identical to the [Tiny Core DOOM File Substitution](https://github.com/Mr-Watch/Tiny-Core-DOOM/tree/main/Tiny%20Core%20DOOM%20File%20Substitution) but with an added `sleep 2` command so that the user can appreciate the slash screen.

## script-injector.sh

This version of the script is very similar to the one found in [Tiny Core DOOM File Substitution](https://github.com/Mr-Watch/Tiny-Core-DOOM/tree/main/Tiny%20Core%20DOOM%20File%20Substitution), with the following additions:  

```sh
cp ../boot.msg boot/isolinux
cp ../f5 boot/isolinux
cp ../isolinux.cfg boot/isolinux
```

```sh
cd etc || exit
...
sudo cp ../../../../motd motd
```

Here we copy three files into the *boot* directory of our extracted ISO, and we also place another file in to the */etc* of the ISO's file system.  
Now what the hell are these files, and why are we changing them?  

The **boot.msg** file contains the initial slash screen when we boot into Tiny Core Linux in the form of text.  
The **f5** file contains an additional selectable splash screen (pressing the **f5** activates it, as the name implies) in the form of text.  
The **motd** file contains the slash screen of the initial load of the shell in the form of text.  
Finally, the **isolinux.cfg** configures how the boot-up sequence should be executed.  

```cfg
display boot.msg
default microcore
label microcore
  kernel /boot/vmlinuz
  initrd /boot/core.gz
  append vga=784 user=doom host=guy
label mc
  kernel /boot/vmlinuz
  append initrd=/boot/core.gz
implicit 0
prompt 1
timeout 50
F1 boot.msg
F2 f2
F3 f3
F4 f4
F5 f5
```

The options we are interested in are:  

- `display boot.msg` - so the splash screen is displayed.  
- `append vga=784 user=doom host=guy` - so that the frame buffer is enabled, and the **user** is changed to **doom** and the **host** to **guy** (got to commit to the theme :joy:).  
- `F5 f5` - so that the F5 key can bring up the f5 splash screen… :melting_face:
