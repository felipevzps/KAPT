process busco {
    label "process_medium"

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
        --download_path ${params.busco_db_path} \
        --offline \
        --cpu $task.cpus \
        """
}
