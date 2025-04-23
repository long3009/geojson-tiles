#!/bin/bash
INPUT_DIR="/tiles"
OUTPUT_DIR="/out"

convert_tile() {
    local z=$1
    local x=$2
    local y=$3
    local in_file="$INPUT_DIR/$z/$x/$y.pbf"
    local out_dir="$OUTPUT_DIR/$z/$x"
    local out_file="$out_dir/$y.geojson"
    mkdir -p "$out_dir"

    vt2geojson $in_file -z $z -x $x -y $y > $out_file
}

find "$INPUT_DIR" -name "*.pbf" | while read filepath; do
    abs_input_dir="$(realpath "$INPUT_DIR")"
    abs_filepath="$(realpath "$filepath")"
    rel_path="${abs_filepath#$abs_input_dir/}"
    z=$(echo "$rel_path" | cut -d/ -f1)
    x=$(echo "$rel_path" | cut -d/ -f2)
    y_file=$(echo "$rel_path" | cut -d/ -f3)
    y=${y_file%.pbf}
    echo "converting z=$z x=$x y=$y..."
    convert_tile "$z" "$x" "$y"
done
echo "DONE!"