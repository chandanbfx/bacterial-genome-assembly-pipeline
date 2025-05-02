configfile: "config/config.yaml"

# Include all modules
include: "rules/correction.smk"
include: "rules/trimming.smk" 
include: "rules/assembly.smk"
include: "rules/polishing.smk"
include: "rules/annotation.smk"

rule all:
    input:
        expand("assembly/{sample}/annotation.tar.gz", sample=config["samples"]),
        expand("{sample}/stats/raw_Assembly_stats.txt", sample=config["samples"]),
        expand("{sample}/stats/Assembly_polished2_stats.txt", sample=config["samples"]),
        expand("{sample}/stats/raw_Assembly_stats.txt", sample=config["samples"])
