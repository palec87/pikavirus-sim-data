process downloadNcbiSummary {
//   publishDir "summary_json/", mode: 'copy'

  input:
  val taxon
  
  output:
  path "summary_json/${taxon}.json", emit: json_summary
  
  script:
  """
  echo "Downloading data from NCBI"
  mkdir -p summary_json
  datasets summary genome taxon ${taxon} --assembly-level complete > summary_json/${taxon}.json
  """
}