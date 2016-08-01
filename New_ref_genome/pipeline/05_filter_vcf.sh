#PBS -l nodes=1:ppn=1,mem=16gb  -N vcffilter -j oe

module load gatk
module unload java
module load java/8

for BASE in C_lus.S9_ref C_lus.S9_ref.A C_lus.S9_ref.B C_lus.S9_ref.C C_lus.S9_ref.AB C_lus.S9_ref.AC
do
echo $BASE
INFILE=${BASE}.vcf
FILTERED=${BASE}.filtered.vcf
SELECTED=${BASE}.selected.vcf
GENOME=/bigdata/stajichlab/shared/projects/Candida/HMAC/Clus_reseq/New_ref_assembly/ref/S9.fasta
SNPONLY=${BASE}.SNPONLY.vcf
INDELONLY=${BASE}.INDELONLY.vcf


if [ ! -f $FILTERED ]; then
java -Xmx3g -jar $GATK \
-T VariantFiltration -o $FILTERED \
--variant $INFILE -R $GENOME \
--clusterWindowSize 10  -filter "QD<2.0" -filterName QualByDepth \
-filter "MQ<=40.0" -filterName MapQual \
-filter "QUAL<100" -filterName QScore \
-filter "MQRankSum < -12.5" -filterName MapQualityRankSum \
-filter "SOR > 4.0" -filterName StrandOddsRatio \
-filter "FS>60.0" -filterName FisherStrandBias 
#-filter "HaplotypeScore > 13.0" -filterName HaplotypeScore
#-filter "MQ0>=10 && ((MQ0 / (1.0 * DP)) > 0.1)" -filterName MapQualRatio \
#-filter "MQRankSum < -12.5" -filterName MQRankSum \
fi

if [ ! -f $SELECTED ]; then
java -Xmx16g -jar $GATK \
   -R $GENOME \
   -T SelectVariants \
   --variant $FILTERED \
   -o $SELECTED \
   -env \
   -ef \
   --excludeFiltered
fi
if [ ! -f $SNPONLY ]; then
java -Xmx16g -jar $GATK \
   -R $GENOME \
   -T SelectVariants \
   --variant $SELECTED \
   -o $SNPONLY \
   --excludeFiltered  \
   -selectType SNP #-selectType MNP 
fi

if [ ! -f $INDELONLY ]; then
java -Xmx16g -jar $GATK \
   -R $GENOME \
   -T SelectVariants \
   --variant $SELECTED \
   -o $INDELONLY \
   --excludeFiltered  \
  -selectType INDEL -selectType MIXED -selectType MNP
fi

done
