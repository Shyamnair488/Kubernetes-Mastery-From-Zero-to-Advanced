# Answers (spoiler!)
1. `broken-1`: tag `1.99.99` doesn't exist → use `nginx:1.27`. (`describe` → ErrImagePull)
2. `broken-2`: command exits 1 → fix command / use `sleep 3600`. (`logs --previous`)
3. `broken-3`: requests exceed any node → lower to e.g. cpu 100m, mem 128Mi. (`describe` → Insufficient cpu/memory)
4. `broken-4`: Service selector `broken-four` ≠ label `broken-4` → fix selector. (`get endpoints` empty)
5. `broken-5`: readiness path `/does-not-exist` returns 404 → use `/`. (READY 0/1)
6. `broken-6`: ConfigMap `ghost-config` missing → create it (`CreateContainerConfigError`) or remove `envFrom`.
