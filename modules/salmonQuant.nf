process salmonQuant {
    label "process_medium"

    input:
        tuple val(run), path(trimmed_reads), path(salmon_index)

    output:
        tuple val(run), path("${run}/quant.sf")

    script:
        """
        salmon quant -i $salmon_index -l A \
        -1 ${trimmed_reads[0]} \
        -2 ${trimmed_reads[1]} \
        -o ${run} \
        -p $task.cpus \
        --validateMappings
        """
}
