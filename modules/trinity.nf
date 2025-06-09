process trinity {
    input:
        path(trimmed_fastq_files)

    output:
        path("trinity_out_dir.Trinity.fasta")

    script:
        """
        # fix sequence id format by removing spaces
        for file in ${trimmed_fastq_files.findAll{ it.name.contains('_1') || it.name.contains('_R1') }.join(' ')}; do
            zcat \$file | sed 's/ .*/\\/1/' | gzip > fixed_\$file
        done
        
        for file in ${trimmed_fastq_files.findAll{ it.name.contains('_2') || it.name.contains('_R2') }.join(' ')}; do
            zcat \$file | sed 's/ .*/\\/2/' | gzip > fixed_\$file
        done
        
        Trinity --seqType fq --max_memory ${task.memory.toGiga()}G \
        --left \$(ls fixed_*_1*.fastq.gz | tr '\\n' ',' | sed 's/,\$//') \
        --right \$(ls fixed_*_2*.fastq.gz | tr '\\n' ',' | sed 's/,\$//') \
        --CPU $task.cpus \
        --output trinity_out_dir
        """
}
