process eggNOG_mapper {
    label "process_medium"

    input:
        path(proteins_fasta)
    
    output:
        path("eggnog_annotations*")
    
    script:
        """
        emapper.py -i ${proteins_fasta} \
        --output eggnog_annotations \
        --cpu $task.cpus \
        --override \
        -m diamond \
        --data_dir ${params.eggnog_db_path}
        """
}
