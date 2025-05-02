rule canu_assemble:
    input:
        trimmed="assembly/{sample}/trimming.tar.gz"
    output:
        assembly=directory("assembly/{sample}/assembly"),
        tarball="assembly/{sample}/assembly.tar.gz",
        raw_assembly="{sample}/Assembly/{sample}.contigs.fasta"
    params:
        genome=config["assembly"]["genome_size"],
        error=config["assembly"]["assembly"]["error_rate"],
        min_len=config["assembly"]["assembly"]["min_read_length"],
        min_ovl=config["assembly"]["assembly"]["min_overlap"],
        mer=config["assembly"]["assembly"]["mer_distinct"]
    resources:
        threads=config["resources"]["assembly"]["threads"],
        mem_gb=config["resources"]["assembly"]["mem_gb"]
    conda: "../envs/assembly.yaml"
    shell:
        """
        tar -xzf {input.trimmed}
        canu -assemble \
        -p {wildcards.sample} \
        -d {output.assembly} \
        genomeSize={params.genome} \
        correctedErrorRate={params.error} \
        minReadLength={params.min_len} \
        minOverlapLength={params.min_ovl} \
        utgOvlMerDistinct={params.mer} \
        -nanopore-corrected assembly/{wildcards.sample}/trimming/{wildcards.sample}.trimmedReads.fasta.gz
        tar -czf {output.tarball} {output.assembly}
        """
