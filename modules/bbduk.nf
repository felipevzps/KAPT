process bbduk {
    input:
        tuple val(run), path(fastq_read_list)

    output:
        tuple val(run), path("trimmed_*")

    script:
        """
        bbduk.sh in1=${fastq_read_list[0]} in2=${fastq_read_list[1]} \
        out1=trimmed_${fastq_read_list[0]} out2=trimmed_${fastq_read_list[1]} \
        ref=adapters,artifacts ktrim=r k=23 mink=11 hdist=1 tpe tbo \
        threads=$task.cpus \
        -Xmx${task.memory.toGiga()}g
        """
}
