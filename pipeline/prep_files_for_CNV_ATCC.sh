#PBS -l nodes=1:ppn=1,mem=4gb -j oe -N prepCNV
module load cnv-seq
module load samtools
OUT=CNV/ATCC
REF=Sample1
GENOMESIZE=12114892
mkdir -p $OUT

for file in Aln/bam_ATCC/*.realign.bam
do
 b=`basename $file .realign.bam`
 if [ ! -f $OUT/$b.hits ]; then
  samtools view -F 4 $file | perl -lane 'print "$F[2]\t$F[3]"' > $OUT/$b.hits
 fi
done

cd $OUT
for n in `ls *.hits | grep -v Sample1.hits`
do
 cnv-seq.pl --ref $REF.hits --test $n --genome-size $GENOMESIZE
done

cd ..
