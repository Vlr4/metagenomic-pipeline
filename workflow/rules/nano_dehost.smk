rule nano_dehost:
    input:
        fastq=lambda wildcards: f"{config['input']['long_reads']}/{wildcards.sample}.qcat.fastq",
        ref=config["reference"]["human"]
    output:
        sam=lambda wildcards: f"{config['output']['dehost']['sam']}/{wildcards.sample}.sam",
        unmapped=lambda wildcards: f"{config['output']['dehost']['sam']}/{wildcards.sample}.unmapped.names",
        copied=lambda wildcards: f"{config['output']['dehost']['result']}/{wildcards.sample}.unmapped.names",
        dehosted=lambda wildcards: f"{config['output']['dehost']['sam']}/nano.{wildcards.sample}.dehost.fq.gz"
    threads: config["threads"]["dehost"]
    conda: "../envs/dehost.yaml"
    shell:
        """
        mkdir -p {config[output][dehost][sam]} {config[output][dehost][result]}
        minimap2 {config[minimap2][options]} -t {threads} {input.ref} {input.fastq} > {output.sam}
        awk '($2==4) {{print $1}}' {output.sam} > {output.unmapped}
        cp {output.unmapped} {output.copied}
        seqkit grep -f {output.unmapped} {input.fastq} > tmp.{wildcards.sample}.fq
        gzip -c tmp.{wildcards.sample}.fq > {output.dehosted}
        rm tmp.{wildcards.sample}.fq
        """