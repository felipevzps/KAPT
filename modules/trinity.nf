process trinity {
    input:
        path(trimmed_fastq_files)

    output:
        path("trinity_out_dir.Trinity.fasta")

    script:
        """
        Trinity --seqType fq --max_memory ${task.memory.toGiga()}G \
        --left ${trimmed_fastq_files.findAll{ it.name.contains('_1') || it.name.contains('_R1') }.join(',')} \
        --right ${trimmed_fastq_files.findAll{ it.name.contains('_2') || it.name.contains('_R2') }.join(',')} \
        --CPU $task.cpus \
        --output trinity_out_dir
        """
}
