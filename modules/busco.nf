process busco {
    input:
        path(transcripts_fasta)
 
    output:
        path("busco_results")

    script:
        """
        busco -i ${transcripts_fasta} \
        -o busco_results \
        -m transcriptome \
        -l rhodophyta_odb12 \
        --cpu $task.cpus \
        """
}
