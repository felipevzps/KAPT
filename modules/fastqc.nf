process fastqc {
    label "process_low"

    input:
        tuple val(run), path(fastq_read_list)

    output:
        tuple val(run), path("*_fastqc")

    script:
        def read_fastqc_names = fastq_read_list.collect { it.toString().replace('.fastq.gz', '_fastqc') }
        """
        mkdir -p ${read_fastqc_names[0]} ${read_fastqc_names[1]}
        fastqc -o ${read_fastqc_names[0]} ${fastq_read_list[0]} -t $task.cpus
        fastqc -o ${read_fastqc_names[1]} ${fastq_read_list[1]} -t $task.cpus 
        """
}
