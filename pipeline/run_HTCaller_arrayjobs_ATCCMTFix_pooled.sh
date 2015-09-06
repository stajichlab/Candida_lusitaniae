#PBS -l nodes=1:ppn=32,mem=410gb,walltime=24:00:00  -j oe -N HTC.ATCCFix.pool
MEM=400
module load java
module load gatk/3.4-46
module load picard
module load samtools
INDIR=Aln/bam_ATCC_MTfix
GENOME=/bigdata/stajichlab/shared/projects/HMAC/Clus_reseq/Aln/ATCC_Ref/candida_lusitaniae_ATCC42720_w_CBS_6936_MT.fasta
OUTDIR=Variants/ATCC_MTfix_pools
b=`basename $GENOME .fasta`
dir=`dirname $GENOME`

CPU=$PBS_NUM_PPN

if [ ! $CPU ]; then 
 CPU=1
fi

if [ ! -f $dir/$b.dict ]; then
 java -jar $PICARD CreateSequenceDictionary \
 R=$GENOME OUTPUT=$dir/$b.dict
fi

if [ ! $PBS_ARRAYID ]; then
 PBS_ARRAYID=$1;
fi

if [ ! $PBS_ARRAYID ]; then
 PBS_ARRAYID=1;
fi

if [ "$PBS_ARRAYID" -gt "3" ]; then
 echo "JOB ID is $PBS_ARRAYID must be 1-3"
 exit  
fi

if [ "$PBS_ARRAYID" -lt "1" ]; then 
  echo "JOB ID is $PBS_ARRAYID must be 1-3" 
  exit
fi

N=`sed -n $PBS_ARRAYID"p" pools.txt`
SAMPNAME=`echo $N | awk '{print $1}'`
POOLSIZE=`echo $N | awk '{print $2}'`

N=$INDIR/$SAMPNAME.realign.bam
O=$SAMPNAME
echo "$O $N"
echo "POOLSIZE = $POOLSIZE"

if [ ! -f $OUTDIR/$O.g.vcf ]; then
java -Xmx$MEM"g" -jar $GATK \
  -T HaplotypeCaller \
  -ERC GVCF \
  -ploidy $POOLSIZE \
  -I $N -R $GENOME \
  -o $OUTDIR/$O.g.vcf -nct $CPU
fi
