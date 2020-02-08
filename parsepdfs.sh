#!/bin/sh
SCRIPTDIR=$(dirname $0)

# Download the binaries (if not yet existing)
ZX_VERSION=3.4.0
JC_VERSION=1.78
for lib in core javase; do
  [ -e $SCRIPTDIR/zx-$lib.jar ] || wget https://repo1.maven.org/maven2/com/google/zxing/$lib/$ZX_VERSION/$lib-$ZX_VERSION.jar -O $SCRIPTDIR/zx-$lib.jar
done
[ -e $SCRIPTDIR/jcommander.jar ] || wget https://repo1.maven.org/maven2/com/beust/jcommander/$JC_VERSION/jcommander-$JC_VERSION.jar -O $SCRIPTDIR/jcommander.jar

# Cleanup filenames that don't work well with scripts.
rename -v 'tr/ ()/___/' *
# Extract all the images.
for i in *.pdf; do pdfimages $i $i; done
# Convert all images to png.
for i in *.pbm *.ppm; do convert $i $i.png; rm $i; done
# Use `file` to identify all black&white images, then try to read the barcode using zxing.
for i in `file *.png | grep 1-bit | cut -f1 -d:`; do
    java -cp $SCRIPTDIR/zx-core.jar:$SCRIPTDIR/zx-javase.jar:$SCRIPTDIR/jcommander.jar \
        com.google.zxing.client.j2se.CommandLineRunner \
        --pure_barcode --dump_results --brief ./$i
done
