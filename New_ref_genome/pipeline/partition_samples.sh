module load bcftools 
bcftools view -S samplesA.txt C_lus.S9_ref.SNPONLY.vcf > C_lus.S9_ref.SNPONLY.samplesA.vcf
 bcftools view -S samplesB.txt C_lus.S9_ref.SNPONLY.vcf > C_lus.S9_ref.SNPONLY.samplesB.vcf
 bcftools view -S samplesAB.txt C_lus.S9_ref.SNPONLY.vcf > C_lus.S9_ref.SNPONLY.samplesAB.vcf
 bcftools view -S samplesC.txt C_lus.S9_ref.SNPONLY.vcf > C_lus.S9_ref.SNPONLY.samplesC.vcf
