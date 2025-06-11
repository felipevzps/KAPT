process transdecoder {
    label "process_medium"

    input:
        path(transcripts_fasta)
    
    output:
        path("${transcripts_fasta}.transdecoder.pep")
    
    script:
        """
        TransDecoder.LongOrfs -t ${transcripts_fasta}
        TransDecoder.Predict -t ${transcripts_fasta} --cpu $task.cpus
        """
}
