process salmonIndex {
    input:
        path(reference_transcriptome)

    output:
        path("salmon_index"), emit: index_dir

    script:
        """
        salmon index -t $reference_transcriptome -i salmon_index
        """
}
