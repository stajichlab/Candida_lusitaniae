#PBS  -l nodes=1:ppn=8,mem=4gb -N GATK.GVCFGeno.all -j oe
MEM=4g
module load java
module load gatk
module load tabix
GENOME=/bigdata/stajichlab/shared/projects/Candida/HMAC/Clus_reseq/New_ref_assembly/ref/S9.fasta
INDIR=Variants
OUT=C_lus.S9_ref.vcf
CPU=1
if [ $PBS_NUM_PPN ]; then
 CPU=$PBS_NUM_PPN
fi
rm -f $INDIR/*.idx

for file in $INDIR/*.g.vcf
do
 bgzip $file
 tabix $file.gz
done
N=$(perl -p -e 's/\n/ /; s/(\S+)/-V Variants\/$1.g.vcf.gz/;' samplesABC.txt)

java -Xmx$MEM -jar $GATK \
    -T GenotypeGVCFs \
    -R $GENOME \
    $N \
    -o $OUT \
    -nt $CPU 
