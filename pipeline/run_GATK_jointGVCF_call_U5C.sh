#PBS  -l nodes=1:ppn=24,mem=80gb -N GATK.GVCFGeno -j oe
MEM=80
module load java
module load GATK/3.4.0
module load picard

GENOME=/shared/stajichlab/projects/Candida/HMAC/Clus_reseq/Aln/U5C_Ref/candida_lusitaniae_U5C.fasta
INDIR=Variants/U5C
OUT=Variants/C_lus.U5C.vcf
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
