# Tiny Core DOOM Internet

## Doom-install-script

This script generates a version of Tiny Core Linux that downloads all the necessary files required to run DOOM.  
The DOOM engine that is used is [fbdoom](https://github.com/maximevince/fbDOOM), since it was the easiest to get working under Tiny Core Linux, whilst only needing to use a framebuffer to draw the graphics.  
When you boot the generated iso (assuming you can get a **working internet connection** under Tiny Core Linux) it will start executing a script that will download **first the required dependencies** (linux-6.12_api_headers, glibc_base-dev, gcc, SDL, git, make, wget).  
Then it will clone the **fbdoom** repository and procid to compile it into an executable binary.  
After that is done it uses **wget** to download the DOOM WAD file (v1.9).  
Finally it creates a little starter script for DOOM and proceeds to execute it (this starter script is present in all version of **Doom-install-script**).  

## script-injector.sh

This is the heart of this project.  
Using this script we have the ability to inject any script we want to be executed right before the shell is fully loaded, thus allowing us to setup Tiny Core Linux just the way we want, right from the iso itself!  

The script requires **three** arguments :

1. Tiny Core Linux iso file
2. Script to be injected
3. Desired output name

A valid invocation would look like this `./script-injector.sh Core-current.iso injected-script output` where "injected-script" and "output" can be anything (the "injected-script" has to be an existing file and both the .iso file and "injected-script" have to be in the same directory as the script-injector.sh).
  
For the script to work you need to run `chmod +x script-injector.sh` to make it executable.  

> [!NOTE]
>
> You need to have following programs installed on your operating system:
>
> - 7z
> - gzip
> - cpio
> - xorriso
> - isohybrid

The injected script can be anything we want  (as long as it is **sh** compatible) **but it must not include the #!/bin/sh directive** as it is going to be appended into a preexisting script.  

### Inner workings

The script starts with a few checks to make sure all the supplied arguments are satisfied.  
Then it creates a temporary directory to make the new iso file and proceeds to extract the supplied one in said directory.  

```sh
mkdir temp_iso_make_directory
cd temp_iso_make_directory || exit
7z x ../"$iso_name"
```

This part is specific for the purpose of running DOOM.  
All it does is to set the vga resolution so that the framebuffer is enabled.

```sh
sed -i '7i\\tappend vga=784' boot/isolinux/isolinux.cfg
```

Then it makes a new temporary directory in which is later extracts the core.gz --> core.cpio, which is where the actual filesystem resides.  

```sh
cd boot/ || exit
gzip -dk core.gz
mv core core.cpio
mkdir temp_directory
cd temp_directory || exit
sudo cpio -idv <../core.cpio
```

This is the **heart** of the script.  
First we make a copy of the original .ashrc file (this file is what loads the shell).  
Then we make a new temporary script and inject our supplied script in to it.  
And the most crucial part is that we later append a small snippet into that script that restores the state of the .ashrc file as soon as our script is done executing.  
This is necessary because if not for this small addition, every time we would start a shell, the script would load all over again.  

```sh
sudo cp etc/skel/.ashrc etc/skel/.ashrc.old
touch temp_script
cat ../../../"$script_name" >temp_script
echo -e "\nsudo rm /etc/skel/.ashrc\nsudo mv /etc/skel/.ashrc.old /etc/skel/.ashrc\nsudo mv .ashrc.old .ashrc" >>temp_script
cat temp_script | sudo tee -a etc/skel/.ashrc
```

After that we remove the old core.gz and core.cpio files, we repackage the modified filesystem back into a core.cpio --> core.gz and remove the temporary directory.  

```sh
rm -f core.gz
rm -f core.cpio
cd ./temp_directory || exit
find . | sudo cpio -oV -H newc | sudo tee ../core.cpio >/dev/null
cd ..
gzip core.cpio
mv core.cpio.gz core.gz
sudo rm -rf temp_directory
```

One of the last steps it to turn all the files in the temporary directory back in to an iso.  

```sh
xorriso -as mkisofs -o "$output_name".iso -b boot/isolinux/isolinux.bin -c boot/isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -J -r -V "$output_name" .
```

And finaly make the iso bootable (as well as remove any left over directories).  

```sh
isohybrid "$output_name".iso
mv "$output_name".iso ../"$output_name".iso
cd ..
rm -rf temp_iso_make_directory
```

Most of the other scripts found in the rest of the repository's directories are very similar to this one, with only a few minor differences, depending on the needs.  
