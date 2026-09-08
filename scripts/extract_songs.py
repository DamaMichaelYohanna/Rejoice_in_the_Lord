import os
import re
import json
import argparse
from pathlib import Path
from PIL import Image

def get_ocr_engine():
    """Initialize RapidOCR engine with angle classification for auto-orientation."""
    try:
        from rapidocr_onnxruntime import RapidOCR
        engine = RapidOCR(use_angle_cls=True)
        
        def run_ocr_with_rotation(img_path):
            img = Image.open(img_path)
            best_text = ""
            max_words = -1

            # Try 0, 90, 180, 270 rotations if angle_cls didn't find clear text
            for angle in [0, 90, 180, 270]:
                rotated = img.rotate(angle, expand=True) if angle != 0 else img
                temp_path = img_path + f"_temp_{angle}.jpg"
                try:
                    rotated.convert("RGB").save(temp_path, "JPEG")
                    result, elapsed = engine(temp_path)
                    if result:
                        lines = [line[1] for line in result if line and len(line) > 1 and float(line[2]) > 0.3]
                        full_text = "\n".join(lines)
                        # Count valid english/alphanumeric words
                        word_count = len(re.findall(r'[a-zA-Z]{2,}', full_text))
                        if word_count > max_words:
                            max_words = word_count
                            best_text = full_text
                finally:
                    if os.path.exists(temp_path):
                        try:
                            os.remove(temp_path)
                        except Exception:
                            pass

                # If we got a strong match with high word count (> 25 words), 0 or current angle is good
                if max_words > 30:
                    break

            return best_text
        return run_ocr_with_rotation
    except ImportError:
        pass

    try:
        import pytesseract
        def run_tesseract(img_path):
            img = Image.open(img_path)
            best_text = ""
            max_words = -1
            for angle in [0, 90, 180, 270]:
                rotated = img.rotate(angle, expand=True) if angle != 0 else img
                text = pytesseract.image_to_string(rotated)
                word_count = len(re.findall(r'[a-zA-Z]{2,}', text))
                if word_count > max_words:
                    max_words = word_count
                    best_text = text
                if max_words > 30:
                    break
            return best_text
        return run_tesseract
    except ImportError:
        pass

    raise RuntimeError("No OCR engine found. Please install rapidocr-onnxruntime or pytesseract.")

def clean_line(line):
    """Clean common OCR artifacts."""
    line = line.strip()
    line = re.sub(r'[\x00-\x1f\x7f-\x9f]', '', line)
    return line

def parse_single_song(text, filename="", default_number=""):
    """
    Parses a single song text block into song metadata.
    """
    lines = [clean_line(l) for l in text.splitlines() if clean_line(l)]
    if not lines:
        return None

    number = default_number
    title = ""
    category = "General"
    refrain = None

    # Try extracting hymn number from first few lines
    number_pattern = r'^(?:Hymn|No\.|#|SONG)?\s*(\d{1,4})\b'
    for idx in range(min(5, len(lines))):
        m = re.search(number_pattern, lines[idx], re.IGNORECASE)
        if m:
            number = m.group(1)
            rem = re.sub(number_pattern, '', lines[idx], flags=re.IGNORECASE).strip(' .-:')
            if rem and len(rem) > 2:
                title = rem
            break

    # If title not found on number line, find first non-number header line
    if not title:
        for line in lines[:5]:
            cleaned = re.sub(r'^\d+[\s\.\:-]*', '', line).strip()
            if len(cleaned) > 2 and not re.match(r'^(?:Chorus|Refrain|Verse|\d+)', cleaned, re.IGNORECASE):
                title = cleaned
                break

    if not title:
        title = Path(filename).stem.replace('_', ' ').replace('-', ' ').title()

    # Clean title from OCR typos & concatenated words
    common_concat = [
        ('ALLOF', 'All Of'), ('ALLIS', 'All Is'), ('INMY', 'In My'), ('OFMY', 'Of My'),
        ('FORYOU', 'For You'), ('GODIS', 'God Is'), ('HEIS', 'He Is'), ('OURGOD', 'Our God'),
        ('THELORD', 'The Lord'), ('TOBE', 'To Be'), ('WITHME', 'With Me'), ('WHENI', 'When I'),
        ('WHATI', 'What I'), ('ANDMY', 'And My'), ('INTOYOUR', 'Into Your'), ('SEETHE', 'See The'),
        ('THEREIS', 'There Is'), ('THISIS', 'This Is'), ('WHATA', 'What A'), ('ISMY', 'Is My'),
        ('JESUSCHRIST', 'Jesus Christ'), ('HOLYGHOST', 'Holy Ghost'), ('HOLYSPIRIT', 'Holy Spirit')
    ]
    for c_from, c_to in common_concat:
        title = title.replace(c_from, c_to)

    title = re.sub(r'^[0-9\.\s\-#]+', '', title).strip()
    if title.isupper() and len(title) > 3:
        title = title.title()
    title = re.sub(r'\bO\b', 'O', title)
    title = re.sub(r'\bI\b', 'I', title)


    blocks = []
    current_block = []

    for line in lines:
        if re.match(r'^(?:Chorus|Refrain|CHORUS|REFRAIN)[:\s]*$', line, re.IGNORECASE):
            if current_block:
                blocks.append("\n".join(current_block))
                current_block = []
            current_block.append("REFRAIN: " + line)
            continue

        if re.match(r'^(?:Verse\s*)?\d+[\.\)\:]?\s+[A-Z]', line) and current_block:
            blocks.append("\n".join(current_block))
            current_block = [line]
        else:
            current_block.append(line)

    if current_block:
        blocks.append("\n".join(current_block))

    final_stanzas = []
    refrain_lines = []

    for b in blocks:
        if b.startswith("REFRAIN:") or re.search(r'^(?:Chorus|Refrain)', b, re.IGNORECASE):
            cleaned_ref = re.sub(r'^(?:REFRAIN:|Chorus|Refrain)[:\s]*', '', b, flags=re.IGNORECASE).strip()
            if cleaned_ref:
                refrain_lines.append(cleaned_ref)
        else:
            if b.strip():
                final_stanzas.append(b.strip())

    if refrain_lines:
        refrain = "\n".join(refrain_lines)

    if not final_stanzas:
        final_stanzas = ["\n".join(lines)]

    return {
        "number": number or default_number or Path(filename).stem,
        "title": title,
        "category": category,
        "stanzas": final_stanzas,
        "refrain": refrain,
        "raw_text": text
    }

