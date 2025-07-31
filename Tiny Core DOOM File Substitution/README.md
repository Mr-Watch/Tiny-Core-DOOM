# Tiny Core DOOM File Substitution

## Doom-install-script

This is the result of seeing just how impractical the [Tiny Core DOOM Script Injection](https://github.com/Mr-Watch/Tiny-Core-DOOM/tree/main/Tiny%20Core%20DOOM%20Script%20Injection) method was.  
So after sleeping on it I had a different idea.  
What if I disguised the files in the iso's filesystem somehow...  
So I started to replace some files in the */etc* directory with my own, and renamed them to the original filenames.  
Then low and behold, these where still present in the final reconstructed iso :smile:  
So all the **Doom-install-script** has to do is to move and rename the files that we copied (using the **script-injector.sh**) in the */etc* directory to the *home* directory.  

## script-injector.sh

This version of the script is very similar to the one found in [Tiny Core DOOM Internet](https://github.com/Mr-Watch/Tiny-Core-DOOM/tree/main/Tiny%20Core%20DOOM%20Internet) but it has the following additions.  

```sh
cd etc || exit
sudo cp ../../../../libSDL-1.2.so.0.11.3 ./
sudo cp ../../../../fbdoom ./
sudo cp ../../../../DOOM.WAD ./

sudo mv modprobe.conf modprobe.conf.old
sudo mv os-release os-release.old
sudo mv issue issue.old

sudo mv libSDL-1.2.so.0.11.3 modprobe.conf
sudo mv fbdoom os-release
sudo mv DOOM.WAD issue
```

What it does is copy the three files in the filesystem's */etc* directory, make backups of the three files that are about to be substituted (these are not removed because they have the same *apparent* name) and then renames the copied files with the names of the substituted ones (without the .old extension).
