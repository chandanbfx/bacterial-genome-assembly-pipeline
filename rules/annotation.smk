rule annotate:
    input:
        polished="assembly/{sample}/Polished2/{sample}_polished2.fasta"
    output:
        annotation=directory("assembly/{sample}/annotation"),
        tarball="assembly/{sample}/annotation.tar.gz",
        txt="{sample}/Annotation/FinalAssembly.txt"
    resources:
        threads=config["resources"]["annotation"]["threads"],
        mem_gb=config["resources"]["annotation"]["mem_gb"]
    conda: "../envs/annotation.yaml"
    shell:
        """
        prokka \
        --outdir {output.annotation} \
        --prefix {wildcards.sample} \
        --cpus {resources.threads} \
        {input.polished}
        tar -czf {output.tarball} {output.annotation}
        """

rule stats:
    input:
        raw_assembly="{sample}/Assembly/{sample}.contigs.fasta", 
        pol1="assembly/{sample}/polished/{sample}.polished1.fasta",
        pol2="assembly/{sample}/Polished2/{sample}_polished2.fasta",
        Ann="{sample}/Annotation/FinalAssembly.txt",
        pl=config["stats"]
    output:
        first="{sample}/stats/raw_Assembly_stats.txt",
        pol1="{sample}/stats/Assembly_polished1_stats.txt",
        pol2="{sample}/stats/Assembly_polished2_stats.txt"
    resources:  mem_mb = config["statRam"], disk_mb = config["statDisk"]
    threads: config.get("statThreads")
    conda:
        "environment.yaml"
    shell:
        "perl {input.pl} {input.raw_assembly} > {output.first} && perl {input.pl} {input.pol1} > {output.pol1} && perl {input.pl} {input.pol2} > {output.pol2}"
