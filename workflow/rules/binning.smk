rule binning:
    input:
        assembly=lambda wc: f"{config['output']['assembly']['spades']}/{wc.sample}_assembly/contigs.fasta",
        r1=lambda wc: f"{config['output']['qc']['read_qc']}/{wc.sample}/final_pure_reads_1.fastq",
        r2=lambda wc: f"{config['output']['qc']['read_qc']}/{wc.sample}/final_pure_reads_2.fastq"
    output:
        dir=lambda wc: f"{config['output']['assembly']['binning']}/{wc.sample}_binning"
    threads: 12
    conda: "../envs/metawrap.yaml"
    shell:
        r"""
        mkdir -p {config[output][assembly][binning]}
        metawrap binning \
          -o {output.dir} \
          -t {threads} \
          -a {input.assembly} \
          --metabat2 --maxbin2 --concoct \
          {input.r1} {input.r2}
        """
