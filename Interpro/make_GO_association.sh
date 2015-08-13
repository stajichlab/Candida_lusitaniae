#PBS -j oe
module load perl

perl /rhome/jstajich/src/genome-scripts/annotation/make_GOassociation_file_from_interpro.pl --go /srv/projects/db/GO/current/go.obo -i candida_lusitaniae_1_proteins.Interpro.tsv -o candida_lusitaniae_1_proteins.Interpro.GO_association -s "Candida lusitaniae" 
