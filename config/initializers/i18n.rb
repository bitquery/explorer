I18n.default_locale = :en
I18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
I18n.config.enforce_available_locales = true
I18n.available_locales = [:en]

# https://apps.timwhitlock.info/emoji/tables/iso3166
LOCALE_FLAG = {
    en: {flag: "\u{1F1FA}\u{1F1F8}", name: "English"},
    zh: {flag: "\u{1F1E8}\u{1F1F3}", name: "中文"},
    ru: {flag: "\u{1F1F7}\u{1F1FA}", name: "Русский"}
}
