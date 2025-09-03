rule bin_refinement:
    input:
        metabat2=lambda wc: f"{config['output']['assembly']['binning']}/{wc.sample}_binning/metabat2_bins",
        maxbin2=lambda wc: f"{config['output']['assembly']['binning']}/{wc.sample}_binning/maxbin2_bins",
        concoct=lambda wc: f"{config['output']['assembly']['binning']}/{wc.sample}_binning/concoct_bins"
    output:
        dir=lambda wc: f"{config['output']['assembly']['binning']}/{wc.sample}/bin_refinement"
    threads: 4
    conda: "../envs/metawrap.yaml"
    log:
        out=lambda wc: f"logs_refinement/{wc.sample}.out",
        err=lambda wc: f"logs_refinement/{wc.sample}.err"
    shell:
        r"""
        mkdir -p {output.dir}
        metawrap bin_refinement \
          -o {output.dir} \
          -A {input.metabat2} \
          -B {input.maxbin2} \
          -C {input.concoct} \
          -c 70 -x 10 \
          -t {threads} \
          1> {log.out} 2> {log.err}
        """
