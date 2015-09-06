#PBS  -l nodes=1:ppn=32,mem=128gb -N GATK.GVCFGeno -j oe
MEM=128g
module load java
module load gatk/3.4-46
module load picard

GENOME=/bigdata/stajichlab/shared/projects/Candida/HMAC/Clus_reseq/Aln/ATCC_Ref/candida_lusitaniae_ATCC42720_w_CBS_6936_MT.fasta
INDIR=Variants/ATCC_MTfix
OUT=Variants/C_lus.ATCCMTfix.vcf
CPU=1
if [ $PBS_NUM_PPN ]; then
 CPU=$PBS_NUM_PPN
fi

N=`ls $INDIR/*.g.vcf | perl -p -e 's/\n/ /; s/(\S+)/-V $1/'`

java -Xmx$MEM -jar $GATK \
    -T GenotypeGVCFs \
    -R $GENOME \
    $N \
    -o $OUT \
    -nt $CPU 
