#PBS  -l nodes=1:ppn=24,mem=128gb -N GATK.GVCFGeno -j oe
MEM=128g
module load java
module load gatk/3.4-46
module load picard

GENOME=/bigdata/stajichlab/shared/projects/Candida/HMAC/Clus_reseq/Aln/ATCC_Ref/candida_lusitaniae_ATCC_42720.fasta
INDIR=Variants/ATCC
OUT=Variants/C_lus.ATCC.vcf
CPU=1
if [ $PBS_NP ]; then
 CPU=$PBS_NP
fi

N=`ls $INDIR/*.g.vcf | perl -p -e 's/\n/ /; s/(\S+)/-V $1/'`

java -Xmx128g -jar $GATK \
    -T GenotypeGVCFs \
    -R $GENOME \
    $N \
    -o $OUT \
    -nt $CPU 
