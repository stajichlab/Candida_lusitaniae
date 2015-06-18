#PBS -j oe -N flagstat
for file in *.realign.bam
do
 if [ ! -f $file.flagstat ]; then
  samtools flagstat $file > $file.flagstat
 fi
done
