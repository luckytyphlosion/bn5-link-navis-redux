
# Protoman
tools/armips.exe build.asm -sym bn5p-link-navis-redux.sym -equ IS_PROTOMAN 1

# Colonel
tools/armips.exe build.asm -sym bn5c-link-navis-redux.sym -equ IS_PROTOMAN 0

if [[ $? -ne 0 ]] ; then
    exit 1
fi

# Make patches
mkdir -p "out_patch/bn5_gate_redux/v1.0.0"
./tools/floating/flips.exe -c -b "bn5p.gba" "bn5p-link-navis-redux.gba" "out_patch/bn5_gate_redux/v1.0.0/BRBE_00.bps"
./tools/floating/flips.exe -c -b "bn5c.gba" "bn5c-link-navis-redux.gba" "out_patch/bn5_gate_redux/v1.0.0/BRKE_00.bps"
touch out_patch/bn5_gate_redux/info.toml
