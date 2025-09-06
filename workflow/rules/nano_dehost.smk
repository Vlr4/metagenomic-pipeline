rule nano_dehost:
    input:
        fastq = lambda wildcards: f"{config['input']['long_reads']}/{wildcards.sample}.fastq",
        ref = config["reference"]["human"]
    output:
        sam = f"{config['output']['dehost']['sam']}/{{sample}}.sam",
        unmapped = f"{config['output']['dehost']['sam']}/{{sample}}.unmapped.names",
        copied = f"{config['output']['dehost']['result']}/{{sample}}.unmapped.names",
        dehosted = f"{config['output']['dehost']['sam']}/nano.{{sample}}.dehost.fq.gz"
    threads: config["threads"]["dehost"]
#    conda: "../envs/nanopore.yaml"
    shell:
        """
        source activate nanosoft
        mkdir -p {config[output]['dehost']['sam']} {config[output]['dehost']['result']}
        minimap2 {config[minimap2][options]} -t {threads} {input.ref} {input.fastq} > {output.sam}
        awk '($2==4) {{print $1}}' {output.sam} > {output.unmapped}
        cp {output.unmapped} {output.copied}
        seqkit grep -f {output.unmapped} {input.fastq} > tmp.{wildcards.sample}.fq
        gzip -c tmp.{wildcards.sample}.fq > {output.dehosted}
        rm tmp.{wildcards.sample}.fq
        """