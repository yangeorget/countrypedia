fr = Language.create(code: "fr", name: "Francais")
en = Language.create(code: "en", name: "English")

Country.create(code: "FR", name: "France", language: fr)
Country.create(code: "FR", name: "France", language: en)

Country.create(code: "EN", name: "Royaume-Uni", language: fr)
Country.create(code: "EN", name: "United-Kingdom", language: en)

