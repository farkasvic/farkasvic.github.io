# Meddata presentation slides

This folder holds PNG exports of each slide from `Meddata_Presentation.pptx` for the projects page carousel.

## Generate the images

**Option 1 – Automated (requires LibreOffice):**

```bash
brew install --cask libreoffice   # if not installed
./scripts/convert_meddata_to_images.sh
```

**Option 2 – Manual (PowerPoint):**

1. Open `assets/Meddata_Presentation.pptx` in PowerPoint
2. File → Save As → choose **PNG Portable Network Graphics (.png)**
3. Choose **All Slides**
4. Save into this folder (`assets/meddata_slides/`)
5. Rename the files to `slide_1.png`, `slide_2.png`, … `slide_19.png`
