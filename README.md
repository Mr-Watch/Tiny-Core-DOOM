# Tiny-Core-DOOM

A collection of scripts that modify the Tiny Core Linux iso to include a playable version of classic DOOM.

## Why do this ?

I was inspired be this [repository](https://github.com/shadlyd15/DoomLinux) which builds a minimal version of Linux just to play DOOM.  
I thought that was pretty cool and wondered what other minimal Linux distro could be used for this purpose... and then I thought of Tiny Core Linux Core edition.  
At just **17MB** it seemed to be the ideal candidate for such a silly experiment :sweat_smile: (although the final iso is closer to 25MB in most cases)  
So here instead of building a minimal Linux distro from scratch, we just modify the iso directly.  
For the provided **scripts to work you need to download the** [**Core**](http://www.tinycorelinux.net/16.x/x86/release/Core-current.iso) version of Tiny Core Linux and make the script point to it.  
More info on how to use the scripts and how they work is provided in the **README.md** found in each separate directory.  
The recommend order that you view and read the directories is this:  

1. [Tiny Core DOOM Internet](https://github.com/Mr-Watch/Tiny-Core-DOOM/tree/main/Tiny%20Core%20DOOM%20Internet)
2. [Tiny Core DOOM Script Injection](https://github.com/Mr-Watch/Tiny-Core-DOOM/tree/main/Tiny%20Core%20DOOM%20Script%20Injection)
3. [Tiny Core DOOM File Substitution](https://github.com/Mr-Watch/Tiny-Core-DOOM/tree/main/Tiny%20Core%20DOOM%20File%20Substitution)
4. [TinyCoom](https://github.com/Mr-Watch/Tiny-Core-DOOM/tree/main/TinyCoom)

## TinyCoom

This is the most heavily modified version of the iso and it is a bit more... DOOMy if you get what I mean :wink:  
You can find this version in the [releases](https://github.com/Mr-Watch/Tiny-Core-DOOM/releases/tag/Initial-Release) section of the repository.  
Or better yet make your own version using the script and accompanying files found in the [TinyCoom](https://github.com/Mr-Watch/Tiny-Core-DOOM/tree/main/TinyCoom) directory.

## Running in a VM

I used Virtual Box to test the generated isos u