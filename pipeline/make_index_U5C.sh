module load java
module load picard

# support for reindexing where needed
for file in bam_U5C/*.bam
do
 java -jar $PICARD/BuildBamIndex.jar I=$file
done
