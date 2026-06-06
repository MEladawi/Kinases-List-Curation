# Data sources

All inputs for `build_kinases.R`. Filenames are version-less; the exact version/date of
each file used in a run is recorded automatically in `data_out/source_versions.tsv` and in
the workbook README. Every source is auto-fetchable: `build_kinases.R` refreshes them (at
most once per day) via `helper_code/source_registry.R`. Set `REFRESH_SOURCES <- FALSE` for
an offline, reproducible rerun of the cached files.

| Local file | Source | Auto-fetch URL |
|---|---|---|
| `hgnc_complete_set.txt` | HGNC complete set (identifier bridge) | https://ftp.ebi.ac.uk/pub/databases/genenames/hgnc/tsv/hgnc_complete_set.txt |
| `pkinfam.txt` | UniProt pkinfam (curated protein kinome) | https://ftp.uniprot.org/pub/databases/uniprot/current_release/knowledgebase/complete/docs/pkinfam.txt |
| `go_mf_genesets_ensembl.gmt` | GO molecular-function gene sets, Ensembl-keyed (Bader Lab EM_Genesets) | https://download.baderlab.org/EM_Genesets/current_release/Human/ensembl/GO/Human_GO_mf_with_GO_iea_ensembl.gmt |
| `kinase.com_manning_list.xls` | Manning human kinome (kinase.com, 2002) | https://raw.githubusercontent.com/IDG-Kinase/DarkKinaseTools/master/data-raw/dark_kinases/kinase.com_list.xls |
| `kinhub_kinases.html` | KinHub human kinase list (kinhub.org; Eid et al. 2017) | http://www.kinhub.org/kinases.html |
| `uniprot_kinase_KW-0418_human.tsv` | UniProtKB reviewed human, keyword KW-0418 "Kinase" | https://rest.uniprot.org/uniprotkb/stream?query=(organism_id:9606)AND(reviewed:true)AND(keyword:KW-0418) |
| `IDG_dark_kinase_list.csv` | IDG understudied ("dark") kinome | https://github.com/IDG-Kinase/DarkKinaseTools (data-raw/dark_kinases/Dark Kinase List.csv) |

Notes
- HGNC is the sole identifier authority: pkinfam / Manning / KinHub / UniProt-KW / IDG are
  mapped to a base Ensembl gene ID through HGNC (by Entrez, then UniProt accession, then
  current/alias/previous symbol). The GO gene sets are already Ensembl-keyed, so they need
  no mapping.
- Kinase taxonomy (group / family / subfamily) is primarily the actively-curated UniProt
  `protein_families` classification (group + subfamily), with the Manning intermediate
  "family" tier from KinHub/kinase.com; each field is filled UniProt -> KinHub -> kinase.com.
  KinHub (2017) and kinase.com (2002) are static, so UniProt is what keeps current kinases
  assigned to the (fixed) Manning scheme.
- Resolution guards against stale source identifiers: a candidate that is an RNA-gene locus,
  or whose HGNC symbol history disagrees with the source symbol, is rejected in favour of a
  consistent hit (see `helper_code/hgnc_bridge.R`).
- Downstream: match your data on base Ensembl ID (preferred) or HGNC symbol. If matching
  on symbols, updating outdated symbols first (e.g. `HGNChelper::checkGeneSymbols()`) avoids
  misses; matching on Ensembl IDs avoids the symbol-versioning problem entirely.
