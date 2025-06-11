process eggNOG_mapper {
    label "process_medium"

    input:
        path(proteins_fasta)
    
    output:
        path("eggnog-mapper/*.emapper.annotations")
    
    script:
        """
        emapper.py -i ${proteins_fasta} \
        -output eggnog_annotations \
        --output_dir eggnog-mapper \
        --cpu $task.cpus \
        --override \
        -m diamond \
        --data_dir ${params.eggnog_db_path}
        """
}
