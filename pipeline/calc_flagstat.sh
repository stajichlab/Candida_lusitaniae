#PBS -j oe -N flagstat
for file in *.RG.bam
do
 if [ ! -f $file.flagstat ]; then
  samtools flagstat $file > $file.flagstat
 fi
done
