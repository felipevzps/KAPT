process multiqc {
    label "process_low"

    input:
        path(fastqc_dirs)

    output:
        path("multiqc_report.html")

    script:
        """
        multiqc ${fastqc_dirs.join(' ')}
        """
}
