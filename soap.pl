
die "perl $0 fq.list out_prefix\n
perl $0 fq.list /Disk04/Project/Micro/liyanli/A540_BeeMetaGenome/07.map/soap
" unless(@ARGV==2);

my $file=shift;
my $prefix=shift;
my $soap="/System/Pipline/DNA/DNA_Micro/MetaGenome_pipeline/MetaGenome_pipeline_V2.2/software/QC/soap2.21/soap2.21";
#my $ref="/Disk04/Project/Micro/liyanli/A552_BeeMetaTranscriptome/ref/rRNA.ref.fa.index";
#my $ref="/Disk04/Project/Micro/liyanli/A540_BeeMetaGenome/beeGenome/total.bee.genome.fa.index";
my $ref="/Disk04/Project/Micro/liyanli/A540_BeeMetaGenome/07.map/ref/gs.fa.index";
my $submit="";
my $node=17;

open I, $file or die $!;
while(<I>){
        chomp;
        my ($sid,$fq1,$fq2)=split;
        my $outdir=$prefix."/$sid";
        if(! -e $outdir){
                `mkdir $outdir`;
        }
        open OUT, ">$outdir/$sid.soap.sh" or die $!;
#       print OUT "$soap -l 40  -m  200 -x 500   -v 4 -r 1 -p  6  -D $ref   -a $fq1 -b $fq2 -o $outdir/$sid.pe.soap -2 $outdir/$sid.
        print OUT "$soap -l 40  -m  200 -x 800   -v 4 -r 1 -p  12  -D $ref   -a $fq1 -b $fq2 -o $outdir/$sid.pe.soap -2 $outdir/$sid
        $submit.="cd $outdir\n";
        $submit.="qsub -cwd -l h=tgs-".$node." -q tmp1.q -P tmp1 $outdir/$sid.soap.sh\n";
        $node++;
        if($node>19){
                $node=17;
        }
}

open O,">submit.sh" or die $!;
print O "$submit\n";

