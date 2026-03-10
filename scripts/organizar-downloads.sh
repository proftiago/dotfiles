#!/usr/bin/env bash
# ╔══════════════════════════════════════════╗
# ║       AUTO-ORGANIZAR DOWNLOADS           ║
# ║       IrajuArch OS · proftiago           ║
# ╚══════════════════════════════════════════╝

DOWNLOADS="$HOME/Downloads"
PICTURES="$HOME/Pictures"
VIDEOS="$HOME/Videos"
MUSIC="$HOME/Music"
ARCHIVE="$HOME/Downloads/Arquivos-Compactados"
ESCOLA="$HOME/escola/materiais"

# ── Garantir que as pastas existem ─────────
mkdir -p "$PICTURES" "$VIDEOS" "$MUSIC" "$ARCHIVE" "$ESCOLA"

# ── Resolver conflito de nomes ─────────────
# Renomeia com data se já existir no destino
mover() {
    local src="$1"
    local dst_dir="$2"
    local filename
    filename=$(basename "$src")
    local base="${filename%.*}"
    local ext="${filename##*.}"
    local dst="$dst_dir/$filename"

    # Se o arquivo ainda não terminou de ser escrito, aguarda
    sleep 0.5

    # Verifica se arquivo ainda existe (pode ter sido movido por outra regra)
    [[ ! -f "$src" ]] && return

    if [[ -f "$dst" ]]; then
        local data
        data=$(date '+%Y-%m-%d_%H-%M-%S')
        # Sem extensão (ex: Makefile)
        if [[ "$base" == "$filename" ]]; then
            dst="$dst_dir/${base}_${data}"
        else
            dst="$dst_dir/${base}_${data}.${ext}"
        fi
    fi

    mv "$src" "$dst"

    # Notificação via Mako
    notify-send \
        -i folder \
        "󰁸 Download organizado" \
        "$(basename "$dst")\n→ ${dst_dir/$HOME/~}" \
        -t 4000
}

# ── Monitorar Downloads com inotifywait ────
inotifywait -m -e close_write -e moved_to --format '%f' "$DOWNLOADS" |
    while read -r FILE; do

        FILEPATH="$DOWNLOADS/$FILE"

        # Ignora pastas e arquivos temporários
        [[ -d "$FILEPATH" ]] && continue
        [[ "$FILE" == *.crdownload ]] && continue
        [[ "$FILE" == *.part ]] && continue
        [[ "$FILE" == *.tmp ]] && continue
        [[ "$FILE" == .* ]] && continue

        # Extensão em minúsculo para comparação
        EXT="${FILE##*.}"
        EXT="${EXT,,}"

        case "$EXT" in
        # Imagens
        jpg | jpeg | png | gif | webp | svg | ico | bmp | tiff | avif)
            mover "$FILEPATH" "$PICTURES"
            ;;

        # Vídeos
        mp4 | mkv | avi | mov | wmv | flv | webm | m4v | 3gp)
            mover "$FILEPATH" "$VIDEOS"
            ;;

        # Músicas
        mp3 | flac | wav | ogg | aac | m4a | opus | wma)
            mover "$FILEPATH" "$MUSIC"
            ;;

        # Compactados
        zip | rar | 7z | tar | gz | bz2 | xz | zst | tgz)
            mover "$FILEPATH" "$ARCHIVE"
            ;;

        # Docs Word / PPT / Excel → escola
        doc | docx | ppt | pptx | xls | xlsx | odt | odp | ods)
            mover "$FILEPATH" "$ESCOLA"
            ;;

        # PDFs → escola
        pdf)
            mover "$FILEPATH" "$ESCOLA"
            ;;
        esac

    done
