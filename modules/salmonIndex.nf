process salmonIndex {
    label "process_low"

    input:
        path(reference_transcriptome)

    output:
        path("salmon_index"), emit: index_dir

    script:
        """
        salmon index -t $reference_transcriptome -i salmon_index
        """
}
