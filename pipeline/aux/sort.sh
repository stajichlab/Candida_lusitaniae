#PBS -j oe -q batch -l mem=4gb,nodes=1:ppn=1,walltime=24:00:00
module load java
module load picard
for file in *.RG.bam; do 
 b=`basename $file .RG.bam`; 
 if [ ! -f $b.sort.bam ]; then 
  java -jar $PICARD/SortSam.jar I=$file O=$b.sort.bam SO=coordinate; 
 fi
done
