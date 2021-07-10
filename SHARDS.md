# Building ICU Shards

The ICU is divided by locales and features. <br/>

By locale:
- EFIGS (en, fr, it, de, es)
- CJK (zh, ja, ko)
- no CJK (all locales except for zh, ja, ko)

By features:
- Collation
- Normalization
- Currency
- Locales
- Zones

To generate ICU shards run:

`make -C ./eng -f icu.mk shards`

which will build all shards from filter files available in `icu-filters/` as well as `icu-dictionary.json`, which maps each parent locale (i.e. en) to relevant files.

## ICU dictionary
The ICU dictionary is divided into the following format:

```
{
  "en": {
    "essentials": [ 
      icudt_currency.dat,
      icudt_normalization.dat,
      icudt_base.dat
    ]
    "zones": [ relevant timezone data files ],
    "locales": [ relevant locale data files ],
    "coll": [ relevant collationd data files ]
  }
  .
  .
  .
}
```

To generate just the ICU dictionary run:

`make -C ./eng -f icu.mk icu_dictionary.json`

The dictionary is packaged with the data files to be consumed later by the WASM runtime.