def parse_song_text(text, filename=""):
    """
    Splits page text if multiple songs exist on the same image page, then parses each.
    """
    # Detect sub-song headers e.g. "12 ALLELUIA", "13 ALL GLORY"
    song_split_pattern = r'(?=\n\s*(?:Hymn|No\.|#)?\s*\d{1,4}\s+[A-Z]{2,})'
    parts = re.split(song_split_pattern, text)
    
    songs = []
    for p in parts:
        if p.strip():
            s = parse_single_song(p.strip(), filename=filename)
            if s:
                songs.append(s)
    return songs if songs else [parse_single_song(text, filename=filename)]


def process_folder(folder_path, output_json="extracted_songs.json", append=False):
    ocr_func = get_ocr_engine()
    folder = Path(folder_path)

    valid_exts = {'.png', '.jpg', '.jpeg', '.bmp', '.webp', '.tiff'}
    image_files = sorted([p for p in folder.rglob('*') if p.suffix.lower() in valid_exts])

    print(f"Found {len(image_files)} image files in {folder_path}", flush=True)

    out_path = Path(output_json)
    out_path.parent.mkdir(parents=True, exist_ok=True)

    extracted_songs = []
    if append and out_path.exists():
        try:
            with open(out_path, 'r', encoding='utf-8') as f:
                extracted_songs = json.load(f)
            print(f"Loaded {len(extracted_songs)} existing songs to append to.", flush=True)
        except Exception as e:
            print(f"Could not load existing JSON for append: {e}", flush=True)

    song_counter = len(extracted_songs) + 1
    for idx, img_file in enumerate(image_files, 1):
        print(f"[{idx}/{len(image_files)}] Processing: {img_file.name}", flush=True)
        try:
            raw_text = ocr_func(str(img_file))
            if not raw_text.strip():
                print(f"  -> Warning: No text detected in {img_file.name}", flush=True)
                continue
            songs = parse_song_text(raw_text, filename=img_file.name)
            for song in songs:
                if song and song.get('title'):
                    song['id'] = song_counter
                    song_counter += 1
                    extracted_songs.append(song)
                    safe_title = song['title'].encode('ascii', 'ignore').decode('ascii')
                    print(f"  -> Extracted Hymn #{song['number']}: {safe_title} ({len(song['stanzas'])} stanzas)", flush=True)

            # Save incrementally after each image file
            if extracted_songs:
                with open(out_path, 'w', encoding='utf-8') as f:
                    json.dump(extracted_songs, f, indent=2, ensure_ascii=False)
        except Exception as e:
            print(f"  -> Error processing {img_file.name}: {e}", flush=True)

    print(f"\nSuccessfully extracted {len(extracted_songs)} total songs and saved to {output_json}!", flush=True)
    return extracted_songs


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="Extract songs from image folder using OCR with auto-rotation")
    parser.add_argument("folder", help="Path to folder containing song images")
    parser.add_argument("--output", default="assets/data/extracted_hymns.json", help="Output JSON path")
    parser.add_argument("--append", action="store_true", help="Append to existing JSON instead of overwriting")
    args = parser.parse_args()

    process_folder(args.folder, args.output, append=args.append)

