process downloadNcbiZip {
    input:
    tuple val(accession_id), val(taxon), val(coverage)
    
    output:
    path "${taxon}-${accession_id}.zip", emit: archive
    
    script:
    """
    echo "Downloading data from NCBI"
    datasets download genome accession ${accession_id} --filename ${taxon}-${accession_id}.zip
    """
}
}