# SocialFrame v3

Volgende iteratie van [SocialFrame v2](https://github.com/erikotn/socialframe-v2) met twee grote toevoegingen voor concept- en presentatie-werk:

1. **Bulk-mockups uit een spreadsheet** — plak een TSV (uit Claude of Sheets), krijg een ZIP met alle PNG's terug
2. **Rich image placeholder** — als je nog geen foto hebt, render een zwart vlak met daarin de briefing-tekst voor de vormgever én de tekst die op het beeld moet komen

V2 blijft live en stabiel als fallback. V3 deelt de Supabase-backend en `brand_kits`-tabel met v2, maar slaat designs op in een aparte `designs_v3`-tabel zodat libraries niet door elkaar lopen.

## Bulk-flow in één minuut

1. Open de **Bulk**-tab (5e tab in de sidebar)
2. Kies brand, platform, format (in Simple-mode) — staat dan vast voor de hele batch
3. Klik **📋 Kopieer Claude-prompt** → plak in Claude → vraag om N variaties
4. Plak Claude's TSV-output terug in de textarea
5. (optioneel) Sleep een gedeelde foto in het foto-veld, óf sleep een hele map met foto's in de **foto-pool**
6. Bekijk de validatie-tabel — vink rijen aan/uit
7. Klik **Genereer ZIP** — alles wordt in één keer gerenderd, gepackt en gedownload + `_report.txt` met issues per rij

## TSV-kolommen

### Simple-mode (default)
Brand, platform, format, frame staan boven de TSV. Per rij alleen wat varieert:

```
naam	posttekst	headline	knop	url	image_filename	image_description	image_text
```

### Advanced-mode
Alles per rij. Meng platforms/brands in één batch:

```
brand	platform	format	frame	naam	posttekst	headline	knop	url	image_filename	image_description	image_text
```

### Image-resolutie per rij

- `image_filename` ingevuld + matched bestand in foto-pool → die foto wordt geplaatst
- `image_filename` leeg + Simple-mode + gedeelde foto geupload → gedeelde foto
- `image_filename` leeg + `image_description`/`image_text` ingevuld → **rich placeholder** (zwart vlak met briefing)
- `image_filename` leeg + niets anders → standaard grijs vlak

## Rich placeholder (los van bulk ook bruikbaar)

In de gewone Edit-tab, wanneer geen foto is geupload, verschijnen twee velden:
- **Beschrijving beeld** ("Stockphoto: zorgmedewerker, close-up")
- **Tekst in beeld** ("Soms ga ik leeg naar huis.")

Vul die in en het beeldvak wordt zwart met die teksten erop. Auto-sized typografie. Handig voor klantpresentaties waar de finale foto nog niet klaar is.

## Setup

Backend is gedeeld met v2 — alleen één extra tabel:

```bash
# Vanuit deze repo
supabase link --project-ref lljnruyhireravkxtxrz
cat supabase/migrations/20260507000001_init_v3.sql | supabase db query --linked
```

Edge Function is al uitgerold met `designs_v3` in de whitelist (commit in v2-repo).

## Deploy

GitHub Pages → Settings → Pages → Source: `main` branch / `/ (root)` → Save.
Live op `https://erikotn.github.io/socialframe-v3/`.

## Stack & architectuur

- React 18 + Tailwind + Babel-standalone (CDN)
- FileSaver.js + JSZip voor batch-export
- Supabase Postgres (`designs_v3` table) + Edge Function als password-gated proxy
- Eén `index.html`, geen build-step

Brand kits gedeeld met v2 via `brand_kits`-tabel. Wachtwoord is hetzelfde `SHARED_PASSWORD`-secret. Sessies losstaan via aparte `localStorage`-key.
