process MMSeqs2 {
    label "process_medium"

    input:
        path(trinity_fasta)
 
    output:
        path("clustered_transcripts.fasta")

    script:
        """
        mmseqs createdb ${trinity_fasta} transcripts_db
        mmseqs cluster transcripts_db clustered_db tmp --min-seq-id 0.9 --cov-mode 2 --cluster-mode 2 -c 0.8 --threads $task.cpus
        mmseqs createsubdb clustered_db transcripts_db rep_seq_db
        mmseqs convert2fasta rep_seq_db clustered_transcripts.fasta
        
        rm -rf tmp transcripts_db* clustered_db* rep_seq_db*
        """
}
