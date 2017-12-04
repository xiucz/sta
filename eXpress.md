results.xprs结果描述：
```
    bundle_id - The bundle that the particular target belongs to
    target_id - The name of the target from the multi-FASTA annotation
    length - The true length of the target sequence
    effective length - The length adjusted for biases
    total counts - The number of fragments that mapped to this target
    unique counts - The number of unique fragments that mapped to this target
    estimated counts - The number of counts estimated by the online EM algorithm
    effective counts - The number of fragments adjusted for biases: est_counts * length / effective_length
    alpha - Beta-Binomial alpha parameter
    beta - Beta-binomial beta parameter
    FPKM - Fragments Per Kilobase per Million Mapped. Proportional to (estimated counts) / (effective length)
    FPKM low
    FPKM high
    solveable flag - Whether or not the likelihood has a unique solution
```