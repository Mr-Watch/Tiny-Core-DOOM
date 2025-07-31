# Tiny Core DOOM Script Injection

## Doom-install-script

This idea was born from sleep depravation and a very clouded mind and is quite possibly the most idiotic, asinine way once could go about trying to run DOOM on any operating system.  
While I was experimenting with modifying the iso, I noticed that any files I placed inside where not persisting after the boot-up sequence finished.  
So with (at the time) no obvious way to include the files I needed (a precompiled version of fbdoom, libSDL-1.2.so.0 as well as the DOOM1.WAD) I said to myself...  

> Was there a way to include the files somehow in the injected script...?  

And then eureka!!!  

> I can just include the **RAW** bytes as hexadecimal using some kind of script and then **painstakingly** decode them back into the correct files using another script! ...

So this is the result.  
The **hex-encode.sh** script accepts **one** argument, which is an existing file and then spits out another file that is the raw hexadecimal representation of every single individual byte.  
The **hex-decode.sh**, as the name implies, takes as the **first argument** the file that **hex-encode.sh** spits out and then using the **second argument** which is the output name it turns it back into whatever file it was originally (with the changed output name).

So the **Doom-install-script** using the following syntax:

```sh
cat > libSDL-1.2.so.0.hex <<-EOF
7f454c46010101000000000000000000...
...
474c4942435f322e3000
EOF
```

it embeds the files in the script.  
What this does is accentually create three files with a .hex extension which later, using a minified version of the **hex-decode.sh** script are turned back in to the files that I was unable to include in the iso natively.  

What I did not take into account is that the process of writing the .hex files is very fast, the process of turing them back into the originals is **UNFATHOMABLY** slow (especially on the systems Tiny Core Linux is meant to run on).  
That is the reason that the included DOOM version is the shareware one.  
Decoding the full fat version of the WAD could take **HOURS**.  
**But** as a proof of concept... I think it's pretty neat (but also very stupid).

The **hex-encode.sh** and **hex-decode.sh** scripts are very generic and only have as a dependency **hexdump** and **printf**, so that makes them very portable.
> [!NOTE]
> Only use the output of **hex-encode.sh** as the input for **hex-decode.sh** to insure optimal results.  

## script-injector.sh

This version of the script is identical to the one found in [Tiny Core DOOM Internet](https://github.com/Mr-Watch/Tiny-Core-DOOM/tree/main/Tiny%20Core%20DOOM%20Internet).  
