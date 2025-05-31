process transrate {
    input:
        path(transcripts_fasta)
    
    output:
        path("transrate_results/assemblies.csv")
    
    script:
        """
        transrate --assembly ${transcripts_fasta} \
        --threads $task.cpus \
        --output transrate_results
        """
}
