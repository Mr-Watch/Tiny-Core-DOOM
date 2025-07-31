#!/bin/bash
iso_name=$1
script_name=$2
output_name=$3

if [ $# -eq 0 ]; then
    echo "You need to supply 3 arguments to this script:"
    echo "1) Tiny Core Linux iso file."
    echo "2) Script to be injected."
    echo "3) Desired output name."
    exit 1
fi

if [ -z "$iso_name" ]; then
    echo "No .iso file was provided."
    echo "Exiting..."
    exit 1
elif [ -z "$script_name" ]; then
    echo "No script file was provided."
    echo "Exiting..."
    exit 1
elif [ -z "$output_name" ]; then
    echo "No output name was provided."
    echo "Exiting..."
    exit 1
fi

mkdir temp_iso_make_directory
echo "The selected iso is $iso_name."
echo "Extracting iso..."
cd temp_iso_make_directory || exit
7z x ../"$iso_name"

echo "Modifying the isolinux.cfg file to include the vga=784 option on boot \(to allow for the framebuffer to work\)..."
sed -i '7i\\tappend vga=784' boot/isolinux/isolinux.cfg

echo "Uncompressing the core.gz and core.cpio files to expose the compressed filesystem..."
cd boot/ || exit
gzip -dk core.gz
mv core core.cpio
mkdir temp_directory
cd temp_directory || exit
sudo cpio -idv <../core.cpio

echo "Injecting $script_name in the .ashrc file to be executed when the shell is loaded..."
sudo cp etc/skel/.ashrc etc/skel/.ashrc.old
touch temp_script
cat ../../../"$script_name" >temp_script
echo -e "\nsudo rm /etc/skel/.ashrc\nsudo mv /etc/skel/.ashrc.old /etc/skel/.ashrc\nsudo mv .ashrc.old .ashrc" >>temp_script
cat temp_script | sudo tee -a etc/skel/.ashrc

echo "Recompressing the filesystem to core.cpio --> core.gz as well as cleaning up the left-over directories..."
cd ..
rm -f core.gz
rm -f core.cpio
cd ./temp_directory || exit
find . | sudo cpio -oV -H newc | sudo tee ../core.cpio >/dev/null
cd ..
gzip core.cpio
mv core.cpio.gz core.gz
sudo rm -rf temp_directory

echo "Repacking the directories to a .iso file..."
cd ..
xorriso -as mkisofs -o "$output_name".iso -b boot/isolinux/isolinux.bin -c boot/isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -J -r -V "\$output_name" .

echo "Making the iso bootable..."
isohybrid "$output_name".iso
mv "$output_name".iso ../"$output_name".iso
cd ..
rm -rf temp_iso_make_directory
