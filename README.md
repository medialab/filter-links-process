# Post process Twitter "filter links" datasets

- Process domain names extraction from links from datasets with missing info (2023-01 + 2023-02)

```
bash add_missing_domains.sh SOURCE_FILE
```

- Multiproc extraction of `france_datetime, hash_user, link, domain, retweet_count, to_hash_user` for all months

```
bash build_light_exports.sh
```

