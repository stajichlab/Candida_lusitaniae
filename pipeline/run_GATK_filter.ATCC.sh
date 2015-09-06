#PBS -l nodes=1:ppn=1,mem=16gb  -N ATCC.filt -j oe

module load gatk/3.4-46
module load java

INFILE=Variants/C_lus.ATCC.vcf
FILTERED=Variants/C_lus.filtered.ATCC.vcf
SELECTED=Variants/C_lus.selected.ATCC.vcf
GENOME=/bigdata/stajichlab/shared/projects/Candida/HMAC/Clus_reseq/Aln/ATCC_Ref/candida_lusitaniae_ATCC_42720.fasta
SNPONLY=Variants/C_lus.SNPONLY.ATCC.vcf
INDELONLY=Variants/C_lus.INDELONLY.ATCC.vcf

if [ ! -f $FILTERED ]; then
java -Xmx3g -jar $GATK \
-T VariantFiltration -o $FILTERED \
--variant $INFILE -R $GENOME \
--clusterWindowSize 10  -filter "QD<2.0" -filterName QualByDepth \
-filter "MQ<=40.0" -filterName MapQual \
-filter "QUAL<100" -filterName QScore \
#-filter "MQRankSum < -12.5" -filterName MQRankSum \
 -filter "MQRankSum < -12.5" -filterName MapQualityRankSum \
-filter "SOR > 4.0" -filterName StrandOddsRatio \
#-filter "MQ0>=10 && ((MQ0 / (1.0 * DP)) > 0.1)" -filterName MapQualRatio \
-filter "FS>60.0" -filterName FisherStrandBias 
#-filter "HaplotypeScore > 13.0" -filterName HaplotypeScore
fi

if [ ! -f $SELECTED ]; then
java -Xmx16g -jar $GATK \
   -R $GENOME \
   -T SelectVariants \
   --variant $FILTERED \
   -o $SELECTED \
   --exclude_sample_name Sample1 --exclude_sample_name Sample22 --exclude_sample_name Sample23 --exclude_sample_name Sample24 \
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
   -selectType SNP -selectType MNP 
fi

if [ ! -f $INDELONLY ]; then
java -Xmx16g -jar $GATK \
   -R $GENOME \
   -T SelectVariants \
   --variant $SELECTED \
   -o $INDELONLY \
   --excludeFiltered  \
  -selectType INDEL -selectType MIXED
fi

