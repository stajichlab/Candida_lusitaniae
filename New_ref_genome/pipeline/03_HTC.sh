#PBS -l nodes=1:ppn=16,mem=32gb,walltime=24:00:00  -j oe -N HTC.ATCC

module load picard
INDIR=bam
GENOME=/bigdata/stajichlab/shared/projects/Candida/HMAC/Clus_reseq/New_ref_assembly/ref/S9.fasta
OUTDIR=Variants
LIST=samples.info
b=`basename $GENOME .fasta`
dir=`dirname $GENOME`
mkdir -p $OUTDIR
CPU=$PBS_NUM_PPN

if [ ! $CPU ]; then 
 CPU=1
fi

if [ ! -f $dir/$b.dict ]; then
 module load picard
 java -jar $PICARD CreateSequenceDictionary \
 R=$GENOME OUTPUT=$dir/$b.dict \
 SPECIES="Candida lusitaniae" TRUNCATE_NAMES_AT_WHITESPACE=true
 module unload picard
fi

if [ ! $PBS_ARRAYID ]; then
 PBS_ARRAYID=1;
fi
# guarantee java 7 is running not java 8
module load gatk
module list
java -version

O=$(sed -n ${PBS_ARRAYID}p $LIST | awk '{print $1}')

BAM=$INDIR/$O.realign.bam
if [ ! -f $BAM ]; then
 echo "No $BAM file"
 exit
fi


if [ ! -f $OUTDIR/$O.g.vcf ]; then
java -Xmx32g -jar $GATK \
  -T HaplotypeCaller \
  --max_alternate_alleles 10 \
  -stand_emit_conf 10 -stand_call_conf 30 \
  -ERC GVCF \
  -ploidy 1 \
  -I $BAM -R $GENOME \
  -o $OUTDIR/$O.g.vcf -nct $CPU
fi
