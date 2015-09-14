# -*- coding: utf-8 -*-
fr = Language.create(code: "fr", name: "Francais")
de = Language.create(code: "de", name: "Deutch")
en = Language.create(code: "en", name: "English")

Country.create(region_code: "150", code2: "fr", code3: "fra", name: "France", language: fr)
Country.create(region_code: "150", code2: "fr", code3: "fra", name: "France", language: en)
Country.create(region_code: "150", code2: "fr", code3: "fra", name: "Frankreich", language: de)

Country.create(region_code: "150", code2: "gb", code3: "gbr", name: "Royaume-Uni", language: fr)
Country.create(region_code: "150", code2: "gb", code3: "gbr", name: "United-Kingdom", language: en)
Country.create(region_code: "150", code2: "gb", code3: "gbr", name: "Vereinigtes Königreich", language: de)

Country.create(region_code: "150", code2: "de", code3: "deu", name: "Allemagne", language: fr)
Country.create(region_code: "150", code2: "de", code3: "deu", name: "Germany", language: en)
Country.create(region_code: "150", code2: "de", code3: "deu", name: "Deutschland", language: de)

