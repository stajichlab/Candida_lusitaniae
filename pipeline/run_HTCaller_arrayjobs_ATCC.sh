#PBS -l nodes=1:ppn=16,mem=32gb,walltime=24:00:00  -j oe -N HTC.ATCC

module load java
module load GATK/3.4.0
module load picard
INDIR=Aln/bam_ATCC
GENOME=/shared/stajichlab/projects/HMAC/Clus_reseq/Aln/ATCC_Ref/candida_lusitaniae_ATCC_42720.fasta
OUTDIR=Variants/ATCC
b=`basename $GENOME .fasta`
dir=`dirname $GENOME`

CPU=$PBS_NP

if [ ! $CPU ]; then 
 CPU=1
fi

if [ ! -f $dir/$b.dict ]; then
 java -jar $PICARD/CreateSequenceDictionary.jar \
 R=$GENOME OUTPUT=$dir/$b.dict
fi

if [ ! $PBS_ARRAYID ]; then
 PBS_ARRAYID=1;
fi

N=`ls $INDIR/*.realign.bam | head -n $PBS_ARRAYID | tail -n 1`
O=`basename $N .realign.bam`

if [ ! -f $OUTDIR/$O.g.vcf ]; then
java -Xmx32g -jar $GATK \
  -T HaplotypeCaller \
  -ERC GVCF \
  -ploidy 1 \
  -I $N -R $GENOME \
  -o $OUTDIR/$O.g.vcf -nct $CPU
fi
