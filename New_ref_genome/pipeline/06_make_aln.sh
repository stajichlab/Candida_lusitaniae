#PBS -j oe -N vcf.to.tree -l nodes=1:ppn=2,mem=2gb
module load vcftools
module load fasttree
for file in *.SNPONLY.vcf
do
 b=`basename $file .vcf`
 if [ ! -f $b.tab ]; then
  vcf-to-tab < $file > $b.tab
  perl ~jstajich/src/genome-scripts/popgen/vcftab_to_fasta.pl --noref $b.tab
  FastTreeMP -nt -gtr -gamma < $b.fas > $b.nj.tre
 fi
done
